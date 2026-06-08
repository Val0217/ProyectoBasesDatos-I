

DELIMITER $$

-- -------------------------------------------------------------
-- 1. Registrar una nueva casa cuna
--    p_sizeIds, p_energyIds y p_spaceIds se reciben como texto CSV:
--    ejemplo: '1,2,3'
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_insert_foster_home$$

CREATE PROCEDURE pr_insert_foster_home(
    IN p_idPerson INT,
    IN p_needsDonation VARCHAR(255),
    IN p_sizeIds TEXT,
    IN p_energyIds TEXT,
    IN p_spaceIds TEXT
)
BEGIN
    DECLARE v_idFosterHome INT;
    DECLARE v_token VARCHAR(50);
    DECLARE v_csv TEXT;

    -- Insert foster home record.
    -- Id se genera automaticamente por AUTO_INCREMENT.
    INSERT INTO FosterHome (
        NeedsDonation,
        IdPerson
    )
    VALUES (
        p_needsDonation,
        p_idPerson
    );

    SET v_idFosterHome = LAST_INSERT_ID();

    -- Insert accepted sizes
    SET v_csv = TRIM(BOTH ',' FROM IFNULL(p_sizeIds, ''));

    WHILE v_csv <> '' DO
        SET v_token = TRIM(SUBSTRING_INDEX(v_csv, ',', 1));

        IF v_token <> '' THEN
            INSERT INTO PetSizeXFosterHome (
                IdPetSize,
                IdFosterHome
            )
            VALUES (
                CAST(v_token AS UNSIGNED),
                v_idFosterHome
            );
        END IF;

        IF INSTR(v_csv, ',') > 0 THEN
            SET v_csv = SUBSTRING(v_csv, INSTR(v_csv, ',') + 1);
        ELSE
            SET v_csv = '';
        END IF;
    END WHILE;

    -- Insert accepted energy levels
    SET v_csv = TRIM(BOTH ',' FROM IFNULL(p_energyIds, ''));

    WHILE v_csv <> '' DO
        SET v_token = TRIM(SUBSTRING_INDEX(v_csv, ',', 1));

        IF v_token <> '' THEN
            INSERT INTO PetLevelEnergyXFosterHome (
                IdPetLevelEnergy,
                IdFosterHome
            )
            VALUES (
                CAST(v_token AS UNSIGNED),
                v_idFosterHome
            );
        END IF;

        IF INSTR(v_csv, ',') > 0 THEN
            SET v_csv = SUBSTRING(v_csv, INSTR(v_csv, ',') + 1);
        ELSE
            SET v_csv = '';
        END IF;
    END WHILE;

    -- Insert accepted space types
    SET v_csv = TRIM(BOTH ',' FROM IFNULL(p_spaceIds, ''));

    WHILE v_csv <> '' DO
        SET v_token = TRIM(SUBSTRING_INDEX(v_csv, ',', 1));

        IF v_token <> '' THEN
            INSERT INTO SpaceRequiredXFosterHome (
                IdSpaceRequired,
                IdFosterHome
            )
            VALUES (
                CAST(v_token AS UNSIGNED),
                v_idFosterHome
            );
        END IF;

        IF INSTR(v_csv, ',') > 0 THEN
            SET v_csv = SUBSTRING(v_csv, INSTR(v_csv, ',') + 1);
        ELSE
            SET v_csv = '';
        END IF;
    END WHILE;

    COMMIT;
END$$


-- -------------------------------------------------------------
-- 2. Obtener todas las casas cuna
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_get_foster_homes$$

CREATE PROCEDURE pr_get_foster_homes()
BEGIN
    SELECT
        fh.Id AS FosterHomeId,
        per.Id AS PersonId,
        CONCAT(per.FirstName, ' ', per.LastName) AS PersonName,
        fh.NeedsDonation,

        -- Accepted sizes as comma-separated string
        (
            SELECT GROUP_CONCAT(ps.Name ORDER BY ps.Name SEPARATOR ', ')
            FROM PetSizeXFosterHome psfh
            JOIN PetSize ps ON psfh.IdPetSize = ps.Id
            WHERE psfh.IdFosterHome = fh.Id
        ) AS AcceptedSizes,

        -- Accepted energy levels
        (
            SELECT GROUP_CONCAT(ple.Name ORDER BY ple.Name SEPARATOR ', ')
            FROM PetLevelEnergyXFosterHome plefh
            JOIN PetLevelEnergy ple ON plefh.IdPetLevelEnergy = ple.Id
            WHERE plefh.IdFosterHome = fh.Id
        ) AS AcceptedEnergy,

        -- Accepted spaces
        (
            SELECT GROUP_CONCAT(sr.Name ORDER BY sr.Name SEPARATOR ', ')
            FROM SpaceRequiredXFosterHome srfh
            JOIN SpaceRequired sr ON srfh.IdSpaceRequired = sr.Id
            WHERE srfh.IdFosterHome = fh.Id
        ) AS AcceptedSpaces

    FROM FosterHome fh
    JOIN Person per ON fh.IdPerson = per.Id
    ORDER BY per.FirstName ASC;
END$$


-- -------------------------------------------------------------
-- 3. Obtener la casa cuna de una persona especifica
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_get_foster_home_by_person$$

