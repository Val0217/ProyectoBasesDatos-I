-- =============================================================
-- ARCHIVO: Inserts.sql
-- DESCRIPCION: Datos de prueba para el sistema Bienestar Animal
-- NOTA: Ejecutar en el orden indicado por las dependencias FK
-- Se usan IDs fijos para que sean reutilizables y predecibles
-- =============================================================

-- -------------------------------------------------------------
-- 1. PAIS / PROVINCIA / CANTON / DISTRITO
-- -------------------------------------------------------------

INSERT INTO Country (Id, Name) VALUES (s_Country.NEXTVAL, 'Costa Rica');
INSERT INTO Country (Id, Name) VALUES (s_Country.NEXTVAL, 'Panama');

INSERT INTO Province (Id, Name, IdCountry) VALUES (s_Province.NEXTVAL, 'San Jose',    9);
INSERT INTO Province (Id, Name, IdCountry) VALUES (s_Province.NEXTVAL, 'Heredia',     9);
INSERT INTO Province (Id, Name, IdCountry) VALUES (s_Province.NEXTVAL, 'Alajuela',    9);
INSERT INTO Province (Id, Name, IdCountry) VALUES (s_Province.NEXTVAL, 'Cartago',     9);
INSERT INTO Province (Id, Name, IdCountry) VALUES (s_Province.NEXTVAL, 'Guanacaste',  9);

INSERT INTO Canton (Id, Name, IdProvince) VALUES (s_Canton.NEXTVAL, 'San Jose',     27);
INSERT INTO Canton (Id, Name, IdProvince) VALUES (s_Canton.NEXTVAL, 'Desamparados', 28);
INSERT INTO Canton (Id, Name, IdProvince) VALUES (s_Canton.NEXTVAL, 'Heredia',      29);
INSERT INTO Canton (Id, Name, IdProvince) VALUES (s_Canton.NEXTVAL, 'Alajuela',     30);
INSERT INTO Canton (Id, Name, IdProvince) VALUES (s_Canton.NEXTVAL, 'Cartago',      31);

INSERT INTO District (Id, Name, IdCanton) VALUES (s_District.NEXTVAL, 'Carmen',        37);
INSERT INTO District (Id, Name, IdCanton) VALUES (s_District.NEXTVAL, 'Hatillo',       38);
INSERT INTO District (Id, Name, IdCanton) VALUES (s_District.NEXTVAL, 'Desamparados',  39);
INSERT INTO District (Id, Name, IdCanton) VALUES (s_District.NEXTVAL, 'Heredia Centro',40);
INSERT INTO District (Id, Name, IdCanton) VALUES (s_District.NEXTVAL, 'Alajuela Centro', 41);

INSERT INTO Province (Id, Name, IdCountry) VALUES (s_Province.NEXTVAL, 'Panama',        10);
INSERT INTO Province (Id, Name, IdCountry) VALUES (s_Province.NEXTVAL, 'Chiriqui',      10);
INSERT INTO Province (Id, Name, IdCountry) VALUES (s_Province.NEXTVAL, 'Colon',         10);
INSERT INTO Province (Id, Name, IdCountry) VALUES (s_Province.NEXTVAL, 'Veraguas',      10);
INSERT INTO Province (Id, Name, IdCountry) VALUES (s_Province.NEXTVAL, 'Los Santos',   10);

INSERT INTO Canton (Id, Name, IdProvince) VALUES (s_Canton.NEXTVAL, 'Panama',       18);
INSERT INTO Canton (Id, Name, IdProvince) VALUES (s_Canton.NEXTVAL, 'San Miguelito',18);
INSERT INTO Canton (Id, Name, IdProvince) VALUES (s_Canton.NEXTVAL, 'David',        19);
INSERT INTO Canton (Id, Name, IdProvince) VALUES (s_Canton.NEXTVAL, 'Santiago',     20);
INSERT INTO Canton (Id, Name, IdProvince) VALUES (s_Canton.NEXTVAL,'Chitre',       21);

