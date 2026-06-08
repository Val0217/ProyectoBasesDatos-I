CREATE TABLE PetClaim (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    ClaimDate DATE,
    Description VARCHAR(250),
    State VARCHAR(25),
    IdPet INT,
    IdClaimant INT,
    IdOwner INT
);

CREATE TABLE PetLevelEnergy (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25)
);

CREATE TABLE PetBreed (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25),
    IdType INT
);

CREATE TABLE PetType (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25)
);

CREATE TABLE PetState (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25)
);

CREATE TABLE PetIllness (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25),
    Description VARCHAR(100)
);

CREATE TABLE Medicine (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25),
    Dose VARCHAR(25)
);

CREATE TABLE PetTreatment (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25),
    Description VARCHAR(100)
);

CREATE TABLE PetTraining (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25)
);

CREATE TABLE PetPhoto (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Photo VARCHAR(255),
    IdPet INT
);

CREATE TABLE SpaceRequired (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25)
);

CREATE TABLE PetSize (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25)
);

CREATE TABLE District (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25),
    IdCanton INT
);

CREATE TABLE Canton (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25),
    IdProvince INT
);

CREATE TABLE Province (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25),
    IdCountry INT
);

CREATE TABLE Country (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25)
);

CREATE TABLE PetSeverity (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25)
);

CREATE TABLE Pet (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Color VARCHAR(50),
    Age INT,
    Description VARCHAR(100),
    Name VARCHAR(25),
    Chip VARCHAR(15),
    IdEnergy INT,
    IdState INT,
    IdType INT,
    IdBreed INT,
    IdDistrict INT,
    IdSpace INT,
    IdPetTraining INT,
    IdSize INT,
    IdOwner INT,
    IdVeterinarian INT
);

CREATE TABLE Veterinarian (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Email VARCHAR(25),
    FirstName VARCHAR(25),
    LastName VARCHAR(25),
    Location VARCHAR(1000),
    IdDistrict INT,
    Phone BIGINT,
    Name VARCHAR(50)
);

CREATE TABLE PetSizeXFosterHome (
    IdPetSize INT,
    IdFosterHome INT
);

CREATE TABLE PetXPetTreatment (
    IdPet INT,
    IdPetTreatment INT
);

CREATE TABLE PetXPetIllness (
    IdPet INT,
    IdPetIllness INT
);

CREATE TABLE PetXMedicine (
    IdPet INT,
    IdMedicine INT
);

CREATE TABLE PetLevelEnergyXFosterHome (
    IdPetLevelEnergy INT,
    IdFosterHome INT
);

CREATE TABLE SpaceRequiredXFosterHome (
    IdSpaceRequired INT,
    IdFosterHome INT
);

CREATE TABLE FoundReport (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    FoundDate DATE,
    Place VARCHAR(100),
    Description VARCHAR(100),
    IdPet INT,
    IdDistrict INT,
    IdPerson INT
);

CREATE TABLE PetMatch (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    SimilarityPercentage INT,
    MatchDate DATE,
    IdLostReport INT,
    IdFoundReport INT
);

CREATE TABLE LostReport (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    LostDate DATE,
    Place VARCHAR(100),
    Description VARCHAR(100),
    Reward INT,
    State VARCHAR(25),
    IdPet INT,
    IdDistrict INT,
    IdCurrency INT
);

CREATE TABLE Adoption (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    AdoptionDate DATE,
    AvailableDate DATE,
    Description VARCHAR(100),
    State VARCHAR(25),
    IdPet INT,
    IdAdopter INT,
    IdOwner INT
);

CREATE TABLE Rescued (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    RescueDate DATE,
    Place VARCHAR(100),
    BeforePhoto VARCHAR(255),
    AfterPhoto VARCHAR(255),
    Description VARCHAR(100),
    IdPet INT,
    IdDistrict INT,
    IdRescuer INT,
    IdPetSeverity INT
);

CREATE TABLE Donation (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Amount INT,
    DonationDate DATE,
    IdPerson INT,
    IdCurrency INT,
    IdAssociation INT
);

CREATE TABLE Currency (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25)
);

CREATE TABLE Person (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(25),
    LastName VARCHAR(25),
    Password VARCHAR(60),
    UserName VARCHAR(25),
    IdDistrict INT
);

CREATE TABLE ReportList (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Description VARCHAR(250),
    IdPerson INT,
    IdReporter INT,
    ReportDate DATE
);

CREATE TABLE Rescuer (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    IdPerson INT
);

CREATE TABLE Adopter (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    IdPerson INT
);

CREATE TABLE Calification (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Stars INT,
    Note VARCHAR(250),
    CalificationDate DATE,
    IdPerson INT
);

CREATE TABLE FosterHome (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    NeedsDonation VARCHAR(1),
    IdPerson INT
);

CREATE TABLE Admin (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    IdPerson INT
);

CREATE TABLE Email (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Email VARCHAR(25),
    IdPerson INT
);

CREATE TABLE Phone (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Phone INT,
    IdPerson INT
);

CREATE TABLE BlockList (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    BlockDate DATE,
    IdPerson INT
);

CREATE TABLE Association (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25),
    PhoneNumber INT,
    BankAccount VARCHAR(35),
    Email VARCHAR(25)
);

CREATE TABLE Deleted (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    DeletedDate DATE,
    DeletedBy VARCHAR(25),
    TableName VARCHAR(25),
    DeletedId INT
);

CREATE TABLE Created (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    CreatedDate DATE,
    CreatedBy VARCHAR(25),
    TableName VARCHAR(25),
    CreatedId INT
);

CREATE TABLE Parameter (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Value INT,
    Name VARCHAR(25),
    Description VARCHAR(100)
);

CREATE TABLE Bitacora (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    TableName VARCHAR(25),
    ChangeDate DATE,
    PreviousValue VARCHAR(50),
    ChangedBy INT,
    CurrentValue VARCHAR(50),
    FieldName VARCHAR(25)
);