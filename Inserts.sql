-- =============================================================
-- ARCHIVO: Inserts.sql
-- DESCRIPCION: Datos de prueba para el sistema Bienestar Animal
-- NOTA: Ejecutar en el orden indicado por las dependencias FK
-- Se usan IDs fijos para que sean reutilizables y predecibles
-- =============================================================

-- -------------------------------------------------------------
-- 1. PAIS / PROVINCIA / CANTON / DISTRITO
-- -------------------------------------------------------------

INSERT INTO Country (Id, Name) VALUES (1, 'Costa Rica');
INSERT INTO Country (Id, Name) VALUES (2, 'Panama');

INSERT INTO Province (Id, Name, IdCountry) VALUES (1, 'San Jose',    1);
INSERT INTO Province (Id, Name, IdCountry) VALUES (2, 'Heredia',     1);
INSERT INTO Province (Id, Name, IdCountry) VALUES (3, 'Alajuela',    1);
INSERT INTO Province (Id, Name, IdCountry) VALUES (4, 'Cartago',     1);
INSERT INTO Province (Id, Name, IdCountry) VALUES (5, 'Guanacaste',  1);

INSERT INTO Canton (Id, Name, IdProvince) VALUES (1, 'San Jose',     1);
INSERT INTO Canton (Id, Name, IdProvince) VALUES (2, 'Desamparados', 1);
INSERT INTO Canton (Id, Name, IdProvince) VALUES (3, 'Heredia',      2);
INSERT INTO Canton (Id, Name, IdProvince) VALUES (4, 'Alajuela',     3);
INSERT INTO Canton (Id, Name, IdProvince) VALUES (5, 'Cartago',      4);

INSERT INTO District (Id, Name, IdCanton) VALUES (1, 'Carmen',        1);
INSERT INTO District (Id, Name, IdCanton) VALUES (2, 'Hatillo',       1);
INSERT INTO District (Id, Name, IdCanton) VALUES (3, 'Desamparados',  2);
INSERT INTO District (Id, Name, IdCanton) VALUES (4, 'Heredia Centro',3);
INSERT INTO District (Id, Name, IdCanton) VALUES (5, 'Alajuela Centro',4);

-- -------------------------------------------------------------
-- 2. CATALOGOS DE MASCOTAS
-- -------------------------------------------------------------

-- Tipos de mascota
INSERT INTO PetType (Id, Name) VALUES (1, 'Perro');
INSERT INTO PetType (Id, Name) VALUES (2, 'Gato');
INSERT INTO PetType (Id, Name) VALUES (3, 'Conejo');
INSERT INTO PetType (Id, Name) VALUES (4, 'Ave');
INSERT INTO PetType (Id, Name) VALUES (5, 'Otro');

-- Razas
INSERT INTO PetBreed (Id, Name) VALUES (1, 'Labrador');
INSERT INTO PetBreed (Id, Name) VALUES (2, 'Poodle');
INSERT INTO PetBreed (Id, Name) VALUES (3, 'Chihuahua');
INSERT INTO PetBreed (Id, Name) VALUES (4, 'Siames');
INSERT INTO PetBreed (Id, Name) VALUES (5, 'Persa');
INSERT INTO PetBreed (Id, Name) VALUES (6, 'Raza Unica');   -- obligatorio segun requerimiento

-- Estados de mascota
INSERT INTO PetState (Id, Name) VALUES (1, 'Perdido');
INSERT INTO PetState (Id, Name) VALUES (2, 'Encontrado');
INSERT INTO PetState (Id, Name) VALUES (3, 'En Adopcion');
INSERT INTO PetState (Id, Name) VALUES (4, 'Adoptado');
INSERT INTO PetState (Id, Name) VALUES (5, 'En Casa Cuna');
INSERT INTO PetState (Id, Name) VALUES (6, 'Fallecido');

-- Nivel de energia
INSERT INTO PetLevelEnergy (Id, Name) VALUES (1, 'Atletico');
INSERT INTO PetLevelEnergy (Id, Name) VALUES (2, 'Corredor');
INSERT INTO PetLevelEnergy (Id, Name) VALUES (3, 'Caminador');
INSERT INTO PetLevelEnergy (Id, Name) VALUES (4, 'Para ver TV');
INSERT INTO PetLevelEnergy (Id, Name) VALUES (5, 'No importante');

-- Tamaño
INSERT INTO PetSize (Id, Name) VALUES (1, 'Pequeno');
INSERT INTO PetSize (Id, Name) VALUES (2, 'Mediano');
INSERT INTO PetSize (Id, Name) VALUES (3, 'Grande');
INSERT INTO PetSize (Id, Name) VALUES (4, 'Extra Grande');

