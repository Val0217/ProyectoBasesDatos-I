DELIMITER $$

DROP FUNCTION IF EXISTS fn_next_id$$

CREATE FUNCTION fn_next_id(
    p_table_name VARCHAR(64)
)
RETURNS BIGINT
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE v_next_id BIGINT DEFAULT NULL;

    CASE UPPER(TRIM(p_table_name))
        WHEN 'PETCLAIM' THEN
            SELECT COALESCE(MAX(Id), 0) + 1 INTO v_next_id FROM PetClaim;
        WHEN 'VETERINARIAN' THEN
            SELECT COALESCE(MAX(Id), 0) + 1 INTO v_next_id FROM Veterinarian;
        WHEN 'LOSTREPORT' THEN
            SELECT COALESCE(MAX(Id), 0) + 1 INTO v_next_id FROM LostReport;
        WHEN 'ADOPTER' THEN
            SELECT COALESCE(MAX(Id), 0) + 1 INTO v_next_id FROM Adopter;
        WHEN 'ADOPTION' THEN
            SELECT COALESCE(MAX(Id), 0) + 1 INTO v_next_id FROM Adoption;
        WHEN 'CALIFICATION' THEN
            SELECT COALESCE(MAX(Id), 0) + 1 INTO v_next_id FROM Calification;
        WHEN 'BLOCKLIST' THEN
            SELECT COALESCE(MAX(Id), 0) + 1 INTO v_next_id FROM BlockList;
        WHEN 'DONATION' THEN
            SELECT COALESCE(MAX(Id), 0) + 1 INTO v_next_id FROM Donation;
        WHEN 'FOSTERHOME' THEN
            SELECT COALESCE(MAX(Id), 0) + 1 INTO v_next_id FROM FosterHome;
        ELSE
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Tabla no soportada por fn_next_id';
    END CASE;

    RETURN v_next_id;
END$$

DELIMITER ;

/*
    Procedimiento almacenado para obtener los distritos de un cantón específico.
    Parámetros:
        - pIdCanton: El ID del cantón para el cual se desean obtener los distritos.
    Retorna:
        - Una lista de distritos con su ID y nombre.

    Cambiar logica.
*/
DROP PROCEDURE IF EXISTS pr_get_districts_by_canton;

DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_districts_by_canton(
    IN pIdCanton INT
)
BEGIN
    SELECT Id, Name
    FROM District
    WHERE IdCanton = pIdCanton;
END$$

DELIMITER ;

/* Procedimiento almacenado para obtener los cantones de una provincia específica.
    Parámetros:
        - pIdProvince: El ID de la provincia para la cual se desean obtener los cantones.
    Retorna:
        - Una lista de cantones con su ID y nombre.

    Cambiar logica.
*/

DROP PROCEDURE IF EXISTS pr_get_canton_by_province;

DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_canton_by_province(
    IN pIdProvince INT
)
BEGIN
    SELECT Id, Name
    FROM Canton
    WHERE IdProvince = pIdProvince;
END$$

DELIMITER ;

/* Procedimiento almacenado para obtener las provincias de un país específico.
    Parámetros:
        - pIdCountry: El ID del país para el cual se desean obtener las provincias.
    Retorna:
        - Una lista de provincias con su ID y nombre.

    Cambiar logica.
*/
DROP PROCEDURE IF EXISTS pr_get_province_by_country;

DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_province_by_country(
    IN pIdCountry INT
)
BEGIN
    SELECT Id, Name
    FROM Province
    WHERE IdCountry = pIdCountry;
END$$

DELIMITER ;

/* Procedimiento almacenado para obtener los cantones de una provincia específica.
    Parámetros:
        - pIdProvince: El ID de la provincia para la cual se desean obtener los cantones.
    Retorna:
        - Una lista de cantones con su ID y nombre.

    Cambiar logica.
*/
DELIMITER $$

DROP PROCEDURE IF EXISTS pr_get_all$$

CREATE OR REPLACE PROCEDURE pr_get_all(
    IN p_table_name VARCHAR(50)
)
BEGIN
    DECLARE v_table VARCHAR(50);
    DECLARE v_sql TEXT;

    SET v_table = UPPER(TRIM(p_table_name));

    IF fn_table_allowed(v_table) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tabla no permitida';
    END IF;

    IF fn_table_has_id(v_table) = 1 THEN
        SET v_sql = CONCAT('SELECT * FROM `', v_table, '` ORDER BY Id');
    ELSE
        SET v_sql = CONCAT('SELECT * FROM `', v_table, '`');
    END IF;

    SET @stmt = v_sql;
    PREPARE stmt FROM @stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS pr_get_by_id$$

CREATE OR REPLACE PROCEDURE pr_get_by_id (
    IN p_table_name VARCHAR(64),
    IN p_id BIGINT
)
BEGIN
    DECLARE v_table VARCHAR(64);
    DECLARE v_sql TEXT;

    SET v_table = UPPER(TRIM(p_table_name));

    -- Validación de tabla permitida (debe existir tu lógica o tabla auxiliar)
    IF fn_table_allowed(v_table) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tabla no permitida';
    END IF;

    -- Validación de columna Id (igual, depende de tu función)
    IF fn_table_has_id(v_table) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La tabla no tiene columna Id';
    END IF;

    SET v_sql = CONCAT('SELECT * FROM ', v_table, ' WHERE Id = ?');

    SET @stmt = v_sql;
    PREPARE stmt FROM @stmt;
    SET @p_id = p_id;

    EXECUTE stmt USING @p_id;
    DEALLOCATE PREPARE stmt;

END$$

DELIMITER ;

/* Procedimiento almacenado para obtener todas las personas registradas en la base de datos. */
DELIMITER $$

DROP PROCEDURE IF EXISTS pr_get_person_all$$

CREATE OR REPLACE PROCEDURE pr_get_person_all()
BEGIN
    SELECT * FROM Person;
END$$

DELIMITER ;

/* Procedimiento almacenado para obtener una persona por su ID. */
DELIMITER $$

DROP PROCEDURE IF EXISTS pr_get_person_by_id$$

CREATE OR REPLACE PROCEDURE pr_get_person_by_id (
    IN p_id BIGINT
)
BEGIN
    SELECT * 
    FROM Person
    WHERE Id = p_id;
END$$

DELIMITER ;

/* Procedimiento almacenado para obtener todas las mascotas registradas en la base de datos. */
DELIMITER $$

DROP PROCEDURE IF EXISTS pr_get_pet_all$$

CREATE OR REPLACE PROCEDURE pr_get_pet_all()
BEGIN
    SELECT * FROM Pet;
END$$

DELIMITER ;

/* Procedimiento almacenado para obtener una mascota por su ID. */
DELIMITER $$

DROP PROCEDURE IF EXISTS pr_get_pet_by_id$$
CREATE OR REPLACE PROCEDURE pr_get_pet_by_id (
    IN p_id BIGINT
)
BEGIN
    SELECT *
    FROM Pet
    WHERE Id = p_id;
END$$

/* Procedimiento almacenado para obtener todas las razas de mascotas registradas en la base de datos. */
DROP PROCEDURE IF EXISTS pr_get_pet_type_all$$
CREATE OR REPLACE PROCEDURE pr_get_pet_type_all()
BEGIN
    SELECT * FROM PetType;
END$$

/* Procedimiento almacenado para obtener una raza de mascota por su ID. */
DROP PROCEDURE IF EXISTS pr_get_pet_type_by_id$$
CREATE OR REPLACE PROCEDURE pr_get_pet_type_by_id (
    IN p_id BIGINT
)
BEGIN
    SELECT *
    FROM PetType
    WHERE Id = p_id;
END$$

/* Procedimiento almacenado para obtener todas las razas de mascotas registradas en la base de datos. */
DROP PROCEDURE IF EXISTS pr_get_pet_breed_all$$
CREATE OR REPLACE PROCEDURE pr_get_pet_breed_all()
BEGIN
    SELECT * FROM PetBreed;
END$$

DELIMITER ;

/* Procedimiento almacenado para obtener una raza de mascota por su ID. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_pet_breed_by_pet_type (
    IN p_id_pet_type INT
)
BEGIN
    SELECT Id, name
    FROM PetBreed
    WHERE IdType = p_id_pet_type;
END $$

DELIMITER ;

/* Procedimiento almacenado para obtener una raza de mascota por su ID. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_pet_breed_by_id (
    IN p_id INT
)
BEGIN
    SELECT Id, name, IdType
    FROM PetBreed
    WHERE Id = p_id;
END $$

DELIMITER ;

/* Procedimiento almacenado para obtener el estado de una mascota por su ID. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_pet_state_all ()
BEGIN
    SELECT *
    FROM PetState;
END $$

DELIMITER ;

/* Procedimiento almacenado para obtener el estado de una mascota por su ID. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_pet_state_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM PetState
    WHERE Id = p_id;
END $$

DELIMITER ;

/* Procedimiento almacenado para obtener el tamaño de una mascota por su ID. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_pet_size_all ()
BEGIN
    SELECT *
    FROM PetSize;
END $$

DELIMITER ;

/* Procedimiento almacenado para obtener el tamaño de una mascota por su ID. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_pet_size_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM PetSize
    WHERE Id = p_id;
END $$

DELIMITER ;

/* Procedimiento almacenado para obtener el nivel de energía de una mascota por su ID. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_pet_energy_all ()
BEGIN
    SELECT *
    FROM PetLevelEnergy;
END $$

DELIMITER ;

/* Procedimiento almacenado para obtener el nivel de energía de una mascota por su ID. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_pet_energy_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM PetLevelEnergy
    WHERE Id = p_id;
END $$

DELIMITER ;

/* Procedimiento almacenado para obtener el entrenamiento de una mascota por su ID. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_pet_training_all ()
BEGIN
    SELECT *
    FROM PetTraining;
END $$

DELIMITER ;

/* Procedimiento almacenado para obtener el entrenamiento de una mascota por su ID. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_pet_training_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM PetTraining
    WHERE Id = p_id;
END $$

DELIMITER ;

/* Procedimientos almacenados generales*/
DELIMITER $$

/* VETERINARIAN */
CREATE OR REPLACE PROCEDURE pr_get_pet_veterinarian_all ()
BEGIN
    SELECT *
    FROM Veterinarian;
END $$


/* SPACE REQUIRED - ALL */
CREATE OR REPLACE PROCEDURE pr_get_pet_space_required_all ()
BEGIN
    SELECT *
    FROM SpaceRequired;
END $$


/* SPACE REQUIRED - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_space_required_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM SpaceRequired
    WHERE Id = p_id;
END $$


/* PET ILLNESS - ALL */
CREATE OR REPLACE PROCEDURE pr_get_pet_illness_all ()
BEGIN
    SELECT *
    FROM PetIllness;
END $$


/* PET ILLNESS - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_pet_illness_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM PetIllness
    WHERE Id = p_id;
END $$


/* MEDICINE - ALL */
CREATE OR REPLACE PROCEDURE pr_get_medicine_all ()
BEGIN
    SELECT *
    FROM Medicine;
END $$


/* MEDICINE - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_medicine_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Medicine
    WHERE Id = p_id;
END $$

DELIMITER ;

/* Procedimientos almacenados generales*/
DELIMITER $$

/* PET TREATMENT - ALL */
CREATE OR REPLACE PROCEDURE pr_get_pet_treatment_all ()
BEGIN
    SELECT *
    FROM PetTreatment;
END $$


/* PET TREATMENT - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_pet_treatment_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM PetTreatment
    WHERE Id = p_id;
END $$


/* LOCATION - COUNTRY */
CREATE OR REPLACE PROCEDURE pr_get_country_all ()
BEGIN
    SELECT *
    FROM Country;
END $$


/* LOCATION - PROVINCE */
CREATE OR REPLACE PROCEDURE pr_get_province_all ()
BEGIN
    SELECT *
    FROM Province;
