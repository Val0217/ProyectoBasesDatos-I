INSERT INTO Country (Name) VALUES ('Costa Rica');
INSERT INTO Country (Name) VALUES ('Panama');

INSERT INTO Province (Name, IdCountry) VALUES ('San Jose',    1);
INSERT INTO Province (Name, IdCountry) VALUES ('Heredia',     1);
INSERT INTO Province (Name, IdCountry) VALUES ('Alajuela',    1);
INSERT INTO Province (Name, IdCountry) VALUES ('Cartago',     1);
INSERT INTO Province (Name, IdCountry) VALUES ('Guanacaste',  1);

INSERT INTO Canton (Name, IdProvince) VALUES ('San Jose',      1);
INSERT INTO Canton (Name, IdProvince) VALUES ('Desamparados',  2);
INSERT INTO Canton (Name, IdProvince) VALUES ('Heredia',       3);
INSERT INTO Canton (Name, IdProvince) VALUES ('Alajuela',      4);
INSERT INTO Canton (Name, IdProvince) VALUES ('Cartago',       5);

INSERT INTO District (Name, IdCanton) VALUES ('Carmen',           1);
INSERT INTO District (Name, IdCanton) VALUES ('Hatillo',          2);
INSERT INTO District (Name, IdCanton) VALUES ('Desamparados',     3);
INSERT INTO District (Name, IdCanton) VALUES ('Heredia Centro',   4);
INSERT INTO District (Name, IdCanton) VALUES ('Alajuela Centro',  5);

INSERT INTO Province (Name, IdCountry) VALUES ('Panama',      2);
INSERT INTO Province (Name, IdCountry) VALUES ('Chiriqui',    2);
INSERT INTO Province (Name, IdCountry) VALUES ('Colon',       2);
INSERT INTO Province (Name, IdCountry) VALUES ('Veraguas',    2);
INSERT INTO Province (Name, IdCountry) VALUES ('Los Santos',  2);

INSERT INTO Canton (Name, IdProvince) VALUES ('Panama',         6);
INSERT INTO Canton (Name, IdProvince) VALUES ('San Miguelito',  7);
INSERT INTO Canton (Name, IdProvince) VALUES ('David',          8);
INSERT INTO Canton (Name, IdProvince) VALUES ('Santiago',       9);
INSERT INTO Canton (Name, IdProvince) VALUES ('Chitre',        10);

INSERT INTO District (Name, IdCanton) VALUES ('Bella Vista',       7);
INSERT INTO District (Name, IdCanton) VALUES ('Calidonia',         8);
INSERT INTO District (Name, IdCanton) VALUES ('Belisario Porras',  9);
INSERT INTO District (Name, IdCanton) VALUES ('David Centro',     10);
INSERT INTO District (Name, IdCanton) VALUES ('Santiago Centro',  10);

--> Mascotas
-- Tipos de mascota
INSERT INTO PetType (Name) VALUES ('Perro');
INSERT INTO PetType (Name) VALUES ('Gato');
INSERT INTO PetType (Name) VALUES ('Conejo');
INSERT INTO PetType (Name) VALUES ('Ave');
INSERT INTO PetType (Name) VALUES ('Otro');

-- Razas de perros
INSERT INTO PetBreed (Name, IdType) VALUES ('Labrador Retriever', 1);
INSERT INTO PetBreed (Name, IdType) VALUES ('Golden Retriever', 1);
INSERT INTO PetBreed (Name, IdType) VALUES ('Pastor Alemán', 1);
INSERT INTO PetBreed (Name, IdType) VALUES ('Bulldog', 1);
INSERT INTO PetBreed (Name, IdType) VALUES ('Poodle', 1);
INSERT INTO PetBreed (Name, IdType) VALUES ('Beagle', 1);
INSERT INTO PetBreed (Name, IdType) VALUES ('Rottweiler', 1);
INSERT INTO PetBreed (Name, IdType) VALUES ('Chihuahua', 1);
INSERT INTO PetBreed (Name, IdType) VALUES ('Husky Siberiano', 1);
INSERT INTO PetBreed (Name, IdType) VALUES ('Dalmata', 1);
INSERT INTO PetBreed (Name, IdType) VALUES ('Boxer', 1);
INSERT INTO PetBreed (Name, IdType) VALUES ('Doberman', 1);
INSERT INTO PetBreed (Name, IdType) VALUES ('Shih Tzu', 1);
INSERT INTO PetBreed (Name, IdType) VALUES ('Pug', 1);
INSERT INTO PetBreed (Name, IdType) VALUES ('Border Collie', 1);

