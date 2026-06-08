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
CREATE PROCEDURE pr_get_bitacora_by_id (
    IN p_id INT
)
BEGIN
    SELECT *
    FROM Bitacora
    WHERE Id = p_id;
END $$

DELIMITER ;