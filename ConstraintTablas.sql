-- =============================================================
-- ARCHIVO: CrearConstraintTablas.sql
-- DESCRIPCION: Constraints de validacion (NOT NULL, CHECK, UNIQUE)
-- PROYECTO: Bienestar Animal
-- =============================================================

-- -------------------------------------------------------------
-- TABLAS DE CATALOGOS (NOT NULL en Name)
-- -------------------------------------------------------------
-- prueba de repositorio
ALTER TABLE PetLevelEnergy MODIFY (Name VARCHAR2(25) NOT NULL);
ALTER TABLE PetBreed       MODIFY (Name VARCHAR2(25) NOT NULL);
ALTER TABLE PetType        MODIFY (Name VARCHAR2(25) NOT NULL);
ALTER TABLE PetState       MODIFY (Name VARCHAR2(25) NOT NULL);
ALTER TABLE PetIllness     MODIFY (Name VARCHAR2(25) NOT NULL);
ALTER TABLE PetTreatment   MODIFY (Name VARCHAR2(25) NOT NULL);
ALTER TABLE PetTraining    MODIFY (Name VARCHAR2(25) NOT NULL);
ALTER TABLE SpaceRequired  MODIFY (Name VARCHAR2(25) NOT NULL);
ALTER TABLE PetSize        MODIFY (Name VARCHAR2(25) NOT NULL);
ALTER TABLE PetSeverity    MODIFY (Name VARCHAR2(25) NOT NULL);
ALTER TABLE Currency       MODIFY (Name VARCHAR2(25) NOT NULL);
ALTER TABLE Medicine       MODIFY (Name VARCHAR2(25) NOT NULL);

-- Unicidad en catalogos (no debe haber dos estados con el mismo nombre)
ALTER TABLE PetLevelEnergy ADD CONSTRAINT uq_PetLevelEnergy_Name UNIQUE (Name);
ALTER TABLE PetBreed       ADD CONSTRAINT uq_PetBreed_Name       UNIQUE (Name);
ALTER TABLE PetType        ADD CONSTRAINT uq_PetType_Name        UNIQUE (Name);
ALTER TABLE PetState       ADD CONSTRAINT uq_PetState_Name       UNIQUE (Name);
ALTER TABLE PetSeverity    ADD CONSTRAINT uq_PetSeverity_Name    UNIQUE (Name);
ALTER TABLE Currency       ADD CONSTRAINT uq_Currency_Name       UNIQUE (Name);

-- -------------------------------------------------------------
-- UBICACION GEOGRAFICA
-- -------------------------------------------------------------

ALTER TABLE Country  MODIFY (Name VARCHAR2(25) NOT NULL);
ALTER TABLE Province MODIFY (Name VARCHAR2(25) NOT NULL, IdCountry NUMBER(8) NOT NULL);
ALTER TABLE Canton   MODIFY (Name VARCHAR2(25) NOT NULL, IdProvince NUMBER(8) NOT NULL);
ALTER TABLE District MODIFY (Name VARCHAR2(25) NOT NULL, IdCanton   NUMBER(8) NOT NULL);

-- -------------------------------------------------------------
-- PERSON
-- -------------------------------------------------------------

ALTER TABLE Person MODIFY (
    FirstName  VARCHAR2(25) NOT NULL,
    LastName   VARCHAR2(25) NOT NULL,
    Password   VARCHAR2(60) NOT NULL,
    UserName   VARCHAR2(25) NOT NULL,
    IdDistrict NUMBER(8)    NOT NULL
);


ALTER TABLE PetBreed MODIFY (
    Name VARCHAR2(25) NOT NULL,
    IdType NUMBER(8) NOT NULL
);

-- -------------------------------------------------------------
-- EMAIL Y PHONE
-- -------------------------------------------------------------

ALTER TABLE Email MODIFY (
    Email    VARCHAR2(25) NOT NULL,
    IdPerson NUMBER(8)    NOT NULL
);

ALTER TABLE Phone MODIFY (
    Phone    NUMBER(8)  NOT NULL,
    IdPerson NUMBER(8)  NOT NULL
);

-- Formato basico de email (contiene @ y un punto despues)
ALTER TABLE Email ADD CONSTRAINT chk_Email_Format
    CHECK (Email LIKE '%@%.%');