END $$


/* LOCATION - CANTON */
CREATE OR REPLACE PROCEDURE pr_get_canton_all ()
BEGIN
    SELECT *
    FROM Canton;
END $$


/* LOCATION - DISTRICT */
CREATE OR REPLACE PROCEDURE pr_get_district_all ()
BEGIN
    SELECT *
    FROM District;
END $$


/* LOST REPORT - ALL */
CREATE OR REPLACE PROCEDURE pr_get_lost_report_all ()
BEGIN
    SELECT *
    FROM LostReport;
END $$


/* LOST REPORT - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_lost_report_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM LostReport
    WHERE Id = p_id;
END $$


/* FOUND REPORT - ALL */
CREATE OR REPLACE PROCEDURE pr_get_found_report_all ()
BEGIN
    SELECT *
    FROM FoundReport;
END $$


/* FOUND REPORT - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_found_report_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM FoundReport
    WHERE Id = p_id;
END $$

DELIMITER ;

/* Procedimientos Generales*/
DELIMITER $$

/* PET MATCH - ALL */
CREATE OR REPLACE PROCEDURE pr_get_pet_match_all ()
BEGIN
    SELECT *
    FROM PetMatch;
END $$


/* PET MATCH - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_pet_match_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM PetMatch
    WHERE Id = p_id;
END $$


/* ADOPTION - ALL */
CREATE OR REPLACE PROCEDURE pr_get_adoption_all ()
BEGIN
    SELECT *
    FROM Adoption;
END $$


/* ADOPTION - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_adoption_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Adoption
    WHERE Id = p_id;
END $$


/* RESCUED - ALL */
CREATE OR REPLACE PROCEDURE pr_get_rescued_all ()
BEGIN
    SELECT *
    FROM Rescued;
END $$


/* RESCUED - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_rescued_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Rescued
    WHERE Id = p_id;
END $$


/* DONATION - ALL */
CREATE OR REPLACE PROCEDURE pr_get_donation_all ()
BEGIN
    SELECT *
    FROM Donation;
END $$


/* DONATION - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_donation_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Donation
    WHERE Id = p_id;
END $$

DELIMITER ;

/* Procedimiento almacenado para obtener una lista de donaciones con información detallada, incluyendo el nombre del donante, el nombre de la asociación, el monto, la moneda y la fecha de la donación. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_donation_join ()
BEGIN
    SELECT 
        d.Id,
        CONCAT(p.FirstName, ' ', p.LastName) AS DonorName,
        a.Name AS AssociationName,
        d.Amount,
        c.Name AS Currency,
        d.DonationDate
    FROM Donation d
    INNER JOIN Person p
        ON d.IdPerson = p.Id
    INNER JOIN Association a
        ON d.IdAssociation = a.Id
    INNER JOIN Currency c
        ON d.IdCurrency = c.Id
    ORDER BY d.DonationDate DESC;
END $$

DELIMITER ;

/* Porcedimientos Generales */
DELIMITER $$

/* CURRENCY - ALL */
CREATE OR REPLACE PROCEDURE pr_get_currency_all ()
BEGIN
    SELECT *
    FROM Currency;
END $$


/* CURRENCY - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_currency_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Currency
    WHERE Id = p_id;
END $$


/* ASSOCIATION - ALL */
CREATE OR REPLACE PROCEDURE pr_get_associations_all ()
BEGIN
    SELECT *
    FROM Association;
END $$


/* ASSOCIATION - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_association_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Association
    WHERE Id = p_id;
END $$


/* FOSTER HOME - ALL */
CREATE OR REPLACE PROCEDURE pr_get_foster_home_all ()
BEGIN
    SELECT *
    FROM FosterHome;
END $$


/* FOSTER HOME - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_foster_home_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM FosterHome
    WHERE Id = p_id;
END $$


/* CALIFICATION - ALL */
CREATE OR REPLACE PROCEDURE pr_get_calification_all ()
BEGIN
    SELECT *
    FROM Calification;
END $$


/* CALIFICATION - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_calification_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Calification
    WHERE Id = p_id;
END $$


/* BLOCK LIST - ALL */
CREATE OR REPLACE PROCEDURE pr_get_blocklist_all ()
BEGIN
    SELECT *
    FROM BlockList;
END $$


/* BLOCK LIST - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_blocklist_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM BlockList
    WHERE Id = p_id;
END $$

DELIMITER ;

/* procedimientos Generales */
DELIMITER $$

/* EMAIL - ALL */
CREATE OR REPLACE PROCEDURE pr_get_email_all ()
BEGIN
    SELECT *
    FROM Email;
END $$


/* EMAIL - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_email_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Email
    WHERE Id = p_id;
END $$


/* EMAIL - BY PERSON ID */
CREATE OR REPLACE PROCEDURE pr_get_email_by_person_id (
    IN p_id_person INT
)
BEGIN
    SELECT Email
    FROM Email
    WHERE IdPerson = p_id_person;
END $$


/* PHONE - ALL */
CREATE OR REPLACE PROCEDURE pr_get_phone_all ()
BEGIN
    SELECT *
    FROM Phone;
END $$


/* PHONE - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_phone_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Phone
    WHERE Id = p_id;
END $$

DELIMITER ;

/* PHONE - BY PERSON ID */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_phone_by_person_id (
    IN p_id_person INT
)
BEGIN
    SELECT
        Id,
        Phone
    FROM Phone
    WHERE IdPerson = p_id_person
    ORDER BY Id;
END $$

DELIMITER ;

DELIMITER $$

/* PARAMETER - ALL */
CREATE OR REPLACE PROCEDURE pr_get_parameter_all ()
BEGIN
    SELECT *
    FROM Parameter;
END $$


/* PARAMETER - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_parameter_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Parameter
    WHERE Id = p_id;
END $$


/* BITACORA - ALL */
CREATE OR REPLACE PROCEDURE pr_get_bitacora_all ()
BEGIN
    SELECT *
    FROM Bitacora;
END $$


/* BITACORA - BY ID */
CREATE OR REPLACE PROCEDURE pr_get_bitacora_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Bitacora
    WHERE Id = p_id;
END $$

DELIMITER ;

/* ARRIBA DE ESTO HAY QUE REVISAR TODO REVISAR */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_query_bitacora (
    IN p_table_name VARCHAR(100),
    IN p_field_name VARCHAR(100),
    IN p_changed_by INT,
    IN p_start_date DATETIME,
    IN p_end_date DATETIME
)
BEGIN
    SELECT
        Id,
        TableName,
        FieldName,
        PreviousValue,
        CurrentValue,
        ChangedBy,
        ChangeDate
    FROM Bitacora
    WHERE (p_table_name IS NULL OR UPPER(TableName) = UPPER(p_table_name))
      AND (p_field_name IS NULL OR UPPER(FieldName) = UPPER(p_field_name))
      AND (p_changed_by IS NULL OR ChangedBy = p_changed_by)
      AND (p_start_date IS NULL OR ChangeDate >= p_start_date)
      AND (p_end_date IS NULL OR ChangeDate <= p_end_date)
    ORDER BY ChangeDate DESC;
END $$

DELIMITER ;

/* Procedimiento almacenado para crear un reclamo de mascota, con validaciones para evitar reclamos inválidos o duplicados. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_create_pet_claim (
    IN p_pet_id INT,
    IN p_claimant_id INT,
    IN p_description VARCHAR(255),
    OUT p_new_id INT
)
BEGIN
    DECLARE v_owner_id INT;
    DECLARE v_state_id INT;
    DECLARE v_count INT;

    /* Obtener dueño y estado */
    SELECT IdOwner, IdState
    INTO v_owner_id, v_state_id
    FROM Pet
    WHERE Id = p_pet_id;

    /* Regla: no reclamar tu propia mascota */
    IF v_owner_id = p_claimant_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You cannot claim a pet that already belongs to you.';
    END IF;

    /* Regla: solo mascotas encontradas (estado = 4) */
    IF v_state_id <> 4 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Only found pets can be claimed.';
    END IF;

    /* Evitar reclamos duplicados pendientes */
    SELECT COUNT(*)
    INTO v_count
    FROM PetClaim
    WHERE IdPet = p_pet_id
      AND IdClaimant = p_claimant_id
      AND State = 'To be confirmed';

    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You already have a pending claim for this pet.';
    END IF;

    /* Insert */
    INSERT INTO PetClaim (
        ClaimDate,
        Description,
        State,
        IdPet,
        IdClaimant,
        IdOwner
    ) VALUES (
        NOW(),
        p_description,
        'To be confirmed',
        p_pet_id,
        p_claimant_id,
        v_owner_id
    );

    SET p_new_id = LAST_INSERT_ID();

END $$

DELIMITER ;

/* Procedimiento almacenado para obtener una lista de reclamos de mascotas pendientes para un dueño específico, con información detallada sobre la mascota y el reclamante. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_claim_requests_owner (
    IN p_owner_id INT
)
BEGIN
    SELECT
        ClaimId,
        PetId,
        ClaimantId,
        PetName,
        ClaimDescription,
        FirstName,
        LastName,
        Phone,
        District,
        Canton,
        Province,
        Country,
        ClaimState
    FROM vw_pet_claim_request_table
    WHERE OwnerId = p_owner_id
      AND ClaimState = 'To be confirmed'
    ORDER BY PetName, ClaimId;
END $$

DELIMITER ;

/* Procedimiento almacenado para aceptar un reclamo de mascota, con validaciones para asegurar que el reclamo es válido y que la transferencia de propiedad se realiza correctamente. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_accept_pet_claim (
    IN p_claim_id INT,
    IN p_owner_id INT
)
BEGIN
    DECLARE v_pet_id INT;
    DECLARE v_claimant_id INT;
    DECLARE v_rowcount INT DEFAULT 0;

    /* Obtener datos del reclamo válido */
    SELECT IdPet, IdClaimant
    INTO v_pet_id, v_claimant_id
    FROM PetClaim
    WHERE Id = p_claim_id
      AND IdOwner = p_owner_id
      AND State = 'To be confirmed';

    /* Transferir propiedad de la mascota */
    UPDATE Pet
    SET IdOwner = v_claimant_id,
        IdState = 2
    WHERE Id = v_pet_id
      AND IdOwner = p_owner_id;

    SET v_rowcount = ROW_COUNT();

    IF v_rowcount = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pet was not found for this owner.';
    END IF;

    /* Eliminar solicitudes relacionadas */
    DELETE FROM PetClaim
    WHERE IdPet = v_pet_id;

    /* Actualizar reporte de encontrado */
    UPDATE FoundReport
    SET IdPerson = v_claimant_id
    WHERE IdPet = v_pet_id;

END $$

DELIMITER ;

/* Procedimiento almacenado para rechazar un reclamo de mascota, con validaciones para asegurar que el reclamo es válido y que el estado del reclamo se actualiza correctamente. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_reject_pet_claim (
    IN p_claim_id INT,
    IN p_owner_id INT
)
BEGIN
    DECLARE v_rowcount INT DEFAULT 0;

    DELETE FROM PetClaim
    WHERE Id = p_claim_id
      AND IdOwner = p_owner_id
      AND State = 'To be confirmed';

    SET v_rowcount = ROW_COUNT();

    IF v_rowcount = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pending claim request not found for this owner.';
    END IF;

END $$

DELIMITER ;

/* Procedimiento almacenado para agregar un nuevo correo electrónico a una persona, con validaciones para asegurar que la persona existe y que el correo electrónico no se repite. */
DELIMITER $$

/* ADD EMAIL PERSON */
CREATE OR REPLACE PROCEDURE pr_add_email_person (
    IN p_email VARCHAR(255),
    IN p_idperson INT
)
BEGIN
    INSERT INTO Email (
        Email,
        IdPerson
    )
    VALUES (
        p_email,
        p_idperson
    );
