
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


/* ------------------------------------------------------------
   Procedimiento: pr_get_person_id
   Descripcion:
   Obtiene el Id de una persona dado su username.
   En caso de que no exista, devuelve NULL.
   ------------------------------------------------------------ */
CREATE OR REPLACE FUNCTION pr_get_person_id(pUserName IN VARCHAR2)
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