-- Email unico por persona (no puede haber dos registros con mismo email)
ALTER TABLE Email ADD CONSTRAINT uq_Email UNIQUE (Email);

-- -------------------------------------------------------------
-- PET
-- -------------------------------------------------------------

ALTER TABLE Pet MODIFY (
    Name    VARCHAR2(25) NOT NULL,
    Color   VARCHAR2(50) NOT NULL,
    IdState NUMBER(8)    NOT NULL,
    IdType  NUMBER(8)    NOT NULL
);

-- Chip unico si existe
ALTER TABLE Pet ADD CONSTRAINT uq_Pet_Chip UNIQUE (Chip);

-- Edad no negativa
ALTER TABLE Pet ADD CONSTRAINT chk_Pet_Age
    CHECK (Age IS NULL OR Age >= 0);

-- -------------------------------------------------------------
-- PET PHOTO
-- -------------------------------------------------------------

ALTER TABLE PetPhoto MODIFY (
    Photo VARCHAR2(255) NOT NULL,
    IdPet NUMBER(8)     NOT NULL
);

-- -------------------------------------------------------------
-- VETERINARIAN
-- -------------------------------------------------------------

ALTER TABLE Veterinarian MODIFY (
    Name      VARCHAR2(50) NOT NULL,
    FirstName VARCHAR2(25) NOT NULL,
    LastName  VARCHAR2(25) NOT NULL
);

ALTER TABLE Veterinarian ADD CONSTRAINT chk_Veterinarian_Email
    CHECK (Email IS NULL OR Email LIKE '%@%.%');

-- -------------------------------------------------------------
-- FOSTER HOME
-- -------------------------------------------------------------

ALTER TABLE FosterHome MODIFY (
    NeedsDonation VARCHAR2(1) NOT NULL,
    IdPerson      NUMBER(8)   NOT NULL
);

ALTER TABLE FosterHome ADD CONSTRAINT chk_FosterHome_NeedsDonation
    CHECK (NeedsDonation IN ('Y', 'N'));

-- -------------------------------------------------------------
-- LOST REPORT
-- -------------------------------------------------------------

ALTER TABLE LostReport MODIFY (
    LostDate   DATE      NOT NULL,
    IdPet      NUMBER(8) NOT NULL,
    IdCurrency NUMBER(8) NOT NULL
);

-- Recompensa no negativa
ALTER TABLE LostReport ADD CONSTRAINT chk_LostReport_Reward
    CHECK (Reward IS NULL OR Reward >= 0);

-- -------------------------------------------------------------
-- FOUND REPORT
-- -------------------------------------------------------------

ALTER TABLE FoundReport MODIFY (
    FoundDate DATE      NOT NULL,
    IdPet     NUMBER(8) NOT NULL,
    IdPerson  NUMBER(8) NOT NULL
);

-- -------------------------------------------------------------
-- PET MATCH
-- -------------------------------------------------------------

ALTER TABLE PetMatch MODIFY (
    MatchDate            DATE      NOT NULL,
    IdLostReport         NUMBER(8) NOT NULL,
    IdFoundReport        NUMBER(8) NOT NULL,
    SimilarityPercentage NUMBER(3) NOT NULL
);

-- Porcentaje entre 0 y 100
ALTER TABLE PetMatch ADD CONSTRAINT chk_PetMatch_Percentage
    CHECK (SimilarityPercentage BETWEEN 0 AND 100);

-- -------------------------------------------------------------
-- ADOPTION
-- -------------------------------------------------------------
ALTER TABLE Adoption
MODIFY IdAdopter NULL;
ALTER TABLE Adoption MODIFY (
    AvailableDate DATE      NOT NULL,
    IdPet         NUMBER(8) NOT NULL,
    IdAdopter     NUMBER(8),
    IdOwner       NUMBER(8) NOT NULL
);

-- Estado debe ser valor conocido
ALTER TABLE Adoption ADD CONSTRAINT chk_Adoption_State
    CHECK (State IN ('In progress', 'Adopted', 'Cancelled'));

-- AvailableDate no puede ser posterior a AdoptionDate si ambas existen
ALTER TABLE Adoption ADD CONSTRAINT chk_Adoption_Dates
    CHECK (AvailableDate IS NULL OR AdoptionDate IS NULL OR AvailableDate <= AdoptionDate);


