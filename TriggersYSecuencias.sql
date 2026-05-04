CREATE SEQUENCE seq_created START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_deleted START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_bitacora START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_parameter START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- Funcion auxiliar para obtener el usuario numerico de la aplicacion.
CREATE OR REPLACE FUNCTION fn_audit_changed_by
RETURN NUMBER
IS
    v_client_identifier VARCHAR2(64);
BEGIN
    v_client_identifier := SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER');

    IF v_client_identifier IS NOT NULL AND REGEXP_LIKE(v_client_identifier, '^[[:digit:]]+$') THEN
        RETURN TO_NUMBER(v_client_identifier);
    END IF;

    RETURN 0;
END;
/

-- Defaults para las tablas de auditoria.
CREATE OR REPLACE TRIGGER trg_bi_created
BEFORE INSERT ON Created
FOR EACH ROW
BEGIN
    IF :NEW.Id IS NULL THEN
        :NEW.Id := seq_created.NEXTVAL;
    END IF;
    IF :NEW.CreatedDate IS NULL THEN
        :NEW.CreatedDate := SYSDATE;
    END IF;
    IF :NEW.CreatedBy IS NULL THEN
        :NEW.CreatedBy := SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_bi_deleted
BEFORE INSERT ON Deleted
FOR EACH ROW
BEGIN
    IF :NEW.Id IS NULL THEN
        :NEW.Id := seq_deleted.NEXTVAL;
    END IF;
    IF :NEW.DeletedDate IS NULL THEN
        :NEW.DeletedDate := SYSDATE;
    END IF;
    IF :NEW.DeletedBy IS NULL THEN
        :NEW.DeletedBy := SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_bi_bitacora
BEFORE INSERT ON Bitacora
FOR EACH ROW
BEGIN
    IF :NEW.Id IS NULL THEN
        :NEW.Id := seq_bitacora.NEXTVAL;
    END IF;
    IF :NEW.ChangeDate IS NULL THEN
        :NEW.ChangeDate := SYSDATE;
    END IF;
    IF :NEW.ChangedBy IS NULL THEN
        :NEW.ChangedBy := fn_audit_changed_by();
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_bi_parameter
BEFORE INSERT ON Parameter
FOR EACH ROW
BEGIN
    IF :NEW.Id IS NULL THEN
        :NEW.Id := seq_parameter.NEXTVAL;
    END IF;
END;
/