END $$


/* ADD PHONE PERSON */
CREATE OR REPLACE PROCEDURE pr_add_phone_person (
    IN p_phone VARCHAR(50),
    IN p_idperson INT
)
BEGIN
    INSERT INTO Phone (
        Phone,
        IdPerson
    )
    VALUES (
        p_phone,
        p_idperson
    );
END $$

DELIMITER ;

/* Procedimiento almacenado para insertar una nueva persona en la base de datos, con validaciones para asegurar que el nombre de usuario no se repite y que el distrito existe. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_insert_person (
    IN p_firstname VARCHAR(100),
    IN p_lastname VARCHAR(100),
    IN p_password VARCHAR(255),
    IN p_username VARCHAR(100),
    IN p_iddistrict INT,
    OUT p_idperson INT
)
BEGIN
    INSERT INTO Person (
        FirstName,
        LastName,
        Password,
        Username,
        IdDistrict
    )
    VALUES (
        p_firstname,
        p_lastname,
        p_password,
        p_username,
        p_iddistrict
    );

    SET p_idperson = LAST_INSERT_ID();
END $$

DELIMITER ;

/* Procedimiento almacenado para registrar un nuevo veterinario en la base de datos, con validaciones para asegurar que el correo electrónico no se repite y que el distrito existe. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_register_veterinarian (
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_clinic_name VARCHAR(150),
    IN p_phone VARCHAR(50),
    IN p_email VARCHAR(150),
    IN p_location VARCHAR(255),
    IN p_id_district INT,
    OUT p_new_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO Veterinarian (
        FirstName,
        LastName,
        Name,
        Phone,
        Email,
        Location,
        IdDistrict
    )
    VALUES (
        p_first_name,
        p_last_name,
        p_clinic_name,
        p_phone,
        p_email,
        p_location,
        p_id_district
    );

    COMMIT;
    SET p_new_id = LAST_INSERT_ID();
END $$

DELIMITER ;

/* Procedimiento almacenado para obtener una lista de mascotas encontradas que no pertenecen al usuario actual, con información detallada sobre la mascota y su dueño. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_found_pet_table (
    IN p_current_user_id INT
)
BEGIN
    SELECT
        p.Id AS PetId,
        p.IdOwner AS OwnerId,
        owner.FirstName AS FirstName,
        owner.LastName AS LastName,
        'Click to see emails' AS Emails,
        'Click to see phones' AS Phones,
        p.Name AS PetName,
        p.Color AS Color,
        p.Chip AS Chip,
        pt.Name AS PetType,
        b.Name AS Breed,
        ps.Name AS PetSize
    FROM Pet p
    INNER JOIN Person owner
        ON owner.Id = p.IdOwner
    LEFT JOIN PetType pt
        ON pt.Id = p.IdType
    LEFT JOIN PetBreed b
        ON b.Id = p.IdBreed
    LEFT JOIN PetSize ps
        ON ps.Id = p.IdSize
    WHERE p.IdState = 4
      AND p.IdOwner <> p_current_user_id
    ORDER BY p.Name;
END $$

DELIMITER ;

/* Procedimiento almacenado para obtener los correos electrónicos de un dueño específico, con validaciones para asegurar que el dueño existe y que se devuelven los correos electrónicos ordenados alfabéticamente. */
DELIMITER $$

/* OWNER EMAILS */
CREATE OR REPLACE PROCEDURE pr_get_owner_emails (
    IN p_owner_id INT
)
BEGIN
    SELECT Email
    FROM Email
    WHERE IdPerson = p_owner_id
    ORDER BY Email;
END $$


/* OWNER PHONES */
CREATE OR REPLACE PROCEDURE pr_get_owner_phones (
    IN p_owner_id INT
)
BEGIN
    SELECT Phone
    FROM Phone
    WHERE IdPerson = p_owner_id
    ORDER BY Phone;
END $$


/* TAKE BACK MISSING REPORT */
CREATE OR REPLACE PROCEDURE pr_take_back_missing_report (
    IN p_pet_id INT,
    IN p_owner_id INT
)
BEGIN
    DECLARE v_rows INT DEFAULT 0;

    START TRANSACTION;

    UPDATE Pet
    SET IdState = 2
    WHERE Id = p_pet_id
      AND IdOwner = p_owner_id
      AND IdState = 3;

    SET v_rows = ROW_COUNT();

    IF v_rows = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pet not found, pet does not belong to this user, or pet is not currently lost.';
    END IF;

    UPDATE LostReport
    SET State = 'Found'
    WHERE IdPet = p_pet_id
      AND State = 'Lost';

    COMMIT;

END $$

DELIMITER ;

/* Procedimiento almacenado para obtener una lista de mascotas perdidas que pertenecen a un dueño específico, con información detallada sobre la mascota y su estado. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_user_missing_pet_table (
    IN p_owner_id INT
)
BEGIN
    SELECT
        PetId,
        PetName,
        Color,
        Age,
        Chip,
        Energy,
        PetState,
        PetType,
        Breed,
        District,
        SpaceRequired,
        Training,
        PetSize,
        VeterinarianName
    FROM VW_USER_PET_TABLE
    WHERE IdOwner = p_owner_id
      AND IdState = 3
    ORDER BY PetName;
END $$

DELIMITER ;

/* Procedimiento almacenado para rechazar una solicitud de adopción, con validaciones para asegurar que la solicitud es válida y que el estado de la solicitud se actualiza correctamente. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_reject_adoption_request (
    IN p_adoption_id INT,
    IN p_owner_id INT
)
BEGIN
    DECLARE v_rows INT DEFAULT 0;

    START TRANSACTION;

    UPDATE Adoption
    SET State = 'Canceled'
    WHERE Id = p_adoption_id
      AND IdOwner = p_owner_id
      AND State = 'To be confirmed';

    SET v_rows = ROW_COUNT();

    IF v_rows = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pending adoption request not found for this owner.';
    END IF;

    COMMIT;
END $$

DELIMITER ;

/* Procedimiento almacenado para registrar un nuevo reporte de mascota perdida, con validaciones para asegurar que la mascota existe, que pertenece al dueño que reporta la pérdida, y que se actualizan correctamente el estado de la mascota y las adopciones relacionadas. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_register_lost_for_owner (
    IN p_pet_id INT,
    IN p_owner_id INT,
    IN p_lost_date DATETIME,
    IN p_place VARCHAR(255),
    IN p_description VARCHAR(255),
    IN p_reward DECIMAL(10,2),
    IN p_currency_id INT,
    OUT p_new_id INT
)
BEGIN
    DECLARE v_district_id INT;
    DECLARE v_rows INT DEFAULT 0;

    /* Manejo de error tipo NO_DATA_FOUND */
    DECLARE EXIT HANDLER FOR NOT FOUND
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pet not found, or this pet does not belong to this user.';
    END;

    START TRANSACTION;

    /* Obtener distrito del pet */
    SELECT IdDistrict
    INTO v_district_id
    FROM Pet
    WHERE Id = p_pet_id
      AND IdOwner = p_owner_id;

    /* Insert LostReport */
    INSERT INTO LostReport (
        LostDate,
        Place,
        Description,
        Reward,
        State,
        IdPet,
        IdDistrict,
        IdCurrency
    )
    VALUES (
        p_lost_date,
        SUBSTRING(p_place, 1, 100),
        SUBSTRING(p_description, 1, 100),
        p_reward,
        'Lost',
        p_pet_id,
        v_district_id,
        p_currency_id
    );

    /* Cambiar estado del pet */
    UPDATE Pet
    SET IdState = 3
    WHERE Id = p_pet_id
      AND IdOwner = p_owner_id;

    /* Cancelar adopciones activas */
    UPDATE Adoption
    SET State = 'Canceled'
    WHERE IdPet = p_pet_id
      AND State IN ('In process', 'To be confirmed');

    COMMIT;
    SET p_new_id = LAST_INSERT_ID();

END $$

DELIMITER ;

/* Procedimiento almacenado para aceptar una solicitud de adopción, con validaciones para asegurar que la solicitud es válida, que la transferencia de propiedad se realiza correctamente, y que se actualizan los estados de las solicitudes relacionadas. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_accept_adoption_request (
    IN p_adoption_id INT,
    IN p_owner_id INT
)
BEGIN
    DECLARE v_pet_id INT;
    DECLARE v_adopter_id INT;
    DECLARE v_role_count INT DEFAULT 0;
    DECLARE v_rows INT DEFAULT 0;

    /* Manejo de error si no existe la adopción */
    DECLARE EXIT HANDLER FOR NOT FOUND
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pending adoption request not found for this owner.';
    END;

    START TRANSACTION;

    /* Bloqueo de la fila (equivalente a FOR UPDATE) */
    SELECT IdPet, IdAdopter
    INTO v_pet_id, v_adopter_id
    FROM Adoption
    WHERE Id = p_adoption_id
      AND IdOwner = p_owner_id
      AND State = 'To be confirmed';

    /* Actualizar propietario del pet */
    UPDATE Pet
    SET IdOwner = v_adopter_id,
        IdState = 2
    WHERE Id = v_pet_id
      AND IdOwner = p_owner_id;

    SET v_rows = ROW_COUNT();

    IF v_rows = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The pet was not found for this owner.';
    END IF;

    /* Aprobar adopción */
    UPDATE Adoption
    SET State = 'Approved',
        AdoptionDate = NOW()
    WHERE Id = p_adoption_id;

    /* Cancelar otras solicitudes pendientes */
    UPDATE Adoption
    SET State = 'Canceled'
    WHERE IdPet = v_pet_id
      AND Id <> p_adoption_id
      AND State = 'To be confirmed';

    /* Verificar si el usuario ya es Adopter */
    SELECT COUNT(*)
    INTO v_role_count
    FROM Adopter
    WHERE IdPerson = v_adopter_id;

    /* Insertar rol si no existe */
    IF v_role_count = 0 THEN
        INSERT INTO Adopter (Id, IdPerson)
        VALUES (fn_next_id('Adopter'), v_adopter_id);
    END IF;

    COMMIT;

END $$

DELIMITER ;

/* Procedimiento almacenado para crear una nueva solicitud de adopción, con validaciones para asegurar que la solicitud es válida y que no existen solicitudes pendientes duplicadas. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_create_adoption_request (
    IN p_pet_id INT,
    IN p_adopter_id INT,
    IN p_description VARCHAR(255),
    OUT p_new_id INT
)
BEGIN
    DECLARE v_owner_id INT;
    DECLARE v_state_id INT;
    DECLARE v_existing_count INT DEFAULT 0;
    DECLARE v_available_date DATETIME;
    DECLARE v_rows INT DEFAULT 0;

    /* Pet no encontrado */
    DECLARE EXIT HANDLER FOR NOT FOUND
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pet not found.';
    END;

    START TRANSACTION;

    /* Obtener dueño y estado del pet */
    SELECT IdOwner, IdState
    INTO v_owner_id, v_state_id
    FROM Pet
    WHERE Id = p_pet_id;

    /* Validación: no adoptar tu propio pet */
    IF v_owner_id = p_adopter_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You cannot request to adopt your own pet.';
    END IF;

    /* Validación: estado disponible */
    IF v_state_id <> 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This pet is not available for adoption.';
    END IF;

    /* Validar adopción pendiente existente */
    SELECT COUNT(*)
    INTO v_existing_count
    FROM Adoption
    WHERE IdPet = p_pet_id
      AND IdAdopter = p_adopter_id
      AND State = 'To be confirmed';

    IF v_existing_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You already have a pending adoption request for this pet.';
    END IF;

    /* Obtener fecha mínima de disponibilidad */
    SELECT MIN(AvailableDate)
    INTO v_available_date
    FROM Adoption
    WHERE IdPet = p_pet_id
      AND IdOwner = v_owner_id
      AND State = 'In process';

    IF v_available_date IS NULL THEN
        SELECT MIN(AvailableDate)
        INTO v_available_date
        FROM Adoption
        WHERE IdPet = p_pet_id
          AND IdOwner = v_owner_id;
    END IF;

    IF v_available_date IS NULL THEN
        SET v_available_date = NOW();
    END IF;

    /* Insert solicitud */
    INSERT INTO Adoption (
        AdoptionDate,
        AvailableDate,
        Description,
        State,
        IdPet,
        IdAdopter,
        IdOwner
    )
    VALUES (
        NULL,
        v_available_date,
        SUBSTRING(p_description, 1, 100),
        'To be confirmed',
        p_pet_id,
        p_adopter_id,
        v_owner_id
    );

    COMMIT;
    SET p_new_id = LAST_INSERT_ID();