INSERT INTO District (Id, Name, IdCanton) VALUES (s_District.NEXTVAL,  'Bella Vista',     17);
INSERT INTO District (Id, Name, IdCanton) VALUES (s_District.NEXTVAL,  'Calidonia',       18);
INSERT INTO District (Id, Name, IdCanton) VALUES (s_District.NEXTVAL,  'Belisario Porras',19);
INSERT INTO District (Id, Name, IdCanton) VALUES (s_District.NEXTVAL,  'David Centro',    20);
INSERT INTO District (Id, Name, IdCanton) VALUES (s_District.NEXTVAL, 'Santiago Centro', 21);

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
INSERT INTO PetState (Id, Name) VALUES (1, 'En Adopcion');
INSERT INTO PetState (Id, Name) VALUES (2, 'Adoptado');
INSERT INTO PetState (Id, Name) VALUES (3, 'Perdido');
INSERT INTO PetState (Id, Name) VALUES (4, 'Encontrado');
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

INSERT INTO PetIllness (Id, Name, Description) VALUES (s_PetIllness.nextval, 'Parvovirus',   'Enfermedad viral en perros');
INSERT INTO PetIllness (Id, Name, Description) VALUES (s_PetIllness.nextval, 'Moquillo',     'Enfermedad respiratoria canina');
INSERT INTO PetIllness (Id, Name, Description) VALUES (s_PetIllness.nextval, 'Toxoplasmosis','Parasito comun en gatos');
INSERT INTO PetIllness (Id, Name, Description) VALUES (s_PetIllness.nextval, 'Sarna',        'Parasito externo');
INSERT INTO PetIllness (Id, Name, Description) VALUES (s_PetIllness.nextval, 'Leucemia Felina','Virus en gatos');

INSERT INTO Medicine (Id, Name, Dose) VALUES (s_Medicine.nextval, 'Amoxicilina',  '250mg cada 8h');
INSERT INTO Medicine (Id, Name, Dose) VALUES (s_Medicine.nextval, 'Ivermectina',  '0.2mg/kg');
INSERT INTO Medicine (Id, Name, Dose) VALUES (s_Medicine.nextval, 'Metronidazol', '15mg/kg');
INSERT INTO Medicine (Id, Name, Dose) VALUES (s_Medicine.nextval, 'Prednisona',   '1mg/kg');
INSERT INTO Medicine (Id, Name, Dose) VALUES (s_Medicine.nextval, 'Vitamina B12', '1ml semanal');


INSERT INTO PetTreatment (Id, Name, Description) VALUES (s_PetTreatment.nextval, 'Desparasitacion', 'Control de parasitos internos');
INSERT INTO PetTreatment (Id, Name, Description) VALUES (s_PetTreatment.nextval, 'Vacunacion',      'Esquema de vacunas basico');
INSERT INTO PetTreatment (Id, Name, Description) VALUES (s_PetTreatment.nextval, 'Bano medicado',   'Tratamiento de piel');
INSERT INTO PetTreatment (Id, Name, Description) VALUES (s_PetTreatment.nextval, 'Cirugia',         'Procedimiento quirurgico');
INSERT INTO PetTreatment (Id, Name, Description) VALUES (s_PetTreatment.nextval, 'Esterilizacion',  'Castración o esterilizacion');

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

INSERT INTO FosterHome (Id, NeedsDonation, IdPerson) VALUES (s_fosterhome.nextval, 'Y', 3);
INSERT INTO FosterHome (Id, NeedsDonation, IdPerson) VALUES (s_fosterhome.nextval, 'N', 6);

-- Tamaños aceptados por casa cuna
INSERT INTO PetSizeXFosterHome (IdPetSize, IdFosterHome) VALUES (1, 1); -- pequeno
INSERT INTO PetSizeXFosterHome (IdPetSize, IdFosterHome) VALUES (2, 1); -- mediano
INSERT INTO PetSizeXFosterHome (IdPetSize, IdFosterHome) VALUES (1, 2);
INSERT INTO PetSizeXFosterHome (IdPetSize, IdFosterHome) VALUES (2, 2);
INSERT INTO PetSizeXFosterHome (IdPetSize, IdFosterHome) VALUES (3, 2);