-- Auditoria INSERT/DELETE para PetLevelEnergy.
CREATE OR REPLACE TRIGGER trg_ai_petlevelenergy_859a
AFTER INSERT ON PetLevelEnergy
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETLEVELENERGY', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_petlevelenergy_f4e8
AFTER DELETE ON PetLevelEnergy
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETLEVELENERGY', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para PetLevelEnergy.
CREATE OR REPLACE TRIGGER trg_au_petlevelenergy_73f6
AFTER UPDATE ON PetLevelEnergy
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETLEVELENERGY', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para PetBreed.
CREATE OR REPLACE TRIGGER trg_ai_petbreed_137b
AFTER INSERT ON PetBreed
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETBREED', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_petbreed_8b6b
AFTER DELETE ON PetBreed
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETBREED', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para PetBreed.
CREATE OR REPLACE TRIGGER trg_au_petbreed_a52c
AFTER UPDATE ON PetBreed
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETBREED', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para PetType.
CREATE OR REPLACE TRIGGER trg_ai_pettype_6459
AFTER INSERT ON PetType
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETTYPE', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_pettype_64e2
AFTER DELETE ON PetType
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETTYPE', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para PetType.
CREATE OR REPLACE TRIGGER trg_au_pettype_c757
AFTER UPDATE ON PetType
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETTYPE', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para PetState.
CREATE OR REPLACE TRIGGER trg_ai_petstate_d457
AFTER INSERT ON PetState
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETSTATE', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_petstate_5b07
AFTER DELETE ON PetState
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETSTATE', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para PetState.
CREATE OR REPLACE TRIGGER trg_au_petstate_1c4b
AFTER UPDATE ON PetState
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETSTATE', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para PetIllness.
CREATE OR REPLACE TRIGGER trg_ai_petillness_6fc8
AFTER INSERT ON PetIllness
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETILLNESS', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_petillness_22ed
AFTER DELETE ON PetIllness
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETILLNESS', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para PetIllness.
CREATE OR REPLACE TRIGGER trg_au_petillness_c514
AFTER UPDATE ON PetIllness
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETILLNESS', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
    IF NVL(SUBSTR(:OLD.Description, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Description, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETILLNESS', SYSDATE, SUBSTR(:OLD.Description, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Description, 1, 50), 'DESCRIPTION');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Medicine.
CREATE OR REPLACE TRIGGER trg_ai_medicine_28ef
AFTER INSERT ON Medicine
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'MEDICINE', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_medicine_d38f
AFTER DELETE ON Medicine
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'MEDICINE', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Medicine.
CREATE OR REPLACE TRIGGER trg_au_medicine_9f01
AFTER UPDATE ON Medicine
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'MEDICINE', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
    IF NVL(SUBSTR(:OLD.Dose, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Dose, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'MEDICINE', SYSDATE, SUBSTR(:OLD.Dose, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Dose, 1, 50), 'DOSE');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para PetTreatment.
CREATE OR REPLACE TRIGGER trg_ai_pettreatment_3fc5
AFTER INSERT ON PetTreatment
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETTREATMENT', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_pettreatment_7c1f
AFTER DELETE ON PetTreatment
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETTREATMENT', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para PetTreatment.
CREATE OR REPLACE TRIGGER trg_au_pettreatment_8ee6
AFTER UPDATE ON PetTreatment
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETTREATMENT', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
    IF NVL(SUBSTR(:OLD.Description, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Description, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETTREATMENT', SYSDATE, SUBSTR(:OLD.Description, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Description, 1, 50), 'DESCRIPTION');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para PetTraining.
CREATE OR REPLACE TRIGGER trg_ai_pettraining_33f2
AFTER INSERT ON PetTraining
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETTRAINING', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_pettraining_3de1
AFTER DELETE ON PetTraining
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETTRAINING', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para PetTraining.
CREATE OR REPLACE TRIGGER trg_au_pettraining_7d11
AFTER UPDATE ON PetTraining
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETTRAINING', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
END;
/



-- Auditoria INSERT/DELETE para SpaceRequired.
CREATE OR REPLACE TRIGGER trg_ai_spacerequired_1398
AFTER INSERT ON SpaceRequired
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'SPACEREQUIRED', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_spacerequired_afac
AFTER DELETE ON SpaceRequired
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'SPACEREQUIRED', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para SpaceRequired.
CREATE OR REPLACE TRIGGER trg_au_spacerequired_3d0b
AFTER UPDATE ON SpaceRequired
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'SPACEREQUIRED', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para PetSize.
CREATE OR REPLACE TRIGGER trg_ai_petsize_3a07
AFTER INSERT ON PetSize
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETSIZE', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_petsize_1652
AFTER DELETE ON PetSize
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETSIZE', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para PetSize.
CREATE OR REPLACE TRIGGER trg_au_petsize_3eb3
AFTER UPDATE ON PetSize
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETSIZE', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para District.
CREATE OR REPLACE TRIGGER trg_ai_district_2ed4
AFTER INSERT ON District
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'DISTRICT', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_district_ac4e
AFTER DELETE ON District
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'DISTRICT', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para District.
CREATE OR REPLACE TRIGGER trg_au_district_9740
AFTER UPDATE ON District
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'DISTRICT', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdCanton), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdCanton), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'DISTRICT', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdCanton), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdCanton), 1, 50), 'IDCANTON');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Canton.
CREATE OR REPLACE TRIGGER trg_ai_canton_e148
AFTER INSERT ON Canton
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'CANTON', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_canton_fc00
AFTER DELETE ON Canton
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'CANTON', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Canton.
CREATE OR REPLACE TRIGGER trg_au_canton_1c20
AFTER UPDATE ON Canton
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'CANTON', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdProvince), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdProvince), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'CANTON', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdProvince), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdProvince), 1, 50), 'IDPROVINCE');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Province.
CREATE OR REPLACE TRIGGER trg_ai_province_7624
AFTER INSERT ON Province
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PROVINCE', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_province_a7ca
AFTER DELETE ON Province
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PROVINCE', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Province.
CREATE OR REPLACE TRIGGER trg_au_province_3dd8
AFTER UPDATE ON Province
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PROVINCE', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdCountry), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdCountry), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PROVINCE', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdCountry), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdCountry), 1, 50), 'IDCOUNTRY');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Country.
CREATE OR REPLACE TRIGGER trg_ai_country_1dca
AFTER INSERT ON Country
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'COUNTRY', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_country_1060
AFTER DELETE ON Country
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'COUNTRY', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Country.
CREATE OR REPLACE TRIGGER trg_au_country_580c
AFTER UPDATE ON Country
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'COUNTRY', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para PetSeverity.
CREATE OR REPLACE TRIGGER trg_ai_petseverity_0d57
AFTER INSERT ON PetSeverity
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETSEVERITY', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_petseverity_f33f
AFTER DELETE ON PetSeverity
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETSEVERITY', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para PetSeverity.
CREATE OR REPLACE TRIGGER trg_au_petseverity_8938
AFTER UPDATE ON PetSeverity
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETSEVERITY', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Pet.
CREATE OR REPLACE TRIGGER trg_ai_pet_46b7
AFTER INSERT ON Pet
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PET', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_pet_839f
AFTER DELETE ON Pet
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PET', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Pet.
CREATE OR REPLACE TRIGGER trg_au_pet_38db
AFTER UPDATE ON Pet
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Color, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Color, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PET', SYSDATE, SUBSTR(:OLD.Color, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Color, 1, 50), 'COLOR');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.Age), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.Age), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PET', SYSDATE, SUBSTR(TO_CHAR(:OLD.Age), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.Age), 1, 50), 'AGE');
    END IF;
    IF NVL(SUBSTR(:OLD.Description, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Description, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PET', SYSDATE, SUBSTR(:OLD.Description, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Description, 1, 50), 'DESCRIPTION');
    END IF;
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PET', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
    IF NVL(SUBSTR(:OLD.Chip, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Chip, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PET', SYSDATE, SUBSTR(:OLD.Chip, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Chip, 1, 50), 'CHIP');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdEnergy), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdEnergy), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PET', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdEnergy), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdEnergy), 1, 50), 'IDENERGY');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdState), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdState), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PET', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdState), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdState), 1, 50), 'IDSTATE');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdType), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdType), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PET', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdType), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdType), 1, 50), 'IDTYPE');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdBreed), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdBreed), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PET', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdBreed), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdBreed), 1, 50), 'IDBREED');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdDistrict), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdDistrict), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PET', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdDistrict), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdDistrict), 1, 50), 'IDDISTRICT');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdSpace), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdSpace), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PET', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdSpace), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdSpace), 1, 50), 'IDSPACE');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPetTraining), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPetTraining), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PET', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPetTraining), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPetTraining), 1, 50), 'IDPETTRAINING');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdSize), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdSize), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PET', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdSize), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdSize), 1, 50), 'IDSIZE');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdOwner), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdOwner), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PET', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdOwner), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdOwner), 1, 50), 'IDOWNER');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdVeterinarian), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdVeterinarian), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PET', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdVeterinarian), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdVeterinarian), 1, 50), 'IDVETERINARIAN');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Veterinarian.
