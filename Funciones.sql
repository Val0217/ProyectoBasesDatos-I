/* ------------------------------------------------------------
   Funcion: fn_next_id
   Descripcion:
   Obtiene el siguiente Id para una tabla.
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION fn_next_id (
    p_table_name IN VARCHAR2
)
RETURN NUMBER
IS
    v_next_id NUMBER;
    v_sequence_name VARCHAR2(128);
BEGIN
    IF p_table_name IS NULL OR NOT REGEXP_LIKE(p_table_name, '^[A-Za-z][A-Za-z0-9_]*$') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nombre de tabla invalido para secuencia.');
    END IF;

    v_sequence_name := 's_' || p_table_name;

    EXECUTE IMMEDIATE 'SELECT ' || v_sequence_name || '.NEXTVAL FROM dual'
        INTO v_next_id;

    RETURN v_next_id;
END;
/


/* ------------------------------------------------------------
   Funcion: fn_get_parameter_value
   Descripcion:
   Obtiene el valor numerico de un parametro del sistema.
   Si no existe, devuelve el valor por defecto.
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION fn_get_parameter_value (
    p_name          IN VARCHAR2,
    p_default_value IN NUMBER
)
RETURN NUMBER
IS
    v_value NUMBER;
BEGIN
    SELECT value
    INTO v_value
    FROM (
        SELECT p.value
        FROM parameter p
        WHERE UPPER(REGEXP_REPLACE(p.name, '[^A-Za-z0-9]', '')) =
              UPPER(REGEXP_REPLACE(p_name, '[^A-Za-z0-9]', ''))
        ORDER BY p.name
    )
    WHERE ROWNUM = 1;

    RETURN v_value;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN p_default_value;
END;
/

/* ------------------------------------------------------------
   Funcion: fn_is_blacklisted
   Descripcion:
   Indica si una persona esta en lista negra.
   Retorna:
   Y = Si esta en lista negra
   N = No esta en lista negra
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION fn_is_blacklisted (
    p_id_person IN NUMBER
)
RETURN VARCHAR2
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM BlockList
    WHERE IdPerson = p_id_person;

    IF v_count > 0 THEN
        RETURN 'Y';
    END IF;

    RETURN 'N';
END;
/

/* ------------------------------------------------------------
   Funcion: fn_get_person_id
   Descripcion:
   Obtiene el Id de una persona dado su username.
   En caso de que no exista, devuelve NULL.
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION fn_get_person_id(pUserName IN VARCHAR2)
RETURN NUMBER
IS
    vcIdPerson NUMBER(8);
BEGIN
    SELECT Id
    INTO vcIdPerson
    FROM Person
    WHERE UserName = pUserName;
    RETURN vcIdPerson;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

/* ------------------------------------------------------------
   Funcion: fn_get_person_role
   Descripcion:
   Verifica si una persona tiene rol de admin.
   Devuelve 1 si es admin, 0 si no lo es, NULL si no existe la persona.
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION fn_get_person_role(pIdPerson IN NUMBER)
RETURN NUMBER
IS
    vcEXIST NUMBER(1);
BEGIN
    SELECT COUNT(1)
    INTO vcEXIST
    FROM Admin
    WHERE IdPerson = pIdPerson;
    RETURN vcEXIST;
END;
/


/* ------------------------------------------------------------
   Funcion: fn_get_districts_by_canton
   Descripcion:
   Retorna un cursor con todos los distritos de un canton dado su Id.
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION fn_get_districts_by_canton(pIdCanton IN NUMBER)
RETURN SYS_REFCURSOR
IS
    v_result SYS_REFCURSOR;
BEGIN
    OPEN v_result FOR
        SELECT Id, Name
        FROM District
        WHERE IdCanton = pIdCanton;
    RETURN v_result;
END;
/

/* ------------------------------------------------------------
   Funcion: fn_get_canton_by_province
   Descripcion:
   Retorna un cursor con todos los cantones de una provincia dado su Id.
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION fn_get_canton_by_province(pIdProvince IN NUMBER)
RETURN SYS_REFCURSOR
IS
    v_result SYS_REFCURSOR;
BEGIN
    OPEN v_result FOR
        SELECT Id, Name
        FROM Canton
        WHERE IdProvince = pIdProvince;
    RETURN v_result;
END;
/

/* ------------------------------------------------------------
   Funcion: fn_get_province_by_country
   Descripcion:
   Retorna un cursor con todas las provincias de un pais dado su Id.
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION fn_get_province_by_country(pIdCountry IN NUMBER)
RETURN SYS_REFCURSOR
IS
    v_result SYS_REFCURSOR;
BEGIN
    OPEN v_result FOR
        SELECT Id, Name
        FROM Province
        WHERE IdCountry = pIdCountry;
    RETURN v_result;
END;
/

--> esta funcion es para obtener el password de un usuario dado su username, se usa en el Sign In
--> en caso de que no exista el usuario, se devuelve NULL

CREATE OR REPLACE FUNCTION fn_get_person_password(pUserName IN VARCHAR2)
RETURN VARCHAR2
IS
    vcPass VARCHAR2(60);
BEGIN --> aqui va el comando:
    SELECT password
    into vcPass
    from Person
    where UserName = pUserName;
    return (vcPass);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        return (NULL);
END;
/

CREATE OR REPLACE FUNCTION fn

/* ------------------------------------------------------------
   Funcion: fn_person_average_rating
   Descripcion:
   Obtiene el promedio de calificacion de una persona.
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION fn_person_average_rating (
    p_id_person IN NUMBER
)
RETURN NUMBER
IS
    v_average NUMBER;
BEGIN
    SELECT ROUND(NVL(AVG(Stars), 0), 2)
    INTO v_average
    FROM Calification
    WHERE IdPerson = p_id_person;

    RETURN v_average;
END;
/

/* ------------------------------------------------------------
   Funcion: fn_pet_match_score
   Descripcion:
   Calcula el porcentaje de similitud entre una mascota perdida
   y una mascota encontrada.
   
   Criterios:
   - Tipo: 25 puntos
   - Raza: 25 puntos
   - Color: 20 puntos
   - Distrito: 15 puntos
   - Edad aproximada: 15 puntos
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION fn_pet_match_score (
    p_lost_pet_id  IN NUMBER,
    p_found_pet_id IN NUMBER
) RETURN NUMBER
IS
    v_score NUMBER := 0;

    v_lost_type     NUMBER;
    v_found_type    NUMBER;
    v_lost_breed    NUMBER;
    v_found_breed   NUMBER;
    v_lost_color    VARCHAR2(50);
    v_found_color   VARCHAR2(50);
    v_lost_district NUMBER;
    v_found_district NUMBER;
    v_lost_age      NUMBER;
    v_found_age     NUMBER;
BEGIN
    SELECT IdType, IdBreed, UPPER(Color), IdDistrict, Age
    INTO v_lost_type, v_lost_breed, v_lost_color, v_lost_district, v_lost_age
    FROM Pet
    WHERE Id = p_lost_pet_id;

    SELECT IdType, IdBreed, UPPER(Color), IdDistrict, Age
    INTO v_found_type, v_found_breed, v_found_color, v_found_district, v_found_age
    FROM Pet
    WHERE Id = p_found_pet_id;

    IF v_lost_type = v_found_type THEN
        v_score := v_score + 25;
    END IF;

    IF v_lost_breed = v_found_breed THEN
        v_score := v_score + 25;
    END IF;

    IF v_lost_color = v_found_color THEN
        v_score := v_score + 20;
    END IF;

    IF v_lost_district = v_found_district THEN
        v_score := v_score + 15;
    END IF;

    IF v_lost_age IS NOT NULL 
       AND v_found_age IS NOT NULL 
       AND ABS(v_lost_age - v_found_age) <= 1 THEN
        v_score := v_score + 15;
    END IF;

    RETURN v_score;
END;
/


/* ------------------------------------------------------------
   Funcion: fn_pet_age_range
   Descripcion:
   Clasifica la edad de la mascota para estadisticas.
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION fn_pet_age_range (
    p_age IN NUMBER
) RETURN VARCHAR2
IS
BEGIN
    IF p_age IS NULL THEN
        RETURN 'Without Age';
    ELSIF p_age >= 0 AND p_age < 1 THEN
        RETURN '0 to 1';
    ELSIF p_age >= 1 AND p_age < 5 THEN
        RETURN '1 to 5';
    ELSIF p_age >= 5 AND p_age < 9 THEN
        RETURN '5 to 9';
    ELSIF p_age >= 9 AND p_age <= 12 THEN
        RETURN '10 to 12';
    ELSE
        RETURN 'Older than 12';
    END IF;
END;
/


/* ------------------------------------------------------------
   Funcion: fn_pet_not_adopted_months
   Descripcion:
   Calcula cuantos meses lleva una mascota disponible
   para adopcion sin ser adoptada.
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION fn_pet_not_adopted_months (
    p_id_pet IN NUMBER
) RETURN NUMBER
IS
    v_available_date DATE;
    v_months NUMBER;
BEGIN
    SELECT AvailableDate
    INTO v_available_date
    FROM Adoption
    WHERE IdPet = p_id_pet
      AND UPPER(State) = 'EN ADOPCION';

    v_months := MONTHS_BETWEEN(SYSDATE, v_available_date);

    RETURN TRUNC(v_months);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/

/* ------------------------------------------------------------
   Funcion: fn_table_allowed
   Descripcion:
   Valida que la tabla solicitada pertenezca al proyecto.
   Retorna:
   1 = tabla permitida
   0 = tabla no permitida
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION fn_table_allowed (
    p_table_name IN VARCHAR2
) RETURN NUMBER
IS
    v_table VARCHAR2(50);
BEGIN
    v_table := UPPER(TRIM(p_table_name));

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
END;
/


/* ------------------------------------------------------------
   Funcion: fn_table_has_id
   Descripcion:
   Indica si una tabla tiene columna Id.
   Retorna:
   1 = tiene Id
   0 = no tiene Id
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION fn_table_has_id (
    p_table_name IN VARCHAR2
) RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM USER_TAB_COLUMNS
    WHERE UPPER(TABLE_NAME) = UPPER(p_table_name)
      AND UPPER(COLUMN_NAME) = 'ID';

    IF v_count > 0 THEN
        RETURN 1;
    END IF;

    RETURN 0;
END;
/


/* ------------------------------------------------------------
   Funcion: fn_get_all
   Descripcion:
   Retorna todos los registros de una tabla permitida.
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION fn_get_all (
    p_table_name IN VARCHAR2
) RETURN SYS_REFCURSOR
IS
    v_result SYS_REFCURSOR;
    v_table  VARCHAR2(50);
    v_sql    VARCHAR2(1000);
BEGIN
    v_table := UPPER(TRIM(p_table_name));

    IF fn_table_allowed(v_table) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Tabla no permitida: ' || p_table_name);
    END IF;

    IF fn_table_has_id(v_table) = 1 THEN
        v_sql := 'SELECT * FROM ' || v_table || ' ORDER BY Id';
    ELSE
        v_sql := 'SELECT * FROM ' || v_table;
    END IF;

    OPEN v_result FOR v_sql;

    RETURN v_result;
END;
/


/* ------------------------------------------------------------
   Funcion: fn_get_by_id
   Descripcion:
   Retorna un registro por Id.
   Solo funciona con tablas que tengan columna Id.
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION fn_get_by_id (
    p_table_name IN VARCHAR2,
    p_id         IN NUMBER
) RETURN SYS_REFCURSOR
IS
    v_result SYS_REFCURSOR;
    v_table  VARCHAR2(50);
    v_sql    VARCHAR2(1000);
BEGIN
    v_table := UPPER(TRIM(p_table_name));

    IF fn_table_allowed(v_table) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Tabla no permitida: ' || p_table_name);
    END IF;

    IF fn_table_has_id(v_table) = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'La tabla no tiene columna Id: ' || p_table_name);
    END IF;

    v_sql := 'SELECT * FROM ' || v_table || ' WHERE Id = :id';

    OPEN v_result FOR v_sql USING p_id;

    RETURN v_result;
END;
/
/* ============================================================
   FUNCIONES GET ESPECIFICAS
   ============================================================ */


