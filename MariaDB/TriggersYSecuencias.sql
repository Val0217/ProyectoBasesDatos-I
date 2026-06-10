
-- Para que fn_audit_changed_by() devuelva el usuario correcto desde Java,
-- ejecuta al iniciar sesion: SET @app_user_id = <IdUsuario>;

DROP SEQUENCE IF EXISTS seq_created;
CREATE SEQUENCE seq_created START WITH 1 INCREMENT BY 1;

DROP SEQUENCE IF EXISTS seq_deleted;
CREATE SEQUENCE seq_deleted START WITH 1 INCREMENT BY 1;

DROP SEQUENCE IF EXISTS seq_bitacora;
CREATE SEQUENCE seq_bitacora START WITH 1 INCREMENT BY 1;

DROP SEQUENCE IF EXISTS seq_parameter;
CREATE SEQUENCE seq_parameter START WITH 1 INCREMENT BY 1;

DELIMITER //

DROP FUNCTION IF EXISTS fn_audit_changed_by//
CREATE FUNCTION fn_audit_changed_by()
RETURNS BIGINT
DETERMINISTIC
BEGIN
    DECLARE v_client_identifier VARCHAR(64);

    SET v_client_identifier = CAST(@app_user_id AS CHAR);

    IF v_client_identifier IS NOT NULL AND v_client_identifier REGEXP '^[0-9]+$' THEN
        RETURN CAST(v_client_identifier AS UNSIGNED);
    END IF;

    RETURN 0;
END//

DROP TRIGGER IF EXISTS trg_bi_created//
-- Defaults para las tablas de auditoria.
CREATE TRIGGER trg_bi_created
BEFORE INSERT ON Created
FOR EACH ROW
BEGIN
    IF NEW.Id IS NULL THEN
        SET NEW.Id = NEXT VALUE FOR seq_created;
    END IF;
    IF NEW.CreatedDate IS NULL THEN
        SET NEW.CreatedDate = NOW();
    END IF;
    IF NEW.CreatedBy IS NULL THEN
        SET NEW.CreatedBy = SUBSTRING(CURRENT_USER(), 1, 25);
    END IF;
END//

DROP TRIGGER IF EXISTS trg_bi_deleted//
CREATE TRIGGER trg_bi_deleted
BEFORE INSERT ON Deleted
FOR EACH ROW
BEGIN
    IF NEW.Id IS NULL THEN
        SET NEW.Id = NEXT VALUE FOR seq_deleted;
    END IF;
    IF NEW.DeletedDate IS NULL THEN
        SET NEW.DeletedDate = NOW();
    END IF;
    IF NEW.DeletedBy IS NULL THEN
        SET NEW.DeletedBy = SUBSTRING(CURRENT_USER(), 1, 25);
    END IF;
END//

DROP TRIGGER IF EXISTS trg_bi_bitacora//
CREATE TRIGGER trg_bi_bitacora
BEFORE INSERT ON Bitacora
FOR EACH ROW
BEGIN
    IF NEW.Id IS NULL THEN
        SET NEW.Id = NEXT VALUE FOR seq_bitacora;
    END IF;
    IF NEW.ChangeDate IS NULL THEN
        SET NEW.ChangeDate = CURTIME();
    END IF;
    IF NEW.ChangedBy IS NULL THEN
        SET NEW.ChangedBy = fn_audit_changed_by();
    END IF;
END//

