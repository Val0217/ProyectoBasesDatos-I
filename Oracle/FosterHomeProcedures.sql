-- =============================================================
-- ARCHIVO: FosterHomeProcedures.sql
-- DESCRIPCION: Procedimientos para el módulo de Casas Cuna
-- NOTA: Requiere que el tipo NUMBERLIST ya exista en la BD
--       (lo usan también en pr_insert_pet)
-- =============================================================

-- -------------------------------------------------------------
-- 1. Registrar una nueva casa cuna
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_insert_foster_home(
    p_idPerson      IN NUMBER,
    p_needsDonation IN VARCHAR2,
    p_sizeIds       IN NUMBERLIST,
    p_energyIds     IN NUMBERLIST,
    p_spaceIds      IN NUMBERLIST
) AS
    v_idFosterHome NUMBER;
BEGIN
    -- Insert foster home record
    INSERT INTO FosterHome (Id, NeedsDonation, IdPerson)
    VALUES (s_FosterHome.NEXTVAL, p_needsDonation, p_idPerson)
    RETURNING Id INTO v_idFosterHome;

    -- Insert accepted sizes
    FOR i IN 1..p_sizeIds.COUNT LOOP
        INSERT INTO PetSizeXFosterHome (IdPetSize, IdFosterHome)
        VALUES (p_sizeIds(i), v_idFosterHome);
    END LOOP;

    -- Insert accepted energy levels
    FOR i IN 1..p_energyIds.COUNT LOOP
        INSERT INTO PetLevelEnergyXFosterHome (IdPetLevelEnergy, IdFosterHome)
        VALUES (p_energyIds(i), v_idFosterHome);
    END LOOP;

    -- Insert accepted space types
    FOR i IN 1..p_spaceIds.COUNT LOOP
        INSERT INTO SpaceRequiredXFosterHome (IdSpaceRequired, IdFosterHome)
        VALUES (p_spaceIds(i), v_idFosterHome);
    END LOOP;

    COMMIT;
END pr_insert_foster_home;
/

