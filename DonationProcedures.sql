-- =============================================================
-- ARCHIVO: DonationProcedures.sql
-- DESCRIPCION: Procedimientos y funciones para el módulo de Donaciones
-- =============================================================

-- -------------------------------------------------------------
-- 1. Insertar donación voluntaria
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_insert_donation(
    p_idPerson      IN NUMBER,
    p_amount        IN NUMBER,
    p_idCurrency    IN NUMBER,
    p_idAssociation IN NUMBER
) AS
BEGIN
    INSERT INTO Donation (Id, Amount, DonationDate, IdPerson, IdCurrency, IdAssociation)
    VALUES (s_Donation.NEXTVAL, p_amount, SYSDATE, p_idPerson, p_idCurrency, p_idAssociation);
    COMMIT;
END pr_insert_donation;
/

-- -------------------------------------------------------------
-- 2. Consulta de donaciones con filtros opcionales
--    Null en cualquier parámetro = sin filtro para ese campo
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_get_donations(
    p_idPerson      IN NUMBER,      -- nullable
    p_idAssociation IN NUMBER,      -- nullable
    p_dateFrom      IN DATE,        -- nullable
    p_dateTo        IN DATE,        -- nullable
    p_cursor        OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT
            d.Id,
            per.FirstName || ' ' || per.LastName AS DonorName,
            a.Name                               AS AssociationName,
            d.Amount,
            c.Name                               AS Currency,
            d.DonationDate
        FROM Donation d
        JOIN Person      per ON d.IdPerson      = per.Id
        JOIN Association a   ON d.IdAssociation = a.Id
        JOIN Currency    c   ON d.IdCurrency    = c.Id
        WHERE (p_idPerson      IS NULL OR d.IdPerson      = p_idPerson)
          AND (p_idAssociation IS NULL OR d.IdAssociation = p_idAssociation)
          AND (p_dateFrom      IS NULL OR d.DonationDate >= p_dateFrom)
          AND (p_dateTo        IS NULL OR d.DonationDate <= p_dateTo)
        ORDER BY d.DonationDate DESC;
END pr_get_donations;
/

-- -------------------------------------------------------------
-- 3. Función para listar todas las asociaciones (combo box)
-- -------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_get_associations_all
RETURN SYS_REFCURSOR AS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT Id, Name
        FROM Association
        ORDER BY Name ASC;
    RETURN v_cursor;
END fn_get_associations_all;
/

-- -------------------------------------------------------------
-- 4. Función para listar todas las monedas (combo box)
--    (posiblemente ya la tienen, verificar antes de crear)
-- -------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_get_currency_all
RETURN SYS_REFCURSOR AS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT Id, Name
        FROM Currency
        ORDER BY Id ASC;
    RETURN v_cursor;
END fn_get_currency_all;
/
