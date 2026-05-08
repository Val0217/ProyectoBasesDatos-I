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