-- Nivel de energia aceptado por casa cuna
INSERT INTO PetLevelEnergyXFosterHome (IDPETLEVELENERGY, IdFosterHome) VALUES (3, 2); -- caminador
INSERT INTO PetLevelEnergyXFosterHome (IDPETLEVELENERGY, IdFosterHome) VALUES (2, 2); -- para ver TV
INSERT INTO PetLevelEnergyXFosterHome (IDPETLEVELENERGY, IdFosterHome) VALUES (1, 3); -- atletico

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





-- ----------------------
-- Inserts Valeria



/* ------------------------------------------------------------
   1. Location hierarchy needed by District foreign keys
   ------------------------------------------------------------ */
INSERT INTO Country (Id, Name)
SELECT 1, 'Costa Rica' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Country WHERE Id = 1);

INSERT INTO Province (Id, Name, IdCountry)
SELECT 1, 'San Jose', 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Province WHERE Id = 1);

INSERT INTO Canton (Id, Name, IdProvince)
SELECT 1, 'San Jose', 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Canton WHERE Id = 1);

INSERT INTO District (Id, Name, IdCanton)
SELECT 1, 'Carmen', 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM District WHERE Id = 1);

INSERT INTO District (Id, Name, IdCanton)
SELECT 2, 'Hatillo', 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM District WHERE Id = 2);

INSERT INTO District (Id, Name, IdCanton)
SELECT 3, 'Escazu', 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM District WHERE Id = 3);

/* ------------------------------------------------------------
   2. Pet catalog rows needed by Pet foreign keys
   ------------------------------------------------------------ */

INSERT INTO PetState (Id, Name)
SELECT 1, 'up for adoption' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetState WHERE Id = 1);

INSERT INTO PetState (Id, Name)
SELECT 2, 'Adopted' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetState WHERE Id = 2);

INSERT INTO PetState (Id, Name)
SELECT 3, 'Lost' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetState WHERE Id = 3);

INSERT INTO PetState (Id, Name)
SELECT 4, 'Found' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetState WHERE Id = 4);

INSERT INTO PetState (Id, Name)
SELECT 2, 'Adoptado' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetState WHERE Id = 2);

INSERT INTO PetState (Id, Name)
SELECT 3, 'Perdido' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetState WHERE Id = 3);

INSERT INTO PetState (Id, Name)
SELECT 1, 'En Adopcion' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetState WHERE Id = 1);

INSERT INTO PetType (Id, Name)
<<<<<<< HEAD
SELECT 1, 'Dog' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetType WHERE Id = 1);
=======
SELECT 1, 'Perro' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetType WHERE Id = 3);
>>>>>>> 2045f04091160651bf5fba5839c625d82a61bf3b

INSERT INTO PetType (Id, Name)
SELECT 2, 'Cat' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetType WHERE Id = 2);

INSERT INTO PetBreed (Id, Name)
SELECT 1, 'Labrador' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetBreed WHERE Id = 1);

INSERT INTO PetBreed (Id, Name)
SELECT 2, 'Poodle' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetBreed WHERE Id = 2);

INSERT INTO PetBreed (Id, Name)
SELECT 3, 'Siames' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetBreed WHERE Id = 3);

INSERT INTO PetBreed (Id, Name)
SELECT 4, 'Persa' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetBreed WHERE Id = 4);

INSERT INTO PetBreed (Id, Name)
SELECT 5, 'Chihuahua' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetBreed WHERE Id = 5);

INSERT INTO PetBreed (Id, Name)
SELECT 6, 'Mixed Breed' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetBreed WHERE Id = 6);

INSERT INTO PetLevelEnergy (Id, Name)
SELECT 1, 'Athletic' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetLevelEnergy WHERE Id = 1);