CREATE OR REPLACE TRIGGER trg_ai_veterinarian_e5d6
AFTER INSERT ON Veterinarian
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'VETERINARIAN', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_veterinarian_930c
AFTER DELETE ON Veterinarian
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'VETERINARIAN', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Veterinarian.
CREATE OR REPLACE TRIGGER trg_au_veterinarian_d85a
AFTER UPDATE ON Veterinarian
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Email, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Email, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'VETERINARIAN', SYSDATE, SUBSTR(:OLD.Email, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Email, 1, 50), 'EMAIL');
    END IF;
    IF NVL(SUBSTR(:OLD.FirstName, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.FirstName, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'VETERINARIAN', SYSDATE, SUBSTR(:OLD.FirstName, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.FirstName, 1, 50), 'FIRSTNAME');
    END IF;
    IF NVL(SUBSTR(:OLD.LastName, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.LastName, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'VETERINARIAN', SYSDATE, SUBSTR(:OLD.LastName, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.LastName, 1, 50), 'LASTNAME');
    END IF;
    IF NVL(SUBSTR(:OLD.Location, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Location, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'VETERINARIAN', SYSDATE, SUBSTR(:OLD.Location, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Location, 1, 50), 'LOCATION');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdDristrict), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdDristrict), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'VETERINARIAN', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdDristrict), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdDristrict), 1, 50), 'IDDRISTRICT');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.Phone), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.Phone), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'VETERINARIAN', SYSDATE, SUBSTR(TO_CHAR(:OLD.Phone), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.Phone), 1, 50), 'PHONE');
    END IF;
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'VETERINARIAN', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para PetSizeXFosterHome.
CREATE OR REPLACE TRIGGER trg_ai_petsizexfosterhome_b6e6
AFTER INSERT ON PetSizeXFosterHome
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETSIZEXFOSTERHOME', NULL);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_petsizexfosterhome_72b9
AFTER DELETE ON PetSizeXFosterHome
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETSIZEXFOSTERHOME', NULL);
END;
/

-- Bitacora UPDATE por campo para PetSizeXFosterHome.
CREATE OR REPLACE TRIGGER trg_au_petsizexfosterhome_1f69
AFTER UPDATE ON PetSizeXFosterHome
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPetSize), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPetSize), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETSIZEXFOSTERHOME', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPetSize), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPetSize), 1, 50), 'IDPETSIZE');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdFosterHome), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdFosterHome), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETSIZEXFOSTERHOME', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdFosterHome), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdFosterHome), 1, 50), 'IDFOSTERHOME');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para PetXPetTreatment.
CREATE OR REPLACE TRIGGER trg_ai_petxpettreatment_33e0
AFTER INSERT ON PetXPetTreatment
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETXPETTREATMENT', NULL);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_petxpettreatment_c90a
AFTER DELETE ON PetXPetTreatment
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETXPETTREATMENT', NULL);
END;
/

