
DELIMITER $$

-- -------------------------------------------------------------
-- 1. Insertar donacion voluntaria
--    Id se genera automaticamente con AUTO_INCREMENT
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_insert_donation$$

CREATE PROCEDURE pr_insert_donation(
    IN p_idPerson INT,
    IN p_amount DECIMAL(10,2),
    IN p_idCurrency INT,
    IN p_idAssociation INT
)
BEGIN
    INSERT INTO Donation (
        Amount,
        DonationDate,
        IdPerson,
        IdCurrency,
        IdAssociation
    )
    VALUES (
        p_amount,
        NOW(),
        p_idPerson,
        p_idCurrency,
        p_idAssociation
    );

    COMMIT;
END$$


-- -------------------------------------------------------------
-- 2. Consulta de donaciones con filtros opcionales
--    NULL en cualquier parametro = sin filtro para ese campo
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_get_donations$$

CREATE PROCEDURE pr_get_donations(
    IN p_idPerson INT,
    IN p_idAssociation INT,
    IN p_dateFrom DATE,
    IN p_dateTo DATE
)
BEGIN
    SELECT
        d.Id,
        per.Id AS PersonId,
        CONCAT(per.FirstName, ' ', per.LastName) AS DonorName,
        a.Name AS AssociationName,
        d.Amount,
        c.Name AS Currency,
        d.DonationDate
    FROM Donation d
    JOIN Person per ON d.IdPerson = per.Id
    JOIN Association a ON d.IdAssociation = a.Id
    JOIN Currency c ON d.IdCurrency = c.Id
    WHERE (p_idPerson IS NULL OR d.IdPerson = p_idPerson)
      AND (p_idAssociation IS NULL OR d.IdAssociation = p_idAssociation)
      AND (p_dateFrom IS NULL OR d.DonationDate >= p_dateFrom)
      AND (p_dateTo IS NULL OR d.DonationDate <= p_dateTo)
    ORDER BY d.DonationDate DESC;
END$$


-- -------------------------------------------------------------
-- 3. Listar todas las asociaciones para combo box
--    En MariaDB se usa PROCEDURE con SELECT en vez de SYS_REFCURSOR
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_get_associations_all$$

CREATE PROCEDURE pr_get_associations_all()
BEGIN
    SELECT
        Id,
        Name
    FROM Association
    ORDER BY Name ASC;
END$$


-- -------------------------------------------------------------
-- 4. Listar todas las monedas para combo box
--    En MariaDB se usa PROCEDURE con SELECT en vez de SYS_REFCURSOR
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_get_currency_all$$

CREATE PROCEDURE pr_get_currency_all()
BEGIN
    SELECT
        Id,
        Name
    FROM Currency
    ORDER BY Id ASC;
END$$

DELIMITER ;