/* PERSON */
CREATE OR REPLACE FUNCTION fn_get_person_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('Person');
END;
/

CREATE OR REPLACE FUNCTION fn_get_person_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('Person', p_id);
END;
/


/* PET */
CREATE OR REPLACE FUNCTION fn_get_pet_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('Pet');
END;
/

CREATE OR REPLACE FUNCTION fn_get_pet_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('Pet', p_id);
END;
/


/* PET TYPE */
CREATE OR REPLACE FUNCTION fn_get_pet_type_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('PetType');
END;
/

CREATE OR REPLACE FUNCTION fn_get_pet_type_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('PetType', p_id);
END;
/


/* PET BREED */
CREATE OR REPLACE FUNCTION fn_get_pet_breed_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('PetBreed');
END;
/

CREATE OR REPLACE FUNCTION fn_get_pet_breed_by_PetType (
    p_id_pet_type IN NUMBER
) RETURN SYS_REFCURSOR
IS
    v_result SYS_REFCURSOR;
BEGIN
    OPEN v_result FOR
        SELECT Id,name FROM PetBreed WHERE IdType = p_id_pet_type;
    RETURN v_result;
END;
/



CREATE OR REPLACE FUNCTION fn_get_pet_breed_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('PetBreed', p_id);
END;
/