-- Bitacora UPDATE por campo para PetXPetTreatment.
CREATE OR REPLACE TRIGGER trg_au_petxpettreatment_11bf
AFTER UPDATE ON PetXPetTreatment
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPet), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPet), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETXPETTREATMENT', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPet), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPet), 1, 50), 'IDPET');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPetTreatment), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPetTreatment), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETXPETTREATMENT', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPetTreatment), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPetTreatment), 1, 50), 'IDPETTREATMENT');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para PetXPetIllness.
CREATE OR REPLACE TRIGGER trg_ai_petxpetillness_c939
AFTER INSERT ON PetXPetIllness
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETXPETILLNESS', NULL);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_petxpetillness_b428
AFTER DELETE ON PetXPetIllness
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETXPETILLNESS', NULL);
END;
/

-- Bitacora UPDATE por campo para PetXPetIllness.
CREATE OR REPLACE TRIGGER trg_au_petxpetillness_e68f
AFTER UPDATE ON PetXPetIllness
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPet), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPet), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETXPETILLNESS', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPet), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPet), 1, 50), 'IDPET');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPetIllness), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPetIllness), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETXPETILLNESS', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPetIllness), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPetIllness), 1, 50), 'IDPETILLNESS');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para PetXMedicine.
CREATE OR REPLACE TRIGGER trg_ai_petxmedicine_3c23
AFTER INSERT ON PetXMedicine
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETXMEDICINE', NULL);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_petxmedicine_ecdc
AFTER DELETE ON PetXMedicine
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETXMEDICINE', NULL);
END;
/

-- Bitacora UPDATE por campo para PetXMedicine.
CREATE OR REPLACE TRIGGER trg_au_petxmedicine_3223
AFTER UPDATE ON PetXMedicine
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPet), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPet), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETXMEDICINE', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPet), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPet), 1, 50), 'IDPET');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdMedicine), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdMedicine), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETXMEDICINE', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdMedicine), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdMedicine), 1, 50), 'IDMEDICINE');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para PetLevelEnergyXFosterHome.
CREATE OR REPLACE TRIGGER trg_ai_petlevelenergyxfos_a393
AFTER INSERT ON PetLevelEnergyXFosterHome
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETLEVELENERGYXFOSTERHOME', NULL);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_petlevelenergyxfos_11dd
AFTER DELETE ON PetLevelEnergyXFosterHome
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETLEVELENERGYXFOSTERHOME', NULL);
END;
/

-- Bitacora UPDATE por campo para PetLevelEnergyXFosterHome.
CREATE OR REPLACE TRIGGER trg_au_petlevelenergyxfos_04dc
AFTER UPDATE ON PetLevelEnergyXFosterHome
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPetLevelEnergy), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPetLevelEnergy), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETLEVELENERGYXFOSTERHOME', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPetLevelEnergy), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPetLevelEnergy), 1, 50), 'IDPETLEVELENERGY');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdFosterHome), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdFosterHome), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETLEVELENERGYXFOSTERHOME', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdFosterHome), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdFosterHome), 1, 50), 'IDFOSTERHOME');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para SpaceRequiredXFosterHome.
CREATE OR REPLACE TRIGGER trg_ai_spacerequiredxfost_f8f9
AFTER INSERT ON SpaceRequiredXFosterHome
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'SPACEREQUIREDXFOSTERHOME', NULL);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_spacerequiredxfost_263d
AFTER DELETE ON SpaceRequiredXFosterHome
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'SPACEREQUIREDXFOSTERHOME', NULL);
END;
/

