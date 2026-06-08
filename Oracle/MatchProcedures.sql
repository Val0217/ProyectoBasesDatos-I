-- =============================================================
-- ARCHIVO: MatchProcedures.sql
-- DESCRIPCION: Procedimientos y Job para el módulo de Match
-- VERSION: Básica — match por tipo de mascota
-- =============================================================

-- -------------------------------------------------------------
-- 1. Procedimiento principal de match
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_run_match AS
    v_minPercentage NUMBER := 60;
BEGIN

    -- Obtener porcentaje mínimo desde Parameter
    BEGIN
        SELECT TO_NUMBER(Value)
        INTO v_minPercentage
        FROM Parameter
        WHERE Name = 'MinMatchPercentage';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_minPercentage := 60;
    END;

    -- Insertar matches nuevos
    INSERT INTO PetMatch (
        Id,
        SimilarityPercentage,
        MatchDate,
        IdLostReport,
        IdFoundReport
    )
    SELECT
        s_PetMatch.NEXTVAL,

        CASE
            WHEN pl.IdBreed = pf.IdBreed
                 AND dl.IdCanton = df.IdCanton THEN 100

            WHEN pl.IdBreed = pf.IdBreed THEN 85

            WHEN dl.IdCanton = df.IdCanton THEN 75

            ELSE 60
        END AS SimilarityPercentage,

        SYSDATE,
        lr.Id,
        fr.Id

    FROM LostReport  lr
    JOIN Pet         pl ON lr.IdPet = pl.Id

    JOIN FoundReport fr
        ON fr.FoundDate >= lr.LostDate

    JOIN Pet         pf ON fr.IdPet = pf.Id

    JOIN District    dl ON pl.IdDistrict = dl.Id
    JOIN District    df ON pf.IdDistrict = df.Id

    WHERE
        -- mismo tipo
        pl.IdType = pf.IdType

        -- reporte aún perdido
        AND lr.State = 'Perdido'

        -- evitar duplicados
        AND NOT EXISTS (
            SELECT 1
            FROM PetMatch pm
            WHERE pm.IdLostReport  = lr.Id
              AND pm.IdFoundReport = fr.Id
        )

        -- porcentaje mínimo
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

END pr_run_match;
/
-- -------------------------------------------------------------
-- 2. Función para contar matches pendientes
-- -------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_count_pending_matches
RETURN NUMBER AS

    v_count NUMBER;

BEGIN

    SELECT COUNT(*)
    INTO v_count

    FROM LostReport  lr
    JOIN Pet         pl ON lr.IdPet = pl.Id

    JOIN FoundReport fr
        ON fr.FoundDate >= lr.LostDate

    JOIN Pet         pf ON fr.IdPet = pf.Id

    WHERE
        pl.IdType = pf.IdType

        AND lr.State = 'Perdido'

        AND NOT EXISTS (
            SELECT 1
            FROM PetMatch pm
            WHERE pm.IdLostReport  = lr.Id
              AND pm.IdFoundReport = fr.Id
        );

    RETURN v_count;

END fn_count_pending_matches;
/
-- -------------------------------------------------------------
-- 3. Reporte de matches
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_get_match_report(
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN

    OPEN p_cursor FOR

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

            ownerL.FirstName || ' ' || ownerL.LastName
                AS LostOwnerName,

            -- Found pet
            pf.Name AS FoundPetName,
            tf.Name AS FoundPetType,
            bf.Name AS FoundPetBreed,
            pf.Color AS FoundPetColor,
            fr.FoundDate,
            df.Name AS FoundDistrict,

            finder.FirstName || ' ' || finder.LastName
                AS FinderName

        FROM PetMatch    pm

        JOIN LostReport  lr
            ON pm.IdLostReport = lr.Id

        JOIN FoundReport fr
            ON pm.IdFoundReport = fr.Id

        JOIN Pet         pl
            ON lr.IdPet = pl.Id

        JOIN Pet         pf
            ON fr.IdPet = pf.Id

        JOIN PetType     tl
            ON pl.IdType = tl.Id

        JOIN PetType     tf
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

END pr_get_match_report;
/
-- -------------------------------------------------------------
-- 4. Job automático
-- -------------------------------------------------------------
DECLARE

    v_interval NUMBER := 2;

BEGIN

    -- Obtener intervalo desde Parameter
    BEGIN
        SELECT TO_NUMBER(Value)
        INTO v_interval
        FROM Parameter
        WHERE Name = 'MatchIntervalHours';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_interval := 2;
    END;

    -- Eliminar job existente
    BEGIN
        DBMS_SCHEDULER.DROP_JOB('JOB_PET_MATCH');
    EXCEPTION
        WHEN OTHERS THEN NULL;
    END;

    -- Crear job
    DBMS_SCHEDULER.CREATE_JOB(
        job_name        => 'JOB_PET_MATCH',
        job_type        => 'STORED_PROCEDURE',
        job_action      => 'pr_run_match',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=HOURLY; INTERVAL=' || v_interval,
        enabled         => TRUE,
        comments        => 'Automatic match between lost and found pets'
    );

END;
/