-- Gatos
INSERT INTO PetBreed (Name, IdType) VALUES ('Persa', 2);
INSERT INTO PetBreed (Name, IdType) VALUES ('Siames', 2);
INSERT INTO PetBreed (Name, IdType) VALUES ('Maine Coon', 2);
INSERT INTO PetBreed (Name, IdType) VALUES ('Bengalí', 2);
INSERT INTO PetBreed (Name, IdType) VALUES ('Ragdoll', 2);
INSERT INTO PetBreed (Name, IdType) VALUES ('British Shorthair', 2);
INSERT INTO PetBreed (Name, IdType) VALUES ('Sphynx', 2);
INSERT INTO PetBreed (Name, IdType) VALUES ('Azul Ruso', 2);
INSERT INTO PetBreed (Name, IdType) VALUES ('Abisinio', 2);
INSERT INTO PetBreed (Name, IdType) VALUES ('Scottish Fold', 2);

-- Conejos
INSERT INTO PetBreed (Name, IdType) VALUES ('Mini Lop', 3);
INSERT INTO PetBreed (Name, IdType) VALUES ('Holandes', 3);
INSERT INTO PetBreed (Name, IdType) VALUES ('Lionhead', 3);
INSERT INTO PetBreed (Name, IdType) VALUES ('Rex', 3);
INSERT INTO PetBreed (Name, IdType) VALUES ('Angora', 3);

-- Aves
INSERT INTO PetBreed (Name, IdType) VALUES ('Periquito', 4);
INSERT INTO PetBreed (Name, IdType) VALUES ('Canario', 4);
INSERT INTO PetBreed (Name, IdType) VALUES ('Cacata', 4);
INSERT INTO PetBreed (Name, IdType) VALUES ('Loro Amazonico', 4);
INSERT INTO PetBreed (Name, IdType) VALUES ('Agapornis', 4);

-- Otros
INSERT INTO PetBreed (Name, IdType) VALUES ('Hamster Sirio', 5);
INSERT INTO PetBreed (Name, IdType) VALUES ('Cobaya', 5);
INSERT INTO PetBreed (Name, IdType) VALUES ('Erizo', 5);
INSERT INTO PetBreed (Name, IdType) VALUES ('Tortuga', 5);
INSERT INTO PetBreed (Name, IdType) VALUES ('Huran', 5);
INSERT INTO PetBreed (Name, IdType) VALUES ('Raza Unica', 5);

-- Estados de mascota
INSERT INTO PetState (Name) VALUES ('En Adopcion');
INSERT INTO PetState (Name) VALUES ('Adoptado');
INSERT INTO PetState (Name) VALUES ('Perdido');
INSERT INTO PetState (Name) VALUES ('Encontrado');
INSERT INTO PetState (Name) VALUES ('En Casa Cuna');
INSERT INTO PetState (Name) VALUES ('Fallecido');

-- Nivel de energia
INSERT INTO PetLevelEnergy (Name) VALUES ('Atletico');
INSERT INTO PetLevelEnergy (Name) VALUES ('Corredor');
INSERT INTO PetLevelEnergy (Name) VALUES ('Caminador');
INSERT INTO PetLevelEnergy (Name) VALUES ('Para ver TV');
INSERT INTO PetLevelEnergy (Name) VALUES ('No importante');

-- Tamaño
INSERT INTO PetSize (Name) VALUES ('Pequeno');
INSERT INTO PetSize (Name) VALUES ('Mediano');
INSERT INTO PetSize (Name) VALUES ('Grande');
INSERT INTO PetSize (Name) VALUES ('Extra Grande');

-- Espacio requerido
INSERT INTO SpaceRequired (Name) VALUES ('Apartamento');
INSERT INTO SpaceRequired (Name) VALUES ('Casa sin patio');
INSERT INTO SpaceRequired (Name) VALUES ('Casa con patio');
INSERT INTO SpaceRequired (Name) VALUES ('Finca');