-- Bitacora UPDATE por campo para SpaceRequiredXFosterHome.
CREATE OR REPLACE TRIGGER trg_au_spacerequiredxfost_5145
AFTER UPDATE ON SpaceRequiredXFosterHome
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdSpaceRequired), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdSpaceRequired), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'SPACEREQUIREDXFOSTERHOME', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdSpaceRequired), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdSpaceRequired), 1, 50), 'IDSPACEREQUIRED');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdFosterHome), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdFosterHome), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'SPACEREQUIREDXFOSTERHOME', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdFosterHome), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdFosterHome), 1, 50), 'IDFOSTERHOME');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para FoundReport.
CREATE OR REPLACE TRIGGER trg_ai_foundreport_5377
AFTER INSERT ON FoundReport
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'FOUNDREPORT', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_foundreport_78f6
AFTER DELETE ON FoundReport
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'FOUNDREPORT', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para FoundReport.
CREATE OR REPLACE TRIGGER trg_au_foundreport_dfdc
AFTER UPDATE ON FoundReport
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.FoundDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.FoundDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'FOUNDREPORT', SYSDATE, SUBSTR(TO_CHAR(:OLD.FoundDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.FoundDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), 'FOUNDDATE');
    END IF;
    IF NVL(SUBSTR(:OLD.Place, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Place, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'FOUNDREPORT', SYSDATE, SUBSTR(:OLD.Place, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Place, 1, 50), 'PLACE');
    END IF;
    IF NVL(SUBSTR(:OLD.Description, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Description, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'FOUNDREPORT', SYSDATE, SUBSTR(:OLD.Description, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Description, 1, 50), 'DESCRIPTION');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPet), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPet), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'FOUNDREPORT', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPet), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPet), 1, 50), 'IDPET');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdDistrict), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdDistrict), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'FOUNDREPORT', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdDistrict), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdDistrict), 1, 50), 'IDDISTRICT');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'FOUNDREPORT', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), 'IDPERSON');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para PetMatch.
CREATE OR REPLACE TRIGGER trg_ai_petmatch_77fb
AFTER INSERT ON PetMatch
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETMATCH', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_petmatch_796d
AFTER DELETE ON PetMatch
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PETMATCH', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para PetMatch.
CREATE OR REPLACE TRIGGER trg_au_petmatch_53a7
AFTER UPDATE ON PetMatch
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.SimilarityPercentage), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.SimilarityPercentage), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETMATCH', SYSDATE, SUBSTR(TO_CHAR(:OLD.SimilarityPercentage), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.SimilarityPercentage), 1, 50), 'SIMILARITYPERCENTAGE');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.MatchDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.MatchDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETMATCH', SYSDATE, SUBSTR(TO_CHAR(:OLD.MatchDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.MatchDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), 'MATCHDATE');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdLostReport), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdLostReport), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETMATCH', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdLostReport), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdLostReport), 1, 50), 'IDLOSTREPORT');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdFoundReport), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdFoundReport), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PETMATCH', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdFoundReport), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdFoundReport), 1, 50), 'IDFOUNDREPORT');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para LostReport.
CREATE OR REPLACE TRIGGER trg_ai_lostreport_e08f
AFTER INSERT ON LostReport
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'LOSTREPORT', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_lostreport_3d71
AFTER DELETE ON LostReport
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'LOSTREPORT', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para LostReport.
CREATE OR REPLACE TRIGGER trg_au_lostreport_c7dd
AFTER UPDATE ON LostReport
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.LostDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.LostDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'LOSTREPORT', SYSDATE, SUBSTR(TO_CHAR(:OLD.LostDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.LostDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), 'LOSTDATE');
    END IF;
    IF NVL(SUBSTR(:OLD.Place, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Place, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'LOSTREPORT', SYSDATE, SUBSTR(:OLD.Place, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Place, 1, 50), 'PLACE');
    END IF;
    IF NVL(SUBSTR(:OLD.Description, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Description, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'LOSTREPORT', SYSDATE, SUBSTR(:OLD.Description, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Description, 1, 50), 'DESCRIPTION');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.Reward), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.Reward), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'LOSTREPORT', SYSDATE, SUBSTR(TO_CHAR(:OLD.Reward), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.Reward), 1, 50), 'REWARD');
    END IF;
    IF NVL(SUBSTR(:OLD.State, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.State, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'LOSTREPORT', SYSDATE, SUBSTR(:OLD.State, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.State, 1, 50), 'STATE');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPet), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPet), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'LOSTREPORT', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPet), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPet), 1, 50), 'IDPET');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdDistrict), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdDistrict), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'LOSTREPORT', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdDistrict), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdDistrict), 1, 50), 'IDDISTRICT');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdCurrency), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdCurrency), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'LOSTREPORT', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdCurrency), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdCurrency), 1, 50), 'IDCURRENCY');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Adoption.
