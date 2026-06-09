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