-- Severidad
INSERT INTO PetSeverity (Name) VALUES ('Critico');
INSERT INTO PetSeverity (Name) VALUES ('Mal estado');
INSERT INTO PetSeverity (Name) VALUES ('Buen estado');

-- Facilidad de entrenamiento
INSERT INTO PetTraining (Name) VALUES ('Muy facil');
INSERT INTO PetTraining (Name) VALUES ('Facil');
INSERT INTO PetTraining (Name) VALUES ('Moderado');
INSERT INTO PetTraining (Name) VALUES ('Dificil');
INSERT INTO PetTraining (Name) VALUES ('Muy dificil');

-- Monedas
INSERT INTO Currency (Name) VALUES ('Colones');
INSERT INTO Currency (Name) VALUES ('Dolars');

-- -------------------------------------------------------------
-- 4. VETERINARIOS
-- -------------------------------------------------------------

INSERT INTO Veterinarian
    (FirstName, LastName, Name, Email, Phone, IdDistrict)
VALUES
    ('Luis', 'Mora', 'Clinica Mascotas Felices', 'luis@vetfelices.com', 22345678, 1);

INSERT INTO Veterinarian
    (FirstName, LastName, Name, Email, Phone, IdDistrict)
VALUES
    ('Ana', 'Jimenez', 'VetCenter', 'ana@vetcenter.com', 22876543, 2);

-- -------------------------------------------------------------
-- 5. PERSONAS (usuarios del sistema)
-- -------------------------------------------------------------

INSERT INTO Person
    (FirstName, LastName, Username, Password, IdDistrict)
VALUES
    ('Carlos', 'Gonzalez', 'cgonzalez', 'pass1234', 1);

INSERT INTO Person
    (FirstName, LastName, Username, Password, IdDistrict)
VALUES
    ('Maria', 'Rodriguez', 'mrodriguez', 'pass5678', 2);

INSERT INTO Person
    (FirstName, LastName, Username, Password, IdDistrict)
VALUES
    ('Jose', 'Vargas', 'jvargas', 'pass9012', 3);

INSERT INTO Person
    (FirstName, LastName, Username, Password, IdDistrict)
VALUES
    ('Luisa', 'Campos', 'lcampos', 'pass3456', 4);

INSERT INTO Person
    (FirstName, LastName, Username, Password, IdDistrict)
VALUES
    ('Pedro', 'Salas', 'psalas', 'pass7890', 5);

INSERT INTO Person
    (FirstName, LastName, Username, Password, IdDistrict)
VALUES
    ('Sofia', 'Mena', 'smena', 'pass1111', 1);

-- Emails

INSERT INTO Email (Email, IdPerson)
VALUES ('carlos@gmail.com', 1);

INSERT INTO Email (Email, IdPerson)
VALUES ('maria@gmail.com', 2);

INSERT INTO Email (Email, IdPerson)
VALUES ('jose@hotmail.com', 3);

INSERT INTO Email (Email, IdPerson)
VALUES ('luisa@yahoo.com', 4);

INSERT INTO Email (Email, IdPerson)
VALUES ('pedro@gmail.com', 5);

INSERT INTO Email (Email, IdPerson)
VALUES ('sofia@gmail.com', 6);

-- Teléfonos

INSERT INTO Phone (Phone, IdPerson)
VALUES (88001111, 1);

INSERT INTO Phone (Phone, IdPerson)
VALUES (88002222, 2);

INSERT INTO Phone (Phone, IdPerson)
VALUES (88003333, 3);

INSERT INTO Phone (Phone, IdPerson)
VALUES (88004444, 4);

INSERT INTO Phone (Phone, IdPerson)
VALUES (88005555, 5);

-- -------------------------------------------------------------
-- 6. ROLES
-- -------------------------------------------------------------

INSERT INTO Admin (IdPerson)
VALUES (1);

INSERT INTO Rescuer (IdPerson)
VALUES (2);

INSERT INTO Rescuer (IdPerson)
VALUES (3);

INSERT INTO Adopter (IdPerson)
VALUES (4);

INSERT INTO Adopter (IdPerson)
VALUES (5);

-- -------------------------------------------------------------
-- 7. CASAS CUNA
-- -------------------------------------------------------------