END $$

DELIMITER ;

/* Procedimiento almacenado para obtener una lista de solicitudes de adopción pendientes para un dueño específico, con información detallada sobre la mascota, el solicitante y el estado de la solicitud. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_adoption_requests_owner (
    IN p_owner_id INT
)
BEGIN
    SELECT
        AdoptionId,
        PetId,
        AdopterId,
        PetName,
        AdoptionDescription,
        FirstName,
        LastName,
        Phone,
        Email,
        AdoptionState
    FROM vw_adoption_request_table
    WHERE OwnerId = p_owner_id
      AND AdoptionState = 'To be confirmed'
    ORDER BY PetName, AdoptionId;
END $$

DELIMITER ;

/* Alter table */
ALTER TABLE Adoption
DROP CONSTRAINT chk_Adoption_State;

/* Alter table */
ALTER TABLE Adoption
ADD CONSTRAINT chk_Adoption_State
CHECK (State IN ('In process', 'To be confirmed', 'Canceled', 'Approved'));

/* Procedimiento almacenado para actualizar la información de una mascota, con validaciones para asegurar que la mascota existe, que pertenece al dueño que realiza la actualización, y que se actualizan correctamente los campos relacionados. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_update_pet_for_owner (
    IN p_pet_id INT,
    IN p_owner_id INT,
    IN p_color VARCHAR(100),
    IN p_age INT,
    IN p_description VARCHAR(255),
    IN p_name VARCHAR(100),
    IN p_chip VARCHAR(100),
    IN p_id_energy INT,
    IN p_id_type INT,
    IN p_id_breed INT,
    IN p_id_district INT,
    IN p_id_space INT,
    IN p_id_pet_training INT,
    IN p_id_size INT,
    IN p_id_veterinarian INT,
    OUT p_rows_updated INT
)
BEGIN
    UPDATE Pet
    SET
        Color = p_color,
        Age = p_age,
        Description = p_description,
        Name = p_name,
        Chip = p_chip,
        IdEnergy = p_id_energy,
        IdType = p_id_type,
        IdBreed = p_id_breed,
        IdDistrict = p_id_district,
        IdSpace = p_id_space,
        IdPetTraining = p_id_pet_training,
        IdSize = p_id_size,
        IdVeterinarian = p_id_veterinarian
    WHERE Id = p_pet_id
      AND IdOwner = p_owner_id;

    SET p_rows_updated = ROW_COUNT();
END $$

DELIMITER ;

/* Procedimiento almacenado para obtener la información de una mascota para edición, con validaciones para asegurar que la mascota existe y que pertenece al dueño que realiza la consulta. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_pet_for_edit (
    IN p_pet_id INT,
    IN p_owner_id INT
)
BEGIN
    SELECT
        p.Id AS IdPet,
        p.IdOwner,
        p.Color,
        p.Age,
        p.Description,
        p.Name AS PetName,
        p.Chip,
        p.IdEnergy,
        p.IdType,
        p.IdBreed,
        p.IdDistrict,
        ca.Id AS IdCanton,
        pr.Id AS IdProvince,
        co.Id AS IdCountry,
        p.IdSpace,
        p.IdPetTraining,
        p.IdSize,
        p.IdVeterinarian
    FROM Pet p
    INNER JOIN District d
        ON d.Id = p.IdDistrict
    INNER JOIN Canton ca
        ON ca.Id = d.IdCanton
    INNER JOIN Province pr
        ON pr.Id = ca.IdProvince
    INNER JOIN Country co
        ON co.Id = pr.IdCountry
    WHERE p.Id = p_pet_id
      AND p.IdOwner = p_owner_id;
END $$

DELIMITER ;

/* Procedimiento almacenado para retirar una mascota del estado de adopción, con validaciones para asegurar que la mascota existe, que pertenece al dueño que realiza la acción, y que se actualizan correctamente el estado de la mascota y las solicitudes de adopción relacionadas. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_undo_pet_up_for_adoption (
    IN p_pet_id INT,
    IN p_owner_id INT
)
BEGIN
    DECLARE v_rows INT DEFAULT 0;

    START TRANSACTION;

    UPDATE Pet
    SET IdState = 2
    WHERE Id = p_pet_id
      AND IdOwner = p_owner_id
      AND IdState = 1;

    SET v_rows = ROW_COUNT();

    IF v_rows = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pet was not found, does not belong to this user, or is not up for adoption.';
    END IF;

    UPDATE Adoption
    SET State = 'Canceled'
    WHERE IdPet = p_pet_id
      AND IdOwner = p_owner_id
      AND State IN ('In process', 'To be confirmed');

    COMMIT;
END $$

DELIMITER ;

/* Procedimientos para filtros de mascotas */
DELIMITER $$

/* ------------------------------------------------------------
   SP_GET_PETS_BY_STATE
------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_get_pets_by_state (
    IN p_id_state INT,
    IN p_color VARCHAR(100),
    IN p_age INT,
    IN p_name VARCHAR(100),
    IN p_chip VARCHAR(100),
    IN p_energy VARCHAR(100),
    IN p_type VARCHAR(100),
    IN p_breed VARCHAR(100),
    IN p_district VARCHAR(100),
    IN p_space_required VARCHAR(100),
    IN p_training VARCHAR(100),
    IN p_size VARCHAR(100),
    IN p_veterinarian VARCHAR(100)
)
BEGIN
    SELECT *
    FROM Pet
    WHERE IdState = p_id_state;
END $$


/* ------------------------------------------------------------
   SP_GET_PETS_UP_FOR_ADOPTION
------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_get_pets_up_for_adoption (
    IN p_color VARCHAR(100),
    IN p_age INT,
    IN p_name VARCHAR(100),
    IN p_chip VARCHAR(100),
    IN p_energy VARCHAR(100),
    IN p_type VARCHAR(100),
    IN p_breed VARCHAR(100),
    IN p_district VARCHAR(100),
    IN p_space_required VARCHAR(100),
    IN p_training VARCHAR(100),
    IN p_size VARCHAR(100),
    IN p_veterinarian VARCHAR(100)
)
BEGIN
    SELECT *
    FROM Pet
    WHERE IdState = 1;
END $$


/* ------------------------------------------------------------
   SP_GET_FOUND_PETS
------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_get_found_pets (
    IN p_color VARCHAR(100),
    IN p_age INT,
    IN p_name VARCHAR(100),
    IN p_chip VARCHAR(100),
    IN p_energy VARCHAR(100),
    IN p_type VARCHAR(100),
    IN p_breed VARCHAR(100),
    IN p_district VARCHAR(100),
    IN p_space_required VARCHAR(100),
    IN p_training VARCHAR(100),
    IN p_size VARCHAR(100),
    IN p_veterinarian VARCHAR(100)
)
BEGIN
    SELECT *
    FROM Pet
    WHERE IdState = 4;
END $$


/* ------------------------------------------------------------
   FN_PUT_PET_UP_FOR_ADOPTION (FUNCTION → PROCEDURE)
------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_put_pet_up_for_adoption (
    IN p_pet_id INT,
    IN p_owner_id INT,
    OUT p_result INT
)
BEGIN
    UPDATE Pet
    SET IdState = 1
    WHERE Id = p_pet_id
      AND IdOwner = p_owner_id;

    SET p_result = ROW_COUNT();
END $$


/* ------------------------------------------------------------
   OPTIONS QUERIES (CURSOR → SELECT)
------------------------------------------------------------ */

CREATE OR REPLACE PROCEDURE pr_get_energy_options ()
BEGIN
    SELECT * FROM PetLevelEnergy;
END $$

CREATE OR REPLACE PROCEDURE pr_get_type_options ()
BEGIN
    SELECT * FROM PetType;
END $$

CREATE OR REPLACE PROCEDURE pr_get_breed_options ()
BEGIN
    SELECT * FROM PetBreed;
END $$

CREATE OR REPLACE PROCEDURE pr_get_district_options ()
BEGIN
    SELECT * FROM District;
END $$

CREATE OR REPLACE PROCEDURE pr_get_space_required_options ()
BEGIN
    SELECT * FROM SpaceRequired;
END $$

CREATE OR REPLACE PROCEDURE pr_get_training_options ()
BEGIN
    SELECT * FROM PetTraining;
END $$

CREATE OR REPLACE PROCEDURE pr_get_size_options ()
BEGIN
    SELECT * FROM PetSize;
END $$

CREATE OR REPLACE PROCEDURE pr_get_veterinarian_options ()
BEGIN
    SELECT * FROM Veterinarian;
END $$

DELIMITER ;

/* Procedimientos almacenados para filtros de mascotas, con validaciones para asegurar que se filtran correctamente por estado y que se pueden reutilizar para diferentes estados. */
DELIMITER $$

/* ============================================================
   GET PETS BY STATE (CORE FILTER)
============================================================ */
CREATE OR REPLACE PROCEDURE pr_pkg_get_pets_by_state (
    IN p_id_state INT,
    IN p_color VARCHAR(100),
    IN p_age INT,
    IN p_name VARCHAR(100),
    IN p_chip VARCHAR(100),
    IN p_energy VARCHAR(100),
    IN p_type VARCHAR(100),
    IN p_breed VARCHAR(100),
    IN p_district VARCHAR(100),
    IN p_space_required VARCHAR(100),
    IN p_training VARCHAR(100),
    IN p_size VARCHAR(100),
    IN p_veterinarian VARCHAR(100)
)
BEGIN
    SELECT *
    FROM VW_TABLE_ADOPTION
    WHERE IdState = p_id_state;
END $$


/* ============================================================
   UP FOR ADOPTION
============================================================ */
CREATE OR REPLACE PROCEDURE pr_pkg_get_pets_up_for_adoption (
    IN p_color VARCHAR(100),
    IN p_age INT,
    IN p_name VARCHAR(100),
    IN p_chip VARCHAR(100),
    IN p_energy VARCHAR(100),
    IN p_type VARCHAR(100),
    IN p_breed VARCHAR(100),
    IN p_district VARCHAR(100),
    IN p_space_required VARCHAR(100),
    IN p_training VARCHAR(100),
    IN p_size VARCHAR(100),
    IN p_veterinarian VARCHAR(100)
)
BEGIN
    CALL pr_get_pets_by_state(1, p_color, p_age, p_name, p_chip,
        p_energy, p_type, p_breed, p_district, p_space_required,
        p_training, p_size, p_veterinarian);
END $$


/* ============================================================
   FOUND PETS
============================================================ */
CREATE OR REPLACE PROCEDURE pr_pkg_get_found_pets (
    IN p_color VARCHAR(100),
    IN p_age INT,
    IN p_name VARCHAR(100),
    IN p_chip VARCHAR(100),
    IN p_energy VARCHAR(100),
    IN p_type VARCHAR(100),
    IN p_breed VARCHAR(100),
    IN p_district VARCHAR(100),
    IN p_space_required VARCHAR(100),
    IN p_training VARCHAR(100),
    IN p_size VARCHAR(100),
    IN p_veterinarian VARCHAR(100)
)
BEGIN
    CALL pr_get_pets_by_state(4, p_color, p_age, p_name, p_chip,
        p_energy, p_type, p_breed, p_district, p_space_required,
        p_training, p_size, p_veterinarian);