DROP TRIGGER IF EXISTS trg_bi_parameter//
CREATE TRIGGER trg_bi_parameter
BEFORE INSERT ON Parameter
FOR EACH ROW
BEGIN
    IF NEW.Id IS NULL THEN
        SET NEW.Id = NEXT VALUE FOR seq_parameter;
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_petlevelenergy_859a//
-- Auditoria INSERT/DELETE para PetLevelEnergy.
CREATE TRIGGER trg_ai_petlevelenergy_859a
AFTER INSERT ON PetLevelEnergy
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETLEVELENERGY', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_petlevelenergy_f4e8//
CREATE TRIGGER trg_ad_petlevelenergy_f4e8
AFTER DELETE ON PetLevelEnergy
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETLEVELENERGY', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_petlevelenergy_73f6//
-- Bitacora UPDATE por campo para PetLevelEnergy.
CREATE TRIGGER trg_au_petlevelenergy_73f6
AFTER UPDATE ON PetLevelEnergy
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETLEVELENERGY', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_petbreed_137b//
-- Auditoria INSERT/DELETE para PetBreed.
CREATE TRIGGER trg_ai_petbreed_137b
AFTER INSERT ON PetBreed
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETBREED', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_petbreed_8b6b//
CREATE TRIGGER trg_ad_petbreed_8b6b
AFTER DELETE ON PetBreed
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETBREED', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_petbreed_a52c//
-- Bitacora UPDATE por campo para PetBreed.
CREATE TRIGGER trg_au_petbreed_a52c
AFTER UPDATE ON PetBreed
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETBREED', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_pettype_6459//
-- Auditoria INSERT/DELETE para PetType.
CREATE TRIGGER trg_ai_pettype_6459
AFTER INSERT ON PetType
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETTYPE', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_pettype_64e2//
CREATE TRIGGER trg_ad_pettype_64e2
AFTER DELETE ON PetType
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETTYPE', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_pettype_c757//
-- Bitacora UPDATE por campo para PetType.
CREATE TRIGGER trg_au_pettype_c757
AFTER UPDATE ON PetType
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETTYPE', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_petstate_d457//
-- Auditoria INSERT/DELETE para PetState.
CREATE TRIGGER trg_ai_petstate_d457
AFTER INSERT ON PetState
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETSTATE', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_petstate_5b07//
CREATE TRIGGER trg_ad_petstate_5b07
AFTER DELETE ON PetState
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETSTATE', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_petstate_1c4b//
-- Bitacora UPDATE por campo para PetState.
CREATE TRIGGER trg_au_petstate_1c4b
AFTER UPDATE ON PetState
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETSTATE', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_petillness_6fc8//
-- Auditoria INSERT/DELETE para PetIllness.
CREATE TRIGGER trg_ai_petillness_6fc8
AFTER INSERT ON PetIllness
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETILLNESS', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_petillness_22ed//
CREATE TRIGGER trg_ad_petillness_22ed
AFTER DELETE ON PetIllness
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETILLNESS', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_petillness_c514//
-- Bitacora UPDATE por campo para PetIllness.
CREATE TRIGGER trg_au_petillness_c514
AFTER UPDATE ON PetIllness
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETILLNESS', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
    IF COALESCE(SUBSTR(OLD.Description, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Description, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETILLNESS', CURTIME(), SUBSTR(OLD.Description, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Description, 1, 50), 'DESCRIPTION');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_medicine_28ef//
-- Auditoria INSERT/DELETE para Medicine.
CREATE TRIGGER trg_ai_medicine_28ef
AFTER INSERT ON Medicine
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'MEDICINE', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_medicine_d38f//
CREATE TRIGGER trg_ad_medicine_d38f
AFTER DELETE ON Medicine
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'MEDICINE', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_medicine_9f01//
-- Bitacora UPDATE por campo para Medicine.
CREATE TRIGGER trg_au_medicine_9f01
AFTER UPDATE ON Medicine
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'MEDICINE', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
    IF COALESCE(SUBSTR(OLD.Dose, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Dose, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'MEDICINE', CURTIME(), SUBSTR(OLD.Dose, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Dose, 1, 50), 'DOSE');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_pettreatment_3fc5//
-- Auditoria INSERT/DELETE para PetTreatment.
CREATE TRIGGER trg_ai_pettreatment_3fc5
AFTER INSERT ON PetTreatment
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETTREATMENT', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_pettreatment_7c1f//
CREATE TRIGGER trg_ad_pettreatment_7c1f
AFTER DELETE ON PetTreatment
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETTREATMENT', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_pettreatment_8ee6//
-- Bitacora UPDATE por campo para PetTreatment.
CREATE TRIGGER trg_au_pettreatment_8ee6
AFTER UPDATE ON PetTreatment
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETTREATMENT', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
    IF COALESCE(SUBSTR(OLD.Description, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Description, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETTREATMENT', CURTIME(), SUBSTR(OLD.Description, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Description, 1, 50), 'DESCRIPTION');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_pettraining_33f2//
-- Auditoria INSERT/DELETE para PetTraining.
CREATE TRIGGER trg_ai_pettraining_33f2
AFTER INSERT ON PetTraining
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETTRAINING', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_pettraining_3de1//
CREATE TRIGGER trg_ad_pettraining_3de1
AFTER DELETE ON PetTraining
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETTRAINING', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_pettraining_7d11//
-- Bitacora UPDATE por campo para PetTraining.
CREATE TRIGGER trg_au_pettraining_7d11
AFTER UPDATE ON PetTraining
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETTRAINING', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_spacerequired_1398//
-- Auditoria INSERT/DELETE para SpaceRequired.
CREATE TRIGGER trg_ai_spacerequired_1398
AFTER INSERT ON SpaceRequired
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'SPACEREQUIRED', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_spacerequired_afac//
CREATE TRIGGER trg_ad_spacerequired_afac
AFTER DELETE ON SpaceRequired
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'SPACEREQUIRED', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_spacerequired_3d0b//
-- Bitacora UPDATE por campo para SpaceRequired.
CREATE TRIGGER trg_au_spacerequired_3d0b
AFTER UPDATE ON SpaceRequired
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'SPACEREQUIRED', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_petsize_3a07//
-- Auditoria INSERT/DELETE para PetSize.
CREATE TRIGGER trg_ai_petsize_3a07
AFTER INSERT ON PetSize
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETSIZE', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_petsize_1652//
CREATE TRIGGER trg_ad_petsize_1652
AFTER DELETE ON PetSize
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETSIZE', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_petsize_3eb3//
-- Bitacora UPDATE por campo para PetSize.
CREATE TRIGGER trg_au_petsize_3eb3
AFTER UPDATE ON PetSize
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETSIZE', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_district_2ed4//
-- Auditoria INSERT/DELETE para District.
CREATE TRIGGER trg_ai_district_2ed4
AFTER INSERT ON District
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'DISTRICT', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_district_ac4e//
CREATE TRIGGER trg_ad_district_ac4e
AFTER DELETE ON District
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'DISTRICT', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_district_9740//
-- Bitacora UPDATE por campo para District.
CREATE TRIGGER trg_au_district_9740
AFTER UPDATE ON District
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'DISTRICT', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdCanton AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdCanton AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'DISTRICT', CURTIME(), SUBSTR(CAST(OLD.IdCanton AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdCanton AS CHAR), 1, 50), 'IDCANTON');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_canton_e148//
-- Auditoria INSERT/DELETE para Canton.
CREATE TRIGGER trg_ai_canton_e148
AFTER INSERT ON Canton
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'CANTON', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_canton_fc00//
CREATE TRIGGER trg_ad_canton_fc00
AFTER DELETE ON Canton
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'CANTON', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_canton_1c20//
-- Bitacora UPDATE por campo para Canton.
CREATE TRIGGER trg_au_canton_1c20
AFTER UPDATE ON Canton
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'CANTON', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdProvince AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdProvince AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'CANTON', CURTIME(), SUBSTR(CAST(OLD.IdProvince AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdProvince AS CHAR), 1, 50), 'IDPROVINCE');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_province_7624//
-- Auditoria INSERT/DELETE para Province.
CREATE TRIGGER trg_ai_province_7624
AFTER INSERT ON Province
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PROVINCE', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_province_a7ca//
CREATE TRIGGER trg_ad_province_a7ca
AFTER DELETE ON Province
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PROVINCE', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_province_3dd8//
-- Bitacora UPDATE por campo para Province.
CREATE TRIGGER trg_au_province_3dd8
AFTER UPDATE ON Province
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PROVINCE', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdCountry AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdCountry AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PROVINCE', CURTIME(), SUBSTR(CAST(OLD.IdCountry AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdCountry AS CHAR), 1, 50), 'IDCOUNTRY');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_country_1dca//
-- Auditoria INSERT/DELETE para Country.
CREATE TRIGGER trg_ai_country_1dca
AFTER INSERT ON Country
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'COUNTRY', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_country_1060//
CREATE TRIGGER trg_ad_country_1060
AFTER DELETE ON Country
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'COUNTRY', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_country_580c//
-- Bitacora UPDATE por campo para Country.
CREATE TRIGGER trg_au_country_580c
AFTER UPDATE ON Country
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'COUNTRY', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_petseverity_0d57//
-- Auditoria INSERT/DELETE para PetSeverity.
CREATE TRIGGER trg_ai_petseverity_0d57
AFTER INSERT ON PetSeverity
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETSEVERITY', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_petseverity_f33f//
CREATE TRIGGER trg_ad_petseverity_f33f
AFTER DELETE ON PetSeverity
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETSEVERITY', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_petseverity_8938//
-- Bitacora UPDATE por campo para PetSeverity.
CREATE TRIGGER trg_au_petseverity_8938
AFTER UPDATE ON PetSeverity
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETSEVERITY', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_pet_46b7//
-- Auditoria INSERT/DELETE para Pet.
CREATE TRIGGER trg_ai_pet_46b7
AFTER INSERT ON Pet
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PET', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_pet_839f//
CREATE TRIGGER trg_ad_pet_839f
AFTER DELETE ON Pet
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PET', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_pet_38db//
-- Bitacora UPDATE por campo para Pet.
CREATE TRIGGER trg_au_pet_38db
AFTER UPDATE ON Pet
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Color, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Color, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PET', CURTIME(), SUBSTR(OLD.Color, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Color, 1, 50), 'COLOR');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.Age AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.Age AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PET', CURTIME(), SUBSTR(CAST(OLD.Age AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.Age AS CHAR), 1, 50), 'AGE');
    END IF;
    IF COALESCE(SUBSTR(OLD.Description, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Description, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PET', CURTIME(), SUBSTR(OLD.Description, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Description, 1, 50), 'DESCRIPTION');
    END IF;
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PET', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
    IF COALESCE(SUBSTR(OLD.Chip, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Chip, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PET', CURTIME(), SUBSTR(OLD.Chip, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Chip, 1, 50), 'CHIP');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdEnergy AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdEnergy AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PET', CURTIME(), SUBSTR(CAST(OLD.IdEnergy AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdEnergy AS CHAR), 1, 50), 'IDENERGY');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdState AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdState AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PET', CURTIME(), SUBSTR(CAST(OLD.IdState AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdState AS CHAR), 1, 50), 'IDSTATE');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdType AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdType AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PET', CURTIME(), SUBSTR(CAST(OLD.IdType AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdType AS CHAR), 1, 50), 'IDTYPE');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdBreed AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdBreed AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PET', CURTIME(), SUBSTR(CAST(OLD.IdBreed AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdBreed AS CHAR), 1, 50), 'IDBREED');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdDistrict AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdDistrict AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PET', CURTIME(), SUBSTR(CAST(OLD.IdDistrict AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdDistrict AS CHAR), 1, 50), 'IDDISTRICT');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdSpace AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdSpace AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PET', CURTIME(), SUBSTR(CAST(OLD.IdSpace AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdSpace AS CHAR), 1, 50), 'IDSPACE');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdPetTraining AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPetTraining AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PET', CURTIME(), SUBSTR(CAST(OLD.IdPetTraining AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPetTraining AS CHAR), 1, 50), 'IDPETTRAINING');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdSize AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdSize AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PET', CURTIME(), SUBSTR(CAST(OLD.IdSize AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdSize AS CHAR), 1, 50), 'IDSIZE');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdOwner AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdOwner AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PET', CURTIME(), SUBSTR(CAST(OLD.IdOwner AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdOwner AS CHAR), 1, 50), 'IDOWNER');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdVeterinarian AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdVeterinarian AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PET', CURTIME(), SUBSTR(CAST(OLD.IdVeterinarian AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdVeterinarian AS CHAR), 1, 50), 'IDVETERINARIAN');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_veterinarian_e5d6//