-- Espacio requerido
INSERT INTO SpaceRequired (Id, Name) VALUES (1, 'Apartamento');
INSERT INTO SpaceRequired (Id, Name) VALUES (2, 'Casa sin patio');
INSERT INTO SpaceRequired (Id, Name) VALUES (3, 'Casa con patio');
INSERT INTO SpaceRequired (Id, Name) VALUES (4, 'Finca');

-- Severidad
INSERT INTO PetSeverity (Id, Name) VALUES (1, 'Critico');
INSERT INTO PetSeverity (Id, Name) VALUES (2, 'Mal estado');
INSERT INTO PetSeverity (Id, Name) VALUES (3, 'Buen estado');

-- Facilidad de entrenamiento
INSERT INTO PetTraining (Id, Name) VALUES (1, 'Muy facil');
INSERT INTO PetTraining (Id, Name) VALUES (2, 'Facil');
INSERT INTO PetTraining (Id, Name) VALUES (3, 'Moderado');
INSERT INTO PetTraining (Id, Name) VALUES (4, 'Dificil');
INSERT INTO PetTraining (Id, Name) VALUES (5, 'Muy dificil');

-- Monedas
INSERT INTO Currency (Id, Name) VALUES (1, 'Colones');
INSERT INTO Currency (Id, Name) VALUES (2, 'Dolares');

-- -------------------------------------------------------------
-- 3. ENFERMEDADES, MEDICAMENTOS, TRATAMIENTOS
-- -------------------------------------------------------------

INSERT INTO PetIllness (Id, Name, Description) VALUES (1, 'Parvovirus',   'Enfermedad viral en perros');
INSERT INTO PetIllness (Id, Name, Description) VALUES (2, 'Moquillo',     'Enfermedad respiratoria canina');
INSERT INTO PetIllness (Id, Name, Description) VALUES (3, 'Toxoplasmosis','Parasito comun en gatos');
INSERT INTO PetIllness (Id, Name, Description) VALUES (4, 'Sarna',        'Parasito externo');
INSERT INTO PetIllness (Id, Name, Description) VALUES (5, 'Leucemia Felina','Virus en gatos');

INSERT INTO Medicine (Id, Name, Dose) VALUES (1, 'Amoxicilina',  '250mg cada 8h');
INSERT INTO Medicine (Id, Name, Dose) VALUES (2, 'Ivermectina',  '0.2mg/kg');
INSERT INTO Medicine (Id, Name, Dose) VALUES (3, 'Metronidazol', '15mg/kg');
INSERT INTO Medicine (Id, Name, Dose) VALUES (4, 'Prednisona',   '1mg/kg');
INSERT INTO Medicine (Id, Name, Dose) VALUES (5, 'Vitamina B12', '1ml semanal');

INSERT INTO PetTreatment (Id, Name, Description) VALUES (1, 'Desparasitacion', 'Control de parasitos internos');
INSERT INTO PetTreatment (Id, Name, Description) VALUES (2, 'Vacunacion',      'Esquema de vacunas basico');
INSERT INTO PetTreatment (Id, Name, Description) VALUES (3, 'Bano medicado',   'Tratamiento de piel');
INSERT INTO PetTreatment (Id, Name, Description) VALUES (4, 'Cirugia',         'Procedimiento quirurgico');
INSERT INTO PetTreatment (Id, Name, Description) VALUES (5, 'Esterilizacion',  'Castración o esterilizacion');

-- -------------------------------------------------------------
-- 4. VETERINARIOS
-- -------------------------------------------------------------

INSERT INTO Veterinarian (Id, FirstName, LastName, Name, Email, Phone, IdDristrict)
VALUES (1, 'Luis', 'Mora', 'Clinica Mascotas Felices', 'luis@vetfelices.com', 22345678, 1);

INSERT INTO Veterinarian (Id, FirstName, LastName, Name, Email, Phone, IdDristrict)
VALUES (2, 'Ana', 'Jimenez', 'VetCenter', 'ana@vetcenter.com', 22876543, 2);

-- -------------------------------------------------------------
-- 5. PERSONAS (usuarios del sistema)
-- -------------------------------------------------------------

INSERT INTO Person (Id, FirstName, LastName, Password, IdDistrict)
VALUES (1, 'Carlos',  'Gonzalez', 'pass1234', 1);