END $$


/* ============================================================
   PUT PET UP FOR ADOPTION (FUNCTION → PROCEDURE)
============================================================ */
CREATE OR REPLACE PROCEDURE pr_pkg_put_pet_up_for_adoption (
    IN p_pet_id INT,
    IN p_owner_id INT,
    OUT p_result INT
)
BEGIN
    DECLARE v_state INT;

    SELECT IdState INTO v_state
    FROM Pet
    WHERE Id = p_pet_id AND IdOwner = p_owner_id;

    IF v_state = 3 THEN
        SET p_result = -2;
    ELSE
        UPDATE Pet
        SET IdState = 1
        WHERE Id = p_pet_id AND IdOwner = p_owner_id;

        UPDATE Adoption
        SET AdoptionDate = NULL,
            AvailableDate = NOW(),
            Description = 'Pet put up for adoption by owner.',
            State = 'In process',
            IdAdopter = NULL,
            IdOwner = p_owner_id
        WHERE IdPet = p_pet_id
          AND State IN ('In process', 'To be confirmed');

        IF ROW_COUNT() = 0 THEN
            INSERT INTO Adoption (
                AdoptionDate,
                AvailableDate,
                Description,
                State,
                IdPet,
                IdAdopter,
                IdOwner
            )
            VALUES (
                NULL,
                NOW(),
                'Pet put up for adoption by owner.',
                'In process',
                p_pet_id,
                NULL,
                p_owner_id
            );
        END IF;

        SET p_result = 1;
    END IF;
END $$


/* ============================================================
   OPTIONS (ALL CURSOR FUNCTIONS → SELECT)
============================================================ */

CREATE OR REPLACE PROCEDURE pr_pkg_get_energy_options ()
BEGIN
    SELECT 'All' AS Name, 0 AS SortOrder
    UNION ALL SELECT Name, 1 FROM PetLevelEnergy;
END $$

CREATE OR REPLACE PROCEDURE pr_pkg_get_type_options ()
BEGIN
    SELECT 'All' AS Name, 0 AS SortOrder
    UNION ALL SELECT Name, 1 FROM PetType;
END $$

CREATE OR REPLACE PROCEDURE pr_pkg_get_breed_options ()
BEGIN
    SELECT 'All' AS Name, 0 AS SortOrder
    UNION ALL SELECT Name, 1 FROM PetBreed;
END $$

CREATE OR REPLACE PROCEDURE pr_pkg_get_district_options ()
BEGIN
    SELECT 'All' AS Name, 0 AS SortOrder
    UNION ALL SELECT Name, 1 FROM District;
END $$

CREATE OR REPLACE PROCEDURE pr_pkg_get_space_required_options ()
BEGIN
    SELECT 'All' AS Name, 0 AS SortOrder
    UNION ALL SELECT Name, 1 FROM SpaceRequired;
END $$

CREATE OR REPLACE PROCEDURE pr_pkg_get_training_options ()
BEGIN
    SELECT 'All' AS Name, 0 AS SortOrder
    UNION ALL SELECT Name, 1 FROM PetTraining;
END $$

CREATE OR REPLACE PROCEDURE pr_pkg_get_size_options ()
BEGIN
    SELECT 'All' AS Name, 0 AS SortOrder
    UNION ALL SELECT Name, 1 FROM PetSize;
END $$

CREATE OR REPLACE PROCEDURE pr_pkg_get_veterinarian_options ()
BEGIN
    SELECT 'All' AS VeterinarianName, 0 AS SortOrder
    UNION ALL
    SELECT DISTINCT VeterinarianName, 1
    FROM VW_TABLE_ADOPTION
    WHERE VeterinarianName IS NOT NULL;
END $$

DELIMITER ;

