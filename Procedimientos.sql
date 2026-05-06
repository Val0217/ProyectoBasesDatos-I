CREATE OR REPLACE PROCEDURE insertPerson(pFirst_name IN VARCHAR2, pLast_name IN VARCHAR2, pEmail IN VARCHAR2, pPassword IN VARCHAR2, pUserName IN VARCHAR2, pIdDistrict IN NUMBER, pPhoneNumber IN NUMBER)
AS 
    vcIdPerson NUMBER(8);
BEGIN --> aqui va el comando:
    --> guardamos el Id solo una vez para no estar llamando a s_Person.
    vcIdPerson := s_Person.NEXTVAL;
    
    INSERT INTO Person (Id, FirstName, LastName, Password, UserName, IdDistrict)
    VALUES 
    (vcIdPerson,pFirst_name,pLast_name,pPassword,pUserName,pIdDistrict);

    INSERT INTO Email (Id, Email, IdPerson) 
    VALUES 
    (s_Email.NEXTVAL, pEmail, vcIdPerson);

    INSERT INTO Phone (Id, Phone, IdPerson) 
    VALUES 
    (s_Phone.NEXTVAL, pPhoneNumber, vcIdPerson);

    COMMIT;
END insertPerson;