/* PET STATE */
CREATE OR REPLACE FUNCTION fn_get_pet_state_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('PetState');
END;
/

CREATE OR REPLACE FUNCTION fn_get_pet_state_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('PetState', p_id);
END;
/


/* PET SIZE */
CREATE OR REPLACE FUNCTION fn_get_pet_size_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('PetSize');
END;
/

CREATE OR REPLACE FUNCTION fn_get_pet_size_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('PetSize', p_id);
END;
/


/* PET LEVEL ENERGY */
CREATE OR REPLACE FUNCTION fn_get_pet_energy_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('PetLevelEnergy');
END;
/

CREATE OR REPLACE FUNCTION fn_get_pet_energy_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('PetLevelEnergy', p_id);
END;
/


/* PET TRAINING */
CREATE OR REPLACE FUNCTION fn_get_pet_training_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('PetTraining');
END;
/

CREATE OR REPLACE FUNCTION fn_get_pet_training_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('PetTraining', p_id);
END;
/

/* VETERINARIAN */
CREATE OR REPLACE FUNCTION fn_get_pet_veterinarian_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('Veterinarian');
END;

/* SPACE REQUIRED */
CREATE OR REPLACE FUNCTION fn_get_pet_space_required_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('SpaceRequired');
END;
/

CREATE OR REPLACE FUNCTION fn_get_space_required_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('SpaceRequired', p_id);
END;
/


