

DELIMITER $$

-- -------------------------------------------------------------
-- A. Total de mascotas por tipo y estado por rango de fecha
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_stat_pets_by_type_state$$

CREATE PROCEDURE pr_stat_pets_by_type_state(
    IN p_dateFrom DATE,
    IN p_dateTo   DATE
)
BEGIN
    SELECT
        pt.Name  AS PetType,
        ps.Name  AS PetState,
        COUNT(*) AS Total
    FROM Pet p
    JOIN PetType  pt ON p.IdType  = pt.Id
    JOIN PetState ps ON p.IdState = ps.Id
    WHERE (p_dateFrom IS NULL OR p.Id IN (
            SELECT IdPet FROM LostReport  WHERE LostDate  >= p_dateFrom
            UNION
            SELECT IdPet FROM FoundReport WHERE FoundDate >= p_dateFrom
          ))
      AND (p_dateTo IS NULL OR p.Id IN (
            SELECT IdPet FROM LostReport  WHERE LostDate  <= p_dateTo
            UNION
            SELECT IdPet FROM FoundReport WHERE FoundDate <= p_dateTo
          ))
    GROUP BY pt.Name, ps.Name
    ORDER BY pt.Name, ps.Name;
END$$


-- -------------------------------------------------------------
-- B. Total de donaciones por asociacion por rango de fecha
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_stat_donation_by_asso$$

CREATE PROCEDURE pr_stat_donation_by_asso(
    IN p_dateFrom DATE,
    IN p_dateTo   DATE
)
BEGIN
    SELECT
        a.Name        AS AssociationName,
        c.Name        AS Currency,
        SUM(d.Amount) AS TotalAmount,
        COUNT(*)      AS DonationCount
    FROM Donation d
    JOIN Association a ON d.IdAssociation = a.Id
    JOIN Currency    c ON d.IdCurrency    = c.Id
    WHERE (p_dateFrom IS NULL OR d.DonationDate >= p_dateFrom)
      AND (p_dateTo   IS NULL OR d.DonationDate <= p_dateTo)
    GROUP BY a.Name, c.Name
    ORDER BY a.Name, c.Name;
END$$


-- -------------------------------------------------------------
-- C. Adopciones exitosas vs mascotas en espera
--    Filtro opcional por tipo de mascota y raza
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_stat_adoptions_vs_waiting$$

CREATE PROCEDURE pr_stat_adoptions_vs_waiting(
    IN p_idType  INT,
    IN p_idBreed INT
)
BEGIN
    SELECT
        ps.Name  AS PetState,
        COUNT(*) AS Total,
        ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS Percentage
    FROM Pet p
    JOIN PetState ps ON p.IdState = ps.Id
    WHERE ps.Name IN ('Adoptado', 'En Adopcion')
      AND (p_idType  IS NULL OR p.IdType  = p_idType)
      AND (p_idBreed IS NULL OR p.IdBreed = p_idBreed)
    GROUP BY ps.Name;
END$$


-- -------------------------------------------------------------
-- D. Mascotas no adoptadas por rango de edad
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_stat_nonadopted_by_age$$

CREATE PROCEDURE pr_stat_nonadopted_by_age()
BEGIN
    SELECT
        CASE
            WHEN p.Age < 1               THEN '0-1 yrs (Puppies)'
            WHEN p.Age BETWEEN 1 AND 4   THEN '1-5 yrs'
            WHEN p.Age BETWEEN 5 AND 9   THEN '5-9 yrs'
            WHEN p.Age BETWEEN 10 AND 12 THEN '10-12 yrs'
            ELSE '+12 yrs'
        END AS AgeRange,
        COUNT(*) AS Total,
        ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS Percentage
    FROM Pet p
    JOIN PetState ps ON p.IdState = ps.Id
    WHERE ps.Name = 'up for adoption'
      AND p.Age IS NOT NULL
    GROUP BY
        CASE
            WHEN p.Age < 1               THEN '0-1 yrs (Puppies)'
            WHEN p.Age BETWEEN 1 AND 4   THEN '1-5 yrs'
            WHEN p.Age BETWEEN 5 AND 9   THEN '5-9 yrs'
            WHEN p.Age BETWEEN 10 AND 12 THEN '10-12 yrs'
            ELSE '+12 yrs'
        END
    ORDER BY MIN(p.Age);
END$$


-- -------------------------------------------------------------
-- E. Tiempo promedio de adopcion por tipo y raza
--    Calcula dias entre AvailableDate y AdoptionDate
-- -------------------------------------------------------------
DROP PROCEDURE IF EXISTS pr_stat_avg_adoption_time$$

CREATE PROCEDURE pr_stat_avg_adoption_time()
BEGIN
    SELECT
        pt.Name AS PetType,
        pb.Name AS PetBreed,
        ROUND(AVG(DATEDIFF(a.AdoptionDate, a.AvailableDate)), 1) AS AvgDays,
        COUNT(*) AS TotalAdoptions
    FROM Adoption a
    JOIN Pet      p  ON a.IdPet   = p.Id
    JOIN PetType  pt ON p.IdType  = pt.Id
    JOIN PetBreed pb ON p.IdBreed = pb.Id
    WHERE a.AvailableDate IS NOT NULL
      AND a.AdoptionDate  IS NOT NULL
    GROUP BY pt.Name, pb.Name
    HAVING COUNT(*) > 0
    ORDER BY pt.Name, AvgDays ASC;
END$$

DELIMITER ;