-- -------------------------------------------------------------
-- 2. Obtener todas las casas cuna
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_get_foster_homes(
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT
            fh.Id                                    AS FosterHomeId,
            per.Id                                   AS PersonId,
            per.FirstName || ' ' || per.LastName     AS PersonName,
            fh.NeedsDonation,
            -- Accepted sizes as comma-separated string
            (SELECT LISTAGG(ps.Name, ', ') WITHIN GROUP (ORDER BY ps.Name)
             FROM PetSizeXFosterHome psfh
             JOIN PetSize ps ON psfh.IdPetSize = ps.Id
             WHERE psfh.IdFosterHome = fh.Id)        AS AcceptedSizes,
            -- Accepted energy levels
            (SELECT LISTAGG(ple.Name, ', ') WITHIN GROUP (ORDER BY ple.Name)
             FROM PetLevelEnergyXFosterHome plefh
             JOIN PetLevelEnergy ple ON plefh.IdPetLevelEnergy = ple.Id
             WHERE plefh.IdFosterHome = fh.Id)       AS AcceptedEnergy,
            -- Accepted spaces
            (SELECT LISTAGG(sr.Name, ', ') WITHIN GROUP (ORDER BY sr.Name)
             FROM SpaceRequiredXFosterHome srfh
             JOIN SpaceRequired sr ON srfh.IdSpaceRequired = sr.Id
             WHERE srfh.IdFosterHome = fh.Id)        AS AcceptedSpaces
        FROM FosterHome fh
        JOIN Person per ON fh.IdPerson = per.Id
        ORDER BY per.FirstName ASC;
END pr_get_foster_homes;
/

-- -------------------------------------------------------------
-- 3. Obtener la casa cuna de una persona específica (para editar)
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_get_foster_home_by_person(
    p_idPerson IN NUMBER,
    p_cursor   OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT
            fh.Id          AS FosterHomeId,
            fh.IdPerson,
            fh.NeedsDonation,
            -- IDs as comma-separated for Java to parse
            (SELECT LISTAGG(IdPetSize, ',') WITHIN GROUP (ORDER BY IdPetSize)
             FROM PetSizeXFosterHome
             WHERE IdFosterHome = fh.Id)             AS SizeIds,
            (SELECT LISTAGG(IdPetLevelEnergy, ',') WITHIN GROUP (ORDER BY IdPetLevelEnergy)
             FROM PetLevelEnergyXFosterHome
             WHERE IdFosterHome = fh.Id)             AS EnergyIds,
            (SELECT LISTAGG(IdSpaceRequired, ',') WITHIN GROUP (ORDER BY IdSpaceRequired)
             FROM SpaceRequiredXFosterHome
             WHERE IdFosterHome = fh.Id)             AS SpaceIds
        FROM FosterHome fh
        WHERE fh.IdPerson = p_idPerson;
END pr_get_foster_home_by_person;
/

-- -------------------------------------------------------------
-- 4. Actualizar una casa cuna (solo el dueño)
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_update_foster_home(
    p_idFosterHome  IN NUMBER,
    p_idPerson      IN NUMBER,   -- security check
    p_needsDonation IN VARCHAR2,
    p_sizeIds       IN NUMBERLIST,
    p_energyIds     IN NUMBERLIST,
    p_spaceIds      IN NUMBERLIST
) AS
    v_owner NUMBER;
BEGIN
    -- Security check: verify ownership
    SELECT IdPerson INTO v_owner
    FROM FosterHome
    WHERE Id = p_idFosterHome;

    IF v_owner <> p_idPerson THEN
        RAISE_APPLICATION_ERROR(-20001, 'You can only edit your own foster home.');
    END IF;

    -- Update main record
    UPDATE FosterHome
    SET NeedsDonation = p_needsDonation
    WHERE Id = p_idFosterHome;

    -- Replace size relations
    DELETE FROM PetSizeXFosterHome WHERE IdFosterHome = p_idFosterHome;
    FOR i IN 1..p_sizeIds.COUNT LOOP
        INSERT INTO PetSizeXFosterHome (IdPetSize, IdFosterHome)
        VALUES (p_sizeIds(i), p_idFosterHome);
    END LOOP;

    -- Replace energy relations
    DELETE FROM PetLevelEnergyXFosterHome WHERE IdFosterHome = p_idFosterHome;
    FOR i IN 1..p_energyIds.COUNT LOOP
        INSERT INTO PetLevelEnergyXFosterHome (IdPetLevelEnergy, IdFosterHome)
        VALUES (p_energyIds(i), p_idFosterHome);
    END LOOP;

    -- Replace space relations
    DELETE FROM SpaceRequiredXFosterHome WHERE IdFosterHome = p_idFosterHome;
    FOR i IN 1..p_spaceIds.COUNT LOOP
        INSERT INTO SpaceRequiredXFosterHome (IdSpaceRequired, IdFosterHome)
        VALUES (p_spaceIds(i), p_idFosterHome);
    END LOOP;

    COMMIT;
END pr_update_foster_home;
/

-- -------------------------------------------------------------
-- 5. Eliminar una casa cuna (solo el dueño)
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_delete_foster_home(
    p_idFosterHome IN NUMBER,
    p_idPerson     IN NUMBER    -- security check
) AS
    v_owner NUMBER;
BEGIN
    -- Security check
    SELECT IdPerson INTO v_owner
    FROM FosterHome
    WHERE Id = p_idFosterHome;

    IF v_owner <> p_idPerson THEN
        RAISE_APPLICATION_ERROR(-20002, 'You can only delete your own foster home.');
    END IF;

    -- Delete relations first (FK constraints)
    DELETE FROM PetSizeXFosterHome          WHERE IdFosterHome = p_idFosterHome;
    DELETE FROM PetLevelEnergyXFosterHome   WHERE IdFosterHome = p_idFosterHome;
    DELETE FROM SpaceRequiredXFosterHome    WHERE IdFosterHome = p_idFosterHome;

    -- Delete main record
    DELETE FROM FosterHome WHERE Id = p_idFosterHome;

    COMMIT;
END pr_delete_foster_home;
/
