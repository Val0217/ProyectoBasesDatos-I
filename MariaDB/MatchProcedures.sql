

DELIMITER $$

-- -------------------------------------------------------------
-- 1. Procedimiento principal de match
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_run_match$$

CREATE PROCEDURE pr_run_match()
BEGIN
    DECLARE v_minPercentage INT DEFAULT 60;

    -- Obtener porcentaje minimo desde Parameter
    SELECT IFNULL(CAST(MAX(Value) AS UNSIGNED), 60)
    INTO v_minPercentage
    FROM Parameter
    WHERE Name = 'MinMatchPercentage';

    -- Insertar matches nuevos
    -- PetMatch.Id debe ser AUTO_INCREMENT, por eso no se inserta manualmente.
    INSERT INTO PetMatch (
        SimilarityPercentage,
        MatchDate,
        IdLostReport,
        IdFoundReport
    )
    SELECT
        CASE
            WHEN pl.IdBreed = pf.IdBreed
                 AND dl.IdCanton = df.IdCanton THEN 100
            WHEN pl.IdBreed = pf.IdBreed THEN 85
            WHEN dl.IdCanton = df.IdCanton THEN 75
            ELSE 60
        END AS SimilarityPercentage,

        NOW() AS MatchDate,
        lr.Id AS IdLostReport,
        fr.Id AS IdFoundReport

    FROM LostReport lr
    JOIN Pet pl ON lr.IdPet = pl.Id

    JOIN FoundReport fr
        ON fr.FoundDate >= lr.LostDate

    JOIN Pet pf ON fr.IdPet = pf.Id

    JOIN District dl ON pl.IdDistrict = dl.Id
    JOIN District df ON pf.IdDistrict = df.Id

    WHERE
        -- mismo tipo
        pl.IdType = pf.IdType

        -- reporte aun perdido
        AND lr.State = 'lost'

        -- evitar duplicados
        AND NOT EXISTS (
            SELECT 1
            FROM PetMatch pm
            WHERE pm.IdLostReport = lr.Id
              AND pm.IdFoundReport = fr.Id
        )

        -- porcentaje minimo
        AND (
            CASE
                WHEN pl.IdBreed = pf.IdBreed
                     AND dl.IdCanton = df.IdCanton THEN 100
                WHEN pl.IdBreed = pf.IdBreed THEN 85
                WHEN dl.IdCanton = df.IdCanton THEN 75
                ELSE 60
            END
        ) >= v_minPercentage;

    COMMIT;
END$$


-- -------------------------------------------------------------
-- 2. Funcion para contar matches pendientes
-- -------------------------------------------------------------
DROP FUNCTION IF EXISTS fn_count_pending_matches$$

CREATE FUNCTION fn_count_pending_matches()
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_count INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_count
    FROM LostReport lr
    JOIN Pet pl ON lr.IdPet = pl.Id

    JOIN FoundReport fr
        ON fr.FoundDate >= lr.LostDate

    JOIN Pet pf ON fr.IdPet = pf.Id

    WHERE
        pl.IdType = pf.IdType

        AND lr.State = 'Perdido'

        AND NOT EXISTS (
            SELECT 1
            FROM PetMatch pm
            WHERE pm.IdLostReport = lr.Id
              AND pm.IdFoundReport = fr.Id
        );

    RETURN v_count;
END$$


-- -------------------------------------------------------------
-- 3. Reporte de matches
--    En MariaDB no se usa SYS_REFCURSOR; el SELECT del procedure
--    se lee desde Java como ResultSet.
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_get_match_report$$

CREATE PROCEDURE pr_get_match_report()
BEGIN
    SELECT
        pm.Id AS MatchId,
        pm.SimilarityPercentage,
        pm.MatchDate,

        -- Lost pet
        pl.Name AS LostPetName,
        tl.Name AS LostPetType,
        bl.Name AS LostPetBreed,
        pl.Color AS LostPetColor,
        lr.LostDate,
        dl.Name AS LostDistrict,

        CONCAT(ownerL.FirstName, ' ', ownerL.LastName) AS LostOwnerName,

        -- Found pet
        pf.Name AS FoundPetName,
        tf.Name AS FoundPetType,
        bf.Name AS FoundPetBreed,
        pf.Color AS FoundPetColor,
        fr.FoundDate,
        df.Name AS FoundDistrict,

        CONCAT(finder.FirstName, ' ', finder.LastName) AS FinderName

    FROM PetMatch pm

    JOIN LostReport lr
        ON pm.IdLostReport = lr.Id

    JOIN FoundReport fr
        ON pm.IdFoundReport = fr.Id

    JOIN Pet pl
        ON lr.IdPet = pl.Id

    JOIN Pet pf
        ON fr.IdPet = pf.Id

    JOIN PetType tl
        ON pl.IdType = tl.Id

    JOIN PetType tf
        ON pf.IdType = tf.Id

    LEFT JOIN PetBreed bl
        ON pl.IdBreed = bl.Id

    LEFT JOIN PetBreed bf
        ON pf.IdBreed = bf.Id

    LEFT JOIN District dl
        ON pl.IdDistrict = dl.Id

    LEFT JOIN District df
        ON pf.IdDistrict = df.Id

    LEFT JOIN Person ownerL
        ON pl.IdOwner = ownerL.Id

    LEFT JOIN Person finder
        ON fr.IdPerson = finder.Id

    ORDER BY pm.MatchDate DESC;
END$$


-- -------------------------------------------------------------
-- 4. Evento automatico en MariaDB
--    Reemplaza DBMS_SCHEDULER de Oracle.
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_create_match_event$$

CREATE PROCEDURE pr_create_match_event()
BEGIN
    DECLARE v_interval INT DEFAULT 2;
    DECLARE v_sql TEXT;

    -- Obtener intervalo desde Parameter
    SELECT IFNULL(CAST(MAX(Value) AS UNSIGNED), 2)
    INTO v_interval
    FROM Parameter
    WHERE Name = 'MatchIntervalHours';

    IF v_interval IS NULL OR v_interval < 1 THEN
        SET v_interval = 2;
    END IF;

    DROP EVENT IF EXISTS JOB_PET_MATCH;

    SET v_sql = CONCAT(
        'CREATE EVENT JOB_PET_MATCH ',
        'ON SCHEDULE EVERY ', v_interval, ' HOUR ',
        'STARTS CURRENT_TIMESTAMP ',
        'DO CALL pr_run_match()'
    );

    PREPARE stmt FROM v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;