INSERT INTO FosterHome (NeedsDonation, IdPerson)
VALUES ('Y', 3);

INSERT INTO FosterHome (NeedsDonation, IdPerson)
VALUES ('N', 6);

-- Tamaños aceptados por casa cuna

INSERT INTO PetSizeXFosterHome (IdPetSize, IdFosterHome)
VALUES (1, 1);

INSERT INTO PetSizeXFosterHome (IdPetSize, IdFosterHome)
VALUES (2, 1);

INSERT INTO PetSizeXFosterHome (IdPetSize, IdFosterHome)
VALUES (1, 2);

INSERT INTO PetSizeXFosterHome (IdPetSize, IdFosterHome)
VALUES (2, 2);

INSERT INTO PetSizeXFosterHome (IdPetSize, IdFosterHome)
VALUES (3, 2);

-- Nivel de energía aceptado por casa cuna

INSERT INTO PetLevelEnergyXFosterHome (IdPetLevelEnergy, IdFosterHome)
VALUES (3, 2);

INSERT INTO PetLevelEnergyXFosterHome (IdPetLevelEnergy, IdFosterHome)
VALUES (2, 2);

INSERT INTO PetLevelEnergyXFosterHome (IdPetLevelEnergy, IdFosterHome)
VALUES (1, 1);

-- Espacio requerido por casa cuna

INSERT INTO SpaceRequiredXFosterHome (IdSpaceRequired, IdFosterHome)
VALUES (2, 1);

INSERT INTO SpaceRequiredXFosterHome (IdSpaceRequired, IdFosterHome)
VALUES (3, 2);

-- -------------------------------------------------------------
-- 8. MASCOTAS
-- -------------------------------------------------------------

INSERT INTO Pet
(Color, Age, Description, Name, Chip, IdEnergy, IdState, IdType,
 IdBreed, IdDistrict, IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian)
VALUES
('Negro', 2, 'Perro amigable y activo', 'Max', 'CH001', 1, 1, 1, 1, 1, 1, 1, 2, 1, 1),

('Blanco', 1, 'Gato tranquilo y cariñoso', 'Luna', 'CH002', 2, 1, 2, 16, 1, 1, 2, 1, 1, 1),

('Marrón', 3, 'Conejo pequeño y juguetón', 'Coco', 'CH003', 1, 1, 3, 26, 1, 1, 1, 1, 1, 1),

('Gris', 4, 'Ave muy sociable', 'Kiwi', 'CH004', 2, 1, 4, 31, 1, 1, 2, 1, 1, 1),

('Dorado', 5, 'Perro protector y leal', 'Rocky', 'CH005', 3, 1, 1, 3, 1, 2, 2, 3, 1, 1),

('Blanco y negro', 2, 'Gato curioso', 'Milo', 'CH006', 1, 1, 2, 17, 1, 1, 1, 1, 1, 1),

('Beige', 1, 'Conejo muy tranquilo', 'Nube', 'CH007', 1, 1, 3, 27, 1, 1, 1, 1, 1, 1),

('Verde', 2, 'Ave parlanchina', 'Paco', 'CH008', 2, 1, 4, 34, 1, 1, 2, 1, 1, 1),

('Negro y café', 6, 'Perro muy energético', 'Thor', 'CH009', 3, 1, 1, 9, 1, 3, 2, 3, 1, 1),

('Naranja', 3, 'Gato dormilón', 'Simba', 'CH010', 1, 1, 2, 18, 1, 1, 1, 2, 1, 1),

('Blanco', 2, 'Conejo amigable', 'Pelusa', 'CH011', 1, 1, 3, 28, 1, 1, 1, 1, 1, 1),

('Azul', 1, 'Ave pequeña y rápida', 'Sky', 'CH012', 2, 1, 4, 32, 1, 1, 2, 1, 1, 1),

('Café', 7, 'Perro obediente', 'Bruno', 'CH013', 2, 1, 1, 7, 1, 2, 2, 3, 1, 1),

('Gris oscuro', 4, 'Gato independiente', 'Shadow', 'CH014', 2, 1, 2, 21, 1, 1, 1, 2, 1, 1),

('Marrón claro', 1, 'Conejo curioso', 'Bunny', 'CH015', 1, 1, 3, 29, 1, 1, 1, 1, 1, 1),