INSERT INTO Person (Id, FirstName, LastName, Password, IdDistrict)
VALUES (2, 'Maria',   'Rodriguez','pass5678', 2);

INSERT INTO Person (Id, FirstName, LastName, Password, IdDistrict)
VALUES (3, 'Jose',    'Vargas',   'pass9012', 3);

INSERT INTO Person (Id, FirstName, LastName, Password, IdDistrict)
VALUES (4, 'Luisa',   'Campos',   'pass3456', 4);

INSERT INTO Person (Id, FirstName, LastName, Password, IdDistrict)
VALUES (5, 'Pedro',   'Salas',    'pass7890', 5);

INSERT INTO Person (Id, FirstName, LastName, Password, IdDistrict)
VALUES (6, 'Sofia',   'Mena',     'pass1111', 1);

-- Emails
INSERT INTO Email (Id, Email, IdPerson) VALUES (1, 'carlos@gmail.com',  1);
INSERT INTO Email (Id, Email, IdPerson) VALUES (2, 'maria@gmail.com',   2);
INSERT INTO Email (Id, Email, IdPerson) VALUES (3, 'jose@hotmail.com',  3);
INSERT INTO Email (Id, Email, IdPerson) VALUES (4, 'luisa@yahoo.com',   4);
INSERT INTO Email (Id, Email, IdPerson) VALUES (5, 'pedro@gmail.com',   5);
INSERT INTO Email (Id, Email, IdPerson) VALUES (6, 'sofia@gmail.com',   6);

-- Telefonos
INSERT INTO Phone (Id, Phone, IdPerson) VALUES (1, 88001111, 1);
INSERT INTO Phone (Id, Phone, IdPerson) VALUES (2, 88002222, 2);
INSERT INTO Phone (Id, Phone, IdPerson) VALUES (3, 88003333, 3);
INSERT INTO Phone (Id, Phone, IdPerson) VALUES (4, 88004444, 4);
INSERT INTO Phone (Id, Phone, IdPerson) VALUES (5, 88005555, 5);

-- -------------------------------------------------------------
-- 6. ROLES
-- -------------------------------------------------------------

INSERT INTO Admin   (Id, IdPerson) VALUES (1, 1);
INSERT INTO Rescuer (Id, IdPerson) VALUES (1, 2);
INSERT INTO Rescuer (Id, IdPerson) VALUES (2, 3);
INSERT INTO Adopter (Id, IdPerson) VALUES (1, 4);
INSERT INTO Adopter (Id, IdPerson) VALUES (2, 5);

-- -------------------------------------------------------------
-- 7. CASAS CUNA
-- -------------------------------------------------------------

INSERT INTO FosterHome (Id, NeedsDonation, IdPerson) VALUES (1, 'Y', 3);
INSERT INTO FosterHome (Id, NeedsDonation, IdPerson) VALUES (2, 'N', 6);

-- Tamaños aceptados por casa cuna
INSERT INTO PetSizeXFosterHome (IdPetSize, IdFosterHome) VALUES (1, 1); -- pequeno
INSERT INTO PetSizeXFosterHome (IdPetSize, IdFosterHome) VALUES (2, 1); -- mediano
INSERT INTO PetSizeXFosterHome (IdPetSize, IdFosterHome) VALUES (1, 2);
INSERT INTO PetSizeXFosterHome (IdPetSize, IdFosterHome) VALUES (2, 2);
INSERT INTO PetSizeXFosterHome (IdPetSize, IdFosterHome) VALUES (3, 2);

-- Nivel de energia aceptado por casa cuna
INSERT INTO PetLevelEnergyXFosterHome (IdEnergy, IdFosterHome) VALUES (3, 1); -- caminador
INSERT INTO PetLevelEnergyXFosterHome (IdEnergy, IdFosterHome) VALUES (4, 1); -- para ver TV
INSERT INTO PetLevelEnergyXFosterHome (IdEnergy, IdFosterHome) VALUES (1, 2); -- atletico

-- Espacio requerido por casa cuna
INSERT INTO SpaceRequiredXFosterHome (IdSpaceRequired, IdFosterHome) VALUES (2, 1);
INSERT INTO SpaceRequiredXFosterHome (IdSpaceRequired, IdFosterHome) VALUES (3, 2);

-- -------------------------------------------------------------
-- 8. MASCOTAS
-- -------------------------------------------------------------

INSERT INTO Pet (Id, Name, Color, Age, Description, Chip,
                 IdEnergy, IdState, IdType, IdBreed,
                 IdDistrict, IdSpace, IdPetTraining, IdSize,
                 IdOwner, IdVeterinarian)