CREATE OR REPLACE TRIGGER trg_ai_adoption_f8e4
AFTER INSERT ON Adoption
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'ADOPTION', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_adoption_32be
AFTER DELETE ON Adoption
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'ADOPTION', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Adoption.
CREATE OR REPLACE TRIGGER trg_au_adoption_fe61
AFTER UPDATE ON Adoption
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.AdoptionDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.AdoptionDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'ADOPTION', SYSDATE, SUBSTR(TO_CHAR(:OLD.AdoptionDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.AdoptionDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), 'ADOPTIONDATE');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.AvailableDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.AvailableDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'ADOPTION', SYSDATE, SUBSTR(TO_CHAR(:OLD.AvailableDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.AvailableDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), 'AVAILABLEDATE');
    END IF;
    IF NVL(SUBSTR(:OLD.Description, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Description, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'ADOPTION', SYSDATE, SUBSTR(:OLD.Description, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Description, 1, 50), 'DESCRIPTION');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.Amount), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.Amount), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'ADOPTION', SYSDATE, SUBSTR(TO_CHAR(:OLD.Amount), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.Amount), 1, 50), 'AMOUNT');
    END IF;
    IF NVL(SUBSTR(:OLD.State, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.State, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'ADOPTION', SYSDATE, SUBSTR(:OLD.State, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.State, 1, 50), 'STATE');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPet), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPet), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'ADOPTION', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPet), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPet), 1, 50), 'IDPET');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdAdopter), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdAdopter), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'ADOPTION', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdAdopter), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdAdopter), 1, 50), 'IDADOPTER');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdOwner), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdOwner), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'ADOPTION', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdOwner), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdOwner), 1, 50), 'IDOWNER');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Rescued.
CREATE OR REPLACE TRIGGER trg_ai_rescued_cff6
AFTER INSERT ON Rescued
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'RESCUED', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_rescued_27e7
AFTER DELETE ON Rescued
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'RESCUED', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Rescued.
CREATE OR REPLACE TRIGGER trg_au_rescued_5c83
AFTER UPDATE ON Rescued
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.RescueDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.RescueDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'RESCUED', SYSDATE, SUBSTR(TO_CHAR(:OLD.RescueDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.RescueDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), 'RESCUEDATE');
    END IF;
    IF NVL(SUBSTR(:OLD.Place, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Place, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'RESCUED', SYSDATE, SUBSTR(:OLD.Place, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Place, 1, 50), 'PLACE');
    END IF;
    IF NVL(SUBSTR(:OLD.Description, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Description, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'RESCUED', SYSDATE, SUBSTR(:OLD.Description, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Description, 1, 50), 'DESCRIPTION');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPet), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPet), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'RESCUED', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPet), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPet), 1, 50), 'IDPET');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdDistrict), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdDistrict), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'RESCUED', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdDistrict), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdDistrict), 1, 50), 'IDDISTRICT');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdRescuer), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdRescuer), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'RESCUED', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdRescuer), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdRescuer), 1, 50), 'IDRESCUER');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPetSeverity), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPetSeverity), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'RESCUED', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPetSeverity), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPetSeverity), 1, 50), 'IDPETSEVERITY');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Donation.
CREATE OR REPLACE TRIGGER trg_ai_donation_2563
AFTER INSERT ON Donation
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'DONATION', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_donation_f454
AFTER DELETE ON Donation
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'DONATION', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Donation.
CREATE OR REPLACE TRIGGER trg_au_donation_0204
AFTER UPDATE ON Donation
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.Amount), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.Amount), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'DONATION', SYSDATE, SUBSTR(TO_CHAR(:OLD.Amount), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.Amount), 1, 50), 'AMOUNT');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.DonationDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.DonationDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'DONATION', SYSDATE, SUBSTR(TO_CHAR(:OLD.DonationDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.DonationDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), 'DONATIONDATE');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'DONATION', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), 'IDPERSON');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdCurrency), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdCurrency), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'DONATION', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdCurrency), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdCurrency), 1, 50), 'IDCURRENCY');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdAssociation), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdAssociation), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'DONATION', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdAssociation), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdAssociation), 1, 50), 'IDASSOCIATION');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Currency.
CREATE OR REPLACE TRIGGER trg_ai_currency_92f1
AFTER INSERT ON Currency
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'CURRENCY', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_currency_cb9f
AFTER DELETE ON Currency
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'CURRENCY', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Currency.
CREATE OR REPLACE TRIGGER trg_au_currency_9bbc
AFTER UPDATE ON Currency
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'CURRENCY', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Person.
CREATE OR REPLACE TRIGGER trg_ai_person_658b
AFTER INSERT ON Person
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PERSON', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_person_6b2a
AFTER DELETE ON Person
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PERSON', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Person.
CREATE OR REPLACE TRIGGER trg_au_person_02b4
AFTER UPDATE ON Person
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.FirstName, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.FirstName, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PERSON', SYSDATE, SUBSTR(:OLD.FirstName, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.FirstName, 1, 50), 'FIRSTNAME');
    END IF;
    IF NVL(SUBSTR(:OLD.LastName, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.LastName, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PERSON', SYSDATE, SUBSTR(:OLD.LastName, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.LastName, 1, 50), 'LASTNAME');
    END IF;
    IF NVL(SUBSTR(:OLD.Password, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Password, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PERSON', SYSDATE, SUBSTR(:OLD.Password, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Password, 1, 50), 'PASSWORD');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdDistrict), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdDistrict), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PERSON', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdDistrict), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdDistrict), 1, 50), 'IDDISTRICT');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para ReportList.