('Amarillo', 2, 'Ave muy activa', 'Sunny', 'CH016', 3, 1, 4, 35, 1, 1, 2, 1, 1, 1),

('Negro', 5, 'Perro tranquilo', 'Zeus', 'CH017', 2, 1, 1, 11, 1, 2, 2, 3, 1, 1),

('Blanco', 2, 'Gato amigable', 'Michi', 'CH018', 1, 1, 2, 25, 1, 1, 1, 1, 1, 1),

('Café oscuro', 3, 'Perro juguetón', 'Toby', 'CH019', 3, 1, 1, 6, 1, 2, 2, 2, 1, 1),

('Gris y blanco', 1, 'Gato pequeño y curioso', 'Nina', 'CH020', 1, 1, 2, 20, 1, 1, 1, 1, 1, 1);

-- Relaciones de mascota con enfermedades, medicamentos y tratamientos

INSERT INTO PetXPetIllness (IdPet, IdPetIllness) VALUES (1, 4);
INSERT INTO PetXPetIllness (IdPet, IdPetIllness) VALUES (3, 2);

INSERT INTO PetXMedicine (IdPet, IdMedicine) VALUES (1, 2);
INSERT INTO PetXMedicine (IdPet, IdMedicine) VALUES (3, 1);

INSERT INTO PetXPetTreatment (IdPet, IdPetTreatment) VALUES (1, 3);
INSERT INTO PetXPetTreatment (IdPet, IdPetTreatment) VALUES (3, 2);
INSERT INTO PetXPetTreatment (IdPet, IdPetTreatment) VALUES (4, 1);

-- -------------------------------------------------------------
-- 9. RESCATES
-- -------------------------------------------------------------

INSERT INTO Rescued (
    RescueDate,
    Place,
    Description,
    IdPet,
    IdDistrict,
    IdRescuer,
    IdPetSeverity
)
VALUES (
    '2024-01-15',
    'Parque La Sabana',
    'Encontrado desnutrido',
    3,
    1,
    1,
    1
);

INSERT INTO Rescued (
    RescueDate,
    Place,
    Description,
    IdPet,
    IdDistrict,
    IdRescuer,
    IdPetSeverity
)
VALUES (
    '2024-03-10',
    'Barrio Amon',
    'Rescatado de maltrato',
    4,
    1,
    2,
    2
);

-- -------------------------------------------------------------
-- 10. REPORTES PERDIDOS
-- -------------------------------------------------------------

INSERT INTO LostReport
(LostDate, Place, Description, Reward, State, IdPet, IdDistrict, IdCurrency)
VALUES
('2025-04-10', 'Parque Central', 'Max desapareció cerca del parque', 50000, 'Lost', 1, 1, 1),

('2025-04-12', 'Barrio Escalante', 'Luna se perdió con collar azul', 100, 'Lost', 2, 1, 2),

('2025-04-15', 'Sabana Norte', 'Coco fue visto por última vez en la zona verde', 25000, 'Lost', 3, 1, 1),

('2025-04-18', 'San Pedro', 'Kiwi escapó de su jaula', 75, 'Lost', 4, 1, 2),

('2025-04-20', 'Curridabat', 'Rocky desapareció durante un paseo', 75000, 'Lost', 5, 1, 1);

-- -------------------------------------------------------------
-- 10. REPORTES ENCONTRADOS
-- -------------------------------------------------------------

INSERT INTO FoundReport
(FoundDate, Place, Description, IdPet, IdDistrict, IdPerson)
VALUES
('2025-04-11', 'Parque Central', 'Max encontrado cerca de la fuente', 1, 1, 1),

('2025-04-13', 'Barrio Escalante', 'Luna encontrada en una cafetería', 2, 1, 2),

('2025-04-16', 'Sabana Norte', 'Coco encontrado por vecinos', 3, 1, 3),

('2025-04-19', 'San Pedro', 'Kiwi recuperado sano y salvo', 4, 1, 4),

('2025-04-21', 'Curridabat', 'Rocky localizado por un rescatista', 5, 1, 5);

-- -------------------------------------------------------------
-- 11. MATCH
-- -------------------------------------------------------------

