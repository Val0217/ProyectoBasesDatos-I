CREATE OR REPLACE PROCEDURE pr_reject_adoption_request (
    p_adoption_id IN NUMBER,
    p_owner_id    IN NUMBER
)
IS
BEGIN
    UPDATE Adoption
       SET State = 'Canceled'
     WHERE Id = p_adoption_id
       AND IdOwner = p_owner_id
       AND State = 'To be confirmed';

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20107, 'Pending adoption request not found for this owner.');
    END IF;

    COMMIT;
END;
/
SHOW ERRORS PROCEDURE pr_reject_adoption_request;

CREATE OR REPLACE PROCEDURE pr_register_lost_for_owner (
    p_pet_id      IN NUMBER,
    p_owner_id    IN NUMBER,
    p_lost_date   IN DATE,
    p_place       IN VARCHAR2,
    p_description IN VARCHAR2,
    p_reward      IN NUMBER,
    p_currency_id IN NUMBER,
    p_new_id      OUT NUMBER
)
IS
    v_district_id Pet.IdDistrict%TYPE;
BEGIN
    SELECT IdDistrict
      INTO v_district_id
      FROM Pet
     WHERE Id = p_pet_id
       AND IdOwner = p_owner_id;

    p_new_id := fn_next_id('LostReport');

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
    ) VALUES (
        p_new_id,
        p_lost_date,
        SUBSTR(p_place, 1, 100),
        SUBSTR(p_description, 1, 100),
        p_reward,
        'Lost',
        p_pet_id,
        v_district_id,
        p_currency_id
    );

    UPDATE Pet
       SET IdState = 3
     WHERE Id = p_pet_id
       AND IdOwner = p_owner_id;

    UPDATE Adoption
       SET State = 'Canceled'
     WHERE IdPet = p_pet_id
       AND State IN ('In process', 'To be confirmed');

    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20108, 'Pet not found, or this pet does not belong to this user.');
END;
/
SHOW ERRORS PROCEDURE PR_REGISTER_LOST_FOR_OWNER;


CREATE OR REPLACE PROCEDURE pr_accept_adoption_request (
    p_adoption_id IN NUMBER,
    p_owner_id    IN NUMBER
)
IS
    v_pet_id     Adoption.IdPet%TYPE;
    v_adopter_id Adoption.IdAdopter%TYPE;
    v_role_count NUMBER;
BEGIN
    SELECT IdPet, IdAdopter
      INTO v_pet_id, v_adopter_id
      FROM Adoption
     WHERE Id = p_adoption_id
       AND IdOwner = p_owner_id
       AND State = 'To be confirmed'
     FOR UPDATE;

    UPDATE Pet
       SET IdOwner = v_adopter_id,
           IdState = 2
     WHERE Id = v_pet_id
       AND IdOwner = p_owner_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20105, 'The pet was not found for this owner.');
    END IF;

    UPDATE Adoption
       SET State = 'Approved',
           AdoptionDate = SYSDATE
     WHERE Id = p_adoption_id;

    UPDATE Adoption
       SET State = 'Canceled'
     WHERE IdPet = v_pet_id
       AND Id <> p_adoption_id
       AND State = 'To be confirmed';

    SELECT COUNT(*)
      INTO v_role_count
      FROM Adopter
     WHERE IdPerson = v_adopter_id;

    IF v_role_count = 0 THEN
        INSERT INTO Adopter (Id, IdPerson)
        VALUES (fn_next_id('Adopter'), v_adopter_id);
    END IF;

    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20106, 'Pending adoption request not found for this owner.');
END;
/
SHOW ERRORS PROCEDURE pr_accept_adoption_request;

CREATE OR REPLACE PROCEDURE pr_create_adoption_request (
    p_pet_id      IN NUMBER,
    p_adopter_id  IN NUMBER,
    p_description IN VARCHAR2,
    p_new_id      OUT NUMBER
)
IS
    v_owner_id       Pet.IdOwner%TYPE;
    v_state_id       Pet.IdState%TYPE;
    v_existing_count NUMBER;
BEGIN
    SELECT IdOwner, IdState
      INTO v_owner_id, v_state_id
      FROM Pet
     WHERE Id = p_pet_id;

    IF v_owner_id = p_adopter_id THEN
        RAISE_APPLICATION_ERROR(-20101, 'You cannot request to adopt your own pet.');
    END IF;

    IF v_state_id <> 1 THEN
        RAISE_APPLICATION_ERROR(-20102, 'This pet is not available for adoption.');
    END IF;

    SELECT COUNT(*)
      INTO v_existing_count
      FROM Adoption
     WHERE IdPet = p_pet_id
       AND IdAdopter = p_adopter_id
       AND State = 'To be confirmed';

    IF v_existing_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20103, 'You already have a pending adoption request for this pet.');
    END IF;

    p_new_id := fn_next_id('Adoption');

    INSERT INTO Adoption (
        Id,
        AdoptionDate,
        AvailableDate,
        Description,
        State,
        IdPet,
        IdAdopter,
        IdOwner
    ) VALUES (
        p_new_id,
        NULL,
        SYSDATE,
        SUBSTR(p_description, 1, 100),
        'To be confirmed',
        p_pet_id,
        p_adopter_id,
        v_owner_id
    );

    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20104, 'Pet not found.');
END;
/
SHOW ERRORS PROCEDURE pr_create_adoption_request;

CREATE OR REPLACE PROCEDURE pr_get_adoption_requests_owner (
    p_owner_id IN NUMBER,
    p_result   OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_result FOR
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
END;
/


/* ------------------------------------------------------------
   Procedimiento: COSAS DE PONER EN ADOPCION Y MISSING STATE
   Descripcion: 
   
   ------------------------------------------------------------ */
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE Adoption DROP CONSTRAINT chk_Adoption_State';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2443 THEN
            RAISE;
        END IF;
END;
/

UPDATE Adoption
   SET State = CASE
       WHEN UPPER(TRIM(State)) IN ('IN PROCESS', 'IN PROGRESS', 'EN ADOPCION', 'EN ADOPCIÓN') THEN 'In process'
       WHEN UPPER(TRIM(State)) IN ('TO BE CONFIRMED', 'TO CONFIRM', 'PENDING CONFIRMATION') THEN 'To be confirmed'
       WHEN UPPER(TRIM(State)) IN ('CANCELED', 'CANCELLED', 'CANCELADO', 'CANCELADA') THEN 'Canceled'
       WHEN UPPER(TRIM(State)) IN ('APPROVED', 'ADOPTED', 'ADOPTADO', 'ADOPTADA') THEN 'Approved'
       ELSE State
   END;

COMMIT;

-- Crear el constraint correcto
ALTER TABLE Adoption ADD CONSTRAINT chk_Adoption_State
    CHECK (State IN ('In process', 'To be confirmed', 'Canceled', 'Approved'));

SHOW ERRORS PROCEDURE pr_report_pet_missing;

CREATE OR REPLACE PROCEDURE pr_report_pet_missing (
    p_pet_id   IN Pet.Id%TYPE,
    p_owner_id IN Pet.IdOwner%TYPE
)
AS
BEGIN
    UPDATE Pet
       SET IdState = 3
     WHERE Id = p_pet_id
       AND IdOwner = p_owner_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20005,
            'Pet not found, or this pet does not belong to this user.'
        );
    END IF;

    UPDATE Adoption
       SET State = 'Canceled'
     WHERE IdPet = p_pet_id
       AND State IN ('In process', 'To be confirmed');

    COMMIT;
