CREATE TABLE PetLevelEnergy (
    Id NUMBER(8),
    Name VARCHAR2(25)
);

CREATE TABLE PetBreed (
    Id NUMBER(8),
    Name VARCHAR2(25)
);

CREATE TABLE PetType (
    Id NUMBER(8),
    Name VARCHAR2(25)
);

CREATE TABLE PetState (
    Id NUMBER(8),
    Name VARCHAR2(25)
);

CREATE TABLE PetIllness (
    Id NUMBER(8),
    Name VARCHAR2(25),
    Description VARCHAR(100)
);

CREATE TABLE Medicine (
    Id NUMBER(8),
    Name VARCHAR2(25),
    Dose VARCHAR2(25)
);

CREATE TABLE PetTreatment (
    Id NUMBER(8),
    Name VARCHAR2(25),
    Description VARCHAR(100)
);

CREATE TABLE PetTraining (
    Id NUMBER(8),
    Name VARCHAR2(25)
);

CREATE TABLE PetPhoto (
    Id NUMBER(8),
    Photo BLOB,
    IdPet Number(8)
);

CREATE TABLE SpaceRequired (
    Id NUMBER(8),
    Name VARCHAR2(25)
);

CREATE TABLE PetSize (
    Id NUMBER(8),
    Name VARCHAR2(25)
);

CREATE TABLE District (
    Id NUMBER(8),
    Name VARCHAR2(25),
    IdCanton Number(8)
);

CREATE TABLE Canton (
    Id NUMBER(8),
    Name VARCHAR2(25),
    IdProvince Number(8)
);

CREATE TABLE Province (
    Id NUMBER(8),
    Name VARCHAR2(25),
    IdCountry Number(8)
);

CREATE TABLE Country (
    Id NUMBER(8),
    Name VARCHAR2(25)
);

CREATE TABLE PetSeverity (
    Id NUMBER(8),
    Name VARCHAR2(25)
);

CREATE TABLE Pet (
    Id NUMBER(8),
    Color VARCHAR2(50),
    Age Number(8),
    Description VARCHAR2(100),
    Name VARCHAR2(25),
    Chip VARCHAR2(15),
    IdEnergy NUMBER(8),
    IdState NUMBER(8),
    IdType NUMBER(8),
    IdBreed NUMBER(8),
    IdDistrict NUMBER(8),
    IdSpace NUMBER(8),
    IdPetTraining NUMBER(8),
    IdSize NUMBER(8),
    IdOwner NUMBER(8),
    IdVeterinarian NUMBER(8)
);

CREATE TABLE Veterinarian (
    Id NUMBER(8),
    Email VARCHAR2(25),
    FirstName VARCHAR2(25),
    LastName VARCHAR2(25),
    Location VARCHAR2(100), -- Agregar Distrito
    IdDristrict NUMBER(8),
    Phone NUMBER(8),
    Name VARCHAR2(50)
);

CREATE TABLE PetSizeXFosterHome (
    IdPetSize NUMBER(8),
    IdFosterHome NUMBER(8)
);

CREATE TABLE PetXPetTreatment (
    IdPet NUMBER(8),
    IdPetTreatment NUMBER(8)
);

CREATE TABLE PetXPetIllness (
    IdPet NUMBER(8),
    IdPetIllness NUMBER(8)
);

CREATE TABLE PetXMedicine (
    IdPet NUMBER(8),
    IdMedicine NUMBER(8)
);

CREATE TABLE PetLevelEnergyXFosterHome (
    IdPetLevelEnergy NUMBER(8),
    IdFosterHome NUMBER(8)
);

CREATE TABLE SpaceRequiredXFosterHome (
    IdSpaceRequired NUMBER(8),
    IdFosterHome NUMBER(8)
);

CREATE TABLE FoundReport (
    Id NUMBER(8),
    FoundDate DATE, -- se cambio el nombre
    Place VARCHAR2(100), -- podria ligarse a district
    Description VARCHAR2(100),
    IdPet NUMBER(8),
    IdDistrict NUMBER(8),
    IdPerson NUMBER(8)
);

CREATE TABLE PetMatch (
    Id NUMBER(8),
    SimilarityPercentage NUMBER(3),
    MatchDate DATE,
    --Status VARCHAR2(25), -- Esto debe ser un campo definido y no me acuerdo porque esto tiene estado
    IdLostReport NUMBER(8),
    IdFoundReport NUMBER(8)
);

CREATE TABLE LostReport (
    Id NUMBER(8),
    LostDate DATE,  -- se cambio el nombre
    Place VARCHAR2(100), -- podria ligarse a district
    Description VARCHAR2(100),
    Reward NUMBER(8),
    State VARCHAR2(25), -- Esto debe ser un campo definido
    IdPet NUMBER(8),
    IdDistrict NUMBER(8),
    IdCurrency NUMBER(8)
);

