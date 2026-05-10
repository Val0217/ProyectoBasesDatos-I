CREATE OR REPLACE VIEW vw_adoption_request_table AS
    SELECT
        a.Id AS AdoptionId,
        a.IdPet AS PetId,
        a.IdAdopter AS AdopterId,
        p.Name AS PetName,
        a.Description AS AdoptionDescription,
        adopter.FirstName AS FirstName,
        adopter.LastName AS LastName,
        (
            SELECT TO_CHAR(MIN(ph.Phone))
              FROM Phone ph
             WHERE ph.IdPerson = adopter.Id
        ) AS Phone,
        (
            SELECT MIN(em.Email)
              FROM Email em
             WHERE em.IdPerson = adopter.Id
        ) AS Email,
        a.State AS AdoptionState,
        a.IdOwner AS OwnerId
    FROM Adoption a
    INNER JOIN Pet p
            ON p.Id = a.IdPet
    INNER JOIN Person adopter
            ON adopter.Id = a.IdAdopter;
    /
    SHOW ERRORS VIEW vw_adoption_request_table;
    


CREATE OR REPLACE VIEW VW_TABLE_ADOPTION AS
SELECT
    p.Id AS PetId,
    p.Color,
    p.Age,
    p.Description,
    p.Name AS PetName,
    p.Chip,

    energy.Name AS Energy,
    state.Id AS IdState,
    state.Name AS PetState,
    type.Name AS PetType,
    breed.Name AS Breed,
    district.Name AS District,
    space.Name AS SpaceRequired,
    training.Name AS Training,
    sizeTable.Name AS PetSize,

    owner.FirstName || ' ' || owner.LastName AS OwnerName,

    CASE
        WHEN vet.Name IS NOT NULL THEN vet.Name
        ELSE vet.FirstName || ' ' || vet.LastName
    END AS VeterinarianName

FROM Pet p

LEFT JOIN PetLevelEnergy energy
    ON p.IdEnergy = energy.Id

LEFT JOIN PetState state
    ON p.IdState = state.Id

LEFT JOIN PetType type
    ON p.IdType = type.Id

LEFT JOIN PetBreed breed
    ON p.IdBreed = breed.Id

LEFT JOIN District district
    ON p.IdDistrict = district.Id

LEFT JOIN SpaceRequired space
    ON p.IdSpace = space.Id

LEFT JOIN PetTraining training
    ON p.IdPetTraining = training.Id

LEFT JOIN PetSize sizeTable
    ON p.IdSize = sizeTable.Id

LEFT JOIN Person owner
    ON p.IdOwner = owner.Id

LEFT JOIN Veterinarian vet
    ON p.IdVeterinarian = vet.Id;
    
/*---------------------------------------------------*/

CREATE OR REPLACE VIEW VW_USER_PET_TABLE AS
SELECT
    p.Id AS PetId,
    p.Name AS PetName,
    p.Color,
    p.Age,
    p.Chip,
    p.Description,

    p.IdOwner,
    p.IdEnergy,
    energy.Name AS Energy,

    p.IdState,
    state.Name AS PetState,

    p.IdType,
    petType.Name AS PetType,

    p.IdBreed,
    breed.Name AS Breed,

    p.IdDistrict,
    district.Name AS District,
    
    country.Id AS IdCountry,
    country.Name AS Country,
    
    province.Id AS IdProvince,
    province.Name AS Province,
    
    canton.Id AS IdCanton,
    canton.Name AS Canton,

    p.IdSpace,
    space.Name AS SpaceRequired,

    p.IdPetTraining,
    training.Name AS Training,

    p.IdSize,
    sizeTable.Name AS PetSize,

    p.IdVeterinarian,
    CASE
        WHEN vet.Name IS NOT NULL THEN vet.Name
        ELSE vet.FirstName || ' ' || vet.LastName
    END AS VeterinarianName

FROM Pet p
LEFT JOIN PetLevelEnergy energy ON p.IdEnergy = energy.Id
LEFT JOIN PetState state ON p.IdState = state.Id
LEFT JOIN PetType petType ON p.IdType = petType.Id
LEFT JOIN PetBreed breed ON p.IdBreed = breed.Id
LEFT JOIN District district ON p.IdDistrict = district.Id
LEFT JOIN Canton canton ON district.IdCanton = canton.Id
LEFT JOIN Province province ON canton.IdProvince = province.Id
LEFT JOIN Country country ON province.IdCountry = country.Id
LEFT JOIN SpaceRequired space ON p.IdSpace = space.Id
LEFT JOIN PetTraining training ON p.IdPetTraining = training.Id
LEFT JOIN PetSize sizeTable ON p.IdSize = sizeTable.Id
LEFT JOIN Veterinarian vet ON p.IdVeterinarian = vet.Id;
/