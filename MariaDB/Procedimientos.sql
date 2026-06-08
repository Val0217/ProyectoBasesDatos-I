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