CREATE TABLE Adoption (
    Id NUMBER(8),
    AdoptionDate DATE,
    AvailableDate DATE,
    Description VARCHAR2(100),
    Amount NUMBER(8), -- no me acuerdo para que es esto
    State VARCHAR2(25), -- Esto debe ser un campo definido
    IdPet NUMBER(8),
    IdAdopter NUMBER(8),
    IdOwner NUMBER(8)
);

CREATE TABLE Rescued (
    Id NUMBER(8),
    RescueDate DATE,  -- se cambio el nombre
    Place VARCHAR2(100), -- esto se podria ligar a distric
    BeforePhoto BLOB,
    AfterPhoto BLOB,
    Description VARCHAR2(100),
    IdPet NUMBER(8),
    IdDistrict NUMBER(8),
    IdRescuer NUMBER(8),
    IdPetSeverity NUMBER(8)
);

CREATE TABLE Donation (
    Id NUMBER(8),
    Amount NUMBER(8),
    DonationDate Date,  -- se cambio el nombre
    IdPerson NUMBER(8),
    IdCurrency NUMBER(8),
    IdAssociation NUMBER(8)
);

CREATE TABLE Currency (
    Id NUMBER(8),
    Name VARCHAR2(25)
);

CREATE TABLE Person (  -- se cambio el nombre
    Id NUMBER(8),
    FirstName VARCHAR2(25),
    LastName VARCHAR2(25),
    Password VARCHAR2(15),
    UserName VARCHAR2(25),
    IdDistrict NUMBER(8)
    --Notes VARCHAR2(25) -- No se porque tiene Notas el usuario, quiza deberiamos meterles Distric
    -- el modelo logico esta mal con lo que viene despues :p
);

CREATE TABLE ReportList (
    Id NUMBER(8),
    Description VARCHAR2(250),
    IdPerson NUMBER(8),
    IdReporter NUMBER(8), -- estaria bien agregar a quien hizo el reporte
    ReportDate DATE -- estaria bien agregar la fecha del reporte
);

CREATE TABLE Rescuer (
    Id NUMBER(8),
    IdPerson NUMBER(8)
);

CREATE TABLE Adopter (
    Id NUMBER(8),
    IdPerson NUMBER(8)
);

CREATE TABLE Calification (
    Id NUMBER(8),
    Stars NUMBER(8),
    Note VARCHAR2(250),
    CalificationDate DATE,  -- se cambio el nombre
    IdPerson NUMBER(8)
);

CREATE TABLE FosterHome (
    Id NUMBER(8),
    NeedsDonation VARCHAR2(1),
    IdPerson NUMBER(8)
);

CREATE TABLE Admin (
    Id NUMBER(8),
    IdPerson NUMBER(8)
);

CREATE TABLE Email (
    Id NUMBER(8),
    Email VARCHAR2(25),
    IdPerson NUMBER(8)
);

CREATE TABLE Phone (
    Id NUMBER(8),
    Phone NUMBER(8),
    IdPerson NUMBER(8)
);

CREATE TABLE BlockList (
    Id NUMBER(8),
    BlockDate DATE,  -- se cambio el nombre
    IdPerson NUMBER(8)
);

CREATE TABLE Association (
    Id NUMBER(8),
    Name VARCHAR2(25),
    PhoneNumber NUMBER(8),
    BankAccount VARCHAR2(35),
    Email VARCHAR2(25)
);

CREATE TABLE Deleted (
    Id NUMBER(8),
    DeletedDate DATE,
    DeletedBy VARCHAR2(25), --esto podria ser el id del usuario
    TableName VARCHAR2(25),
    DeletedId NUMBER(8)
);

CREATE TABLE Created (
    Id NUMBER(8),
    CreatedDate DATE,
    CreatedBy VARCHAR2(25), --esto podria ser el id del usuario
    TableName VARCHAR2(25),
    CreatedId NUMBER(8)
);

CREATE TABLE Parameter (
    Id NUMBER(8),
    Value NUMBER(8),
    Name VARCHAR2(25),
    Description VARCHAR2(100)
);

CREATE TABLE Bitacora ( -- Ojo
    Id NUMBER(8),
    TableName VARCHAR2(25),
    ChangeDate DATE, 
    PreviousValue VARCHAR2(50),
    ChangedBy NUMBER(8),
    CurrentValue VARCHAR2(50),
    FieldName VARCHAR2(25)
);

-- Tabla AdoptionPhoto 