-- Auditoria INSERT/DELETE para Veterinarian.
CREATE TRIGGER trg_ai_veterinarian_e5d6
AFTER INSERT ON Veterinarian
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'VETERINARIAN', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_veterinarian_930c//
CREATE TRIGGER trg_ad_veterinarian_930c
AFTER DELETE ON Veterinarian
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'VETERINARIAN', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_veterinarian_d85a//
-- Bitacora UPDATE por campo para Veterinarian.
CREATE TRIGGER trg_au_veterinarian_d85a
AFTER UPDATE ON Veterinarian
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Email, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Email, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'VETERINARIAN', CURTIME(), SUBSTR(OLD.Email, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Email, 1, 50), 'EMAIL');
    END IF;
    IF COALESCE(SUBSTR(OLD.FirstName, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.FirstName, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'VETERINARIAN', CURTIME(), SUBSTR(OLD.FirstName, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.FirstName, 1, 50), 'FIRSTNAME');
    END IF;
    IF COALESCE(SUBSTR(OLD.LastName, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.LastName, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'VETERINARIAN', CURTIME(), SUBSTR(OLD.LastName, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.LastName, 1, 50), 'LASTNAME');
    END IF;
    IF COALESCE(SUBSTR(OLD.Location, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Location, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'VETERINARIAN', CURTIME(), SUBSTR(OLD.Location, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Location, 1, 50), 'LOCATION');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdDistrict AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdDistrict AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'VETERINARIAN', CURTIME(), SUBSTR(CAST(OLD.IdDistrict AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdDistrict AS CHAR), 1, 50), 'IDDISTRICT');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.Phone AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.Phone AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'VETERINARIAN', CURTIME(), SUBSTR(CAST(OLD.Phone AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.Phone AS CHAR), 1, 50), 'PHONE');
    END IF;
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'VETERINARIAN', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_petsizexfosterhome_b6e6//
-- Auditoria INSERT/DELETE para PetSizeXFosterHome.
CREATE TRIGGER trg_ai_petsizexfosterhome_b6e6
AFTER INSERT ON PetSizeXFosterHome
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETSIZEXFOSTERHOME', NULL);
END//

DROP TRIGGER IF EXISTS trg_ad_petsizexfosterhome_72b9//
CREATE TRIGGER trg_ad_petsizexfosterhome_72b9
AFTER DELETE ON PetSizeXFosterHome
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETSIZEXFOSTERHOME', NULL);
END//

DROP TRIGGER IF EXISTS trg_au_petsizexfosterhome_1f69//
-- Bitacora UPDATE por campo para PetSizeXFosterHome.
CREATE TRIGGER trg_au_petsizexfosterhome_1f69
AFTER UPDATE ON PetSizeXFosterHome
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(CAST(OLD.IdPetSize AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPetSize AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETSIZEXFOSTERHOME', CURTIME(), SUBSTR(CAST(OLD.IdPetSize AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPetSize AS CHAR), 1, 50), 'IDPETSIZE');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdFosterHome AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdFosterHome AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETSIZEXFOSTERHOME', CURTIME(), SUBSTR(CAST(OLD.IdFosterHome AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdFosterHome AS CHAR), 1, 50), 'IDFOSTERHOME');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_petxpettreatment_33e0//
-- Auditoria INSERT/DELETE para PetXPetTreatment.
CREATE TRIGGER trg_ai_petxpettreatment_33e0
AFTER INSERT ON PetXPetTreatment
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETXPETTREATMENT', NULL);
END//

DROP TRIGGER IF EXISTS trg_ad_petxpettreatment_c90a//
CREATE TRIGGER trg_ad_petxpettreatment_c90a
AFTER DELETE ON PetXPetTreatment
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETXPETTREATMENT', NULL);
END//

DROP TRIGGER IF EXISTS trg_au_petxpettreatment_11bf//
-- Bitacora UPDATE por campo para PetXPetTreatment.
CREATE TRIGGER trg_au_petxpettreatment_11bf
AFTER UPDATE ON PetXPetTreatment
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(CAST(OLD.IdPet AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPet AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETXPETTREATMENT', CURTIME(), SUBSTR(CAST(OLD.IdPet AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPet AS CHAR), 1, 50), 'IDPET');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdPetTreatment AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPetTreatment AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETXPETTREATMENT', CURTIME(), SUBSTR(CAST(OLD.IdPetTreatment AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPetTreatment AS CHAR), 1, 50), 'IDPETTREATMENT');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_petxpetillness_c939//
-- Auditoria INSERT/DELETE para PetXPetIllness.
CREATE TRIGGER trg_ai_petxpetillness_c939
AFTER INSERT ON PetXPetIllness
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETXPETILLNESS', NULL);
END//

DROP TRIGGER IF EXISTS trg_ad_petxpetillness_b428//
CREATE TRIGGER trg_ad_petxpetillness_b428
AFTER DELETE ON PetXPetIllness
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETXPETILLNESS', NULL);
END//

DROP TRIGGER IF EXISTS trg_au_petxpetillness_e68f//
-- Bitacora UPDATE por campo para PetXPetIllness.
CREATE TRIGGER trg_au_petxpetillness_e68f
AFTER UPDATE ON PetXPetIllness
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(CAST(OLD.IdPet AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPet AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETXPETILLNESS', CURTIME(), SUBSTR(CAST(OLD.IdPet AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPet AS CHAR), 1, 50), 'IDPET');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdPetIllness AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPetIllness AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETXPETILLNESS', CURTIME(), SUBSTR(CAST(OLD.IdPetIllness AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPetIllness AS CHAR), 1, 50), 'IDPETILLNESS');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_petxmedicine_3c23//
-- Auditoria INSERT/DELETE para PetXMedicine.
CREATE TRIGGER trg_ai_petxmedicine_3c23
AFTER INSERT ON PetXMedicine
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETXMEDICINE', NULL);
END//

DROP TRIGGER IF EXISTS trg_ad_petxmedicine_ecdc//
CREATE TRIGGER trg_ad_petxmedicine_ecdc
AFTER DELETE ON PetXMedicine
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETXMEDICINE', NULL);
END//

DROP TRIGGER IF EXISTS trg_au_petxmedicine_3223//
-- Bitacora UPDATE por campo para PetXMedicine.
CREATE TRIGGER trg_au_petxmedicine_3223
AFTER UPDATE ON PetXMedicine
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(CAST(OLD.IdPet AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPet AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETXMEDICINE', CURTIME(), SUBSTR(CAST(OLD.IdPet AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPet AS CHAR), 1, 50), 'IDPET');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdMedicine AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdMedicine AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETXMEDICINE', CURTIME(), SUBSTR(CAST(OLD.IdMedicine AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdMedicine AS CHAR), 1, 50), 'IDMEDICINE');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_petlevelenergyxfos_a393//
-- Auditoria INSERT/DELETE para PetLevelEnergyXFosterHome.
CREATE TRIGGER trg_ai_petlevelenergyxfos_a393
AFTER INSERT ON PetLevelEnergyXFosterHome
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETLEVELENERGYXFOSTERHOME', NULL);
END//

DROP TRIGGER IF EXISTS trg_ad_petlevelenergyxfos_11dd//
CREATE TRIGGER trg_ad_petlevelenergyxfos_11dd
AFTER DELETE ON PetLevelEnergyXFosterHome
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETLEVELENERGYXFOSTERHOME', NULL);
END//

DROP TRIGGER IF EXISTS trg_au_petlevelenergyxfos_04dc//
-- Bitacora UPDATE por campo para PetLevelEnergyXFosterHome.
CREATE TRIGGER trg_au_petlevelenergyxfos_04dc
AFTER UPDATE ON PetLevelEnergyXFosterHome
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(CAST(OLD.IdPetLevelEnergy AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPetLevelEnergy AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETLEVELENERGYXFOSTERHOME', CURTIME(), SUBSTR(CAST(OLD.IdPetLevelEnergy AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPetLevelEnergy AS CHAR), 1, 50), 'IDPETLEVELENERGY');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdFosterHome AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdFosterHome AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETLEVELENERGYXFOSTERHOME', CURTIME(), SUBSTR(CAST(OLD.IdFosterHome AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdFosterHome AS CHAR), 1, 50), 'IDFOSTERHOME');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_spacerequiredxfost_f8f9//
-- Auditoria INSERT/DELETE para SpaceRequiredXFosterHome.
CREATE TRIGGER trg_ai_spacerequiredxfost_f8f9
AFTER INSERT ON SpaceRequiredXFosterHome
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'SPACEREQUIREDXFOSTERHOME', NULL);
END//

DROP TRIGGER IF EXISTS trg_ad_spacerequiredxfost_263d//
CREATE TRIGGER trg_ad_spacerequiredxfost_263d
AFTER DELETE ON SpaceRequiredXFosterHome
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'SPACEREQUIREDXFOSTERHOME', NULL);
END//

DROP TRIGGER IF EXISTS trg_au_spacerequiredxfost_5145//
-- Bitacora UPDATE por campo para SpaceRequiredXFosterHome.
CREATE TRIGGER trg_au_spacerequiredxfost_5145
AFTER UPDATE ON SpaceRequiredXFosterHome
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(CAST(OLD.IdSpaceRequired AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdSpaceRequired AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'SPACEREQUIREDXFOSTERHOME', CURTIME(), SUBSTR(CAST(OLD.IdSpaceRequired AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdSpaceRequired AS CHAR), 1, 50), 'IDSPACEREQUIRED');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdFosterHome AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdFosterHome AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'SPACEREQUIREDXFOSTERHOME', CURTIME(), SUBSTR(CAST(OLD.IdFosterHome AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdFosterHome AS CHAR), 1, 50), 'IDFOSTERHOME');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_foundreport_5377//
-- Auditoria INSERT/DELETE para FoundReport.
CREATE TRIGGER trg_ai_foundreport_5377
AFTER INSERT ON FoundReport
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'FOUNDREPORT', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_foundreport_78f6//
CREATE TRIGGER trg_ad_foundreport_78f6
AFTER DELETE ON FoundReport
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'FOUNDREPORT', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_foundreport_dfdc//
-- Bitacora UPDATE por campo para FoundReport.
CREATE TRIGGER trg_au_foundreport_dfdc
AFTER UPDATE ON FoundReport
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(DATE_FORMAT(OLD.FoundDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') <> COALESCE(SUBSTR(DATE_FORMAT(NEW.FoundDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'FOUNDREPORT', CURTIME(), SUBSTR(DATE_FORMAT(OLD.FoundDate, '%Y-%m-%d %H:%i:%s'), 1, 50), fn_audit_changed_by(), SUBSTR(DATE_FORMAT(NEW.FoundDate, '%Y-%m-%d %H:%i:%s'), 1, 50), 'FOUNDDATE');
    END IF;
    IF COALESCE(SUBSTR(OLD.Place, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Place, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'FOUNDREPORT', CURTIME(), SUBSTR(OLD.Place, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Place, 1, 50), 'PLACE');
    END IF;
    IF COALESCE(SUBSTR(OLD.Description, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Description, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'FOUNDREPORT', CURTIME(), SUBSTR(OLD.Description, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Description, 1, 50), 'DESCRIPTION');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdPet AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPet AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'FOUNDREPORT', CURTIME(), SUBSTR(CAST(OLD.IdPet AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPet AS CHAR), 1, 50), 'IDPET');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdDistrict AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdDistrict AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'FOUNDREPORT', CURTIME(), SUBSTR(CAST(OLD.IdDistrict AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdDistrict AS CHAR), 1, 50), 'IDDISTRICT');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'FOUNDREPORT', CURTIME(), SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), 'IDPERSON');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_petmatch_77fb//
-- Auditoria INSERT/DELETE para PetMatch.
CREATE TRIGGER trg_ai_petmatch_77fb
AFTER INSERT ON PetMatch
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETMATCH', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_petmatch_796d//
CREATE TRIGGER trg_ad_petmatch_796d
AFTER DELETE ON PetMatch
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PETMATCH', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_petmatch_53a7//
-- Bitacora UPDATE por campo para PetMatch.
CREATE TRIGGER trg_au_petmatch_53a7
AFTER UPDATE ON PetMatch
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(CAST(OLD.SimilarityPercentage AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.SimilarityPercentage AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETMATCH', CURTIME(), SUBSTR(CAST(OLD.SimilarityPercentage AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.SimilarityPercentage AS CHAR), 1, 50), 'SIMILARITYPERCENTAGE');
    END IF;
    IF COALESCE(SUBSTR(DATE_FORMAT(OLD.MatchDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') <> COALESCE(SUBSTR(DATE_FORMAT(NEW.MatchDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETMATCH', CURTIME(), SUBSTR(DATE_FORMAT(OLD.MatchDate, '%Y-%m-%d %H:%i:%s'), 1, 50), fn_audit_changed_by(), SUBSTR(DATE_FORMAT(NEW.MatchDate, '%Y-%m-%d %H:%i:%s'), 1, 50), 'MATCHDATE');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdLostReport AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdLostReport AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETMATCH', CURTIME(), SUBSTR(CAST(OLD.IdLostReport AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdLostReport AS CHAR), 1, 50), 'IDLOSTREPORT');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdFoundReport AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdFoundReport AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PETMATCH', CURTIME(), SUBSTR(CAST(OLD.IdFoundReport AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdFoundReport AS CHAR), 1, 50), 'IDFOUNDREPORT');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_lostreport_e08f//
-- Auditoria INSERT/DELETE para LostReport.
CREATE TRIGGER trg_ai_lostreport_e08f
AFTER INSERT ON LostReport
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'LOSTREPORT', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_lostreport_3d71//
CREATE TRIGGER trg_ad_lostreport_3d71
AFTER DELETE ON LostReport
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'LOSTREPORT', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_lostreport_c7dd//
-- Bitacora UPDATE por campo para LostReport.
CREATE TRIGGER trg_au_lostreport_c7dd
AFTER UPDATE ON LostReport
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(DATE_FORMAT(OLD.LostDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') <> COALESCE(SUBSTR(DATE_FORMAT(NEW.LostDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'LOSTREPORT', CURTIME(), SUBSTR(DATE_FORMAT(OLD.LostDate, '%Y-%m-%d %H:%i:%s'), 1, 50), fn_audit_changed_by(), SUBSTR(DATE_FORMAT(NEW.LostDate, '%Y-%m-%d %H:%i:%s'), 1, 50), 'LOSTDATE');
    END IF;
    IF COALESCE(SUBSTR(OLD.Place, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Place, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'LOSTREPORT', CURTIME(), SUBSTR(OLD.Place, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Place, 1, 50), 'PLACE');
    END IF;
    IF COALESCE(SUBSTR(OLD.Description, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Description, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'LOSTREPORT', CURTIME(), SUBSTR(OLD.Description, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Description, 1, 50), 'DESCRIPTION');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.Reward AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.Reward AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'LOSTREPORT', CURTIME(), SUBSTR(CAST(OLD.Reward AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.Reward AS CHAR), 1, 50), 'REWARD');
    END IF;
    IF COALESCE(SUBSTR(OLD.State, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.State, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'LOSTREPORT', CURTIME(), SUBSTR(OLD.State, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.State, 1, 50), 'STATE');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdPet AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPet AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'LOSTREPORT', CURTIME(), SUBSTR(CAST(OLD.IdPet AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPet AS CHAR), 1, 50), 'IDPET');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdDistrict AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdDistrict AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'LOSTREPORT', CURTIME(), SUBSTR(CAST(OLD.IdDistrict AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdDistrict AS CHAR), 1, 50), 'IDDISTRICT');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdCurrency AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdCurrency AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'LOSTREPORT', CURTIME(), SUBSTR(CAST(OLD.IdCurrency AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdCurrency AS CHAR), 1, 50), 'IDCURRENCY');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_adoption_f8e4//
-- Auditoria INSERT/DELETE para Adoption.
CREATE TRIGGER trg_ai_adoption_f8e4
AFTER INSERT ON Adoption
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'ADOPTION', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_adoption_32be//
CREATE TRIGGER trg_ad_adoption_32be
AFTER DELETE ON Adoption
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'ADOPTION', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_adoption_fe61//
-- Bitacora UPDATE por campo para Adoption.
CREATE TRIGGER trg_au_adoption_fe61
AFTER UPDATE ON Adoption
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(DATE_FORMAT(OLD.AdoptionDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') <> COALESCE(SUBSTR(DATE_FORMAT(NEW.AdoptionDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'ADOPTION', CURTIME(), SUBSTR(DATE_FORMAT(OLD.AdoptionDate, '%Y-%m-%d %H:%i:%s'), 1, 50), fn_audit_changed_by(), SUBSTR(DATE_FORMAT(NEW.AdoptionDate, '%Y-%m-%d %H:%i:%s'), 1, 50), 'ADOPTIONDATE');
    END IF;
    IF COALESCE(SUBSTR(DATE_FORMAT(OLD.AvailableDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') <> COALESCE(SUBSTR(DATE_FORMAT(NEW.AvailableDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'ADOPTION', CURTIME(), SUBSTR(DATE_FORMAT(OLD.AvailableDate, '%Y-%m-%d %H:%i:%s'), 1, 50), fn_audit_changed_by(), SUBSTR(DATE_FORMAT(NEW.AvailableDate, '%Y-%m-%d %H:%i:%s'), 1, 50), 'AVAILABLEDATE');
    END IF;
    IF COALESCE(SUBSTR(OLD.Description, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Description, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'ADOPTION', CURTIME(), SUBSTR(OLD.Description, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Description, 1, 50), 'DESCRIPTION');
    END IF;
    IF COALESCE(SUBSTR(OLD.State, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.State, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'ADOPTION', CURTIME(), SUBSTR(OLD.State, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.State, 1, 50), 'STATE');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdPet AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPet AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'ADOPTION', CURTIME(), SUBSTR(CAST(OLD.IdPet AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPet AS CHAR), 1, 50), 'IDPET');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdAdopter AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdAdopter AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'ADOPTION', CURTIME(), SUBSTR(CAST(OLD.IdAdopter AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdAdopter AS CHAR), 1, 50), 'IDADOPTER');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdOwner AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdOwner AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'ADOPTION', CURTIME(), SUBSTR(CAST(OLD.IdOwner AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdOwner AS CHAR), 1, 50), 'IDOWNER');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_rescued_cff6//
-- Auditoria INSERT/DELETE para Rescued.
CREATE TRIGGER trg_ai_rescued_cff6
AFTER INSERT ON Rescued
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'RESCUED', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_rescued_27e7//
CREATE TRIGGER trg_ad_rescued_27e7
AFTER DELETE ON Rescued
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'RESCUED', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_rescued_5c83//
-- Bitacora UPDATE por campo para Rescued.
CREATE TRIGGER trg_au_rescued_5c83
AFTER UPDATE ON Rescued
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(DATE_FORMAT(OLD.RescueDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') <> COALESCE(SUBSTR(DATE_FORMAT(NEW.RescueDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'RESCUED', CURTIME(), SUBSTR(DATE_FORMAT(OLD.RescueDate, '%Y-%m-%d %H:%i:%s'), 1, 50), fn_audit_changed_by(), SUBSTR(DATE_FORMAT(NEW.RescueDate, '%Y-%m-%d %H:%i:%s'), 1, 50), 'RESCUEDATE');
    END IF;
    IF COALESCE(SUBSTR(OLD.Place, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Place, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'RESCUED', CURTIME(), SUBSTR(OLD.Place, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Place, 1, 50), 'PLACE');
    END IF;
    IF COALESCE(SUBSTR(OLD.Description, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Description, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'RESCUED', CURTIME(), SUBSTR(OLD.Description, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Description, 1, 50), 'DESCRIPTION');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdPet AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPet AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'RESCUED', CURTIME(), SUBSTR(CAST(OLD.IdPet AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPet AS CHAR), 1, 50), 'IDPET');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdDistrict AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdDistrict AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'RESCUED', CURTIME(), SUBSTR(CAST(OLD.IdDistrict AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdDistrict AS CHAR), 1, 50), 'IDDISTRICT');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdRescuer AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdRescuer AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'RESCUED', CURTIME(), SUBSTR(CAST(OLD.IdRescuer AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdRescuer AS CHAR), 1, 50), 'IDRESCUER');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdPetSeverity AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPetSeverity AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'RESCUED', CURTIME(), SUBSTR(CAST(OLD.IdPetSeverity AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPetSeverity AS CHAR), 1, 50), 'IDPETSEVERITY');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_donation_2563//
-- Auditoria INSERT/DELETE para Donation.
CREATE TRIGGER trg_ai_donation_2563
AFTER INSERT ON Donation
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'DONATION', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_donation_f454//
CREATE TRIGGER trg_ad_donation_f454
AFTER DELETE ON Donation
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'DONATION', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_donation_0204//
-- Bitacora UPDATE por campo para Donation.
CREATE TRIGGER trg_au_donation_0204
AFTER UPDATE ON Donation
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(CAST(OLD.Amount AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.Amount AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'DONATION', CURTIME(), SUBSTR(CAST(OLD.Amount AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.Amount AS CHAR), 1, 50), 'AMOUNT');
    END IF;
    IF COALESCE(SUBSTR(DATE_FORMAT(OLD.DonationDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') <> COALESCE(SUBSTR(DATE_FORMAT(NEW.DonationDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'DONATION', CURTIME(), SUBSTR(DATE_FORMAT(OLD.DonationDate, '%Y-%m-%d %H:%i:%s'), 1, 50), fn_audit_changed_by(), SUBSTR(DATE_FORMAT(NEW.DonationDate, '%Y-%m-%d %H:%i:%s'), 1, 50), 'DONATIONDATE');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'DONATION', CURTIME(), SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), 'IDPERSON');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdCurrency AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdCurrency AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'DONATION', CURTIME(), SUBSTR(CAST(OLD.IdCurrency AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdCurrency AS CHAR), 1, 50), 'IDCURRENCY');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdAssociation AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdAssociation AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'DONATION', CURTIME(), SUBSTR(CAST(OLD.IdAssociation AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdAssociation AS CHAR), 1, 50), 'IDASSOCIATION');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_currency_92f1//
-- Auditoria INSERT/DELETE para Currency.
CREATE TRIGGER trg_ai_currency_92f1
AFTER INSERT ON Currency
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'CURRENCY', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_currency_cb9f//
CREATE TRIGGER trg_ad_currency_cb9f
AFTER DELETE ON Currency
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'CURRENCY', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_currency_9bbc//
-- Bitacora UPDATE por campo para Currency.
CREATE TRIGGER trg_au_currency_9bbc
AFTER UPDATE ON Currency
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'CURRENCY', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_person_658b//
-- Auditoria INSERT/DELETE para Person.
CREATE TRIGGER trg_ai_person_658b
AFTER INSERT ON Person
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PERSON', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_person_6b2a//
CREATE TRIGGER trg_ad_person_6b2a
AFTER DELETE ON Person
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PERSON', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_person_02b4//
-- Bitacora UPDATE por campo para Person.
CREATE TRIGGER trg_au_person_02b4
AFTER UPDATE ON Person
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.FirstName, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.FirstName, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PERSON', CURTIME(), SUBSTR(OLD.FirstName, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.FirstName, 1, 50), 'FIRSTNAME');
    END IF;
    IF COALESCE(SUBSTR(OLD.LastName, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.LastName, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PERSON', CURTIME(), SUBSTR(OLD.LastName, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.LastName, 1, 50), 'LASTNAME');
    END IF;
    IF COALESCE(SUBSTR(OLD.Password, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Password, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PERSON', CURTIME(), SUBSTR(OLD.Password, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Password, 1, 50), 'PASSWORD');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdDistrict AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdDistrict AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PERSON', CURTIME(), SUBSTR(CAST(OLD.IdDistrict AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdDistrict AS CHAR), 1, 50), 'IDDISTRICT');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_reportlist_670d//
-- Auditoria INSERT/DELETE para ReportList.
CREATE TRIGGER trg_ai_reportlist_670d
AFTER INSERT ON ReportList
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'REPORTLIST', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_reportlist_6fde//
CREATE TRIGGER trg_ad_reportlist_6fde
AFTER DELETE ON ReportList
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'REPORTLIST', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_reportlist_c26a//
-- Bitacora UPDATE por campo para ReportList.
CREATE TRIGGER trg_au_reportlist_c26a
AFTER UPDATE ON ReportList
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Description, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Description, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'REPORTLIST', CURTIME(), SUBSTR(OLD.Description, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Description, 1, 50), 'DESCRIPTION');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'REPORTLIST', CURTIME(), SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), 'IDPERSON');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdReporter AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdReporter AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'REPORTLIST', CURTIME(), SUBSTR(CAST(OLD.IdReporter AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdReporter AS CHAR), 1, 50), 'IDREPORTER');
    END IF;
    IF COALESCE(SUBSTR(DATE_FORMAT(OLD.ReportDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') <> COALESCE(SUBSTR(DATE_FORMAT(NEW.ReportDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'REPORTLIST', CURTIME(), SUBSTR(DATE_FORMAT(OLD.ReportDate, '%Y-%m-%d %H:%i:%s'), 1, 50), fn_audit_changed_by(), SUBSTR(DATE_FORMAT(NEW.ReportDate, '%Y-%m-%d %H:%i:%s'), 1, 50), 'REPORTDATE');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_rescuer_9bc6//
-- Auditoria INSERT/DELETE para Rescuer.
CREATE TRIGGER trg_ai_rescuer_9bc6
AFTER INSERT ON Rescuer
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'RESCUER', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_rescuer_3bc8//
CREATE TRIGGER trg_ad_rescuer_3bc8
AFTER DELETE ON Rescuer
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'RESCUER', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_rescuer_90f6//
-- Bitacora UPDATE por campo para Rescuer.
CREATE TRIGGER trg_au_rescuer_90f6
AFTER UPDATE ON Rescuer
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'RESCUER', CURTIME(), SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), 'IDPERSON');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_adopter_cdfb//
-- Auditoria INSERT/DELETE para Adopter.
CREATE TRIGGER trg_ai_adopter_cdfb
AFTER INSERT ON Adopter
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'ADOPTER', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_adopter_ab7b//
CREATE TRIGGER trg_ad_adopter_ab7b
AFTER DELETE ON Adopter
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'ADOPTER', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_adopter_6134//
-- Bitacora UPDATE por campo para Adopter.
CREATE TRIGGER trg_au_adopter_6134
AFTER UPDATE ON Adopter
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'ADOPTER', CURTIME(), SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), 'IDPERSON');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_calification_153c//
-- Auditoria INSERT/DELETE para Calification.
CREATE TRIGGER trg_ai_calification_153c
AFTER INSERT ON Calification
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'CALIFICATION', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_calification_b98c//
CREATE TRIGGER trg_ad_calification_b98c
AFTER DELETE ON Calification
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'CALIFICATION', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_calification_9938//
-- Bitacora UPDATE por campo para Calification.
CREATE TRIGGER trg_au_calification_9938
AFTER UPDATE ON Calification
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(CAST(OLD.Stars AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.Stars AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'CALIFICATION', CURTIME(), SUBSTR(CAST(OLD.Stars AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.Stars AS CHAR), 1, 50), 'STARS');
    END IF;
    IF COALESCE(SUBSTR(OLD.Note, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Note, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'CALIFICATION', CURTIME(), SUBSTR(OLD.Note, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Note, 1, 50), 'NOTE');
    END IF;
    IF COALESCE(SUBSTR(DATE_FORMAT(OLD.CalificationDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') <> COALESCE(SUBSTR(DATE_FORMAT(NEW.CalificationDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'CALIFICATION', CURTIME(), SUBSTR(DATE_FORMAT(OLD.CalificationDate, '%Y-%m-%d %H:%i:%s'), 1, 50), fn_audit_changed_by(), SUBSTR(DATE_FORMAT(NEW.CalificationDate, '%Y-%m-%d %H:%i:%s'), 1, 50), 'CALIFICATIONDATE');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'CALIFICATION', CURTIME(), SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), 'IDPERSON');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_fosterhome_fd27//
-- Auditoria INSERT/DELETE para FosterHome.
CREATE TRIGGER trg_ai_fosterhome_fd27
AFTER INSERT ON FosterHome
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'FOSTERHOME', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_fosterhome_bfe3//
CREATE TRIGGER trg_ad_fosterhome_bfe3
AFTER DELETE ON FosterHome
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'FOSTERHOME', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_fosterhome_688a//
-- Bitacora UPDATE por campo para FosterHome.
CREATE TRIGGER trg_au_fosterhome_688a
AFTER UPDATE ON FosterHome
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.NeedsDonation, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.NeedsDonation, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'FOSTERHOME', CURTIME(), SUBSTR(OLD.NeedsDonation, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.NeedsDonation, 1, 50), 'NEEDSDONATION');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'FOSTERHOME', CURTIME(), SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), 'IDPERSON');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_admin_3079//
-- Auditoria INSERT/DELETE para Admin.
CREATE TRIGGER trg_ai_admin_3079
AFTER INSERT ON Admin
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'ADMIN', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_admin_0918//
CREATE TRIGGER trg_ad_admin_0918
AFTER DELETE ON Admin
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'ADMIN', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_admin_56b1//
-- Bitacora UPDATE por campo para Admin.
CREATE TRIGGER trg_au_admin_56b1
AFTER UPDATE ON Admin
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'ADMIN', CURTIME(), SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), 'IDPERSON');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_email_e967//
-- Auditoria INSERT/DELETE para Email.
CREATE TRIGGER trg_ai_email_e967
AFTER INSERT ON Email
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'EMAIL', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_email_6e26//
CREATE TRIGGER trg_ad_email_6e26
AFTER DELETE ON Email
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'EMAIL', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_email_ea05//
-- Bitacora UPDATE por campo para Email.
CREATE TRIGGER trg_au_email_ea05
AFTER UPDATE ON Email
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Email, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Email, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'EMAIL', CURTIME(), SUBSTR(OLD.Email, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Email, 1, 50), 'EMAIL');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'EMAIL', CURTIME(), SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), 'IDPERSON');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_phone_7b2c//
-- Auditoria INSERT/DELETE para Phone.
CREATE TRIGGER trg_ai_phone_7b2c
AFTER INSERT ON Phone
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PHONE', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_phone_dfec//
CREATE TRIGGER trg_ad_phone_dfec
AFTER DELETE ON Phone
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PHONE', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_phone_638d//
-- Bitacora UPDATE por campo para Phone.
CREATE TRIGGER trg_au_phone_638d
AFTER UPDATE ON Phone
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(CAST(OLD.Phone AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.Phone AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PHONE', CURTIME(), SUBSTR(CAST(OLD.Phone AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.Phone AS CHAR), 1, 50), 'PHONE');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PHONE', CURTIME(), SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), 'IDPERSON');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_blocklist_4e27//
-- Auditoria INSERT/DELETE para BlockList.
CREATE TRIGGER trg_ai_blocklist_4e27
AFTER INSERT ON BlockList
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'BLOCKLIST', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_blocklist_455e//
CREATE TRIGGER trg_ad_blocklist_455e
AFTER DELETE ON BlockList
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'BLOCKLIST', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_blocklist_0cc3//
-- Bitacora UPDATE por campo para BlockList.
CREATE TRIGGER trg_au_blocklist_0cc3
AFTER UPDATE ON BlockList
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(DATE_FORMAT(OLD.BlockDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') <> COALESCE(SUBSTR(DATE_FORMAT(NEW.BlockDate, '%Y-%m-%d %H:%i:%s'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'BLOCKLIST', CURTIME(), SUBSTR(DATE_FORMAT(OLD.BlockDate, '%Y-%m-%d %H:%i:%s'), 1, 50), fn_audit_changed_by(), SUBSTR(DATE_FORMAT(NEW.BlockDate, '%Y-%m-%d %H:%i:%s'), 1, 50), 'BLOCKDATE');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'BLOCKLIST', CURTIME(), SUBSTR(CAST(OLD.IdPerson AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.IdPerson AS CHAR), 1, 50), 'IDPERSON');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_association_b762//
-- Auditoria INSERT/DELETE para Association.
CREATE TRIGGER trg_ai_association_b762
AFTER INSERT ON Association
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'ASSOCIATION', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_association_6eb7//
CREATE TRIGGER trg_ad_association_6eb7
AFTER DELETE ON Association
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'ASSOCIATION', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_association_b4d9//
-- Bitacora UPDATE por campo para Association.
CREATE TRIGGER trg_au_association_b4d9
AFTER UPDATE ON Association
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'ASSOCIATION', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
    IF COALESCE(SUBSTR(CAST(OLD.PhoneNumber AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.PhoneNumber AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'ASSOCIATION', CURTIME(), SUBSTR(CAST(OLD.PhoneNumber AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.PhoneNumber AS CHAR), 1, 50), 'PHONENUMBER');
    END IF;
    IF COALESCE(SUBSTR(OLD.BankAccount, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.BankAccount, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'ASSOCIATION', CURTIME(), SUBSTR(OLD.BankAccount, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.BankAccount, 1, 50), 'BANKACCOUNT');
    END IF;
    IF COALESCE(SUBSTR(OLD.Email, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Email, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'ASSOCIATION', CURTIME(), SUBSTR(OLD.Email, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Email, 1, 50), 'EMAIL');
    END IF;
END//

DROP TRIGGER IF EXISTS trg_ai_parameter_a324//
-- Auditoria INSERT/DELETE para Parameter.
CREATE TRIGGER trg_ai_parameter_a324
AFTER INSERT ON Parameter
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (NEXT VALUE FOR seq_created, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PARAMETER', NEW.Id);
END//

DROP TRIGGER IF EXISTS trg_ad_parameter_ab70//
CREATE TRIGGER trg_ad_parameter_ab70
AFTER DELETE ON Parameter
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (NEXT VALUE FOR seq_deleted, NOW(), SUBSTRING(CURRENT_USER(), 1, 25), 'PARAMETER', OLD.Id);
END//

DROP TRIGGER IF EXISTS trg_au_parameter_9607//
-- Bitacora UPDATE por campo para Parameter.
CREATE TRIGGER trg_au_parameter_9607
AFTER UPDATE ON Parameter
FOR EACH ROW
BEGIN
    IF COALESCE(SUBSTR(CAST(OLD.Value AS CHAR), 1, 50), '#NULL#') <> COALESCE(SUBSTR(CAST(NEW.Value AS CHAR), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PARAMETER', CURTIME(), SUBSTR(CAST(OLD.Value AS CHAR), 1, 50), fn_audit_changed_by(), SUBSTR(CAST(NEW.Value AS CHAR), 1, 50), 'VALUE');
    END IF;
    IF COALESCE(SUBSTR(OLD.Name, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PARAMETER', CURTIME(), SUBSTR(OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Name, 1, 50), 'NAME');
    END IF;
    IF COALESCE(SUBSTR(OLD.Description, 1, 50), '#NULL#') <> COALESCE(SUBSTR(NEW.Description, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (NEXT VALUE FOR seq_bitacora, 'PARAMETER', CURTIME(), SUBSTR(OLD.Description, 1, 50), fn_audit_changed_by(), SUBSTR(NEW.Description, 1, 50), 'DESCRIPTION');
    END IF;
END//

DELIMITER ;