VALUES (1, 'Luna', 'Blanco', 3, 'Perra amigable, vacunada',
        'CHIP001', 2, 1, 1, 1, 1, 3, 2, 2, 2, 1);

INSERT INTO Pet (Id, Name, Color, Age, Description, Chip,
                 IdEnergy, IdState, IdType, IdBreed,
                 IdDistrict, IdSpace, IdPetTraining, IdSize,
                 IdOwner, IdVeterinarian)
VALUES (2, 'Michi', 'Negro', 2, 'Gato tranquilo, castrado',
        'CHIP002', 4, 3, 2, 4, 2, 1, 1, 1, 3, 2);

INSERT INTO Pet (Id, Name, Color, Age, Description, Chip,
                 IdEnergy, IdState, IdType, IdBreed,
                 IdDistrict, IdSpace, IdPetTraining, IdSize,
                 IdOwner, IdVeterinarian)
VALUES (3, 'Rocky', 'Cafe', 5, 'Perro activo, necesita espacio',
        NULL, 1, 2, 1, 6, 3, 4, 3, 3, NULL, 1);

INSERT INTO Pet (Id, Name, Color, Age, Description, Chip,
                 IdEnergy, IdState, IdType, IdBreed,
                 IdDistrict, IdSpace, IdPetTraining, IdSize,
                 IdOwner, IdVeterinarian)
VALUES (4, 'Nala', 'Dorado', 1, 'Cachorra rescatada',
        NULL, 1, 3, 1, 2, 1, 3, 4, 1, NULL, 1);

INSERT INTO Pet (Id, Name, Color, Age, Description, Chip,
                 IdEnergy, IdState, IdType, IdBreed,
                 IdDistrict, IdSpace, IdPetTraining, IdSize,
                 IdOwner, IdVeterinarian)
VALUES (5, 'Simba', 'Naranja', 4, 'Gato persa, requiere cuidados',
        'CHIP005', 3, 1, 2, 5, 4, 2, 2, 2, 4, 2);

-- Relaciones de mascota con enfermedades, medicamentos, tratamientos
INSERT INTO PetXPetIllness (IdPet, IdPetIllness) VALUES (1, 4); -- Luna con sarna
INSERT INTO PetXPetIllness (IdPet, IdPetIllness) VALUES (3, 2); -- Rocky con moquillo

INSERT INTO PetXMedicine (IdPet, IdMedicine) VALUES (1, 2); -- Luna con ivermectina
INSERT INTO PetXMedicine (IdPet, IdMedicine) VALUES (3, 1); -- Rocky con amoxicilina

INSERT INTO PetXPetTreatment (IdPet, IdPetTreatment) VALUES (1, 3); -- Luna bano medicado
INSERT INTO PetXPetTreatment (IdPet, IdPetTreatment) VALUES (3, 2); -- Rocky vacunacion
INSERT INTO PetXPetTreatment (IdPet, IdPetTreatment) VALUES (4, 1); -- Nala desparasitacion

-- -------------------------------------------------------------
-- 9. RESCATES
-- -------------------------------------------------------------

INSERT INTO Rescued (Id, RescueDate, Place, Description,
                     IdPet, IdDistrict, IdRescuer, IdPetSeverity)
VALUES (1, DATE '2024-01-15', 'Parque La Sabana', 'Encontrado desnutrido',
        3, 1, 1, 1);

INSERT INTO Rescued (Id, RescueDate, Place, Description,
                     IdPet, IdDistrict, IdRescuer, IdPetSeverity)
VALUES (2, DATE '2024-03-10', 'Barrio Amon', 'Rescatado de maltrato',
        4, 1, 2, 2);

-- -------------------------------------------------------------
-- 10. REPORTES PERDIDOS Y ENCONTRADOS
-- -------------------------------------------------------------

INSERT INTO LostReport (Id, LostDate, Place, Description, Reward, State,
                        IdPet, IdDistrict, IdCurrency)
VALUES (1, DATE '2024-06-01', 'Barrio Escalante', 'Se perdio en la manana',
        50000, 'Perdido', 1, 1, 1);

INSERT INTO LostReport (Id, LostDate, Place, Description, Reward, State,
                        IdPet, IdDistrict, IdCurrency)
VALUES (2, DATE '2024-07-15', 'Rohrmoser', 'Se escapo del jardin',
        100, 'Perdido', 5, 1, 2);

INSERT INTO FoundReport (Id, FoundDate, Place, Description,
                          IdPet, IdDistrict, IdPerson)