/** Procedimiento almacenado para obtener los valores de un catálogo específico, con validaciones para asegurar que el nombre del catálogo es válido y que se devuelven los resultados ordenados alfabéticamente. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_catalog (
    IN p_catalog_name VARCHAR(50)
)
BEGIN
    DECLARE v_cat VARCHAR(50);

    SET v_cat = UPPER(TRIM(p_catalog_name));

    IF v_cat = 'ENERGY' THEN
        SELECT Id, Name FROM PetLevelEnergy ORDER BY Name;

    ELSEIF v_cat = 'TYPE' THEN
        SELECT Id, Name FROM PetType ORDER BY Name;

    ELSEIF v_cat = 'BREED' THEN
        SELECT Id, Name FROM PetBreed ORDER BY Name;

    ELSEIF v_cat = 'DISTRICT' THEN
        SELECT Id, Name FROM District ORDER BY Name;

    ELSEIF v_cat = 'COUNTRY' THEN
        SELECT Id, Name FROM Country ORDER BY Name;

    ELSEIF v_cat = 'PROVINCE' THEN
        SELECT Id, Name FROM Province ORDER BY Name;

    ELSEIF v_cat = 'CANTON' THEN
        SELECT Id, Name FROM Canton ORDER BY Name;

    ELSEIF v_cat = 'SPACE' THEN
        SELECT Id, Name FROM SpaceRequired ORDER BY Name;

    ELSEIF v_cat = 'TRAINING' THEN
        SELECT Id, Name FROM PetTraining ORDER BY Name;

    ELSEIF v_cat = 'SIZE' THEN
        SELECT Id, Name FROM PetSize ORDER BY Name;

    ELSEIF v_cat = 'VETERINARIAN' THEN
        SELECT Id,
               CASE 
                   WHEN Name IS NOT NULL THEN Name
                   ELSE CONCAT(FirstName, ' ', LastName)
               END AS Name
        FROM Veterinarian
        ORDER BY Name;

    ELSEIF v_cat = 'CURRENCY' THEN
        SELECT Id, Name FROM Currency ORDER BY Name;

    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid catalog name';
    END IF;
END $$

DELIMITER ;

/** Procedimiento almacenado para obtener una lista de mascotas disponibles para adopción que no pertenecen al usuario actual, con filtros opcionales para diferentes atributos de la mascota y validaciones para asegurar que se excluyen las mascotas con solicitudes de adopción pendientes del usuario. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_adoption_pet_table (
    IN p_current_user_id INT,
    IN p_id_energy INT,
    IN p_id_type INT,
    IN p_id_breed INT,
    IN p_id_country INT,
    IN p_id_province INT,
    IN p_id_canton INT,
    IN p_id_district INT,
    IN p_id_space INT,
    IN p_id_training INT,
    IN p_id_size INT,
    IN p_id_veterinarian INT,
    IN p_color VARCHAR(100),
    IN p_age INT,
    IN p_name VARCHAR(100),
    IN p_chip VARCHAR(100)
)
BEGIN
    SELECT
        PetId,
        PetName,
        Color,
        Age,
        Chip,
        Energy,
        PetState,
        PetType,
        Breed,
        District,
        SpaceRequired,
        Training,
        PetSize,
        VeterinarianName
    FROM VW_USER_PET_TABLE
    WHERE IdState = 1
      AND IdOwner <> p_current_user_id

      AND NOT EXISTS (
          SELECT 1
          FROM Adoption a
          WHERE a.IdPet = VW_USER_PET_TABLE.PetId
            AND a.IdAdopter = p_current_user_id
            AND a.State = 'To be confirmed'
      )

      AND (p_id_energy IS NULL OR IdEnergy = p_id_energy)
      AND (p_id_type IS NULL OR IdType = p_id_type)
      AND (p_id_breed IS NULL OR IdBreed = p_id_breed)
      AND (p_id_country IS NULL OR IdCountry = p_id_country)
      AND (p_id_province IS NULL OR IdProvince = p_id_province)
      AND (p_id_canton IS NULL OR IdCanton = p_id_canton)
      AND (p_id_district IS NULL OR IdDistrict = p_id_district)
      AND (p_id_space IS NULL OR IdSpace = p_id_space)
      AND (p_id_training IS NULL OR IdPetTraining = p_id_training)
      AND (p_id_size IS NULL OR IdSize = p_id_size)
      AND (p_id_veterinarian IS NULL OR IdVeterinarian = p_id_veterinarian)

      AND (p_color IS NULL OR LOWER(Color) LIKE CONCAT('%', LOWER(p_color), '%'))
      AND (p_age IS NULL OR Age = p_age)
      AND (p_name IS NULL OR LOWER(PetName) LIKE CONCAT('%', LOWER(p_name), '%'))
      AND (p_chip IS NULL OR LOWER(Chip) LIKE CONCAT('%', LOWER(p_chip), '%'))

    ORDER BY PetName;
END $$

DELIMITER ;

/** Procedimiento almacenado para obtener una lista de mascotas perdidas que pertenecen a un dueño específico, con filtros opcionales para diferentes atributos de la mascota y validaciones para asegurar que se devuelven solo las mascotas del dueño que cumplen con los criterios de búsqueda. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_get_user_pet_table (
    IN p_id_owner INT,
    IN p_id_energy INT,
    IN p_id_type INT,
    IN p_id_breed INT,
    IN p_id_district INT,
    IN p_id_country INT,
    IN p_id_province INT,
    IN p_id_canton INT,
    IN p_id_space INT,
    IN p_id_training INT,
    IN p_id_size INT,
    IN p_id_veterinarian INT,
    IN p_color VARCHAR(100),
    IN p_age INT,
    IN p_name VARCHAR(100),
    IN p_chip VARCHAR(100)
)
BEGIN
    SELECT
        PetId,
        PetName,
        Color,
        Age,
        Chip,
        Energy,
        PetState,
        PetType,
        Breed,
        District,
        SpaceRequired,
        Training,
        PetSize,
        VeterinarianName
    FROM VW_USER_PET_TABLE
    WHERE IdOwner = p_id_owner

      AND (p_id_energy IS NULL OR IdEnergy = p_id_energy)
      AND (p_id_type IS NULL OR IdType = p_id_type)
      AND (p_id_breed IS NULL OR IdBreed = p_id_breed)
      AND (p_id_district IS NULL OR IdDistrict = p_id_district)
      AND (p_id_country IS NULL OR IdCountry = p_id_country)
      AND (p_id_province IS NULL OR IdProvince = p_id_province)
      AND (p_id_canton IS NULL OR IdCanton = p_id_canton)
      AND (p_id_space IS NULL OR IdSpace = p_id_space)
      AND (p_id_training IS NULL OR IdPetTraining = p_id_training)
      AND (p_id_size IS NULL OR IdSize = p_id_size)
      AND (p_id_veterinarian IS NULL OR IdVeterinarian = p_id_veterinarian)

      AND (p_color IS NULL OR UPPER(Color) LIKE CONCAT('%', UPPER(p_color), '%'))
      AND (p_age IS NULL OR Age = p_age)
      AND (p_name IS NULL OR UPPER(PetName) LIKE CONCAT('%', UPPER(p_name), '%'))
      AND (p_chip IS NULL OR UPPER(Chip) LIKE CONCAT('%', UPPER(p_chip), '%'))

    ORDER BY PetName;
END $$

DELIMITER ;

/** Procedimiento almacenado para poner una mascota en adopción, con validaciones para asegurar que la mascota existe, que pertenece al dueño que realiza la acción, y que se actualizan correctamente el estado de la mascota y las solicitudes de adopción relacionadas. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_put_pet_up_for_adoption (
    IN p_pet_id INT,
    IN p_owner_id INT
)
BEGIN
    DECLARE v_rows INT DEFAULT 0;

    START TRANSACTION;

    UPDATE Pet
    SET IdState = 1
    WHERE Id = p_pet_id
      AND IdOwner = p_owner_id;

    SET v_rows = ROW_COUNT();

    IF v_rows = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pet not found, or this pet does not belong to this user.';
    ELSE
        COMMIT;
    END IF;

END $$

DELIMITER ;

/** Procedimiento almacenado para registrar una nueva mascota, con validaciones para asegurar que se insertan correctamente los datos de la mascota y que se devuelve el ID de la nueva mascota creada. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_register_pet (
    IN p_color VARCHAR(100),
    IN p_age INT,
    IN p_description VARCHAR(255),
    IN p_name VARCHAR(100),
    IN p_chip VARCHAR(100),
    IN p_id_energy INT,
    IN p_id_state INT,
    IN p_id_type INT,
    IN p_id_breed INT,
    IN p_id_district INT,
    IN p_id_space INT,
    IN p_id_training INT,
    IN p_id_size INT,
    IN p_id_owner INT,
    IN p_id_veterinarian INT,
    OUT p_new_id INT
)
BEGIN
    START TRANSACTION;

    INSERT INTO Pet (
        Color, Age, Description, Name, Chip,
        IdEnergy, IdState, IdType, IdBreed, IdDistrict,
        IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
    )
    VALUES (
        p_color, p_age, p_description, p_name, p_chip,
        p_id_energy, p_id_state, p_id_type, p_id_breed, p_id_district,
        p_id_space, p_id_training, p_id_size, p_id_owner, p_id_veterinarian
    );

    SET p_new_id = LAST_INSERT_ID();

    COMMIT;
END $$

DELIMITER ;

/* Procedimiento almacenado para actualizar la información de una mascota, con validaciones para asegurar que la mascota existe y que se actualizan correctamente los campos relacionados. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_update_pet (
    IN p_id INT,
    IN p_color VARCHAR(100),
    IN p_age INT,
    IN p_description VARCHAR(255),
    IN p_name VARCHAR(100),
    IN p_chip VARCHAR(100),
    IN p_id_energy INT,
    IN p_id_state INT,
    IN p_id_type INT,
    IN p_id_breed INT,
    IN p_id_district INT,
    IN p_id_space INT,
    IN p_id_training INT,
    IN p_id_size INT,
    IN p_id_owner INT,
    IN p_id_veterinarian INT
)
BEGIN
    START TRANSACTION;

    UPDATE Pet
    SET Color = p_color,
        Age = p_age,
        Description = p_description,
        Name = p_name,
        Chip = p_chip,
        IdEnergy = p_id_energy,
        IdState = p_id_state,
        IdType = p_id_type,
        IdBreed = p_id_breed,
        IdDistrict = p_id_district,
        IdSpace = p_id_space,
        IdPetTraining = p_id_training,
        IdSize = p_id_size,
        IdOwner = p_id_owner,
        IdVeterinarian = p_id_veterinarian
    WHERE Id = p_id;

    COMMIT;
END $$

DELIMITER ;

/* Procedimiento almacenado para buscar mascotas perdidas, con filtros opcionales para diferentes atributos de la mascota y validaciones para asegurar que se devuelven solo las mascotas que cumplen con los criterios de búsqueda. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_search_pets (
    IN p_id_type INT,
    IN p_id_breed INT,
    IN p_id_state INT,
    IN p_chip VARCHAR(100),
    IN p_id_district INT,
    IN p_name VARCHAR(100)
)
BEGIN
    SELECT 
        p.Id,
        p.Name,
        p.Chip,
        p.Color,
        p.Age,
        pt.Name AS PetType,
        pb.Name AS Breed,
        ps.Name AS State,
        d.Name  AS District,
        COALESCE(lr.LostDate, fr.FoundDate) AS ReportDate
    FROM Pet p
    LEFT JOIN PetType pt ON pt.Id = p.IdType
    LEFT JOIN PetBreed pb ON pb.Id = p.IdBreed
    LEFT JOIN PetState ps ON ps.Id = p.IdState
    LEFT JOIN District d ON d.Id = p.IdDistrict
    LEFT JOIN LostReport lr ON lr.IdPet = p.Id
    LEFT JOIN FoundReport fr ON fr.IdPet = p.Id
    WHERE (p_id_type IS NULL OR p.IdType = p_id_type)
      AND (p_id_breed IS NULL OR p.IdBreed = p_id_breed)
      AND (p_id_state IS NULL OR p.IdState = p_id_state)
      AND (p_chip IS NULL OR UPPER(p.Chip) = UPPER(p_chip))
      AND (p_id_district IS NULL OR p.IdDistrict = p_id_district)
      AND (p_name IS NULL OR UPPER(p.Name) LIKE CONCAT('%', UPPER(p_name), '%'))
    ORDER BY COALESCE(lr.LostDate, fr.FoundDate) DESC;
END $$

DELIMITER ;

/* Procedimiento almacenado para registrar un nuevo reporte de mascota perdida, con validaciones para asegurar que se insertan correctamente los datos del reporte y que se devuelve el ID del nuevo reporte creado. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_register_lost_report (
    IN p_lost_date DATETIME,
    IN p_place VARCHAR(255),
    IN p_description VARCHAR(255),
    IN p_reward DECIMAL(10,2),
    IN p_state VARCHAR(50),
    IN p_id_pet INT,
    IN p_id_district INT,
    IN p_id_currency INT,
    OUT p_new_id INT
)
BEGIN
    START TRANSACTION;

    INSERT INTO LostReport (
        LostDate,
        Place,
        Description,
        Reward,
        State,
        IdPet,
        IdDistrict,
        IdCurrency
    )
    VALUES (
        p_lost_date,
        p_place,
        p_description,
        p_reward,
        p_state,
        p_id_pet,
        p_id_district,
        p_id_currency
    );

    SET p_new_id = LAST_INSERT_ID();

    COMMIT;
END $$

DELIMITER ;

/* Procedimiento almacenado para registrar un nuevo reporte de mascota encontrada, con validaciones para asegurar que se insertan correctamente los datos del reporte y que se devuelve el ID del nuevo reporte creado. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_register_found_report (
    IN p_found_date DATETIME,
    IN p_place VARCHAR(255),
    IN p_description VARCHAR(255),
    IN p_id_pet INT,
    IN p_id_district INT,
    IN p_id_person INT,
    OUT p_new_id INT
)
BEGIN
    START TRANSACTION;

    INSERT INTO FoundReport (
        FoundDate,
        Place,
        Description,
        IdPet,
        IdDistrict,
        IdPerson
    )
    VALUES (
        p_found_date,
        p_place,
        p_description,
        p_id_pet,
        p_id_district,
        p_id_person
    );

    SET p_new_id = LAST_INSERT_ID();

    COMMIT;
END $$

DELIMITER ;

/* Procedimiento almacenado para generar coincidencias entre reportes de mascotas perdidas y encontradas, con validaciones para asegurar que se calculan correctamente los puntajes de similitud y que se insertan las coincidencias en la tabla correspondiente solo si cumplen con el umbral mínimo establecido. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_generate_pet_matches()
BEGIN
    DECLARE v_score INT DEFAULT 0;
    DECLARE v_min_score INT DEFAULT 60;
    DECLARE v_new_id INT;
    DECLARE v_exists INT;

    DECLARE done_lost INT DEFAULT 0;
    DECLARE done_found INT DEFAULT 0;

    DECLARE v_lost_id INT;
    DECLARE v_lost_pet INT;

    DECLARE v_found_id INT;
    DECLARE v_found_pet INT;

    DECLARE cur_lost CURSOR FOR
        SELECT Id, IdPet
        FROM LostReport
        WHERE UPPER(State) = 'PERDIDO';

    DECLARE cur_found CURSOR FOR
        SELECT Id, IdPet
        FROM FoundReport;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done_lost = 1;

    /* obtener parámetro */
    SELECT CAST(Value AS SIGNED)
    INTO v_min_score
    FROM Parameter
    WHERE Name = 'MIN_MATCH_PERCENTAGE'
    LIMIT 1;

    OPEN cur_lost;

    read_lost: LOOP
        FETCH cur_lost INTO v_lost_id, v_lost_pet;

        IF done_lost = 1 THEN
            LEAVE read_lost;
        END IF;

        /* reiniciar cursor found para cada lost */
        SET done_found = 0;
        OPEN cur_found;

        read_found: LOOP
            FETCH cur_found INTO v_found_id, v_found_pet;

            IF done_found = 1 THEN
                LEAVE read_found;
            END IF;

            /* aquí llamamos lógica de scoring */
            SET v_score = fn_pet_match_score(v_lost_pet, v_found_pet);

            IF v_score >= v_min_score THEN

                SELECT COUNT(*)
                INTO v_exists
                FROM PetMatch
                WHERE IdLostReport = v_lost_id
                  AND IdFoundReport = v_found_id;

                IF v_exists = 0 THEN

                    INSERT INTO PetMatch (
                        SimilarityPercentage,
                        MatchDate,
                        IdLostReport,
                        IdFoundReport
                    )
                    VALUES (
                        v_score,
                        NOW(),
                        v_lost_id,
                        v_found_id
                    );

                END IF;

            END IF;

        END LOOP;

        CLOSE cur_found;

    END LOOP;

    CLOSE cur_lost;

END $$

DELIMITER ;