INSERT INTO PetLevelEnergy (Id, Name)
SELECT 2, 'Runner' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetLevelEnergy WHERE Id = 2);

INSERT INTO PetLevelEnergy (Id, Name)
SELECT 3, 'Walker' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetLevelEnergy WHERE Id = 3);

INSERT INTO SpaceRequired (Id, Name)
SELECT 1, 'Apartment' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM SpaceRequired WHERE Id = 1);

INSERT INTO SpaceRequired (Id, Name)
SELECT 2, 'House Without Yard' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM SpaceRequired WHERE Id = 2);

INSERT INTO SpaceRequired (Id, Name)
SELECT 3, 'House With Yard' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM SpaceRequired WHERE Id = 3);

INSERT INTO PetTraining (Id, Name)
SELECT 1, 'Very Easy' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetTraining WHERE Id = 1);

INSERT INTO PetTraining (Id, Name)
SELECT 2, 'Easy' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetTraining WHERE Id = 2);

INSERT INTO PetTraining (Id, Name)
SELECT 3, 'Moderate' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetTraining WHERE Id = 3);

INSERT INTO PetSize (Id, Name)
SELECT 1, 'Small' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetSize WHERE Id = 1);

INSERT INTO PetSize (Id, Name)
SELECT 2, 'Medium' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetSize WHERE Id = 2);

INSERT INTO PetSize (Id, Name)
SELECT 3, 'Large' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetSize WHERE Id = 3);


/* ------------------------------------------------------------
   4. Veterinarians needed by Pet.IdVeterinarian
   ------------------------------------------------------------ */
INSERT INTO Veterinarian (Id, Email, FirstName, LastName, Location, IdDristrict, Phone, Name)
SELECT 1, 'luis@vet.com', 'Luis', 'Mora', 'San Jose', 1, 22345678, 'Mascotas Felices' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Veterinarian WHERE Id = 1);

INSERT INTO Veterinarian (Id, Email, FirstName, LastName, Location, IdDristrict, Phone, Name)
SELECT 2, 'ana@vet.com', 'Ana', 'Jimenez', 'Hatillo', 2, 22876543, 'VetCenter' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Veterinarian WHERE Id = 2);

/* ------------------------------------------------------------
   5. Pets with IdState = 4 only
   ------------------------------------------------------------ */
INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 1, 'Brown', 3, 'Friendly medium-size dog', 'Luna', 'CHIP001',
       1, 4, 1, 1, 1,
       1, 1, 2, 1, 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 1);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 2, 'Black', 2, 'Found near park', 'Max', 'CHIP002',
       2, 4, 1, 2, 1,
       1, 2, 2, 1, 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 2);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 3, 'White', 1, 'Calm affectionate cat', 'Mia', 'CHIP003',
       1, 4, 2, 3, 2,
       2, 1, 1, 2, 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 3);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 4, 'Gray', 4, 'Found with blue collar', 'Nala', 'CHIP004',
       2, 4, 2, 4, 2,
       2, 2, 1, 2, 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 4);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 5, 'Golden', 5, 'Playful trained dog', 'Toby', 'CHIP005',
       3, 4, 1, 5, 3,
       3, 3, 3, 3, 2
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 5);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 6, 'Spotted', 2, 'Found close to avenue', 'Rocky', 'CHIP006',
       3, 4, 1, 6, 3,
       3, 2, 3, 3, 2
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 6);

INSERT INTO PetState (Id, Name)
SELECT 1, 'Up for adoption' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM PetState WHERE Id = 1);

/* ------------------------------------------------------------
   5. Pets with IdState = 1 only
      Pet IDs use 101-106 to avoid conflicts if you already ran the state-4 script.
   ------------------------------------------------------------ */
INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 101, 'Brown', 3, 'Friendly medium-size dog', 'Luna', 'CHIP008',
       1, 1, 1, 1, 1,
       1, 1, 2, 1, 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 101);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 102, 'Black', 2, 'Available for adoption, rescued near park', 'Max', 'CHIP009',
       2, 1, 1, 2, 1,
       1, 2, 2, 1, 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 102);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 103, 'White', 1, 'Calm affectionate cat', 'Mia', 'CHIP013',
       1, 1, 2, 3, 2,
       2, 1, 1, 2, 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 103);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 104, 'Gray', 4, 'Available for adoption, has blue collar', 'Nala', 'CHIP010',
       2, 1, 2, 4, 2,
       2, 2, 1, 2, 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 104);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 105, 'Golden', 5, 'Playful trained dog', 'Toby', 'CHIP015',
       3, 1, 1, 5, 3,
       3, 3, 3, 3, 2
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 105);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 106, 'Spotted', 2, 'Available for adoption, rescued close to avenue', 'Rocky', 'CHIP01',
       3, 1, 1, 6, 3,
       3, 2, 3, 3, 2
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 106);



COMMIT;

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 107, 'Cream', 1, 'Small shy puppy, recently rescued', 'Coco', 'CHIP016',
       1, 1, 1, 1, 1,
       1, 1, 1, 1, 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 107);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 108, 'Orange', 3, 'Friendly cat that likes people', 'Simba', 'CHIP017',
       2, 1, 2, 3, 2,
       2, 2, 1, 2, 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 108);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 109, 'Black and White', 4, 'Available for adoption, calm and obedient', 'Oreo', 'CHIP018',
       1, 1, 1, 2, 1,
       1, 3, 2, 1, 2
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 109);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 110, 'Brown and White', 2, 'Energetic young dog, loves running', 'Bruno', 'CHIP019',
       3, 1, 1, 5, 3,
       3, 2, 3, 3, 2
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 110);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 111, 'Gray and White', 6, 'Older cat, very calm and affectionate', 'Milo', 'CHIP020',
       1, 1, 2, 4, 2,
       2, 1, 1, 2, 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 111);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 112, 'Tan', 2, 'Available for adoption, rescued from street', 'Bella', 'CHIP021',
       2, 1, 1, 6, 3,
       3, 2, 2, 3, 2
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 112);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 113, 'White and Brown', 1, 'Playful kitten, good with children', 'Lily', 'CHIP022',
       2, 1, 2, 3, 2,
       2, 1, 1, 2, 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 113);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 114, 'Black', 5, 'Trained guard dog, loyal and calm', 'Zeus', 'CHIP023',
       3, 1, 1, 5, 3,
       3, 3, 3, 3, 2
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 114);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 115, 'Calico', 3, 'Available for adoption, quiet indoor cat', 'Cleo', 'CHIP024',
       1, 1, 2, 4, 1,
       1, 2, 1, 1, 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 115);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 116, 'Golden and White', 4, 'Friendly family dog, medium energy', 'Buddy', 'CHIP025',
       2, 1, 1, 1, 2,
       2, 2, 2, 2, 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 116);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 117, 'Dark Brown', 7, 'Senior dog, calm and well behaved', 'Rex', 'CHIP026',
       1, 1, 1, 2, 3,
       3, 3, 3, 3, 2
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 117);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 118, 'White', 2, 'Available for adoption, affectionate small cat', 'Snow', 'CHIP027',
       1, 1, 2, 3, 1,
       1, 1, 1, 1, 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 118);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 119, 'Mixed Brown', 3, 'Very active dog, needs outdoor space', 'Thor', 'CHIP028',
       3, 1, 1, 6, 3,
       3, 2, 3, 3, 2
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 119);

INSERT INTO Pet (
    Id, Color, Age, Description, Name, Chip,
    IdEnergy, IdState, IdType, IdBreed, IdDistrict,
    IdSpace, IdPetTraining, IdSize, IdOwner, IdVeterinarian
)
SELECT 120, 'Gray', 1, 'Small kitten, playful and curious', 'Kira', 'CHIP029',
       2, 1, 2, 4, 2,
       2, 1, 1, 2, 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Pet WHERE Id = 120);