END;
/
/* ------------------------------------------------------------
   Procedimiento: FN_GET_DISTRICTS_BY_CANTON
   Descripcion: 
   
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION FN_GET_DISTRICTS_BY_CANTON (
    pIdCanton IN NUMBER
)
RETURN SYS_REFCURSOR
IS
    v_result SYS_REFCURSOR;
BEGIN
    OPEN v_result FOR
        SELECT
            Id,
            Name
        FROM District
        WHERE IdCanton = pIdCanton
        ORDER BY Name;

    RETURN v_result;
END;
/

-- Tipos de datos para listas de IDs en procedimientos almacenados
CREATE OR REPLACE TYPE NumberList AS TABLE OF NUMBER;

/* ------------------------------------------------------------
   Procedimiento: FN_GET_CANTON_BY_PROVINCE
   Descripcion: 
   
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION FN_GET_CANTON_BY_PROVINCE (
    pIdProvince IN NUMBER
)
RETURN SYS_REFCURSOR
IS
    v_result SYS_REFCURSOR;
BEGIN
    OPEN v_result FOR
        SELECT
            Id,
            Name
        FROM Canton
        WHERE IdProvince = pIdProvince
        ORDER BY Name;

    RETURN v_result;
END;
/

/* ------------------------------------------------------------
   Procedimiento: FN_GET_PROVINCE_BY_COUNTRY
   Descripcion: 
   
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION FN_GET_PROVINCE_BY_COUNTRY (
    pIdCountry IN NUMBER
)
RETURN SYS_REFCURSOR
IS
    v_result SYS_REFCURSOR;
BEGIN
    OPEN v_result FOR
        SELECT
            Id,
            Name
        FROM Province
        WHERE IdCountry = pIdCountry
        ORDER BY Name;

    RETURN v_result;
END;
/

/* ------------------------------------------------------------
   Procedimiento: FN_GET_PET_VETERINARIAN_ALL
   Descripcion: 
   
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION FN_GET_PET_VETERINARIAN_ALL
RETURN SYS_REFCURSOR
AS
    v_result SYS_REFCURSOR;
BEGIN
    OPEN v_result FOR
        SELECT
            Id AS Id,
            Name AS Name
        FROM Veterinarian
        ORDER BY Name;

    RETURN v_result;
END;
/
/* ------------------------------------------------------------
   Procedimiento: FN_GET_PET_SPACE_REQUIRED_ALL
   Descripcion: 
   
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION FN_GET_PET_SPACE_REQUIRED_ALL
RETURN SYS_REFCURSOR
AS
    v_result SYS_REFCURSOR;
BEGIN
    OPEN v_result FOR
        SELECT
            Id AS Id,
            Name AS Name
        FROM SpaceRequired
        ORDER BY Name;

    RETURN v_result;
END;
/

/* ------------------------------------------------------------
   Procedimiento: SP_GET_PET_FOR_EDIT
   Descripcion: 
   
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE SP_UPDATE_PET_FOR_OWNER (
    p_pet_id            IN  NUMBER,
    p_owner_id          IN  NUMBER,
    p_color             IN  VARCHAR2,
    p_age               IN  NUMBER,
    p_description       IN  VARCHAR2,
    p_name              IN  VARCHAR2,
    p_chip              IN  VARCHAR2,
    p_id_energy         IN  NUMBER,
    p_id_type           IN  NUMBER,
    p_id_breed          IN  NUMBER,
    p_id_district       IN  NUMBER,
    p_id_space          IN  NUMBER,
    p_id_pet_training   IN  NUMBER,
    p_id_size           IN  NUMBER,
    p_id_veterinarian   IN  NUMBER,
    p_rows_updated      OUT NUMBER
)
AS
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

    p_rows_updated := SQL%ROWCOUNT;
END;
/

/* ------------------------------------------------------------
   Procedimiento: SP_GET_PET_FOR_EDIT
   Descripcion: 
   
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE SP_GET_PET_FOR_EDIT (
    p_pet_id   IN  NUMBER,
    p_owner_id IN  NUMBER,
    p_result   OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_result FOR
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
END;
/
/* ------------------------------------------------------------
   Procedimiento: pr_undo_pet_up_for_adoption
   Descripcion: 
   como dice el nombre cambia de estado a la pet
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_undo_pet_up_for_adoption (
    p_pet_id   IN NUMBER,
    p_owner_id IN NUMBER
    )
    IS
    BEGIN
        UPDATE Pet
           SET IdState = 2
         WHERE Id = p_pet_id
           AND IdOwner = p_owner_id
           AND IdState = 1;
    
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(
                -20003,
                'Pet was not found, does not belong to this user, or is not up for adoption.'
            );
        END IF;
    
        UPDATE Adoption
           SET State = 'Canceled'
         WHERE IdPet = p_pet_id
           AND IdOwner = p_owner_id
           AND State IN ('In process', 'To be confirmed');
    
        COMMIT;
    END;
    /



/* ------------------------------------------------------------
   Procedimiento: Psquetes de procedures y functionsnd
   Descripcion: 
   cosas varias
   ------------------------------------------------------------ */

CREATE OR REPLACE PACKAGE PKG_PET_OPERATIONS AS

    PROCEDURE SP_GET_PETS_BY_STATE(
        P_ID_STATE       IN NUMBER,
        P_COLOR          IN VARCHAR2 DEFAULT NULL,
        P_AGE            IN NUMBER   DEFAULT NULL,
        P_NAME           IN VARCHAR2 DEFAULT NULL,
        P_CHIP           IN VARCHAR2 DEFAULT NULL,
        P_ENERGY         IN VARCHAR2 DEFAULT NULL,
        P_TYPE           IN VARCHAR2 DEFAULT NULL,
        P_BREED          IN VARCHAR2 DEFAULT NULL,
        P_DISTRICT       IN VARCHAR2 DEFAULT NULL,
        P_SPACE_REQUIRED IN VARCHAR2 DEFAULT NULL,
        P_TRAINING       IN VARCHAR2 DEFAULT NULL,
        P_SIZE           IN VARCHAR2 DEFAULT NULL,
        P_VETERINARIAN   IN VARCHAR2 DEFAULT NULL,
        P_RESULT         OUT SYS_REFCURSOR
    );

    PROCEDURE SP_GET_PETS_UP_FOR_ADOPTION(
        P_COLOR          IN VARCHAR2 DEFAULT NULL,
        P_AGE            IN NUMBER   DEFAULT NULL,
        P_NAME           IN VARCHAR2 DEFAULT NULL,
        P_CHIP           IN VARCHAR2 DEFAULT NULL,
        P_ENERGY         IN VARCHAR2 DEFAULT NULL,
        P_TYPE           IN VARCHAR2 DEFAULT NULL,
        P_BREED          IN VARCHAR2 DEFAULT NULL,
        P_DISTRICT       IN VARCHAR2 DEFAULT NULL,
        P_SPACE_REQUIRED IN VARCHAR2 DEFAULT NULL,
        P_TRAINING       IN VARCHAR2 DEFAULT NULL,
        P_SIZE           IN VARCHAR2 DEFAULT NULL,
        P_VETERINARIAN   IN VARCHAR2 DEFAULT NULL,
        P_RESULT         OUT SYS_REFCURSOR
    );

    PROCEDURE SP_GET_FOUND_PETS(
        P_COLOR          IN VARCHAR2 DEFAULT NULL,
        P_AGE            IN NUMBER   DEFAULT NULL,
        P_NAME           IN VARCHAR2 DEFAULT NULL,
        P_CHIP           IN VARCHAR2 DEFAULT NULL,
        P_ENERGY         IN VARCHAR2 DEFAULT NULL,
        P_TYPE           IN VARCHAR2 DEFAULT NULL,
        P_BREED          IN VARCHAR2 DEFAULT NULL,
        P_DISTRICT       IN VARCHAR2 DEFAULT NULL,
        P_SPACE_REQUIRED IN VARCHAR2 DEFAULT NULL,
        P_TRAINING       IN VARCHAR2 DEFAULT NULL,
        P_SIZE           IN VARCHAR2 DEFAULT NULL,
        P_VETERINARIAN   IN VARCHAR2 DEFAULT NULL,
        P_RESULT         OUT SYS_REFCURSOR
    );

    FUNCTION FN_PUT_PET_UP_FOR_ADOPTION(
        P_PET_ID   IN NUMBER,
        P_OWNER_ID IN NUMBER
    ) RETURN NUMBER;

    PROCEDURE SP_GET_ENERGY_OPTIONS(P_RESULT OUT SYS_REFCURSOR);
    PROCEDURE SP_GET_TYPE_OPTIONS(P_RESULT OUT SYS_REFCURSOR);
    PROCEDURE SP_GET_BREED_OPTIONS(P_RESULT OUT SYS_REFCURSOR);
    PROCEDURE SP_GET_DISTRICT_OPTIONS(P_RESULT OUT SYS_REFCURSOR);
    PROCEDURE SP_GET_SPACE_REQUIRED_OPTIONS(P_RESULT OUT SYS_REFCURSOR);
    PROCEDURE SP_GET_TRAINING_OPTIONS(P_RESULT OUT SYS_REFCURSOR);
    PROCEDURE SP_GET_SIZE_OPTIONS(P_RESULT OUT SYS_REFCURSOR);
    PROCEDURE SP_GET_VETERINARIAN_OPTIONS(P_RESULT OUT SYS_REFCURSOR);