INSERT INTO PetMatch (
    SimilarityPercentage,
    MatchDate,
    IdLostReport,
    IdFoundReport
)
VALUES (
    85,
    '2024-06-04',
    1,
    1
);

INSERT INTO PetMatch (
    SimilarityPercentage,
    MatchDate,
    IdLostReport,
    IdFoundReport
)
VALUES (
    72,
    '2024-07-21',
    2,
    2
);

INSERT INTO Parameter (Name, Value, Description)
VALUES (
    'MinMatchPercentage',
    '60',
    'Minimum similarity percentage for pet matches'
);

INSERT INTO Parameter (Name, Value, Description)
VALUES (
    'MatchIntervalHours',
    '2',
    'Hours between automatic pet match executions'
);

-- -------------------------------------------------------------
-- 15. ASOCIACIONES
-- -------------------------------------------------------------

INSERT INTO Association (
    Name,
    PhoneNumber,
    BankAccount,
    Email
)
VALUES (
    'Refugio Animal CR',
    22110000,
    'CR21015200009123456789',
    'info@refugioanimal.cr'
);

INSERT INTO Association (
    Name,
    PhoneNumber,
    BankAccount,
    Email
)
VALUES (
    'Amigos Peludos',
    22220001,
    'CR21015200009987654321',
    'amigos@peludos.cr'
);

INSERT INTO Association (
    Name,
    PhoneNumber,
    BankAccount,
    Email
)
VALUES (
    'Patitas Felices',
    22330002,
    'CR21015200009111111111',
    'patitas@felices.cr'
);

INSERT INTO Adoption
(AdoptionDate, AvailableDate, Description, State, IdPet, IdAdopter, IdOwner)
VALUES
('2024-02-15', '2024-01-20', 'Adopcion aprobada de perro mestizo', 'Approved', 3, 5, 1);

INSERT INTO Adoption
(AdoptionDate, AvailableDate, Description, State, IdPet, IdAdopter, IdOwner)
VALUES
('2024-05-10', '2024-04-18', 'Adopcion aprobada de gato adulto', 'Approved', 7, 6, 2);

INSERT INTO Adoption
(AdoptionDate, AvailableDate, Description, State, IdPet, IdAdopter, IdOwner)
VALUES
('2024-08-22', '2024-07-30', 'Adopcion aprobada por familia Rodríguez', 'Approved', 9, 8, 3);

INSERT INTO Adoption
(AdoptionDate, AvailableDate, Description, State, IdPet, IdAdopter, IdOwner)
VALUES
('2024-11-05', '2024-10-12', 'Adopcion aprobada de mascota rescatada', 'Approved', 12, 4, 2);

INSERT INTO Adoption
(AdoptionDate, AvailableDate, Description, State, IdPet, IdAdopter, IdOwner)
VALUES
('2025-01-18', '2024-12-28', 'Adopcion aprobada de cachorro mestizo', 'Approved', 14, 9, 5);

INSERT INTO Adoption
(AdoptionDate, AvailableDate, Description, State, IdPet, IdAdopter, IdOwner)
VALUES
('2025-03-27', '2025-03-01', 'Adopcion aprobada de conejo domestico', 'Approved', 18, 7, 4);

INSERT INTO Adoption
(AdoptionDate, AvailableDate, Description, State, IdPet, IdAdopter, IdOwner)
VALUES
('2025-06-14', '2025-05-25', 'Adopcion aprobada por cumplimiento de requisitos', 'Approved', 5, 10, 1);

INSERT INTO Adoption
(AdoptionDate, AvailableDate, Description, State, IdPet, IdAdopter, IdOwner)
VALUES
('2025-09-09', '2025-08-11', 'Adopcion aprobada de gato joven', 'Approved', 11, 2, 1);

INSERT INTO Adoption
(AdoptionDate, AvailableDate, Description, State, IdPet, IdAdopter, IdOwner)
VALUES
('2026-01-12', '2025-12-15', 'Adopcion aprobada de perro de tamaño mediano', 'Approved', 15, 3, 2);

INSERT INTO Adoption
(AdoptionDate, AvailableDate, Description, State, IdPet, IdAdopter, IdOwner)
VALUES
('2026-04-30', '2026-04-02', 'Adopcion aprobada de mascota encontrada', 'Approved', 21, 1, 2);