VALUES (1, DATE '2024-06-03', 'Barrio Escalante', 'Encontrado cerca del parque',
        3, 1, 5);

INSERT INTO FoundReport (Id, FoundDate, Place, Description,
                          IdPet, IdDistrict, IdPerson)
VALUES (2, DATE '2024-07-20', 'Sabana Norte', 'Visto en la madrugada',
        5, 1, 6);

-- -------------------------------------------------------------
-- 11. MATCH
-- -------------------------------------------------------------

INSERT INTO PetMatch (Id, SimilarityPercentage, MatchDate, IdLostRepost, IdFoundReport)
VALUES (1, 85, DATE '2024-06-04', 1, 1);

INSERT INTO PetMatch (Id, SimilarityPercentage, MatchDate, IdLostRepost, IdFoundReport)
VALUES (2, 72, DATE '2024-07-21', 2, 2);

-- -------------------------------------------------------------
-- 12. ADOPCIONES
-- -------------------------------------------------------------

INSERT INTO Adoption (Id, AdoptionDate, AvailableDate, Description,
                      State, IdPet, IdAdopter, IdOwner)
VALUES (1, DATE '2024-05-01', DATE '2024-04-20',
        'Adopcion de Michi por familia Campos',
        'Adoptado', 2, 4, 3);

-- -------------------------------------------------------------
-- 13. CALIFICACIONES
-- -------------------------------------------------------------

INSERT INTO Calification (Id, Stars, Note, CalificationDate, IdPerson)
VALUES (1, 5, 'Excelente dueno, muy responsable',  DATE '2024-05-10', 4);
INSERT INTO Calification (Id, Stars, Note, CalificationDate, IdPerson)
VALUES (2, 3, 'Cumple, pero tarda en responder',   DATE '2024-04-15', 5);

-- -------------------------------------------------------------
-- 14. LISTA NEGRA Y REPORTES
-- -------------------------------------------------------------

INSERT INTO BlockList (Id, BlockDate, IdPerson)
VALUES (1, DATE '2024-02-01', 5);

INSERT INTO ReportList (Id, Description, IdPerson, IdReporter, DateReport)
VALUES (1, 'Reportado por maltrato animal', 5, 1, DATE '2024-01-28');

-- -------------------------------------------------------------
-- 15. ASOCIACIONES
-- -------------------------------------------------------------

INSERT INTO Association (Id, Name, PhoneNumber, BankAccount, Email)
VALUES (1, 'Refugio Animal CR',  22110000, 'CR21015200009123456789', 'info@refugioanimal.cr');

INSERT INTO Association (Id, Name, PhoneNumber, BankAccount, Email)
VALUES (2, 'Amigos Peludos',     22220001, 'CR21015200009987654321', 'amigos@peludos.cr');

INSERT INTO Association (Id, Name, PhoneNumber, BankAccount, Email)
VALUES (3, 'Patitas Felices',    22330002, 'CR21015200009111111111', 'patitas@felices.cr');

-- -------------------------------------------------------------
-- 16. DONACIONES
-- -------------------------------------------------------------

INSERT INTO Donation (Id, Amount, DonationDate, IdPerson, IdCurrency, IdAssociation)
VALUES (1, 25000, DATE '2024-06-05', 5, 1, 1);  -- recompensa donada en colones

INSERT INTO Donation (Id, Amount, DonationDate, IdPerson, IdCurrency, IdAssociation)
VALUES (2, 50,    DATE '2024-07-22', 6, 2, 2);  -- donacion voluntaria en dolares

INSERT INTO Donation (Id, Amount, DonationDate, IdPerson, IdCurrency, IdAssociation)
VALUES (3, 10000, DATE '2024-08-01', 1, 1, 3);

-- -------------------------------------------------------------
-- 17. PARAMETROS DEL SISTEMA
-- -------------------------------------------------------------

INSERT INTO Parameter (Id, Name, Value, Description)
VALUES (1, 'MatchIntervalHours',  4,  'Intervalo en horas del job de match');
INSERT INTO Parameter (Id, Name, Value, Description)
VALUES (2, 'MinMatchPercentage', 60,  'Porcentaje minimo para considerar un match valido');
INSERT INTO Parameter (Id, Name, Value, Description)
VALUES (3, 'MonthsNoAdoption',    2,  'Meses sin adopcion para alerta de mascota');
INSERT INTO Parameter (Id, Name, Value, Description)
VALUES (4, 'MaxPhotosPerPet',     10, 'Maxima cantidad de fotos por mascota');

COMMIT;