/* Procedimiento almacenado para generar un reporte de coincidencias entre mascotas perdidas y encontradas, con filtros opcionales para el rango de fechas de las coincidencias y validaciones para asegurar que se devuelven solo las coincidencias que cumplen con los criterios de búsqueda. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_report_pet_matches (
    p_start_date DATETIME,
    p_end_date DATETIME
)
BEGIN
    SELECT
        pm.Id AS MatchId,
        pm.SimilarityPercentage,
        pm.MatchDate,

        lost_pet.Id AS LostPetId,
        lost_pet.Name AS LostPetName,
        lost_pet.Chip AS LostPetChip,
        lost_pet.Color AS LostPetColor,
        lr.Place AS LostPlace,
        lr.LostDate,

        found_pet.Id AS FoundPetId,
        found_pet.Name AS FoundPetName,
        found_pet.Chip AS FoundPetChip,
        found_pet.Color AS FoundPetColor,
        fr.Place AS FoundPlace,
        fr.FoundDate

    FROM PetMatch pm
    INNER JOIN LostReport lr ON lr.Id = pm.IdLostReport
    INNER JOIN FoundReport fr ON fr.Id = pm.IdFoundReport
    INNER JOIN Pet lost_pet ON lost_pet.Id = lr.IdPet
    INNER JOIN Pet found_pet ON found_pet.Id = fr.IdPet

    WHERE (p_start_date IS NULL OR pm.MatchDate >= p_start_date)
      AND (p_end_date IS NULL OR pm.MatchDate <= p_end_date)

    ORDER BY pm.MatchDate DESC;
END$$

DELIMITER ;

/
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_calificate_person (
    p_stars INT,
    p_note VARCHAR(255),
    p_id_person INT,
    OUT p_new_id INT
)
BEGIN

    INSERT INTO Calification (
        Id,
        Stars,
        Note,
        CalificationDate,
        IdPerson
    )
    VALUES (
        p_new_id,
        p_stars,
        p_note,
        NOW(),
        p_id_person
    );

    SET p_new_id = LAST_INSERT_ID();
END$$

DELIMITER ;

/* Procedimiento almacenado para agregar una persona a la lista de bloqueados, con validaciones para asegurar que se inserta correctamente el registro en la tabla de bloqueados y que se devuelve el ID del nuevo registro creado. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_add_to_blocklist (
    p_id_person INT,
    OUT p_new_id INT
)
BEGIN

    INSERT INTO BlockList (
        Id,
        BlockDate,
        IdPerson
    )
    VALUES (
        p_new_id,
        NOW(),
        p_id_person
    );

    SET p_new_id = LAST_INSERT_ID();
END$$

DELIMITER ;

/* Procedimiento almacenado para registrar una nueva donación, con validaciones para asegurar que se insertan correctamente los datos de la donación y que se devuelve el ID de la nueva donación creada. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_register_donation (
    p_amount DECIMAL(10,2),
    p_donation_date DATETIME,
    p_id_person INT,
    p_id_currency INT,
    p_id_association INT,
    OUT p_new_id INT
)
BEGIN

    INSERT INTO Donation (
        Id,
        Amount,
        DonationDate,
        IdPerson,
        IdCurrency,
        IdAssociation
    )
    VALUES (
        p_new_id,
        p_amount,
        p_donation_date,
        p_id_person,
        p_id_currency,
        p_id_association
    );

    SET p_new_id = LAST_INSERT_ID();
END$$

DELIMITER ;

/* Procedimiento almacenado para generar un reporte de donaciones, con filtros opcionales para el rango de fechas, el donante, la asociación receptora, y el monto de la donación, y validaciones para asegurar que se devuelven solo las donaciones que cumplen con los criterios de búsqueda. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_report_donations (
    p_start_date DATETIME,
    p_end_date DATETIME,
    p_id_person INT,
    p_id_association INT,
    p_min_amount DECIMAL(10,2),
    p_max_amount DECIMAL(10,2)
)
BEGIN
    SELECT
        d.Id,
        d.Amount,
        d.DonationDate,
        c.Name AS Currency,
        CONCAT(p.FirstName, ' ', p.LastName) AS Donor,
        a.Name AS AssociationName
    FROM Donation d
    INNER JOIN Person p ON p.Id = d.IdPerson
    INNER JOIN Association a ON a.Id = d.IdAssociation
    INNER JOIN Currency c ON c.Id = d.IdCurrency
    WHERE (p_start_date IS NULL OR d.DonationDate >= p_start_date)
      AND (p_end_date IS NULL OR d.DonationDate <= p_end_date)
      AND (p_id_person IS NULL OR d.IdPerson = p_id_person)
      AND (p_id_association IS NULL OR d.IdAssociation = p_id_association)
      AND (p_min_amount IS NULL OR d.Amount >= p_min_amount)
      AND (p_max_amount IS NULL OR d.Amount <= p_max_amount)
    ORDER BY d.DonationDate DESC;
END$$

DELIMITER ;

/* Procedimiento almacenado para generar un reporte de donaciones totales por asociación, con filtros opcionales para el rango de fechas, y validaciones para asegurar que se devuelven solo las asociaciones que han recibido donaciones dentro del rango especificado, ordenadas por el monto total recibido. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_total_donations_assoc (
    p_start_date DATETIME,
    p_end_date DATETIME
)
BEGIN
    SELECT
        a.Id AS AssociationId,
        a.Name AS AssociationName,
        SUM(d.Amount) AS TotalAmount,
        COUNT(*) AS TotalDonations
    FROM Donation d
    INNER JOIN Association a 
        ON a.Id = d.IdAssociation
    WHERE (p_start_date IS NULL OR d.DonationDate >= p_start_date)
      AND (p_end_date IS NULL OR d.DonationDate <= p_end_date)
    GROUP BY 
        a.Id,
        a.Name
    ORDER BY 
        SUM(d.Amount) DESC;
END$$

DELIMITER ;

/* Procedimiento almacenado para registrar un nuevo hogar de acogida, con validaciones para asegurar que se insertan correctamente los datos del hogar de acogida y que se devuelve el ID del nuevo hogar creado. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_register_foster_home (
    p_needs_donation VARCHAR(10),
    p_id_person INT,
    OUT p_new_id INT
)
BEGIN

    INSERT INTO FosterHome (
        Id,
        NeedsDonation,
        IdPerson
    )
    VALUES (
        p_new_id,
        p_needs_donation,
        p_id_person
    );

    SET p_new_id = LAST_INSERT_ID();
END$$

DELIMITER ;

/* Procedimiento almacenado para buscar hogares de acogida que coincidan con los criterios especificados, con filtros opcionales para el tamaño del animal, el nivel de energía y el espacio requerido. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_search_foster_homes (
    p_id_pet_size INT,
    p_id_energy INT,
    p_id_space INT
)
BEGIN
    SELECT DISTINCT
        fh.Id AS FosterHomeId,
        p.Id AS PersonId,
        p.FirstName,
        p.LastName,
        fh.NeedsDonation
    FROM FosterHome fh
    INNER JOIN Person p 
        ON p.Id = fh.IdPerson
    LEFT JOIN PetSizeXFosterHome psfh 
        ON psfh.IdFosterHome = fh.Id
    LEFT JOIN PetLevelEnergyXFosterHome pefh 
        ON pefh.IdFosterHome = fh.Id
    LEFT JOIN SpaceRequiredXFosterHome srfh 
        ON srfh.IdFosterHome = fh.Id
    WHERE (p_id_pet_size IS NULL OR psfh.IdPetSize = p_id_pet_size)
      AND (p_id_energy IS NULL OR pefh.IdPetLevelEnergy = p_id_energy)
      AND (p_id_space IS NULL OR srfh.IdSpaceRequired = p_id_space)
    ORDER BY p.FirstName, p.LastName;
END$$

DELIMITER ;

/* Procedimiento almacenado para generar un reporte de mascotas que han estado disponibles para adopción por más de 2 meses, con validaciones para asegurar que se devuelven solo las mascotas que cumplen con los criterios de búsqueda y que se ordenan por la fecha en que estuvieron disponibles. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_report_not_adopted_pets ()
BEGIN
    SELECT
        p.Id,
        p.Name,
        p.Color,
        p.Age,
        a.AvailableDate,
        TIMESTAMPDIFF(MONTH, a.AvailableDate, NOW()) AS WaitingMonths
    FROM Adoption a
    INNER JOIN Pet p ON p.Id = a.IdPet
    WHERE UPPER(a.State) = 'EN ADOPCION'
      AND a.AvailableDate <= DATE_SUB(NOW(), INTERVAL 2 MONTH)
    ORDER BY a.AvailableDate ASC;
END$$

DELIMITER ;

/* Procedimiento almacenado para consultar la bitácora de cambios en la base de datos, con filtros opcionales para el nombre de la tabla, el nombre del campo, el usuario que realizó el cambio, y el rango de fechas en que se realizaron los cambios. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_query_bitacora (
    p_table_name VARCHAR(100),
    p_field_name VARCHAR(100),
    p_changed_by INT,
    p_start_date DATETIME,
    p_end_date DATETIME
)
BEGIN
    SELECT
        Id,
        TableName,
        FieldName,
        PreviousValue,
        CurrentValue,
        ChangedBy,
        ChangeDate
    FROM Bitacora
    WHERE (p_table_name IS NULL OR UPPER(TableName) = UPPER(p_table_name))
      AND (p_field_name IS NULL OR UPPER(FieldName) = UPPER(p_field_name))
      AND (p_changed_by IS NULL OR ChangedBy = p_changed_by)
      AND (p_start_date IS NULL OR ChangeDate >= p_start_date)
      AND (p_end_date IS NULL OR ChangeDate <= p_end_date)
    ORDER BY ChangeDate DESC;
END$$

DELIMITER ;

/* Procedimiento almacenado para generar un reporte de estadísticas de mascotas por tipo y estado, con filtros opcionales para el rango de fechas en que las mascotas estuvieron disponibles para adopción o fueron reportadas como perdidas o encontradas. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE pr_stats_pets_by_type_state (
    p_start_date DATETIME,
    p_end_date DATETIME
)
BEGIN
    SELECT
        pt.Name AS PetType,
        ps.Name AS PetState,
        COUNT(*) AS TotalPets
    FROM Pet p
    INNER JOIN PetType pt ON pt.Id = p.IdType
    INNER JOIN PetState ps ON ps.Id = p.IdState
    LEFT JOIN LostReport lr ON lr.IdPet = p.Id
    LEFT JOIN FoundReport fr ON fr.IdPet = p.Id
    WHERE (
            COALESCE(lr.LostDate, fr.FoundDate) BETWEEN p_start_date AND p_end_date
            OR COALESCE(lr.LostDate, fr.FoundDate) IS NULL
          )
    GROUP BY pt.Name, ps.Name
    ORDER BY pt.Name, ps.Name;
END$$

DELIMITER ;

/* Procedimiento almacenado para generar un reporte de estadísticas de adopciones por estado, con filtros opcionales para el tipo y la raza de las mascotas adoptadas, y validaciones para asegurar que se devuelven solo las adopciones que cumplen con los criterios de búsqueda y que se calculan correctamente los totales y porcentajes. */
DELIMITER //

CREATE OR REPLACE PROCEDURE pr_stats_adoptions (
    IN p_id_type INT,
    IN p_id_breed INT
)
BEGIN
    SELECT
        a.State,
        COUNT(*) AS Total,
        ROUND(
            COUNT(*) * 100 / SUM(COUNT(*)) OVER (),
            2
        ) AS Percentage
    FROM Adoption a
    INNER JOIN Pet p ON p.Id = a.IdPet
    WHERE (p_id_type IS NULL OR p.IdType = p_id_type)
      AND (p_id_breed IS NULL OR p.IdBreed = p_id_breed)
    GROUP BY a.State
    ORDER BY a.State;
END//

DELIMITER ;

/* Procedimiento almacenado para generar un reporte de estadísticas de mascotas que no han sido adoptadas por rango de edad, con validaciones para asegurar que se devuelven solo las mascotas que cumplen con los criterios de búsqueda y que se calculan correctamente los totales y porcentajes por cada rango de edad. */
DELIMITER //

CREATE OR REPLACE PROCEDURE pr_stats_not_adopted_by_age ()
BEGIN
    SELECT
        fn_pet_age_range(p.Age) AS AgeRange,
        COUNT(*) AS TotalPets,
        ROUND(
            COUNT(*) * 100 / SUM(COUNT(*)) OVER (),
            2
        ) AS Percentage
    FROM Adoption a
    INNER JOIN Pet p ON p.Id = a.IdPet
    WHERE UPPER(a.State) = 'EN ADOPCION'
    GROUP BY fn_pet_age_range(p.Age)
    ORDER BY AgeRange;
END//

DELIMITER ;

/* Procedimiento almacenado para insertar una nueva imagen de mascota, con validaciones para asegurar que se insertan correctamente los datos de la imagen y que se asocian con la mascota correspondiente. */
DELIMITER //

CREATE OR REPLACE PROCEDURE pr_insert_pet_image (
    IN pImage LONGTEXT,
    IN pIdPet INT
)
BEGIN
    INSERT INTO petPhoto (Photo, IdPet)
    VALUES (pImage, pIdPet);
END//

DELIMITER ;

/* Procedimiento almacenado */
DELIMITER //

CREATE OR REPLACE PROCEDURE pr_insert_donation(
    IN p_idPerson INT,
    IN p_amount DECIMAL(10,2),
    IN p_idCurrency INT,
    IN p_idAssociation INT
)
BEGIN
    INSERT INTO Donation (
        Amount,
        DonationDate,
        IdPerson,
        IdCurrency,
        IdAssociation
    )
    VALUES (
        p_amount,
        NOW(),
        p_idPerson,
        p_idCurrency,
        p_idAssociation
    );
END//

DELIMITER ;

/* Procedimiento almacenado para insertar una nueva persona, con validaciones para asegurar que se insertan correctamente los datos de la persona, que se asocian con el distrito correspondiente, y que se crean los registros relacionados en las tablas de email, teléfono y rol de adoptante. */
DELIMITER //