-- -------------------------------------------------------------
-- RESCUED
-- -------------------------------------------------------------

ALTER TABLE Rescued MODIFY (
    RescueDate   DATE      NOT NULL,
    IdPet        NUMBER(8) NOT NULL,
    IdRescuer    NUMBER(8) NOT NULL,
    IdPetSeverity NUMBER(8) NOT NULL
);

-- -------------------------------------------------------------
-- DONATION
-- -------------------------------------------------------------

ALTER TABLE Donation MODIFY (
    Amount       NUMBER(8) NOT NULL,
    DonationDate DATE      NOT NULL,
    IdPerson     NUMBER(8) NOT NULL,
    IdCurrency   NUMBER(8) NOT NULL,
    IdAssociation NUMBER(8) NOT NULL
);

-- Monto debe ser positivo
ALTER TABLE Donation ADD CONSTRAINT chk_Donation_Amount
    CHECK (Amount > 0);

-- -------------------------------------------------------------
-- ASSOCIATION
-- -------------------------------------------------------------

ALTER TABLE Association MODIFY (
    Name VARCHAR2(25) NOT NULL
);

ALTER TABLE Association ADD CONSTRAINT uq_Association_Name UNIQUE (Name);

ALTER TABLE Association ADD CONSTRAINT chk_Association_Email
    CHECK (Email IS NULL OR Email LIKE '%@%.%');

-- -------------------------------------------------------------
-- CALIFICATION
-- -------------------------------------------------------------

ALTER TABLE Calification MODIFY (
    Stars            NUMBER(8) NOT NULL,
    CalificationDate DATE      NOT NULL,
    IdPerson         NUMBER(8) NOT NULL
);

-- Estrellas del 1 al 5
ALTER TABLE Calification ADD CONSTRAINT chk_Calification_Stars
    CHECK (Stars BETWEEN 1 AND 5);

-- -------------------------------------------------------------
-- REPORT LIST (Lista Negra)
-- -------------------------------------------------------------

ALTER TABLE ReportList MODIFY (
    IdPerson   NUMBER(8) NOT NULL,
    IdReporter NUMBER(8) NOT NULL,
    ReportDate DATE      NOT NULL
);

-- No puede reportarse a si mismo
ALTER TABLE ReportList ADD CONSTRAINT chk_ReportList_SelfReport
    CHECK (IdPerson <> IdReporter);

-- -------------------------------------------------------------
-- BLOCK LIST
-- -------------------------------------------------------------

ALTER TABLE BlockList MODIFY (
    BlockDate DATE      NOT NULL,
    IdPerson  NUMBER(8) NOT NULL
);

-- -------------------------------------------------------------
-- PARAMETER
-- -------------------------------------------------------------

ALTER TABLE Parameter MODIFY (
    Name  VARCHAR2(25)  NOT NULL,
    Value NUMBER(8)     NOT NULL
);

ALTER TABLE Parameter ADD CONSTRAINT uq_Parameter_Name UNIQUE (Name);

-- -------------------------------------------------------------
-- BITACORA
-- -------------------------------------------------------------

ALTER TABLE Bitacora MODIFY (
    TableName  VARCHAR2(25) NOT NULL,
    ChangeDate DATE         NOT NULL,
    ChangedBy  NUMBER(8)    NOT NULL,
    FieldName  VARCHAR2(25) NOT NULL
);

-- -------------------------------------------------------------
-- RESCUER / ADOPTER / ADMIN (roles)
-- -------------------------------------------------------------

ALTER TABLE Rescuer MODIFY (IdPerson NUMBER(8) NOT NULL);
ALTER TABLE Adopter MODIFY (IdPerson NUMBER(8)  );
ALTER TABLE Admin   MODIFY (IdPerson NUMBER(8) NOT NULL);

-- Una persona no puede ser rescatista dos veces
ALTER TABLE Rescuer ADD CONSTRAINT uq_Rescuer_Person UNIQUE (IdPerson);
ALTER TABLE Adopter ADD CONSTRAINT uq_Adopter_Person UNIQUE (IdPerson);
ALTER TABLE Admin   ADD CONSTRAINT uq_Admin_Person   UNIQUE (IdPerson);
ALTER TABLE FosterHome ADD CONSTRAINT uq_FosterHome_Person UNIQUE (IdPerson);
