CREATE TABLE AppUsers (
    Id INT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Notes CLOB,
    idEmail INT,
    idFosterHome INT,
    idReportList INT,
    idBlockList INT
);

CREATE TABLE Email (
    Id INT PRIMARY KEY,
    Email VARCHAR(255) NOT NULL,
    idUser INT,
    CONSTRAINT fk_email_user
        FOREIGN KEY (idUser) REFERENCES AppUsers(Id)
);

CREATE TABLE Phone (
    Id INT PRIMARY KEY,
    Phone VARCHAR(50) NOT NULL,
    idUser INT,
    CONSTRAINT fk_phone_user
        FOREIGN KEY (idUser) REFERENCES AppUsers(Id)
);

CREATE TABLE BlockList (
    Id INT PRIMARY KEY,
    BlockDate DATE NOT NULL,
    idUser INT,
    CONSTRAINT fk_blocklist_user
        FOREIGN KEY (idUser) REFERENCES AppUsers(Id)
);

CREATE TABLE ReportList (
    Id INT PRIMARY KEY,
    Description CLOB,
    idUser INT,
    CONSTRAINT fk_reportlist_user
        FOREIGN KEY (idUser) REFERENCES AppUsers(Id)
);

CREATE TABLE Calification (
    Id INT PRIMARY KEY,
    Stars INT NOT NULL,
    Note CLOB,
    CalificationDate DATE NOT NULL,
    idUser INT,
    CONSTRAINT fk_calification_user
        FOREIGN KEY (idUser) REFERENCES AppUsers(Id)
);

CREATE TABLE Admin (
    Id INT PRIMARY KEY,
    idUser INT,
    CONSTRAINT fk_admin_user
        FOREIGN KEY (idUser) REFERENCES AppUsers(Id)
);

CREATE TABLE Adopter (
    Id INT PRIMARY KEY,
    idUser INT,
    CONSTRAINT fk_adopter_user
        FOREIGN KEY (idUser) REFERENCES AppUsers(Id)
);

CREATE TABLE Rescuer (
    Id INT PRIMARY KEY,
    idUser INT,
    CONSTRAINT fk_rescuer_user
        FOREIGN KEY (idUser) REFERENCES AppUsers(Id)
);

CREATE TABLE FosterHome (
    Id INT PRIMARY KEY,
    NeedsDonation CHAR(1) NOT NULL,
    CONSTRAINT chk_fosterhome_needsdonation
        CHECK (NeedsDonation IN ('Y', 'N')),
    idUser INT,
    CONSTRAINT fk_fosterhome_user
        FOREIGN KEY (idUser) REFERENCES AppUsers(Id)
);

ALTER TABLE AppUsers
ADD CONSTRAINT fk_users_email
    FOREIGN KEY (idEmail) REFERENCES Email(Id);

ALTER TABLE AppUsers
ADD CONSTRAINT fk_users_fosterhome
    FOREIGN KEY (idFosterHome) REFERENCES FosterHome(Id);

ALTER TABLE AppUsers
ADD CONSTRAINT fk_users_reportlist
    FOREIGN KEY (idReportList) REFERENCES ReportList(Id);

ALTER TABLE AppUsers
ADD CONSTRAINT fk_users_blocklist
    FOREIGN KEY (idBlockList) REFERENCES BlockList(Id);
    