CREATE OR REPLACE TRIGGER trg_ai_reportlist_670d
AFTER INSERT ON ReportList
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'REPORTLIST', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_reportlist_6fde
AFTER DELETE ON ReportList
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'REPORTLIST', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para ReportList.
CREATE OR REPLACE TRIGGER trg_au_reportlist_c26a
AFTER UPDATE ON ReportList
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Description, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Description, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'REPORTLIST', SYSDATE, SUBSTR(:OLD.Description, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Description, 1, 50), 'DESCRIPTION');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'REPORTLIST', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), 'IDPERSON');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdReporter), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdReporter), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'REPORTLIST', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdReporter), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdReporter), 1, 50), 'IDREPORTER');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.ReportDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.ReportDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'REPORTLIST', SYSDATE, SUBSTR(TO_CHAR(:OLD.ReportDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.ReportDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), 'REPORTDATE');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Rescuer.
CREATE OR REPLACE TRIGGER trg_ai_rescuer_9bc6
AFTER INSERT ON Rescuer
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'RESCUER', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_rescuer_3bc8
AFTER DELETE ON Rescuer
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'RESCUER', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Rescuer.
CREATE OR REPLACE TRIGGER trg_au_rescuer_90f6
AFTER UPDATE ON Rescuer
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'RESCUER', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), 'IDPERSON');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Adopter.
CREATE OR REPLACE TRIGGER trg_ai_adopter_cdfb
AFTER INSERT ON Adopter
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'ADOPTER', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_adopter_ab7b
AFTER DELETE ON Adopter
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'ADOPTER', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Adopter.
CREATE OR REPLACE TRIGGER trg_au_adopter_6134
AFTER UPDATE ON Adopter
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'ADOPTER', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), 'IDPERSON');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Calification.
CREATE OR REPLACE TRIGGER trg_ai_calification_153c
AFTER INSERT ON Calification
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'CALIFICATION', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_calification_b98c
AFTER DELETE ON Calification
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'CALIFICATION', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Calification.
CREATE OR REPLACE TRIGGER trg_au_calification_9938
AFTER UPDATE ON Calification
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.Stars), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.Stars), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'CALIFICATION', SYSDATE, SUBSTR(TO_CHAR(:OLD.Stars), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.Stars), 1, 50), 'STARS');
    END IF;
    IF NVL(SUBSTR(:OLD.Note, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Note, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'CALIFICATION', SYSDATE, SUBSTR(:OLD.Note, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Note, 1, 50), 'NOTE');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.CalificationDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.CalificationDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'CALIFICATION', SYSDATE, SUBSTR(TO_CHAR(:OLD.CalificationDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.CalificationDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), 'CALIFICATIONDATE');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'CALIFICATION', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), 'IDPERSON');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para FosterHome.
