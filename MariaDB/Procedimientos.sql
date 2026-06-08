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

CREATE PROCEDURE pr_get_districts_by_canton(
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

CREATE PROCEDURE pr_get_canton_by_province(
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

CREATE PROCEDURE pr_get_province_by_country(
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

CREATE PROCEDURE pr_get_all(
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

CREATE PROCEDURE pr_get_by_id (
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

CREATE PROCEDURE pr_get_person_all()
BEGIN
    SELECT * FROM Person;
END$$

DELIMITER ;

/* Procedimiento almacenado para obtener una persona por su ID. */
DELIMITER $$

DROP PROCEDURE IF EXISTS pr_get_person_by_id$$

CREATE PROCEDURE pr_get_person_by_id (
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

CREATE PROCEDURE pr_get_pet_all()
BEGIN
    SELECT * FROM Pet;
END$$

DELIMITER ;

/* Procedimiento almacenado para obtener una mascota por su ID. */
DELIMITER $$

DROP PROCEDURE IF EXISTS pr_get_pet_by_id$$
CREATE PROCEDURE pr_get_pet_by_id (
    IN p_id BIGINT
)
BEGIN
    SELECT *
    FROM Pet
    WHERE Id = p_id;
END$$

/* Procedimiento almacenado para obtener todas las razas de mascotas registradas en la base de datos. */
DROP PROCEDURE IF EXISTS pr_get_pet_type_all$$
CREATE PROCEDURE pr_get_pet_type_all()
BEGIN
    SELECT * FROM PetType;
END$$

/* Procedimiento almacenado para obtener una raza de mascota por su ID. */
DROP PROCEDURE IF EXISTS pr_get_pet_type_by_id$$
CREATE PROCEDURE pr_get_pet_type_by_id (
    IN p_id BIGINT
)
BEGIN
    SELECT *
    FROM PetType
    WHERE Id = p_id;
END$$

/* Procedimiento almacenado para obtener todas las razas de mascotas registradas en la base de datos. */
DROP PROCEDURE IF EXISTS pr_get_pet_breed_all$$
CREATE PROCEDURE pr_get_pet_breed_all()
BEGIN
    SELECT * FROM PetBreed;
END$$

DELIMITER ;

/* Procedimiento almacenado para obtener una raza de mascota por su ID. */
DELIMITER $$

CREATE PROCEDURE pr_get_pet_breed_by_pet_type (
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

CREATE PROCEDURE pr_get_pet_breed_by_id (
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

CREATE PROCEDURE pr_get_pet_state_all ()
BEGIN
    SELECT *
    FROM PetState;
END $$

DELIMITER ;

/* Procedimiento almacenado para obtener el estado de una mascota por su ID. */
DELIMITER $$

CREATE PROCEDURE pr_get_pet_state_by_id (
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

CREATE PROCEDURE pr_get_pet_size_all ()
BEGIN
    SELECT *
    FROM PetSize;
END $$

DELIMITER ;

/* Procedimiento almacenado para obtener el tamaño de una mascota por su ID. */
DELIMITER $$

CREATE PROCEDURE pr_get_pet_size_by_id (
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

CREATE PROCEDURE pr_get_pet_energy_all ()
BEGIN
    SELECT *
    FROM PetLevelEnergy;
END $$

DELIMITER ;

/* Procedimiento almacenado para obtener el nivel de energía de una mascota por su ID. */
DELIMITER $$

CREATE PROCEDURE pr_get_pet_energy_by_id (
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

CREATE PROCEDURE pr_get_pet_training_all ()
BEGIN
    SELECT *
    FROM PetTraining;
END $$

DELIMITER ;

/* Procedimiento almacenado para obtener el entrenamiento de una mascota por su ID. */
DELIMITER $$

CREATE PROCEDURE pr_get_pet_training_by_id (
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
CREATE PROCEDURE pr_get_pet_veterinarian_all ()
BEGIN
    SELECT *
    FROM Veterinarian;
END $$


/* SPACE REQUIRED - ALL */
CREATE PROCEDURE pr_get_pet_space_required_all ()
BEGIN
    SELECT *
    FROM SpaceRequired;
END $$


/* SPACE REQUIRED - BY ID */
CREATE PROCEDURE pr_get_space_required_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM SpaceRequired
    WHERE Id = p_id;
END $$


/* PET ILLNESS - ALL */
CREATE PROCEDURE pr_get_pet_illness_all ()
BEGIN
    SELECT *
    FROM PetIllness;
END $$


/* PET ILLNESS - BY ID */
CREATE PROCEDURE pr_get_pet_illness_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM PetIllness
    WHERE Id = p_id;
END $$


/* MEDICINE - ALL */
CREATE PROCEDURE pr_get_medicine_all ()
BEGIN
    SELECT *
    FROM Medicine;
END $$


/* MEDICINE - BY ID */
CREATE PROCEDURE pr_get_medicine_by_id (
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
CREATE PROCEDURE pr_get_pet_treatment_all ()
BEGIN
    SELECT *
    FROM PetTreatment;
END $$


/* PET TREATMENT - BY ID */
CREATE PROCEDURE pr_get_pet_treatment_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM PetTreatment
    WHERE Id = p_id;
END $$


/* LOCATION - COUNTRY */
CREATE PROCEDURE pr_get_country_all ()
BEGIN
    SELECT *
    FROM Country;
END $$


/* LOCATION - PROVINCE */
CREATE PROCEDURE pr_get_province_all ()
BEGIN
    SELECT *
    FROM Province;
END $$


/* LOCATION - CANTON */
CREATE PROCEDURE pr_get_canton_all ()
BEGIN
    SELECT *
    FROM Canton;
END $$


/* LOCATION - DISTRICT */
CREATE PROCEDURE pr_get_district_all ()
BEGIN
    SELECT *
    FROM District;
END $$


/* LOST REPORT - ALL */
CREATE PROCEDURE pr_get_lost_report_all ()
BEGIN
    SELECT *
    FROM LostReport;
END $$


/* LOST REPORT - BY ID */
CREATE PROCEDURE pr_get_lost_report_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM LostReport
    WHERE Id = p_id;
END $$


/* FOUND REPORT - ALL */
CREATE PROCEDURE pr_get_found_report_all ()
BEGIN
    SELECT *
    FROM FoundReport;
END $$


/* FOUND REPORT - BY ID */
CREATE PROCEDURE pr_get_found_report_by_id (
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
CREATE PROCEDURE pr_get_pet_match_all ()
BEGIN
    SELECT *
    FROM PetMatch;
END $$


/* PET MATCH - BY ID */
CREATE PROCEDURE pr_get_pet_match_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM PetMatch
    WHERE Id = p_id;
END $$


/* ADOPTION - ALL */
CREATE PROCEDURE pr_get_adoption_all ()
BEGIN
    SELECT *
    FROM Adoption;
END $$


/* ADOPTION - BY ID */
CREATE PROCEDURE pr_get_adoption_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Adoption
    WHERE Id = p_id;
END $$


/* RESCUED - ALL */
CREATE PROCEDURE pr_get_rescued_all ()
BEGIN
    SELECT *
    FROM Rescued;
END $$


/* RESCUED - BY ID */
CREATE PROCEDURE pr_get_rescued_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Rescued
    WHERE Id = p_id;
END $$


/* DONATION - ALL */
CREATE PROCEDURE pr_get_donation_all ()
BEGIN
    SELECT *
    FROM Donation;
END $$


/* DONATION - BY ID */
CREATE PROCEDURE pr_get_donation_by_id (
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

CREATE PROCEDURE pr_get_donation_join ()
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
CREATE PROCEDURE pr_get_currency_all ()
BEGIN
    SELECT *
    FROM Currency;
END $$


/* CURRENCY - BY ID */
CREATE PROCEDURE pr_get_currency_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Currency
    WHERE Id = p_id;
END $$


/* ASSOCIATION - ALL */
CREATE PROCEDURE pr_get_associations_all ()
BEGIN
    SELECT *
    FROM Association;
END $$


/* ASSOCIATION - BY ID */
CREATE PROCEDURE pr_get_association_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Association
    WHERE Id = p_id;
END $$


/* FOSTER HOME - ALL */
CREATE PROCEDURE pr_get_foster_home_all ()
BEGIN
    SELECT *
    FROM FosterHome;
END $$


/* FOSTER HOME - BY ID */
CREATE PROCEDURE pr_get_foster_home_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM FosterHome
    WHERE Id = p_id;
END $$


/* CALIFICATION - ALL */
CREATE PROCEDURE pr_get_calification_all ()
BEGIN
    SELECT *
    FROM Calification;
END $$


/* CALIFICATION - BY ID */
CREATE PROCEDURE pr_get_calification_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Calification
    WHERE Id = p_id;
END $$


/* BLOCK LIST - ALL */
CREATE PROCEDURE pr_get_blocklist_all ()
BEGIN
    SELECT *
    FROM BlockList;
END $$


/* BLOCK LIST - BY ID */
CREATE PROCEDURE pr_get_blocklist_by_id (
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
CREATE PROCEDURE pr_get_email_all ()
BEGIN
    SELECT *
    FROM Email;
END $$


/* EMAIL - BY ID */
CREATE PROCEDURE pr_get_email_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Email
    WHERE Id = p_id;
END $$


/* EMAIL - BY PERSON ID */
CREATE PROCEDURE pr_get_email_by_person_id (
    IN p_id_person INT
)
BEGIN
    SELECT Email
    FROM Email
    WHERE IdPerson = p_id_person;
END $$


/* PHONE - ALL */
CREATE PROCEDURE pr_get_phone_all ()
BEGIN
    SELECT *
    FROM Phone;
END $$


/* PHONE - BY ID */
CREATE PROCEDURE pr_get_phone_by_id (
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

CREATE PROCEDURE pr_get_phone_by_person_id (
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
CREATE PROCEDURE pr_get_parameter_all ()
BEGIN
    SELECT *
    FROM Parameter;
END $$


/* PARAMETER - BY ID */
CREATE PROCEDURE pr_get_parameter_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Parameter
    WHERE Id = p_id;
END $$


/* BITACORA - ALL */
CREATE PROCEDURE pr_get_bitacora_all ()
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

CREATE PROCEDURE pr_query_bitacora (
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

CREATE PROCEDURE pr_create_pet_claim (
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

    /* Generar nuevo ID (manteniendo tu lógica actual) */
    SELECT fn_next_id('PetClaim')
    INTO p_new_id;

    /* Insert */
    INSERT INTO PetClaim (
        Id,
        ClaimDate,
        Description,
        State,
        IdPet,
        IdClaimant,
        IdOwner
    ) VALUES (
        p_new_id,
        NOW(),
        p_description,
        'To be confirmed',
        p_pet_id,
        p_claimant_id,
        v_owner_id
    );

END $$

DELIMITER ;

/* Procedimiento almacenado para obtener una lista de reclamos de mascotas pendientes para un dueño específico, con información detallada sobre la mascota y el reclamante. */
DELIMITER $$

CREATE PROCEDURE pr_get_claim_requests_owner (
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

CREATE PROCEDURE pr_accept_pet_claim (
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

CREATE PROCEDURE pr_reject_pet_claim (
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
CREATE PROCEDURE pr_add_email_person (
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
CREATE PROCEDURE pr_add_phone_person (
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

CREATE PROCEDURE pr_insert_person (
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

CREATE PROCEDURE pr_register_veterinarian (
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

    /* Generar ID (Oracle fn_next_id reemplazado por AUTO_INCREMENT recomendado) */
    SELECT fn_next_id('Veterinarian')
    INTO p_new_id;

    INSERT INTO Veterinarian (
        Id,
        FirstName,
        LastName,
        Name,
        Phone,
        Email,
        Location,
        IdDistrict
    )
    VALUES (
        p_new_id,
        p_first_name,
        p_last_name,
        p_clinic_name,
        p_phone,
        p_email,
        p_location,
        p_id_district
    );

    COMMIT;
END $$

DELIMITER ;

/* Procedimiento almacenado para obtener una lista de mascotas encontradas que no pertenecen al usuario actual, con información detallada sobre la mascota y su dueño. */
DELIMITER $$

CREATE PROCEDURE pr_get_found_pet_table (
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
CREATE PROCEDURE pr_get_owner_emails (
    IN p_owner_id INT
)
BEGIN
    SELECT Email
    FROM Email
    WHERE IdPerson = p_owner_id
    ORDER BY Email;
END $$


/* OWNER PHONES */
CREATE PROCEDURE pr_get_owner_phones (
    IN p_owner_id INT
)
BEGIN
    SELECT Phone
    FROM Phone
    WHERE IdPerson = p_owner_id
    ORDER BY Phone;
END $$


/* TAKE BACK MISSING REPORT */
CREATE PROCEDURE pr_take_back_missing_report (
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

CREATE PROCEDURE pr_get_user_missing_pet_table (
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

CREATE PROCEDURE pr_reject_adoption_request (
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

CREATE PROCEDURE pr_register_lost_for_owner (
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

    /* Generar ID (manteniendo lógica existente) */
    SELECT fn_next_id('LostReport')
    INTO p_new_id;

    /* Insert LostReport */
    INSERT INTO LostReport (
        Id,
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
        p_new_id,
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

END $$

DELIMITER ;

/* Procedimiento almacenado para aceptar una solicitud de adopción, con validaciones para asegurar que la solicitud es válida, que la transferencia de propiedad se realiza correctamente, y que se actualizan los estados de las solicitudes relacionadas. */
DELIMITER $$

CREATE PROCEDURE pr_accept_adoption_request (
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

CREATE PROCEDURE pr_create_adoption_request (
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

    /* Generar ID (manteniendo lógica actual) */
    SELECT fn_next_id('Adoption')
    INTO p_new_id;

    /* Insert solicitud */
    INSERT INTO Adoption (
        Id,
        AdoptionDate,
        AvailableDate,
        Description,
        State,
        IdPet,
        IdAdopter,
        IdOwner
    )
    VALUES (
        p_new_id,
        NULL,
        v_available_date,
        SUBSTRING(p_description, 1, 100),
        'To be confirmed',
        p_pet_id,
        p_adopter_id,
        v_owner_id
    );

    COMMIT;

END $$

DELIMITER ;

/* Procedimiento almacenado para obtener una lista de solicitudes de adopción pendientes para un dueño específico, con información detallada sobre la mascota, el solicitante y el estado de la solicitud. */
DELIMITER $$

CREATE PROCEDURE pr_get_adoption_requests_owner (
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