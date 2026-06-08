-- =============================================================
-- ARCHIVO: BlockListProcedures_mariadb.sql
-- DESCRIPCION: Procedimientos para el modulo de Lista Negra
-- =============================================================

DELIMITER $$

-- -------------------------------------------------------------
-- 1. Reportar una persona y agregarla a la lista negra
--    Inserta en ReportList y en BlockList en una sola llamada
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_report_person$$

CREATE PROCEDURE pr_report_person(
    IN p_idPerson INT,
    IN p_idReporter INT,
    IN p_description VARCHAR(4000)
)
BEGIN
    -- Validar que no se reporte a si mismo
    IF p_idPerson = p_idReporter THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'You cannot report yourself.';
    END IF;

    -- Insertar en ReportList
    -- Id se omite porque debe ser AUTO_INCREMENT
    INSERT INTO ReportList (
        Description,
        IdPerson,
        IdReporter,
        ReportDate
    )
    VALUES (
        p_description,
        p_idPerson,
        p_idReporter,
        NOW()
    );

    -- Insertar en BlockList si no esta ya bloqueado
    -- Id se omite porque debe ser AUTO_INCREMENT
    INSERT INTO BlockList (
        BlockDate,
        IdPerson
    )
    SELECT
        NOW(),
        p_idPerson
    WHERE NOT EXISTS (
        SELECT 1
        FROM BlockList
        WHERE IdPerson = p_idPerson
    );

    COMMIT;
END$$


-- -------------------------------------------------------------
-- 2. Obtener la lista negra completa con calificacion y notas
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_get_block_list$$

CREATE PROCEDURE pr_get_block_list()
BEGIN
    SELECT
        bl.Id AS BlockListId,
        CONCAT(per.FirstName, ' ', per.LastName) AS PersonName,
        bl.BlockDate,

        -- Razon mas reciente del reporte
        (
            SELECT rl.Description
            FROM ReportList rl
            WHERE rl.IdPerson = bl.IdPerson
            ORDER BY rl.ReportDate DESC
            LIMIT 1
        ) AS Reason,

        -- Promedio de calificacion
        IFNULL(ROUND(AVG(cal.Stars), 1), 0) AS AvgStars,

        -- Nota mas reciente
        (
            SELECT cal2.Note
            FROM Calification cal2
            WHERE cal2.IdPerson = bl.IdPerson
            ORDER BY cal2.CalificationDate DESC
            LIMIT 1
        ) AS LatestNote

    FROM BlockList bl
    JOIN Person per ON bl.IdPerson = per.Id
    LEFT JOIN Calification cal ON cal.IdPerson = bl.IdPerson
    GROUP BY
        bl.Id,
        per.FirstName,
        per.LastName,
        bl.BlockDate,
        bl.IdPerson
    ORDER BY bl.BlockDate DESC;
END$$


-- -------------------------------------------------------------
-- 3. Obtener detalle completo de una persona en lista negra
--    Todos sus reportes y calificaciones
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_get_block_list_detail$$

CREATE PROCEDURE pr_get_block_list_detail(
    IN p_idPerson INT
)
BEGIN
    SELECT
        CONCAT(per.FirstName, ' ', per.LastName) AS PersonName,
        bl.BlockDate,
        rl.Description AS ReportReason,
        CONCAT(rep.FirstName, ' ', rep.LastName) AS ReportedBy,
        rl.ReportDate,
        cal.Stars,
        cal.Note,
        cal.CalificationDate
    FROM BlockList bl
    JOIN Person per ON bl.IdPerson = per.Id
    LEFT JOIN ReportList rl ON rl.IdPerson = bl.IdPerson
    LEFT JOIN Person rep ON rl.IdReporter = rep.Id
    LEFT JOIN Calification cal ON cal.IdPerson = bl.IdPerson
    WHERE bl.IdPerson = p_idPerson
    ORDER BY rl.ReportDate DESC, cal.CalificationDate DESC;
END$$


-- -------------------------------------------------------------
-- 4. Quitar a una persona de la lista negra
--    Solo admins pueden hacerlo
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_remove_from_block_list$$

CREATE PROCEDURE pr_remove_from_block_list(
    IN p_idPerson INT,
    IN p_idAdmin INT
)
BEGIN
    DECLARE v_isAdmin INT DEFAULT 0;

    -- Verificar que quien ejecuta sea admin
    SELECT COUNT(*)
    INTO v_isAdmin
    FROM Admin
    WHERE IdPerson = p_idAdmin;

    IF v_isAdmin = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only admins can remove people from the block list.';
    END IF;

    -- p_idPerson representa la persona, por eso se usa IdPerson
    DELETE FROM BlockList
    WHERE IdPerson = p_idPerson;

    COMMIT;
END$$


-- -------------------------------------------------------------
-- 5. Obtener todas las personas disponibles
--    Para el combo de reportar persona
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_get_persons_all$$

CREATE PROCEDURE pr_get_persons_all()
BEGIN
    SELECT
        Id,
        CONCAT(FirstName, ' ', LastName) AS Name
    FROM Person
    ORDER BY FirstName ASC;
END$$

DELIMITER ;
