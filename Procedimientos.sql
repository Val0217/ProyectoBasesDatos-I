CREATE PROCEDURE insertPerson(pFirst_name IN VARCHAR2, pLast_name IN VARCHAR2, pEmail IN VARCHAR2, pPassword IN VARCHAR2, pUserName IN VARCHAR2, pIdDistrict IN NUMBER)
AS 
BEGIN --> aqui va el comando:
    INSERT INTO Person (Id, FirstName, LastName, Password, UserName, IdDistrict)
    VALUES 
    (s_Person.NEXTVAL,pFirst_name,pLast_name,pPassword,pUserName,pIdDistrict);
    COMMIT;
    INSERT INTO Email (Id, Email, IdPerson) VALUES (s_Email.NEXTVAL, pEmail,  s_Person.Currval);
    COMMIT;
END insertPerson;