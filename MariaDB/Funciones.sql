DELIMITER $$
DROP FUNCTION IF EXISTS fn_is_admin;
CREATE FUNCTION fn_is_admin(
    p_idPerson INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN EXISTS(
        SELECT 1
        FROM Admin
        WHERE IdPerson = p_idPerson
    );
END$$

DELIMITER ;

/* Función para obtener el valor de un parámetro, con un valor predeterminado si no se encuentra */
DROP FUNCTION IF EXISTS fn_get_parameter_value;

DELIMITER $$

CREATE FUNCTION fn_get_parameter_value(
    p_name VARCHAR(25),
    p_default_value INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_value INT DEFAULT NULL;

    SELECT Value
    INTO v_value
    FROM Parameter
    WHERE UPPER(Name) = UPPER(p_name)
    LIMIT 1;

    RETURN IFNULL(v_value, p_default_value);
END$$

DELIMITER ;

/* Función para verificar si una persona está en la lista negra */
DROP FUNCTION IF EXISTS fn_is_blacklisted;

DELIMITER $$

CREATE FUNCTION fn_is_blacklisted(
    p_id_person INT
)
RETURNS CHAR(1)
DETERMINISTIC
BEGIN
    IF EXISTS (
        SELECT 1
        FROM BlockList
        WHERE IdPerson = p_id_person
    ) THEN
        RETURN 'Y';
    END IF;

    RETURN 'N';
END$$

DELIMITER ;

/* Función para obtener el ID de una persona por su nombre de usuario */
DROP FUNCTION IF EXISTS fn_get_person_id;

DELIMITER $$

CREATE FUNCTION fn_get_person_id(
    pUserName VARCHAR(25)
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE vcIdPerson INT DEFAULT NULL;

    SELECT Id
    INTO vcIdPerson
    FROM Person
    WHERE UserName = pUserName
    LIMIT 1;

    RETURN vcIdPerson;
END$$

DELIMITER ;

/* Función para obtener el rol de una persona (admin o user) */
DROP FUNCTION IF EXISTS fn_get_person_role;

DELIMITER $$

CREATE FUNCTION fn_get_person_role(
    pIdPerson INT
)
RETURNS INT
READS SQL DATA
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM Admin
        WHERE IdPerson = pIdPerson
    );
END$$

DELIMITER ;

/* Función para obtener la contraseña de una persona por su nombre de usuario */
DROP FUNCTION IF EXISTS fn_get_person_password;

DELIMITER $$

CREATE FUNCTION fn_get_person_password(
    pUserName VARCHAR(25)
)
RETURNS VARCHAR(60)
READS SQL DATA
BEGIN
    DECLARE vcPass VARCHAR(60) DEFAULT NULL;

    SELECT Password
    INTO vcPass
    FROM Person
    WHERE UserName = pUserName
    LIMIT 1;

    RETURN vcPass;
END$$

DELIMITER ;

/* Función para calcular el promedio de calificaciones de una persona */
DROP FUNCTION IF EXISTS fn_person_average_rating;

DELIMITER $$

CREATE FUNCTION fn_person_average_rating(
    p_id_person INT
)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_average DECIMAL(10,2);

    SELECT ROUND(IFNULL(AVG(Stars), 0), 2)
    INTO v_average
    FROM Calification
    WHERE IdPerson = p_id_person;

    RETURN v_average;
END$$

DELIMITER ;


/* Función para calcular el puntaje de coincidencia entre una mascota perdida y una encontrada */
DROP FUNCTION IF EXISTS fn_pet_match_score;

DELIMITER $$

CREATE FUNCTION fn_pet_match_score(
    p_lost_pet_id INT,
    p_found_pet_id INT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_score INT DEFAULT 0;

    DECLARE v_lost_type INT;
    DECLARE v_found_type INT;
    DECLARE v_lost_breed INT;
    DECLARE v_found_breed INT;
    DECLARE v_lost_color VARCHAR(50);
    DECLARE v_found_color VARCHAR(50);
    DECLARE v_lost_district INT;
    DECLARE v_found_district INT;
    DECLARE v_lost_age INT;
    DECLARE v_found_age INT;

    SELECT IdType, IdBreed, UPPER(Color), IdDistrict, Age
    INTO v_lost_type, v_lost_breed, v_lost_color, v_lost_district, v_lost_age
    FROM Pet
    WHERE Id = p_lost_pet_id
    LIMIT 1;

    SELECT IdType, IdBreed, UPPER(Color), IdDistrict, Age
    INTO v_found_type, v_found_breed, v_found_color, v_found_district, v_found_age
    FROM Pet
    WHERE Id = p_found_pet_id
    LIMIT 1;

    IF v_lost_type = v_found_type THEN
        SET v_score = v_score + 25;
    END IF;

    IF v_lost_breed = v_found_breed THEN
        SET v_score = v_score + 25;
    END IF;

    IF v_lost_color = v_found_color THEN
        SET v_score = v_score + 20;
    END IF;

    IF v_lost_district = v_found_district THEN
        SET v_score = v_score + 15;
    END IF;

    IF v_lost_age IS NOT NULL
       AND v_found_age IS NOT NULL
       AND ABS(v_lost_age - v_found_age) <= 1 THEN
        SET v_score = v_score + 15;
    END IF;

    RETURN v_score;
END$$

DELIMITER ;

/* Procedimiento almacenado para obtener los distritos de un cantón específico.
    Parámetros:
        - pIdCanton: El ID del cantón para el cual se desean obtener los distritos.
*/
DROP FUNCTION IF EXISTS fn_pet_age_range;

DELIMITER $$

CREATE FUNCTION fn_pet_age_range(
    p_age INT
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF p_age IS NULL THEN
        RETURN 'Without Age';
    ELSEIF p_age >= 0 AND p_age < 1 THEN
        RETURN '0 to 1';
    ELSEIF p_age >= 1 AND p_age < 5 THEN
        RETURN '1 to 5';
    ELSEIF p_age >= 5 AND p_age < 9 THEN
        RETURN '5 to 9';
    ELSEIF p_age >= 9 AND p_age <= 12 THEN
        RETURN '10 to 12';
    ELSE
        RETURN 'Older than 12';
    END IF;
END$$

DELIMITER ;

/* Función para calcular el número de meses que una mascota ha estado disponible para adopción */
DROP FUNCTION IF EXISTS fn_pet_not_adopted_months;

DELIMITER $$

CREATE FUNCTION fn_pet_not_adopted_months(
    p_id_pet INT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_available_date DATE;
    DECLARE v_months INT DEFAULT 0;

    SELECT AvailableDate
    INTO v_available_date
    FROM Adoption
    WHERE IdPet = p_id_pet
      AND UPPER(State) = 'EN ADOPCION'
    LIMIT 1;

    IF v_available_date IS NULL THEN
        RETURN 0;
    END IF;

    SET v_months = TIMESTAMPDIFF(
        MONTH,
        v_available_date,
        CURDATE()
    );

    RETURN v_months;
END$$

DELIMITER ;

/* Función para verificar si una tabla está permitida para operaciones específicas (por ejemplo, para auditoría o acceso restringido) */
DROP FUNCTION IF EXISTS fn_table_allowed;

DELIMITER $$

CREATE FUNCTION fn_table_allowed(
    p_table_name VARCHAR(50)
)
RETURNS TINYINT
DETERMINISTIC
BEGIN
    DECLARE v_table VARCHAR(50);

    SET v_table = UPPER(TRIM(p_table_name));

    IF v_table IN (
        'PETLEVELENERGY',
        'PETBREED',
        'PETTYPE',
        'PETSTATE',
        'PETILLNESS',
        'MEDICINE',
        'PETTREATMENT',
        'PETTRAINING',
        'PETPHOTO',
        'SPACEREQUIRED',
        'PETSIZE',
        'DISTRICT',
        'CANTON',
        'PROVINCE',
        'COUNTRY',
        'PETSEVERITY',
        'PET',
        'VETERINARIAN',
        'PETSIZEXFOSTERHOME',
        'PETXPETTREATMENT',
        'PETXPETILLNESS',
        'PETXMEDICINE',
        'PETLEVELENERGYXFOSTERHOME',
        'SPACEREQUIREDXFOSTERHOME',
        'FOUNDREPORT',
        'PETMATCH',
        'LOSTREPORT',
        'ADOPTION',
        'RESCUED',
        'DONATION',
        'CURRENCY',
        'PERSON',
        'REPORTLIST',
        'RESCUER',
        'ADOPTER',
        'CALIFICATION',
        'FOSTERHOME',
        'ADMIN',
        'EMAIL',
        'PHONE',
        'BLOCKLIST',
        'ASSOCIATION',
        'DELETED',
        'CREATED',
        'PARAMETER',
        'BITACORA'
    ) THEN
        RETURN 1;
    END IF;

    RETURN 0;
END$$

DELIMITER ;

/* Procedimiento almacenado para obtener los distritos de un cantón específico.
    Parámetros:
        - pIdCanton: El ID del cantón para el cual se desean obtener los distritos.
*/
DROP FUNCTION IF EXISTS fn_table_has_id;

DELIMITER $$

CREATE FUNCTION fn_table_has_id(
    p_table_name VARCHAR(50)
)
RETURNS TINYINT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_count INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_count
    FROM information_schema.columns
    WHERE TABLE_SCHEMA = DATABASE()
      AND UPPER(TABLE_NAME) = UPPER(p_table_name)
      AND UPPER(COLUMN_NAME) = 'ID';

    IF v_count > 0 THEN
        RETURN 1;
    END IF;

    RETURN 0;
END$$

DELIMITER ;