/* PET ILLNESS */
CREATE OR REPLACE FUNCTION fn_get_pet_illness_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('PetIllness');
END;
/

CREATE OR REPLACE FUNCTION fn_get_pet_illness_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('PetIllness', p_id);
END;
/


/* MEDICINE */
CREATE OR REPLACE FUNCTION fn_get_medicine_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('Medicine');
END;
/

CREATE OR REPLACE FUNCTION fn_get_medicine_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('Medicine', p_id);
END;
/


/* PET TREATMENT */
CREATE OR REPLACE FUNCTION fn_get_pet_treatment_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('PetTreatment');
END;
/

CREATE OR REPLACE FUNCTION fn_get_pet_treatment_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('PetTreatment', p_id);
END;
/


/* LOCATION */
CREATE OR REPLACE FUNCTION fn_get_country_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('Country');
END;
/

CREATE OR REPLACE FUNCTION fn_get_province_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('Province');
END;
/

CREATE OR REPLACE FUNCTION fn_get_canton_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('Canton');
END;
/

CREATE OR REPLACE FUNCTION fn_get_district_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('District');
END;
/


/* LOST REPORT */
CREATE OR REPLACE FUNCTION fn_get_lost_report_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('LostReport');
END;
/

CREATE OR REPLACE FUNCTION fn_get_lost_report_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('LostReport', p_id);
END;
/


/* FOUND REPORT */
CREATE OR REPLACE FUNCTION fn_get_found_report_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('FoundReport');
END;
/

CREATE OR REPLACE FUNCTION fn_get_found_report_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('FoundReport', p_id);
END;
/