CREATE OR REPLACE TRIGGER trg_ai_fosterhome_fd27
AFTER INSERT ON FosterHome
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'FOSTERHOME', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_fosterhome_bfe3
AFTER DELETE ON FosterHome
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'FOSTERHOME', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para FosterHome.
CREATE OR REPLACE TRIGGER trg_au_fosterhome_688a
AFTER UPDATE ON FosterHome
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.NeedsDonation, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.NeedsDonation, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'FOSTERHOME', SYSDATE, SUBSTR(:OLD.NeedsDonation, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.NeedsDonation, 1, 50), 'NEEDSDONATION');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'FOSTERHOME', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), 'IDPERSON');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Admin.
CREATE OR REPLACE TRIGGER trg_ai_admin_3079
AFTER INSERT ON Admin
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'ADMIN', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_admin_0918
AFTER DELETE ON Admin
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'ADMIN', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Admin.
CREATE OR REPLACE TRIGGER trg_au_admin_56b1
AFTER UPDATE ON Admin
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'ADMIN', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), 'IDPERSON');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Email.
CREATE OR REPLACE TRIGGER trg_ai_email_e967
AFTER INSERT ON Email
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'EMAIL', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_email_6e26
AFTER DELETE ON Email
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'EMAIL', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Email.
CREATE OR REPLACE TRIGGER trg_au_email_ea05
AFTER UPDATE ON Email
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Email, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Email, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'EMAIL', SYSDATE, SUBSTR(:OLD.Email, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Email, 1, 50), 'EMAIL');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'EMAIL', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), 'IDPERSON');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Phone.
CREATE OR REPLACE TRIGGER trg_ai_phone_7b2c
AFTER INSERT ON Phone
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PHONE', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_phone_dfec
AFTER DELETE ON Phone
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PHONE', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Phone.
CREATE OR REPLACE TRIGGER trg_au_phone_638d
AFTER UPDATE ON Phone
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.Phone), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.Phone), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PHONE', SYSDATE, SUBSTR(TO_CHAR(:OLD.Phone), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.Phone), 1, 50), 'PHONE');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PHONE', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), 'IDPERSON');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para BlockList.
CREATE OR REPLACE TRIGGER trg_ai_blocklist_4e27
AFTER INSERT ON BlockList
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'BLOCKLIST', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_blocklist_455e
AFTER DELETE ON BlockList
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'BLOCKLIST', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para BlockList.
CREATE OR REPLACE TRIGGER trg_au_blocklist_0cc3
AFTER UPDATE ON BlockList
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.BlockDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.BlockDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'BLOCKLIST', SYSDATE, SUBSTR(TO_CHAR(:OLD.BlockDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.BlockDate, 'YYYY-MM-DD HH24:MI:SS'), 1, 50), 'BLOCKDATE');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'BLOCKLIST', SYSDATE, SUBSTR(TO_CHAR(:OLD.IdPerson), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.IdPerson), 1, 50), 'IDPERSON');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Association.
CREATE OR REPLACE TRIGGER trg_ai_association_b762
AFTER INSERT ON Association
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'ASSOCIATION', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_association_6eb7
AFTER DELETE ON Association
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'ASSOCIATION', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Association.
CREATE OR REPLACE TRIGGER trg_au_association_b4d9
AFTER UPDATE ON Association
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'ASSOCIATION', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
    IF NVL(SUBSTR(TO_CHAR(:OLD.PhoneNumber), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.PhoneNumber), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'ASSOCIATION', SYSDATE, SUBSTR(TO_CHAR(:OLD.PhoneNumber), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.PhoneNumber), 1, 50), 'PHONENUMBER');
    END IF;
    IF NVL(SUBSTR(:OLD.BankAccount, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.BankAccount, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'ASSOCIATION', SYSDATE, SUBSTR(:OLD.BankAccount, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.BankAccount, 1, 50), 'BANKACCOUNT');
    END IF;
    IF NVL(SUBSTR(:OLD.Email, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Email, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'ASSOCIATION', SYSDATE, SUBSTR(:OLD.Email, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Email, 1, 50), 'EMAIL');
    END IF;
END;
/

-- Auditoria INSERT/DELETE para Parameter.
CREATE OR REPLACE TRIGGER trg_ai_parameter_a324
AFTER INSERT ON Parameter
FOR EACH ROW
BEGIN
    INSERT INTO Created (Id, CreatedDate, CreatedBy, TableName, CreatedId)
    VALUES (seq_created.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PARAMETER', :NEW.Id);
END;
/

CREATE OR REPLACE TRIGGER trg_ad_parameter_ab70
AFTER DELETE ON Parameter
FOR EACH ROW
BEGIN
    INSERT INTO Deleted (Id, DeletedDate, DeletedBy, TableName, DeletedId)
    VALUES (seq_deleted.NEXTVAL, SYSDATE, SUBSTR(SYS_CONTEXT('USERENV', 'SESSION_USER'), 1, 25), 'PARAMETER', :OLD.Id);
END;
/

-- Bitacora UPDATE por campo para Parameter.
CREATE OR REPLACE TRIGGER trg_au_parameter_9607
AFTER UPDATE ON Parameter
FOR EACH ROW
BEGIN
    IF NVL(SUBSTR(TO_CHAR(:OLD.Value), 1, 50), '#NULL#') <> NVL(SUBSTR(TO_CHAR(:NEW.Value), 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PARAMETER', SYSDATE, SUBSTR(TO_CHAR(:OLD.Value), 1, 50), fn_audit_changed_by(), SUBSTR(TO_CHAR(:NEW.Value), 1, 50), 'VALUE');
    END IF;
    IF NVL(SUBSTR(:OLD.Name, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Name, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PARAMETER', SYSDATE, SUBSTR(:OLD.Name, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Name, 1, 50), 'NAME');
    END IF;
    IF NVL(SUBSTR(:OLD.Description, 1, 50), '#NULL#') <> NVL(SUBSTR(:NEW.Description, 1, 50), '#NULL#') THEN
        INSERT INTO Bitacora (Id, TableName, ChangeDate, PreviousValue, ChangedBy, CurrentValue, FieldName)
        VALUES (seq_bitacora.NEXTVAL, 'PARAMETER', SYSDATE, SUBSTR(:OLD.Description, 1, 50), fn_audit_changed_by(), SUBSTR(:NEW.Description, 1, 50), 'DESCRIPTION');
    END IF;
END;
/