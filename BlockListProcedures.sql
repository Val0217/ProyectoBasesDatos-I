-- =============================================================
-- ARCHIVO: BlockListProcedures.sql
-- DESCRIPCION: Procedimientos para el módulo de Lista Negra
-- =============================================================

-- -------------------------------------------------------------
-- 1. Reportar una persona y agregarla a la lista negra
--    Inserta en ReportList Y en BlockList en una sola llamada
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_report_person(
    p_idPerson      IN NUMBER,   -- persona reportada
    p_idReporter    IN NUMBER,   -- quien hace el reporte
    p_description   IN VARCHAR2  -- razón del reporte
) AS
BEGIN
    -- Validar que no se reporte a sí mismo
    IF p_idPerson = p_idReporter THEN
        RAISE_APPLICATION_ERROR(-20010, 'You cannot report yourself.');
    END IF;

    -- Insertar en ReportList
    INSERT INTO ReportList (Id, Description, IdPerson, IdReporter, ReportDate)
    VALUES (s_ReportList.NEXTVAL, p_description, p_idPerson, p_idReporter, SYSDATE);

    -- Insertar en BlockList si no está ya bloqueado
    INSERT INTO BlockList (Id, BlockDate, IdPerson)
    SELECT s_BlockList.NEXTVAL, SYSDATE, p_idPerson
    FROM DUAL
    WHERE NOT EXISTS (
        SELECT 1 FROM BlockList WHERE IdPerson = p_idPerson
    );

    COMMIT;
END pr_report_person;
/

-- -------------------------------------------------------------
-- 2. Obtener la lista negra completa con calificación y notas
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_get_block_list(
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT
            bl.Id                                    AS BlockListId,
            per.FirstName || ' ' || per.LastName     AS PersonName,
            bl.BlockDate,
            -- Most recent report reason
            (SELECT rl.Description
             FROM ReportList rl
             WHERE rl.IdPerson = bl.IdPerson
             AND rl.ReportDate = (
                 SELECT MAX(ReportDate)
                 FROM ReportList
                 WHERE IdPerson = bl.IdPerson
             )
             AND ROWNUM = 1)                          AS Reason,
            -- Average rating (from Calification table)
            NVL(ROUND(AVG(cal.Stars), 1), 0)          AS AvgStars,
            -- Most recent note
            (SELECT cal2.Note
             FROM Calification cal2
             WHERE cal2.IdPerson = bl.IdPerson
             AND cal2.CalificationDate = (
                 SELECT MAX(CalificationDate)
                 FROM Calification
                 WHERE IdPerson = bl.IdPerson
             )
             AND ROWNUM = 1)                          AS LatestNote
        FROM BlockList bl
        JOIN Person per ON bl.IdPerson = per.Id
        LEFT JOIN Calification cal ON cal.IdPerson = bl.IdPerson
        GROUP BY bl.Id, per.FirstName, per.LastName,
                 bl.BlockDate, bl.IdPerson
        ORDER BY bl.BlockDate DESC;
END pr_get_block_list;
/

-- -------------------------------------------------------------
-- 3. Obtener detalle completo de una persona en lista negra
--    (todos sus reportes y calificaciones)
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_get_block_list_detail(
    p_idPerson IN NUMBER,
    p_cursor   OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT
            per.FirstName || ' ' || per.LastName     AS PersonName,
            bl.BlockDate,
            rl.Description                           AS ReportReason,
            rep.FirstName || ' ' || rep.LastName     AS ReportedBy,
            rl.ReportDate,
            cal.Stars,
            cal.Note,
            cal.CalificationDate
        FROM BlockList bl
        JOIN Person per ON bl.IdPerson = per.Id
        LEFT JOIN ReportList rl ON rl.IdPerson = bl.IdPerson
        LEFT JOIN Person rep   ON rl.IdReporter = rep.Id
        LEFT JOIN Calification cal ON cal.IdPerson = bl.IdPerson
        WHERE bl.IdPerson = p_idPerson
        ORDER BY rl.ReportDate DESC, cal.CalificationDate DESC;
END pr_get_block_list_detail;
/

-- -------------------------------------------------------------
-- 4. Quitar a una persona de la lista negra
--    Solo admins pueden hacerlo
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_remove_from_block_list(
    p_idPerson  IN NUMBER,   -- persona a quitar
    p_idAdmin   IN NUMBER    -- quien ejecuta la acción
) AS
    v_isAdmin NUMBER;
BEGIN
    -- Verify the executor is an admin
    SELECT COUNT(*) INTO v_isAdmin
    FROM Admin
    WHERE IdPerson = p_idAdmin;

    IF v_isAdmin = 0 THEN
        RAISE_APPLICATION_ERROR(-20011, 'Only admins can remove people from the block list.');
    END IF;

    DELETE FROM BlockList WHERE IdPerson = p_idPerson;

    COMMIT;
END pr_remove_from_block_list;
/

-- -------------------------------------------------------------
-- 5. Función para obtener todas las personas disponibles
--    (para el combo de "reportar persona")
-- -------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_get_persons_all
RETURN SYS_REFCURSOR AS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT Id, FirstName || ' ' || LastName AS Name
        FROM Person
        ORDER BY FirstName ASC;
    RETURN v_cursor;
END fn_get_persons_all;
/