END PKG_PET_OPERATIONS;
/

SHOW ERRORS PACKAGE PKG_PET_OPERATIONS;

CREATE OR REPLACE PACKAGE BODY PKG_PET_OPERATIONS AS


    PROCEDURE SP_GET_PETS_BY_STATE(
        P_ID_STATE       IN NUMBER,
        P_COLOR          IN VARCHAR2 DEFAULT NULL,
        P_AGE            IN NUMBER   DEFAULT NULL,
        P_NAME           IN VARCHAR2 DEFAULT NULL,
        P_CHIP           IN VARCHAR2 DEFAULT NULL,
        P_ENERGY         IN VARCHAR2 DEFAULT NULL,
        P_TYPE           IN VARCHAR2 DEFAULT NULL,
        P_BREED          IN VARCHAR2 DEFAULT NULL,
        P_DISTRICT       IN VARCHAR2 DEFAULT NULL,
        P_SPACE_REQUIRED IN VARCHAR2 DEFAULT NULL,
        P_TRAINING       IN VARCHAR2 DEFAULT NULL,
        P_SIZE           IN VARCHAR2 DEFAULT NULL,
        P_VETERINARIAN   IN VARCHAR2 DEFAULT NULL,
        P_RESULT         OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        OPEN P_RESULT FOR
            SELECT
                PetId,
                Color,
                Age,
                Description,
                PetName,
                Chip,
                Energy,
                PetState,
                PetType,
                Breed,
                District,
                SpaceRequired,
                Training,
                PetSize,
                OwnerName,
                VeterinarianName
            FROM VW_TABLE_ADOPTION
            WHERE IdState = P_ID_STATE
              AND (P_COLOR IS NULL OR TRIM(P_COLOR) IS NULL OR UPPER(Color) LIKE '%' || UPPER(TRIM(P_COLOR)) || '%')
              AND (P_AGE IS NULL OR Age = P_AGE)
              AND (P_NAME IS NULL OR TRIM(P_NAME) IS NULL OR UPPER(PetName) LIKE '%' || UPPER(TRIM(P_NAME)) || '%')
              AND (P_CHIP IS NULL OR TRIM(P_CHIP) IS NULL OR UPPER(Chip) LIKE '%' || UPPER(TRIM(P_CHIP)) || '%')
              AND (P_ENERGY IS NULL OR TRIM(P_ENERGY) IS NULL OR UPPER(TRIM(P_ENERGY)) = 'ALL' OR UPPER(Energy) = UPPER(TRIM(P_ENERGY)))
              AND (P_TYPE IS NULL OR TRIM(P_TYPE) IS NULL OR UPPER(TRIM(P_TYPE)) = 'ALL' OR UPPER(PetType) = UPPER(TRIM(P_TYPE)))
              AND (P_BREED IS NULL OR TRIM(P_BREED) IS NULL OR UPPER(TRIM(P_BREED)) = 'ALL' OR UPPER(Breed) = UPPER(TRIM(P_BREED)))
              AND (P_DISTRICT IS NULL OR TRIM(P_DISTRICT) IS NULL OR UPPER(TRIM(P_DISTRICT)) = 'ALL' OR UPPER(District) = UPPER(TRIM(P_DISTRICT)))
              AND (P_SPACE_REQUIRED IS NULL OR TRIM(P_SPACE_REQUIRED) IS NULL OR UPPER(TRIM(P_SPACE_REQUIRED)) = 'ALL' OR UPPER(SpaceRequired) = UPPER(TRIM(P_SPACE_REQUIRED)))
              AND (P_TRAINING IS NULL OR TRIM(P_TRAINING) IS NULL OR UPPER(TRIM(P_TRAINING)) = 'ALL' OR UPPER(Training) = UPPER(TRIM(P_TRAINING)))
              AND (P_SIZE IS NULL OR TRIM(P_SIZE) IS NULL OR UPPER(TRIM(P_SIZE)) = 'ALL' OR UPPER(PetSize) = UPPER(TRIM(P_SIZE)))
              AND (P_VETERINARIAN IS NULL OR TRIM(P_VETERINARIAN) IS NULL OR UPPER(TRIM(P_VETERINARIAN)) = 'ALL' OR UPPER(VeterinarianName) = UPPER(TRIM(P_VETERINARIAN)))
            ORDER BY PetId;
    END SP_GET_PETS_BY_STATE;

    PROCEDURE SP_GET_PETS_UP_FOR_ADOPTION(
        P_COLOR          IN VARCHAR2 DEFAULT NULL,
        P_AGE            IN NUMBER   DEFAULT NULL,
        P_NAME           IN VARCHAR2 DEFAULT NULL,
        P_CHIP           IN VARCHAR2 DEFAULT NULL,
        P_ENERGY         IN VARCHAR2 DEFAULT NULL,
        P_TYPE           IN VARCHAR2 DEFAULT NULL,
        P_BREED          IN VARCHAR2 DEFAULT NULL,
        P_DISTRICT       IN VARCHAR2 DEFAULT NULL,
        P_SPACE_REQUIRED IN VARCHAR2 DEFAULT NULL,
        P_TRAINING       IN VARCHAR2 DEFAULT NULL,
        P_SIZE           IN VARCHAR2 DEFAULT NULL,
        P_VETERINARIAN   IN VARCHAR2 DEFAULT NULL,
        P_RESULT         OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        SP_GET_PETS_BY_STATE(
            P_ID_STATE       => 1,
            P_COLOR          => P_COLOR,
            P_AGE            => P_AGE,
            P_NAME           => P_NAME,
            P_CHIP           => P_CHIP,
            P_ENERGY         => P_ENERGY,
            P_TYPE           => P_TYPE,
            P_BREED          => P_BREED,
            P_DISTRICT       => P_DISTRICT,
            P_SPACE_REQUIRED => P_SPACE_REQUIRED,
            P_TRAINING       => P_TRAINING,
            P_SIZE           => P_SIZE,
            P_VETERINARIAN   => P_VETERINARIAN,
            P_RESULT         => P_RESULT
        );
    END SP_GET_PETS_UP_FOR_ADOPTION;

    PROCEDURE SP_GET_FOUND_PETS(
        P_COLOR          IN VARCHAR2 DEFAULT NULL,
        P_AGE            IN NUMBER   DEFAULT NULL,
        P_NAME           IN VARCHAR2 DEFAULT NULL,
        P_CHIP           IN VARCHAR2 DEFAULT NULL,
        P_ENERGY         IN VARCHAR2 DEFAULT NULL,
        P_TYPE           IN VARCHAR2 DEFAULT NULL,
        P_BREED          IN VARCHAR2 DEFAULT NULL,
        P_DISTRICT       IN VARCHAR2 DEFAULT NULL,
        P_SPACE_REQUIRED IN VARCHAR2 DEFAULT NULL,
        P_TRAINING       IN VARCHAR2 DEFAULT NULL,
        P_SIZE           IN VARCHAR2 DEFAULT NULL,
        P_VETERINARIAN   IN VARCHAR2 DEFAULT NULL,
        P_RESULT         OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        SP_GET_PETS_BY_STATE(
            P_ID_STATE       => 4,
            P_COLOR          => P_COLOR,
            P_AGE            => P_AGE,
            P_NAME           => P_NAME,
            P_CHIP           => P_CHIP,
            P_ENERGY         => P_ENERGY,
            P_TYPE           => P_TYPE,
            P_BREED          => P_BREED,
            P_DISTRICT       => P_DISTRICT,
            P_SPACE_REQUIRED => P_SPACE_REQUIRED,
            P_TRAINING       => P_TRAINING,
            P_SIZE           => P_SIZE,
            P_VETERINARIAN   => P_VETERINARIAN,
            P_RESULT         => P_RESULT
        );
    END SP_GET_FOUND_PETS;

FUNCTION FN_PUT_PET_UP_FOR_ADOPTION(
        P_PET_ID   IN NUMBER,
        P_OWNER_ID IN NUMBER
    ) RETURN NUMBER
    IS
        v_pet_count NUMBER;
    BEGIN
        SELECT COUNT(*)
          INTO v_pet_count
          FROM Pet
         WHERE Id = P_PET_ID
           AND IdOwner = P_OWNER_ID;

        IF v_pet_count = 0 THEN
            RETURN 0;
        END IF;

        UPDATE Pet
           SET IdState = 1
         WHERE Id = P_PET_ID
           AND IdOwner = P_OWNER_ID;

        UPDATE Adoption
           SET AdoptionDate  = NULL,
               AvailableDate = SYSDATE,
               Description   = 'Pet put up for adoption by owner.',
               State         = 'In process',
               IdAdopter     = NULL,
               IdOwner       = P_OWNER_ID
         WHERE IdPet = P_PET_ID
           AND State IN ('In process', 'To be confirmed');

        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO Adoption (
                Id,
                AdoptionDate,
                AvailableDate,
                Description,
                State,
                IdPet,
                IdAdopter,
                IdOwner
            ) VALUES (
                fn_next_id('Adoption'),
                NULL,
                SYSDATE,
                'Pet put up for adoption by owner.',
                'In process',
                P_PET_ID,
                NULL,
                P_OWNER_ID
            );
        END IF;

        COMMIT;
        RETURN 1;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END FN_PUT_PET_UP_FOR_ADOPTION;

    PROCEDURE SP_GET_ENERGY_OPTIONS(P_RESULT OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN P_RESULT FOR
            SELECT 'All' AS Name, 0 AS SortOrder FROM dual
            UNION ALL
            SELECT Name, 1 AS SortOrder FROM PetLevelEnergy
            ORDER BY SortOrder, Name;
    END SP_GET_ENERGY_OPTIONS;

    PROCEDURE SP_GET_TYPE_OPTIONS(P_RESULT OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN P_RESULT FOR
            SELECT 'All' AS Name, 0 AS SortOrder FROM dual
            UNION ALL
            SELECT Name, 1 AS SortOrder FROM PetType
            ORDER BY SortOrder, Name;
    END SP_GET_TYPE_OPTIONS;

    PROCEDURE SP_GET_BREED_OPTIONS(P_RESULT OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN P_RESULT FOR
            SELECT 'All' AS Name, 0 AS SortOrder FROM dual
            UNION ALL
            SELECT Name, 1 AS SortOrder FROM PetBreed
            ORDER BY SortOrder, Name;
    END SP_GET_BREED_OPTIONS;

    PROCEDURE SP_GET_DISTRICT_OPTIONS(P_RESULT OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN P_RESULT FOR
            SELECT 'All' AS Name, 0 AS SortOrder FROM dual
            UNION ALL
            SELECT Name, 1 AS SortOrder FROM District
            ORDER BY SortOrder, Name;
    END SP_GET_DISTRICT_OPTIONS;

    PROCEDURE SP_GET_SPACE_REQUIRED_OPTIONS(P_RESULT OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN P_RESULT FOR
            SELECT 'All' AS Name, 0 AS SortOrder FROM dual
            UNION ALL
            SELECT Name, 1 AS SortOrder FROM SpaceRequired
            ORDER BY SortOrder, Name;
    END SP_GET_SPACE_REQUIRED_OPTIONS;

    PROCEDURE SP_GET_TRAINING_OPTIONS(P_RESULT OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN P_RESULT FOR
            SELECT 'All' AS Name, 0 AS SortOrder FROM dual
            UNION ALL
            SELECT Name, 1 AS SortOrder FROM PetTraining
            ORDER BY SortOrder, Name;
    END SP_GET_TRAINING_OPTIONS;

    PROCEDURE SP_GET_SIZE_OPTIONS(P_RESULT OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN P_RESULT FOR
            SELECT 'All' AS Name, 0 AS SortOrder FROM dual
            UNION ALL
            SELECT Name, 1 AS SortOrder FROM PetSize
            ORDER BY SortOrder, Name;
    END SP_GET_SIZE_OPTIONS;

    PROCEDURE SP_GET_VETERINARIAN_OPTIONS(P_RESULT OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN P_RESULT FOR
            SELECT 'All' AS VeterinarianName, 0 AS SortOrder FROM dual
            UNION ALL
            SELECT DISTINCT VeterinarianName, 1 AS SortOrder
            FROM VW_TABLE_ADOPTION
            WHERE VeterinarianName IS NOT NULL
            ORDER BY SortOrder, VeterinarianName;
    END SP_GET_VETERINARIAN_OPTIONS;

END PKG_PET_OPERATIONS;
/

SHOW ERRORS PACKAGE BODY PKG_PET_OPERATIONS;
/* ------------------------------------------------------------
   Procedimiento: pr_get_catalog
   Descripcion: procedimiento para los combox de la ventana UserPetTable
   
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_get_catalog (
    p_catalog_name IN VARCHAR2,
    p_result       OUT SYS_REFCURSOR
)
IS
BEGIN
    IF UPPER(p_catalog_name) = 'ENERGY' THEN
        OPEN p_result FOR SELECT Id, Name FROM PetLevelEnergy ORDER BY Name;

    ELSIF UPPER(p_catalog_name) = 'TYPE' THEN
        OPEN p_result FOR SELECT Id, Name FROM PetType ORDER BY Name;

    ELSIF UPPER(p_catalog_name) = 'BREED' THEN
        OPEN p_result FOR SELECT Id, Name FROM PetBreed ORDER BY Name;

    ELSIF UPPER(p_catalog_name) = 'DISTRICT' THEN
        OPEN p_result FOR SELECT Id, Name FROM District ORDER BY Name;

    ELSIF UPPER(p_catalog_name) = 'COUNTRY' THEN
        OPEN p_result FOR SELECT Id, Name FROM Country ORDER BY Name;

    ELSIF UPPER(p_catalog_name) = 'PROVINCE' THEN
        OPEN p_result FOR SELECT Id, Name FROM Province ORDER BY Name;

    ELSIF UPPER(p_catalog_name) = 'CANTON' THEN
        OPEN p_result FOR SELECT Id, Name FROM Canton ORDER BY Name;

    ELSIF UPPER(p_catalog_name) = 'SPACE' THEN
        OPEN p_result FOR SELECT Id, Name FROM SpaceRequired ORDER BY Name;

    ELSIF UPPER(p_catalog_name) = 'TRAINING' THEN
        OPEN p_result FOR SELECT Id, Name FROM PetTraining ORDER BY Name;

    ELSIF UPPER(p_catalog_name) = 'SIZE' THEN
        OPEN p_result FOR SELECT Id, Name FROM PetSize ORDER BY Name;

    ELSIF UPPER(p_catalog_name) = 'VETERINARIAN' THEN
        OPEN p_result FOR
            SELECT Id,
                   CASE WHEN Name IS NOT NULL THEN Name ELSE FirstName || ' ' || LastName END AS Name
              FROM Veterinarian
             ORDER BY Name;

    ELSIF UPPER(p_catalog_name) = 'CURRENCY' THEN
        OPEN p_result FOR SELECT Id, Name FROM Currency ORDER BY Name;

    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Invalid catalog name.');
    END IF;
END;
/

/* ------------------------------------------------------------
   Procedimiento: pr_get_adoption_pet_table
   Descripcion:
   
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_get_adoption_pet_table (
    p_id_energy       IN NUMBER DEFAULT NULL,
    p_id_type         IN NUMBER DEFAULT NULL,
    p_id_breed        IN NUMBER DEFAULT NULL,
    p_id_district     IN NUMBER DEFAULT NULL,
    p_id_country      IN NUMBER DEFAULT NULL,
    p_id_province     IN NUMBER DEFAULT NULL,
    p_id_canton       IN NUMBER DEFAULT NULL,
    p_id_space        IN NUMBER DEFAULT NULL,
    p_id_training     IN NUMBER DEFAULT NULL,
    p_id_size         IN NUMBER DEFAULT NULL,
    p_id_veterinarian IN NUMBER DEFAULT NULL,
    p_color           IN VARCHAR2 DEFAULT NULL,
    p_age             IN NUMBER DEFAULT NULL,
    p_name            IN VARCHAR2 DEFAULT NULL,
    p_chip            IN VARCHAR2 DEFAULT NULL,
    p_result          OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_result FOR
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
          AND (p_color IS NULL OR UPPER(Color) LIKE '%' || UPPER(p_color) || '%')
          AND (p_age IS NULL OR Age = p_age)
          AND (p_name IS NULL OR UPPER(PetName) LIKE '%' || UPPER(p_name) || '%')
          AND (p_chip IS NULL OR UPPER(Chip) LIKE '%' || UPPER(p_chip) || '%')
        ORDER BY PetName;
END;
/
SHOW ERRORS PROCEDURE pr_get_adoption_pet_table;
/* ------------------------------------------------------------
   Procedimiento: pr_get_user_pet_table
   Descripcion:
   Get user pet/s
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_get_user_pet_table (
    p_id_owner        IN NUMBER,
    p_id_energy       IN NUMBER DEFAULT NULL,
    p_id_type         IN NUMBER DEFAULT NULL,
    p_id_breed        IN NUMBER DEFAULT NULL,
    p_id_district     IN NUMBER DEFAULT NULL,
    p_id_country      IN NUMBER DEFAULT NULL,
    p_id_province     IN NUMBER DEFAULT NULL,
    p_id_canton       IN NUMBER DEFAULT NULL,
    p_id_space        IN NUMBER DEFAULT NULL,
    p_id_training     IN NUMBER DEFAULT NULL,
    p_id_size         IN NUMBER DEFAULT NULL,
    p_id_veterinarian IN NUMBER DEFAULT NULL,
    p_color           IN VARCHAR2 DEFAULT NULL,
    p_age             IN NUMBER DEFAULT NULL,
    p_name            IN VARCHAR2 DEFAULT NULL,
    p_chip            IN VARCHAR2 DEFAULT NULL,
    p_result          OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_result FOR
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
          AND (p_color IS NULL OR UPPER(Color) LIKE '%' || UPPER(p_color) || '%')
          AND (p_age IS NULL OR Age = p_age)
          AND (p_name IS NULL OR UPPER(PetName) LIKE '%' || UPPER(p_name) || '%')
          AND (p_chip IS NULL OR UPPER(Chip) LIKE '%' || UPPER(p_chip) || '%')
        ORDER BY PetName;
END;
/
/* ------------------------------------------------------------
   Procedimiento: PR_PUT_PET_UP_FOR_ADOPTION
   Descripcion:
   Cambia de estado a una mascota para ponerla en adopcion
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE PR_PUT_PET_UP_FOR_ADOPTION (
    p_pet_id   IN Pet.Id%TYPE,
    p_owner_id IN Pet.IdOwner%TYPE
)
AS
BEGIN
    UPDATE Pet
    SET IdState = 1
    WHERE Id = p_pet_id
      AND IdOwner = p_owner_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Pet not found, or this pet does not belong to this user.'
        );
    END IF;

    COMMIT;
END;
/
/* ------------------------------------------------------------
   Procedimiento: pr_register_pet
   Descripcion:
   Registra una mascota.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_register_pet (
    p_color           IN VARCHAR2,
    p_age             IN NUMBER,
    p_description     IN VARCHAR2,
    p_name            IN VARCHAR2,
    p_chip            IN VARCHAR2,
    p_id_energy       IN NUMBER,
    p_id_state        IN NUMBER,
    p_id_type         IN NUMBER,
    p_id_breed        IN NUMBER,
    p_id_district     IN NUMBER,
    p_id_space        IN NUMBER,
    p_id_training     IN NUMBER,
    p_id_size         IN NUMBER,
    p_id_owner        IN NUMBER,
    p_id_veterinarian IN NUMBER,
    p_new_id          OUT NUMBER
)
IS
BEGIN
    p_new_id := fn_next_id('Pet');

    INSERT INTO Pet (
        Id, Color, Age, Description, Name, Chip,
        IdEnergy, IdState, IdType, IdBreed, IdDistrict,
        IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
    )
    VALUES (
        p_new_id, p_color, p_age, p_description, p_name, p_chip,
        p_id_energy, p_id_state, p_id_type, p_id_breed, p_id_district,
        p_id_space, p_id_training, p_id_size, p_id_owner, p_id_veterinarian
    );

    COMMIT;
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_update_pet
   Descripcion:
   Actualiza todos los datos principales de una mascota.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_update_pet (
    p_id              IN NUMBER,
    p_color           IN VARCHAR2,
    p_age             IN NUMBER,
    p_description     IN VARCHAR2,
    p_name            IN VARCHAR2,
    p_chip            IN VARCHAR2,
    p_id_energy       IN NUMBER,
    p_id_state        IN NUMBER,
    p_id_type         IN NUMBER,
    p_id_breed        IN NUMBER,
    p_id_district     IN NUMBER,
    p_id_space        IN NUMBER,
    p_id_training     IN NUMBER,
    p_id_size         IN NUMBER,
    p_id_owner        IN NUMBER,
    p_id_veterinarian IN NUMBER
)
IS
BEGIN
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
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_search_pets
   Descripcion:
   Consulta mascotas por combinacion de filtros.
   Ordena por fecha descendente usando reportes de perdida
   o hallazgo cuando existan.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_search_pets (
    p_id_type      IN NUMBER DEFAULT NULL,
    p_id_breed     IN NUMBER DEFAULT NULL,
    p_id_state     IN NUMBER DEFAULT NULL,
    p_chip         IN VARCHAR2 DEFAULT NULL,
    p_id_district  IN NUMBER DEFAULT NULL,
    p_name         IN VARCHAR2 DEFAULT NULL,
    p_result       OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_result FOR
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
            NVL(lr.LostDate, fr.FoundDate) AS ReportDate
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
          AND (p_name IS NULL OR UPPER(p.Name) LIKE '%' || UPPER(p_name) || '%')
        ORDER BY NVL(lr.LostDate, fr.FoundDate) DESC NULLS LAST;
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_register_lost_report
   Descripcion:
   Registra un reporte de mascota perdida.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_register_lost_report (
    p_lost_date    IN DATE,
    p_place        IN VARCHAR2,
    p_description  IN VARCHAR2,
    p_reward       IN NUMBER,
    p_state        IN VARCHAR2,
    p_id_pet       IN NUMBER,
    p_id_district  IN NUMBER,
    p_id_currency  IN NUMBER,
    p_new_id       OUT NUMBER
)
IS
BEGIN
    p_new_id := fn_next_id('LostReport');

    INSERT INTO LostReport (
        Id, LostDate, Place, Description, Reward, State,
        IdPet, IdDistrict, IdCurrency
    )
    VALUES (
        p_new_id, p_lost_date, p_place, p_description, p_reward, p_state,
        p_id_pet, p_id_district, p_id_currency
    );

    COMMIT;
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_register_found_report
   Descripcion:
   Registra un reporte de mascota encontrada.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_register_found_report (
    p_found_date   IN DATE,
    p_place        IN VARCHAR2,
    p_description  IN VARCHAR2,
    p_id_pet       IN NUMBER,
    p_id_district  IN NUMBER,
    p_id_person    IN NUMBER,
    p_new_id       OUT NUMBER
)
IS
BEGIN
    p_new_id := fn_next_id('FoundReport');

    INSERT INTO FoundReport (
        Id, FoundDate, Place, Description, IdPet, IdDistrict, IdPerson
    )
    VALUES (
        p_new_id, p_found_date, p_place, p_description,
        p_id_pet, p_id_district, p_id_person
    );

    COMMIT;
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_generate_pet_matches
   Descripcion:
   Genera matches entre mascotas perdidas y encontradas.
   Usa el parametro MIN_MATCH_PERCENTAGE.
   Si no existe, usa 60%.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_generate_pet_matches
IS
    v_score NUMBER;
    v_min_score NUMBER;
    v_new_id NUMBER;
    v_exists NUMBER;
BEGIN
    v_min_score := fn_get_parameter_value('MIN_MATCH_PERCENTAGE', 60);

    FOR lost_rec IN (
        SELECT lr.Id AS IdLostReport, lr.IdPet AS IdLostPet
        FROM LostReport lr
        WHERE UPPER(lr.State) = 'PERDIDO'
    )
    LOOP
        FOR found_rec IN (
            SELECT fr.Id AS IdFoundReport, fr.IdPet AS IdFoundPet
            FROM FoundReport fr
        )
        LOOP
            v_score := fn_pet_match_score(
                lost_rec.IdLostPet,
                found_rec.IdFoundPet
            );

            IF v_score >= v_min_score THEN

                SELECT COUNT(*)
                INTO v_exists
                FROM PetMatch
                WHERE IdLostReport = lost_rec.IdLostReport
                  AND IdFoundReport = found_rec.IdFoundReport;

                IF v_exists = 0 THEN
                    v_new_id := fn_next_id('PetMatch');

                    INSERT INTO PetMatch (
                        Id,
                        SimilarityPercentage,
                        MatchDate,
                        IdLostReport,
                        IdFoundReport
                    )
                    VALUES (
                        v_new_id,
                        v_score,
                        SYSDATE,
                        lost_rec.IdLostReport,
                        found_rec.IdFoundReport
                    );
                END IF;
            END IF;
        END LOOP;
    END LOOP;

    COMMIT;
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_report_pet_matches
   Descripcion:
   Reporte de matches a demanda.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_report_pet_matches (
    p_start_date IN DATE DEFAULT NULL,
    p_end_date   IN DATE DEFAULT NULL,
    p_result     OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_result FOR
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
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_register_adoption
   Descripcion:
   Registra una adopcion o una mascota en adopcion.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_register_adoption (
    p_adoption_date  IN DATE,
    p_available_date IN DATE,
    p_description    IN VARCHAR2,
    p_amount         IN NUMBER,
    p_state          IN VARCHAR2,
    p_id_pet         IN NUMBER,
    p_id_adopter     IN NUMBER,
    p_id_owner       IN NUMBER,
    p_new_id         OUT NUMBER
)
IS
BEGIN
    p_new_id := fn_next_id('Adoption');

    INSERT INTO Adoption (
        Id, AdoptionDate, AvailableDate, Description, Amount,
        State, IdPet, IdAdopter, IdOwner
    )
    VALUES (
        p_new_id, p_adoption_date, p_available_date, p_description, p_amount,
        p_state, p_id_pet, p_id_adopter, p_id_owner
    );

    COMMIT;
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_calificate_person
   Descripcion:
   Registra calificacion y nota para adoptante/persona.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_calificate_person (
    p_stars     IN NUMBER,
    p_note      IN VARCHAR2,
    p_id_person IN NUMBER,
    p_new_id    OUT NUMBER
)
IS
BEGIN
    p_new_id := fn_next_id('Calification');

    INSERT INTO Calification (
        Id, Stars, Note, CalificationDate, IdPerson
    )
    VALUES (
        p_new_id, p_stars, p_note, SYSDATE, p_id_person
    );

    COMMIT;
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_add_to_blocklist
   Descripcion:
   Agrega una persona a lista negra.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_add_to_blocklist (
    p_id_person IN NUMBER,
    p_new_id    OUT NUMBER
)
IS
BEGIN
    p_new_id := fn_next_id('BlockList');

    INSERT INTO BlockList (
        Id, BlockDate, IdPerson
    )
    VALUES (
        p_new_id, SYSDATE, p_id_person
    );

    COMMIT;
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_report_blocklist
   Descripcion:
   Reporte de lista negra con calificacion promedio.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_report_blocklist (
    p_result OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_result FOR
        SELECT
            bl.Id,
            bl.BlockDate,
            p.Id AS PersonId,
            p.FirstName,
            p.LastName,
            fn_person_average_rating(p.Id) AS AverageRating,
            fn_is_blacklisted(p.Id) AS IsBlacklisted
        FROM BlockList bl
        INNER JOIN Person p ON p.Id = bl.IdPerson
        ORDER BY bl.BlockDate DESC;
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_register_donation
   Descripcion:
   Registra una donacion.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_register_donation (
    p_amount         IN NUMBER,
    p_donation_date  IN DATE,
    p_id_person      IN NUMBER,
    p_id_currency    IN NUMBER,
    p_id_association IN NUMBER,
    p_new_id         OUT NUMBER
)
IS
BEGIN
    p_new_id := fn_next_id('Donation');

    INSERT INTO Donation (
        Id, Amount, DonationDate, IdPerson, IdCurrency, IdAssociation
    )
    VALUES (
        p_new_id, p_amount, p_donation_date,
        p_id_person, p_id_currency, p_id_association
    );

    COMMIT;
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_report_donations
   Descripcion:
   Consulta de donaciones filtrable por fecha, donador,
   asociacion y monto.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_report_donations (
    p_start_date     IN DATE DEFAULT NULL,
    p_end_date       IN DATE DEFAULT NULL,
    p_id_person      IN NUMBER DEFAULT NULL,
    p_id_association IN NUMBER DEFAULT NULL,
    p_min_amount     IN NUMBER DEFAULT NULL,
    p_max_amount     IN NUMBER DEFAULT NULL,
    p_result         OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_result FOR
        SELECT
            d.Id,
            d.Amount,
            d.DonationDate,
            c.Name AS Currency,
            p.FirstName || ' ' || p.LastName AS Donor,
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
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_total_donations_by_association
   Descripcion:
   Total de donaciones agrupado por asociacion.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_total_donations_assoc  (
    p_start_date IN DATE DEFAULT NULL,
    p_end_date   IN DATE DEFAULT NULL,
    p_result     OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_result FOR
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
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_register_foster_home
   Descripcion:
   Registra casa cuna.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_register_foster_home (
    p_needs_donation IN VARCHAR2,
    p_id_person      IN NUMBER,
    p_new_id         OUT NUMBER
)
IS
BEGIN
    p_new_id := fn_next_id('FosterHome');

    INSERT INTO FosterHome (
        Id, NeedsDonation, IdPerson
    )
    VALUES (
        p_new_id, p_needs_donation, p_id_person
    );

    COMMIT;
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_search_foster_homes
   Descripcion:
   Consulta casas cuna por tamano, energia o espacio requerido.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_search_foster_homes (
    p_id_pet_size IN NUMBER DEFAULT NULL,
    p_id_energy   IN NUMBER DEFAULT NULL,
    p_id_space    IN NUMBER DEFAULT NULL,
    p_result      OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_result FOR
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
END pr_search_foster_homes;
/


/* ------------------------------------------------------------
   Procedimiento: pr_report_not_adopted_pets
   Descripcion:
   Lista mascotas no adoptadas en los ultimos 2 meses.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_report_not_adopted_pets (
    p_result OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_result FOR
        SELECT
            p.Id,
            p.Name,
            p.Color,
            p.Age,
            a.AvailableDate,
            TRUNC(MONTHS_BETWEEN(SYSDATE, a.AvailableDate)) AS WaitingMonths
        FROM Adoption a
        INNER JOIN Pet p ON p.Id = a.IdPet
        WHERE UPPER(a.State) = 'EN ADOPCION'
          AND a.AvailableDate <= ADD_MONTHS(SYSDATE, -2)
        ORDER BY a.AvailableDate ASC;
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_query_bitacora
   Descripcion:
   Consulta de bitacora filtrable por atributos.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_query_bitacora (
    p_table_name IN VARCHAR2 DEFAULT NULL,
    p_field_name IN VARCHAR2 DEFAULT NULL,
    p_changed_by IN NUMBER DEFAULT NULL,
    p_start_date IN DATE DEFAULT NULL,
    p_end_date   IN DATE DEFAULT NULL,
    p_result     OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_result FOR
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
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_stats_pets_by_type_state
   Descripcion:
   Estadistica de mascotas por tipo y estado.
   Por defecto: inicio del ano actual hasta hoy.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_stats_pets_by_type_state (
    p_start_date IN DATE DEFAULT TRUNC(SYSDATE, 'YYYY'),
    p_end_date   IN DATE DEFAULT SYSDATE,
    p_result     OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_result FOR
        SELECT
            pt.Name AS PetType,
            ps.Name AS PetState,
            COUNT(*) AS TotalPets
        FROM Pet p
        INNER JOIN PetType pt ON pt.Id = p.IdType
        INNER JOIN PetState ps ON ps.Id = p.IdState
        LEFT JOIN LostReport lr ON lr.IdPet = p.Id
        LEFT JOIN FoundReport fr ON fr.IdPet = p.Id
        WHERE NVL(lr.LostDate, fr.FoundDate) BETWEEN p_start_date AND p_end_date
           OR NVL(lr.LostDate, fr.FoundDate) IS NULL
        GROUP BY pt.Name, ps.Name
        ORDER BY pt.Name, ps.Name;
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_stats_adoptions
   Descripcion:
   Porcentaje de adopciones exitosas vs mascotas en espera.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_stats_adoptions (
    p_id_type  IN NUMBER DEFAULT NULL,
    p_id_breed IN NUMBER DEFAULT NULL,
    p_result   OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_result FOR
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
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_stats_not_adopted_by_age
   Descripcion:
   Total y porcentaje de mascotas no adoptadas por rango de edad.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_stats_not_adopted_by_age (
    p_result OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_result FOR
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
END;
/


CREATE OR REPLACE PROCEDURE pr_insert_pet_image(pImage IN VARCHAR2, pIdPet IN NUMBER)
AS 
BEGIN --> aqui va el comando:
    INSERT INTO petPhoto (id,Photo,IdPet)
    VALUES 
    (s_petPhoto.nextval,pImage,pIdPet);
    COMMIT;
END pr_insert_pet_image;


/*Insert person de Carlos */
CREATE OR REPLACE PROCEDURE pr_insert_person(pFirst_name IN VARCHAR2, pLast_name IN VARCHAR2, pEmail IN VARCHAR2, pPassword IN VARCHAR2, pUserName IN VARCHAR2, pIdDistrict IN NUMBER, pPhoneNumber IN NUMBER)
AS 
    vcIdPerson NUMBER(8);
BEGIN --> aqui va el comando:
    --> guardamos el Id solo una vez para no estar llamando a s_Person.
    vcIdPerson := s_Person.NEXTVAL;
    
    INSERT INTO Person (Id, FirstName, LastName, Password, UserName, IdDistrict)
    VALUES 
    (vcIdPerson,pFirst_name,pLast_name,pPassword,pUserName,pIdDistrict);

    INSERT INTO Email (Id, Email, IdPerson) 
    VALUES 
    (s_Email.NEXTVAL, pEmail, vcIdPerson);

    INSERT INTO Phone (Id, Phone, IdPerson) 
    VALUES 
    (s_Phone.NEXTVAL, pPhoneNumber, vcIdPerson);

    -- Rol por defecto: todo usuario nuevo queda como adoptante.
    INSERT INTO Adopter (Id, IdPerson)
    VALUES
    (s_Adopter.NEXTVAL, vcIdPerson);

    COMMIT;
END pr_insert_person;
/

/* ------------------------------------------------------------
   Procedimiento: pr_insert_pet
   Descripcion:
   Inserta una nueva mascota en la base de datos.
   ------------------------------------------------------------ */
   CREATE OR REPLACE TYPE VARCHAR2LIST AS TABLE OF VARCHAR2(255);
   CREATE OR REPLACE TYPE NUMBERLIST AS TABLE OF NUMBER;
CREATE OR REPLACE PROCEDURE pr_insert_pet(pColor IN VARCHAR2, pAge IN NUMBER, pDescription IN VARCHAR2, pPetName IN VARCHAR2, pChip IN VARCHAR2, pIdEnergy IN NUMBER, pIdType IN NUMBER, pIdBreed IN NUMBER, pIdDistrict IN NUMBER, pIdSpaceRequired IN NUMBER, pIdPetTraining IN NUMBER, pIdPetSize IN NUMBER, pIdPerson IN NUMBER, pIdVeterinarian IN NUMBER, pIllnessId IN NumberList, pTreatMentId IN NumberList, pMedicineId IN NumberList, pPhotoPath IN VARCHAR2LIST)
AS 
    vcIdPet NUMBER(8);
BEGIN --> aqui va el comando:
    vcIdPet := s_Pet.NEXTVAL;
    INSERT INTO Pet (id, Color, Age, Description, Name, Chip, IdEnergy, IdState, IdType, IdBreed, IdDistrict, IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian)
    VALUES 
    (vcIdPet, pColor, pAge, pDescription, pPetName, pChip, pIdEnergy, 2, pIdType, pIdBreed, pIdDistrict, pIdSpaceRequired, pIdPetTraining, pIdPetSize, pIdPerson, pIdVeterinarian);
    
    --> Insertar enfermedades
    FOR i IN 1 .. pIllnessId.COUNT LOOP

        INSERT INTO PetXPetIllness (
            IdPet,
            IdPetIllness
        )
        VALUES (
            vcIdPet,
            pIllnessId(i)
        );

    END LOOP;
    --> Insertar tratamientos
    FOR i IN 1 .. pTreatMentId.COUNT LOOP

        INSERT INTO PetXPetTreatment (
            IdPet,
            IdPetTreatment
        )
        VALUES (
            vcIdPet,
            pTreatMentId(i)
        );

    END LOOP;
    
     --> Insertar medicinas
    FOR i IN 1 .. pMedicineId.COUNT LOOP

        INSERT INTO PetXMedicine (
            IdPet,
            IdMedicine
        )
        VALUES (
            vcIdPet,
            pMedicineId(i)
        );

    END LOOP;

    --> Insertar fotos de mascota (si se proporcionan)
    IF pPhotoPath IS NOT NULL THEN
        for i in 1 .. pPhotoPath.COUNT loop
            INSERT INTO petPhoto (
                Id,
                Photo,
                IdPet
            )
            VALUES (
                s_petPhoto.NEXTVAL,
                pPhotoPath(i),
                vcIdPet
            );
        END LOOP;
    END IF;

    COMMIT;
END pr_insert_pet;




/* ------------------------------------------------------------
   Procedimiento: pr_register_person_email
   Descripcion:
   Registra un correo asociado a una persona.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_register_person_email (
    p_email     IN VARCHAR2,
    p_id_person IN NUMBER,
    p_new_id    OUT NUMBER
)
IS
BEGIN
    p_new_id := fn_next_id('Email');

    INSERT INTO Email (
        Id,
        Email,
        IdPerson
    )
    VALUES (
        p_new_id,
        p_email,
        p_id_person
    );

    COMMIT;
END;
/


/* ------------------------------------------------------------
   Procedimiento: pr_register_person_phone
   Descripcion:
   Registra un telefono asociado a una persona.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_register_person_phone (
    p_phone     IN NUMBER,
    p_id_person IN NUMBER,
    p_new_id    OUT NUMBER
)
IS
BEGIN
    p_new_id := fn_next_id('Phone');

    INSERT INTO Phone (
        Id,
        Phone,
        IdPerson
    )
    VALUES (
        p_new_id,
        p_phone,
        p_id_person
    );

    COMMIT;
END;
/


/* ============================================================
   PROCEDIMIENTOS PARA ROLES DE PERSONA
   ============================================================ */

/* ------------------------------------------------------------
   Procedimiento: pr_assign_admin_role
   Descripcion:
   Asigna el rol de administrador a una persona existente.
   La persona debe existir. Si ya es admin, no duplica el registro.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_assign_admin_role (
    p_id_person IN NUMBER,
    p_new_id    OUT NUMBER
)
IS
    v_person_exists NUMBER(1);
    v_admin_id      Admin.Id%TYPE;
BEGIN
    -- Validar que la persona exista.
    SELECT COUNT(*)
      INTO v_person_exists
      FROM Person
     WHERE Id = p_id_person;

    IF v_person_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'La persona indicada no existe.');
    END IF;

    -- Validar si la persona ya tiene rol admin.
    SELECT MAX(Id)
      INTO v_admin_id
      FROM Admin
     WHERE IdPerson = p_id_person;

    IF v_admin_id IS NOT NULL THEN
        p_new_id := v_admin_id;
        RETURN;
    END IF;

    -- Asignar rol admin.
    p_new_id := s_Admin.NEXTVAL;

    INSERT INTO Admin (Id, IdPerson)
    VALUES (p_new_id, p_id_person);

    COMMIT;
END pr_assign_admin_role;
/

/* ------------------------------------------------------------
   Procedimiento: pr_assign_adopter_role
   Descripcion:
   Asigna el rol de adoptante a una persona existente.
   La persona debe existir. Si ya es adoptante, no duplica el registro.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_assign_adopter_role (
    p_id_person IN NUMBER,
    p_new_id    OUT NUMBER
)
IS
    v_person_exists NUMBER(1);
    v_adopter_id    Adopter.Id%TYPE;
BEGIN
    SELECT COUNT(*)
      INTO v_person_exists
      FROM Person
     WHERE Id = p_id_person;

    IF v_person_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20011, 'La persona indicada no existe.');
    END IF;

    SELECT MAX(Id)
      INTO v_adopter_id
      FROM Adopter
     WHERE IdPerson = p_id_person;

    IF v_adopter_id IS NOT NULL THEN
        p_new_id := v_adopter_id;
        RETURN;
    END IF;

    p_new_id := s_Adopter.NEXTVAL;

    INSERT INTO Adopter (Id, IdPerson)
    VALUES (p_new_id, p_id_person);

    COMMIT;
END pr_assign_adopter_role;
/


/* ------------------------------------------------------------
   Procedimiento: pr_assign_rescuer_role
   Descripcion:
   Asigna el rol de rescatista a una persona existente.
   La persona debe existir. Si ya es rescatista, no duplica el registro.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_assign_rescuer_role (
    p_id_person IN NUMBER,
    p_new_id    OUT NUMBER
)
IS
    v_person_exists NUMBER(1);
    v_rescuer_id    Rescuer.Id%TYPE;
BEGIN
    SELECT COUNT(*)
      INTO v_person_exists
      FROM Person
     WHERE Id = p_id_person;

    IF v_person_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'La persona indicada no existe.');
    END IF;

    SELECT MAX(Id)
      INTO v_rescuer_id
      FROM Rescuer
     WHERE IdPerson = p_id_person;

    IF v_rescuer_id IS NOT NULL THEN
        p_new_id := v_rescuer_id;
        RETURN;
    END IF;

    p_new_id := s_Rescuer.NEXTVAL;

    INSERT INTO Rescuer (Id, IdPerson)
    VALUES (p_new_id, p_id_person);

    COMMIT;
END pr_assign_rescuer_role;
/


/* ------------------------------------------------------------
   Procedimiento: pr_assign_foster_home_role
   Descripcion:
   Asigna el rol de casa cuna a una persona existente.
   La persona debe existir. Si ya es casa cuna, no duplica el registro.
   ------------------------------------------------------------ */
CREATE OR REPLACE PROCEDURE pr_assign_foster_home_role (
    p_id_person      IN NUMBER,
    p_needs_donation IN VARCHAR2 DEFAULT 'N',
    p_new_id         OUT NUMBER
)
IS
    v_person_exists  NUMBER(1);
    v_foster_home_id FosterHome.Id%TYPE;
    v_needs_donation FosterHome.NeedsDonation%TYPE;
BEGIN
    SELECT COUNT(*)
      INTO v_person_exists
      FROM Person
     WHERE Id = p_id_person;

    IF v_person_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20013, 'La persona indicada no existe.');
    END IF;

    v_needs_donation := UPPER(NVL(p_needs_donation, 'N'));

    IF v_needs_donation NOT IN ('Y', 'N') THEN
        RAISE_APPLICATION_ERROR(-20014, 'NeedsDonation solo puede ser Y o N.');
    END IF;

    SELECT MAX(Id)
      INTO v_foster_home_id
      FROM FosterHome
     WHERE IdPerson = p_id_person;

    IF v_foster_home_id IS NOT NULL THEN
        p_new_id := v_foster_home_id;
        RETURN;
    END IF;

    p_new_id := s_FosterHome.NEXTVAL;

    INSERT INTO FosterHome (Id, NeedsDonation, IdPerson)
    VALUES (p_new_id, v_needs_donation, p_id_person);

    COMMIT;
END pr_assign_foster_home_role;
/

/*Cambiar el estado de una mascota a el estado 4
1 Up for adoption
2 Adopted
3 Lost
4 Found
*/
CREATE OR REPLACE PROCEDURE put_pet_up_for_adoption (
    p_pet_id IN Pet.Id%TYPE
)
AS
BEGIN
    UPDATE Pet
    SET IdState = 1
    WHERE Id = p_pet_id
      AND IdState = 4;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Pet was not found or is not in Found state.'
        );
    END IF;

    COMMIT;
END;
/