/* PET MATCH */
CREATE OR REPLACE FUNCTION fn_get_pet_match_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('PetMatch');
END;
/

CREATE OR REPLACE FUNCTION fn_get_pet_match_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('PetMatch', p_id);
END;
/


/* ADOPTION */
CREATE OR REPLACE FUNCTION fn_get_adoption_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('Adoption');
END;
/

CREATE OR REPLACE FUNCTION fn_get_adoption_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('Adoption', p_id);
END;
/


/* RESCUED */
CREATE OR REPLACE FUNCTION fn_get_rescued_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('Rescued');
END;
/

CREATE OR REPLACE FUNCTION fn_get_rescued_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('Rescued', p_id);
END;
/


/* DONATION */
CREATE OR REPLACE FUNCTION fn_get_donation_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('Donation');
END;
/

CREATE OR REPLACE FUNCTION fn_get_donation_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('Donation', p_id);
END;
/

CREATE OR REPLACE FUNCTION fn_get_donation_join
RETURN SYS_REFCURSOR
AS
    pCursor SYS_REFCURSOR;
BEGIN
    OPEN pCursor FOR
        SELECT 
            d.Id,
            p.FirstName || ' ' || p.LastName AS DonorName,
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

    RETURN pCursor;
END;


/* CURRENCY */
CREATE OR REPLACE FUNCTION fn_get_currency_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('Currency');
END;
/

CREATE OR REPLACE FUNCTION fn_get_currency_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('Currency', p_id);
END;
/


/* ASSOCIATION */
CREATE OR REPLACE FUNCTION fn_get_associations_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('Association');
END;
/

CREATE OR REPLACE FUNCTION fn_get_association_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('Association', p_id);
END;
/


/* FOSTER HOME */
CREATE OR REPLACE FUNCTION fn_get_foster_home_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('FosterHome');
END;
/

CREATE OR REPLACE FUNCTION fn_get_foster_home_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('FosterHome', p_id);
END;
/


/* CALIFICATION */
CREATE OR REPLACE FUNCTION fn_get_calification_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('Calification');
END;
/

CREATE OR REPLACE FUNCTION fn_get_calification_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('Calification', p_id);
END;
/


/* BLOCK LIST */
CREATE OR REPLACE FUNCTION fn_get_blocklist_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('BlockList');
END;
/

CREATE OR REPLACE FUNCTION fn_get_blocklist_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('BlockList', p_id);
END;
/


/* EMAIL */
CREATE OR REPLACE FUNCTION fn_get_email_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('Email');
END;
/

CREATE OR REPLACE FUNCTION fn_get_email_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('Email', p_id);
END;
/

CREATE OR REPLACE FUNCTION fn_get_email_by_person_id (
    p_id_person IN NUMBER
) RETURN SYS_REFCURSOR
AS
    pCursor SYS_REFCURSOR;
BEGIN
    OPEN pCursor FOR
        SELECT Email
        FROM Email
        WHERE IdPerson = p_id_person;

    RETURN pCursor;
END;


/* PHONE */
CREATE OR REPLACE FUNCTION fn_get_phone_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('Phone');
END;
/

CREATE OR REPLACE FUNCTION fn_get_phone_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('Phone', p_id);
END;
/

CREATE OR REPLACE FUNCTION fn_get_phone_by_person_id(
    pIdPerson IN NUMBER
)
RETURN SYS_REFCURSOR
IS
    vCursor SYS_REFCURSOR;
BEGIN

    OPEN vCursor FOR
        SELECT
            Id,
            Phone
        FROM Phone
        WHERE IdPerson = pIdPerson
        ORDER BY Id;

    RETURN vCursor;
END;
/


/* PARAMETER */
CREATE OR REPLACE FUNCTION fn_get_parameter_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('Parameter');
END;
/

CREATE OR REPLACE FUNCTION fn_get_parameter_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('Parameter', p_id);
END;
/


/* BITACORA */
CREATE OR REPLACE FUNCTION fn_get_bitacora_all
RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_all('Bitacora');
END;
/

CREATE OR REPLACE FUNCTION fn_get_bitacora_by_id (
    p_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
BEGIN
    RETURN fn_get_by_id('Bitacora', p_id);
END;
/