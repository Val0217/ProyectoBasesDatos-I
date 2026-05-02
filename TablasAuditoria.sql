CREATE TABLE AuditDeleted (
    Id           NUMBER PRIMARY KEY,
    DeletedDate DATE DEFAULT SYSDATE,
    DeletedBy   VARCHAR2(100),
    TableName   VARCHAR2(100),
    CreatedId   NUMBER
);

CREATE TABLE AuditCreated (
    Id           NUMBER PRIMARY KEY,
    CreatedDate DATE DEFAULT SYSDATE,
    CreatedBy   VARCHAR2(100),
    TableName   VARCHAR2(100),
    CreatedId   NUMBER
);

CREATE TABLE SystemParameter (
    Id          NUMBER PRIMARY KEY,
    Value       VARCHAR2(500),
    Name        VARCHAR2(150),
    Description VARCHAR2(500)
);

CREATE TABLE Bitacora (
    Id            NUMBER PRIMARY KEY,
    TableName     VARCHAR2(100),
    ChangeDate    DATE DEFAULT SYSDATE,
    PreviousValue VARCHAR2(1000),
    ChangedBy     VARCHAR2(100),
    CurrentValue  VARCHAR2(1000),
    FieldName     VARCHAR2(100)
);