CREATE PROCEDURE pr_get_foster_home_by_person(
    IN p_idPerson INT
)
BEGIN
    SELECT
        fh.Id AS FosterHomeId,
        fh.IdPerson,
        fh.NeedsDonation,

        -- IDs as comma-separated for Java to parse
        (
            SELECT GROUP_CONCAT(IdPetSize ORDER BY IdPetSize SEPARATOR ',')
            FROM PetSizeXFosterHome
            WHERE IdFosterHome = fh.Id
        ) AS SizeIds,

        (
            SELECT GROUP_CONCAT(IdPetLevelEnergy ORDER BY IdPetLevelEnergy SEPARATOR ',')
            FROM PetLevelEnergyXFosterHome
            WHERE IdFosterHome = fh.Id
        ) AS EnergyIds,

        (
            SELECT GROUP_CONCAT(IdSpaceRequired ORDER BY IdSpaceRequired SEPARATOR ',')
            FROM SpaceRequiredXFosterHome
            WHERE IdFosterHome = fh.Id
        ) AS SpaceIds

    FROM FosterHome fh
    WHERE fh.IdPerson = p_idPerson;
END$$


-- -------------------------------------------------------------
-- 4. Actualizar una casa cuna
--    p_sizeIds, p_energyIds y p_spaceIds se reciben como texto CSV:
--    ejemplo: '1,2,3'
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_update_foster_home$$

CREATE PROCEDURE pr_update_foster_home(
    IN p_idFosterHome INT,
    IN p_idPerson INT,
    IN p_needsDonation VARCHAR(255),
    IN p_sizeIds TEXT,
    IN p_energyIds TEXT,
    IN p_spaceIds TEXT
)
BEGIN
    DECLARE v_owner INT DEFAULT NULL;
    DECLARE v_token VARCHAR(50);
    DECLARE v_csv TEXT;

    -- Security check: verify ownership
    SELECT IdPerson
    INTO v_owner
    FROM FosterHome
    WHERE Id = p_idFosterHome;

    IF v_owner IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Foster home not found.';
    END IF;

    IF v_owner <> p_idPerson THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'You can only edit your own foster home.';
    END IF;

    -- Update main record
    UPDATE FosterHome
    SET NeedsDonation = p_needsDonation
    WHERE Id = p_idFosterHome;

    -- Replace size relations
    DELETE FROM PetSizeXFosterHome
    WHERE IdFosterHome = p_idFosterHome;

    SET v_csv = TRIM(BOTH ',' FROM IFNULL(p_sizeIds, ''));

    WHILE v_csv <> '' DO
        SET v_token = TRIM(SUBSTRING_INDEX(v_csv, ',', 1));

        IF v_token <> '' THEN
            INSERT INTO PetSizeXFosterHome (
                IdPetSize,
                IdFosterHome
            )
            VALUES (
                CAST(v_token AS UNSIGNED),
                p_idFosterHome
            );
        END IF;

        IF INSTR(v_csv, ',') > 0 THEN
            SET v_csv = SUBSTRING(v_csv, INSTR(v_csv, ',') + 1);
        ELSE
            SET v_csv = '';
        END IF;
    END WHILE;

    -- Replace energy relations
    DELETE FROM PetLevelEnergyXFosterHome
    WHERE IdFosterHome = p_idFosterHome;

    SET v_csv = TRIM(BOTH ',' FROM IFNULL(p_energyIds, ''));

    WHILE v_csv <> '' DO
        SET v_token = TRIM(SUBSTRING_INDEX(v_csv, ',', 1));

        IF v_token <> '' THEN
            INSERT INTO PetLevelEnergyXFosterHome (
                IdPetLevelEnergy,
                IdFosterHome
            )
            VALUES (
                CAST(v_token AS UNSIGNED),
                p_idFosterHome
            );
        END IF;

        IF INSTR(v_csv, ',') > 0 THEN
            SET v_csv = SUBSTRING(v_csv, INSTR(v_csv, ',') + 1);
        ELSE
            SET v_csv = '';
        END IF;
    END WHILE;

    -- Replace space relations
    DELETE FROM SpaceRequiredXFosterHome
    WHERE IdFosterHome = p_idFosterHome;

    SET v_csv = TRIM(BOTH ',' FROM IFNULL(p_spaceIds, ''));

    WHILE v_csv <> '' DO
        SET v_token = TRIM(SUBSTRING_INDEX(v_csv, ',', 1));

        IF v_token <> '' THEN
            INSERT INTO SpaceRequiredXFosterHome (
                IdSpaceRequired,
                IdFosterHome
            )
            VALUES (
                CAST(v_token AS UNSIGNED),
                p_idFosterHome
            );
        END IF;

        IF INSTR(v_csv, ',') > 0 THEN
            SET v_csv = SUBSTRING(v_csv, INSTR(v_csv, ',') + 1);
        ELSE
            SET v_csv = '';
        END IF;
    END WHILE;

    COMMIT;
END$$


-- -------------------------------------------------------------
-- 5. Eliminar una casa cuna
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_delete_foster_home$$

CREATE PROCEDURE pr_delete_foster_home(
    IN p_idFosterHome INT,
    IN p_idPerson INT
)
BEGIN
    DECLARE v_owner INT DEFAULT NULL;

    -- Security check
    SELECT IdPerson
    INTO v_owner
    FROM FosterHome
    WHERE Id = p_idFosterHome;

    IF v_owner IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Foster home not found.';
    END IF;

    IF v_owner <> p_idPerson THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'You can only delete your own foster home.';
    END IF;

    -- Delete relations first because of FK constraints
    DELETE FROM PetSizeXFosterHome
    WHERE IdFosterHome = p_idFosterHome;

    DELETE FROM PetLevelEnergyXFosterHome
    WHERE IdFosterHome = p_idFosterHome;

    DELETE FROM SpaceRequiredXFosterHome
    WHERE IdFosterHome = p_idFosterHome;

    -- Delete main record
    DELETE FROM FosterHome
    WHERE Id = p_idFosterHome;

    COMMIT;
END$$

DELIMITER ;
