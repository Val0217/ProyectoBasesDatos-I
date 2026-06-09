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
INSERT INTO District (Name, IdCanton) VALUES ('Santiago Centro',  11);