CREATE OR REPLACE PROCEDURE pr_insert_person (
    IN pFirst_name VARCHAR(100),
    IN pLast_name VARCHAR(100),
    IN pEmail VARCHAR(255),
    IN pPassword VARCHAR(255),
    IN pUserName VARCHAR(100),
    IN pIdDistrict INT,
    IN pPhoneNumber VARCHAR(30)
)
BEGIN
    DECLARE vcIdPerson INT;

    -- Insert persona (Id debe ser AUTO_INCREMENT)
    INSERT INTO Person (
        FirstName,
        LastName,
        Password,
        UserName,
        IdDistrict
    )
    VALUES (
        pFirst_name,
        pLast_name,
        pPassword,
        pUserName,
        pIdDistrict
    );

    -- obtener ID generado
    SET vcIdPerson = LAST_INSERT_ID();

    -- Email
    INSERT INTO Email (Email, IdPerson)
    VALUES (pEmail, vcIdPerson);

    -- Phone
    INSERT INTO Phone (Phone, IdPerson)
    VALUES (pPhoneNumber, vcIdPerson);

    -- Rol por defecto (Adopter)
    INSERT INTO Adopter (IdPerson)
    VALUES (vcIdPerson);

END//

DELIMITER ;

/* Procedimiento almacenado para insertar una nueva mascota, con validaciones para asegurar que se insertan correctamente los datos de la mascota, que se asocian con los registros relacionados de enfermedades, tratamientos, medicamentos y fotos, y que se devuelve el ID de la nueva mascota creada. */
DELIMITER //

CREATE OR REPLACE PROCEDURE pr_insert_pet (
    IN pColor VARCHAR(50),
    IN pAge INT,
    IN pDescription TEXT,
    IN pPetName VARCHAR(100),
    IN pChip VARCHAR(100),
    IN pIdEnergy INT,
    IN pIdType INT,
    IN pIdBreed INT,
    IN pIdDistrict INT,
    IN pIdSpaceRequired INT,
    IN pIdPetTraining INT,
    IN pIdPetSize INT,
    IN pIdPerson INT,
    IN pIdVeterinarian INT,
    IN pIllnessJson JSON,
    IN pTreatmentJson JSON,
    IN pMedicineJson JSON,
    IN pPhotoJson JSON
)
BEGIN
    DECLARE vcIdPet INT;

    -- 1. Insert Pet
    INSERT INTO Pet (
        Color, Age, Description, Name, Chip,
        IdEnergy, IdState, IdType, IdBreed,
        IdDistrict, IdSpace, IdPetTraining,
        IdSize, IdOwner, IdVeterinarian
    )
    VALUES (
        pColor, pAge, pDescription, pPetName, pChip,
        pIdEnergy, 2, pIdType, pIdBreed,
        pIdDistrict, pIdSpaceRequired, pIdPetTraining,
        pIdPetSize, pIdPerson, pIdVeterinarian
    );

    SET vcIdPet = LAST_INSERT_ID();

    -- 2. Illnesses
    IF pIllnessJson IS NOT NULL THEN
        INSERT INTO PetXPetIllness (IdPet, IdPetIllness)
        SELECT vcIdPet, CAST(value AS UNSIGNED)
        FROM JSON_TABLE(pIllnessJson, '$[*]' COLUMNS(value INT PATH '$')) AS jt;
    END IF;

    -- 3. Treatments
    IF pTreatmentJson IS NOT NULL THEN
        INSERT INTO PetXPetTreatment (IdPet, IdPetTreatment)
        SELECT vcIdPet, CAST(value AS UNSIGNED)
        FROM JSON_TABLE(pTreatmentJson, '$[*]' COLUMNS(value INT PATH '$')) AS jt;
    END IF;

    -- 4. Medicines
    IF pMedicineJson IS NOT NULL THEN
        INSERT INTO PetXMedicine (IdPet, IdMedicine)
        SELECT vcIdPet, CAST(value AS UNSIGNED)
        FROM JSON_TABLE(pMedicineJson, '$[*]' COLUMNS(value INT PATH '$')) AS jt;
    END IF;

    -- 5. Photos
    IF pPhotoJson IS NOT NULL THEN
        INSERT INTO PetPhoto (Photo, IdPet)
        SELECT value, vcIdPet
        FROM JSON_TABLE(pPhotoJson, '$[*]' COLUMNS(value TEXT PATH '$')) AS jt;
    END IF;

END//

DELIMITER ;

/* Procedimiento almacenado para registrar un nuevo email para una persona, con validaciones para asegurar que se inserta correctamente el registro en la tabla de email y que se devuelve el ID del nuevo email creado. */
DELIMITER //

CREATE OR REPLACE PROCEDURE pr_register_person_email (
    IN p_email VARCHAR(255),
    IN p_id_person INT,
    OUT p_new_id INT
)
BEGIN
    INSERT INTO Email (
        Email,
        IdPerson
    )
    VALUES (
        p_email,
        p_id_person
    );

    SET p_new_id = LAST_INSERT_ID();
END//

DELIMITER ;

/* Procedimiento almacenado para registrar un nuevo número de teléfono para una persona, con validaciones para asegurar que se inserta correctamente el registro en la tabla de teléfono y que se devuelve el ID del nuevo teléfono creado. */
DELIMITER //

CREATE OR REPLACE PROCEDURE pr_register_person_phone (
    IN p_phone VARCHAR(30),
    IN p_id_person INT,
    OUT p_new_id INT
)
BEGIN
    INSERT INTO Phone (
        Phone,
        IdPerson
    )
    VALUES (
        p_phone,
        p_id_person
    );

    SET p_new_id = LAST_INSERT_ID();
END//

DELIMITER ;

/* Procedimiento almacenado para asignar el rol de administrador a una persona, con validaciones para asegurar que la persona existe, que no se asigna el rol de administrador más de una vez a la misma persona, y que se devuelve el ID del nuevo registro en la tabla de administradores o el ID existente si ya tenía el rol. */
DELIMITER //

CREATE OR REPLACE PROCEDURE pr_assign_admin_role (
    IN p_id_person INT,
    OUT p_new_id INT
)
BEGIN
    DECLARE v_person_exists INT DEFAULT 0;
    DECLARE v_admin_id INT DEFAULT NULL;

    -- Validar que la persona exista
    SELECT COUNT(*)
    INTO v_person_exists
    FROM Person
    WHERE Id = p_id_person;

    IF v_person_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La persona indicada no existe.';
    END IF;

    -- Validar si ya es admin
    SELECT MAX(Id)
    INTO v_admin_id
    FROM Admin
    WHERE IdPerson = p_id_person;

    -- Si ya existe, retornar el mismo id
    IF v_admin_id IS NOT NULL THEN
        SET p_new_id = v_admin_id;
    ELSE
        INSERT INTO Admin (IdPerson)
        VALUES (p_id_person);

        SET p_new_id = LAST_INSERT_ID();
    END IF;

END//

DELIMITER ;

/* Procedimiento almacenado para asignar el rol de adoptante a una persona, con validaciones para asegurar que la persona existe, que no se asigna el rol de adoptante más de una vez a la misma persona, y que se devuelve el ID del nuevo registro en la tabla de adoptantes o el ID existente si ya tenía el rol. */
DELIMITER //

CREATE OR REPLACE PROCEDURE pr_assign_adopter_role (
    IN p_id_person INT,
    OUT p_new_id INT
)
BEGIN
    DECLARE v_person_exists INT DEFAULT 0;
    DECLARE v_adopter_id INT DEFAULT NULL;

    -- Validar que la persona exista
    SELECT COUNT(*)
    INTO v_person_exists
    FROM Person
    WHERE Id = p_id_person;

    IF v_person_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La persona indicada no existe.';
    END IF;

    -- Verificar si ya tiene rol adopter
    SELECT MAX(Id)
    INTO v_adopter_id
    FROM Adopter
    WHERE IdPerson = p_id_person;

    -- Si ya existe, devolver el mismo ID
    IF v_adopter_id IS NOT NULL THEN
        SET p_new_id = v_adopter_id;
    ELSE
        INSERT INTO Adopter (IdPerson)
        VALUES (p_id_person);

        SET p_new_id = LAST_INSERT_ID();
    END IF;

END//

DELIMITER ;

/* Procedimiento almacenado para asignar el rol de rescatista a una persona, con validaciones para asegurar que la persona existe, que no se asigna el rol de rescatista más de una vez a la misma persona, y que se devuelve el ID del nuevo registro en la tabla de rescatistas o el ID existente si ya tenía el rol. */
DELIMITER //

CREATE OR REPLACE PROCEDURE pr_assign_rescuer_role (
    IN p_id_person INT,
    OUT p_new_id INT
)
BEGIN
    DECLARE v_person_exists INT DEFAULT 0;
    DECLARE v_rescuer_id INT DEFAULT NULL;

    -- Validar que la persona exista
    SELECT COUNT(*)
    INTO v_person_exists
    FROM Person
    WHERE Id = p_id_person;

    IF v_person_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La persona indicada no existe.';
    END IF;

    -- Verificar si ya tiene rol rescuer
    SELECT MAX(Id)
    INTO v_rescuer_id
    FROM Rescuer
    WHERE IdPerson = p_id_person;

    -- Si ya existe, devolver el mismo ID
    IF v_rescuer_id IS NOT NULL THEN
        SET p_new_id = v_rescuer_id;
    ELSE
        INSERT INTO Rescuer (IdPerson)
        VALUES (p_id_person);

        SET p_new_id = LAST_INSERT_ID();
    END IF;

END//

DELIMITER ;

/* Procedimiento almacenado para asignar el rol de hogar de acogida a una persona, con validaciones para asegurar que la persona existe, que no se asigna el rol de hogar de acogida más de una vez a la misma persona, que el valor de NeedsDonation es válido, y que se devuelve el ID del nuevo registro en la tabla de hogares de acogida o el ID existente si ya tenía el rol. */
DELIMITER //

CREATE OR REPLACE PROCEDURE pr_assign_foster_home_role (
    IN p_id_person INT,
    IN p_needs_donation VARCHAR(1),
    OUT p_new_id INT
)
BEGIN
    DECLARE v_person_exists INT DEFAULT 0;
    DECLARE v_foster_home_id INT DEFAULT NULL;
    DECLARE v_needs_donation VARCHAR(1);

    -- Validar existencia de persona
    SELECT COUNT(*)
    INTO v_person_exists
    FROM Person
    WHERE Id = p_id_person;

    IF v_person_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La persona indicada no existe.';
    END IF;

    -- Normalizar valor
    SET v_needs_donation = UPPER(COALESCE(p_needs_donation, 'N'));

    -- Validación de dominio
    IF v_needs_donation NOT IN ('Y', 'N') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'NeedsDonation solo puede ser Y o N.';
    END IF;

    -- Verificar si ya existe
    SELECT MAX(Id)
    INTO v_foster_home_id
    FROM FosterHome
    WHERE IdPerson = p_id_person;

    IF v_foster_home_id IS NOT NULL THEN
        SET p_new_id = v_foster_home_id;
    ELSE
        INSERT INTO FosterHome (NeedsDonation, IdPerson)
        VALUES (v_needs_donation, p_id_person);

        SET p_new_id = LAST_INSERT_ID();
    END IF;

END//

DELIMITER ;

/* Procedimiento almacenado para poner una mascota en adopción, con validaciones para asegurar que la mascota existe, que está en estado de encontrada, que se actualiza correctamente su estado a "en adopción", y que se maneja el caso en que no se encuentra la mascota o no está en el estado correcto. */
DELIMITER $$

CREATE OR REPLACE PROCEDURE put_pet_up_for_adoption (
    IN p_pet_id INT
)
BEGIN
    DECLARE v_rows INT DEFAULT 0;

    UPDATE Pet
    SET IdState = 1
    WHERE Id = p_pet_id
      AND IdState = 4;

    SET v_rows = ROW_COUNT();

    IF v_rows = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pet was not found or is not in Found state.';
    END IF;

END$$

DELIMITER ;