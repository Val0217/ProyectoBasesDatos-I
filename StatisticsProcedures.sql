-- =============================================================
-- ARCHIVO: StatisticsProcedures.sql
-- DESCRIPCION: Procedimientos para el módulo de Estadísticas
-- =============================================================

-- -------------------------------------------------------------
-- A. Total de mascotas por tipo y estado por rango de fecha
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_stat_pets_by_type_state(
    p_dateFrom DATE,
    p_dateTo   DATE,
    p_cursor   OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
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
END pr_stat_pets_by_type_state;
/

-- -------------------------------------------------------------
-- B. Total de donaciones por asociación por rango de fecha
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_stat_donations_by_association(
    p_dateFrom DATE,
    p_dateTo   DATE,
    p_cursor   OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT
            a.Name       AS AssociationName,
            c.Name       AS Currency,
            SUM(d.Amount) AS TotalAmount,
            COUNT(*)     AS DonationCount
        FROM Donation d
        JOIN Association a ON d.IdAssociation = a.Id
        JOIN Currency    c ON d.IdCurrency    = c.Id
        WHERE (p_dateFrom IS NULL OR d.DonationDate >= p_dateFrom)
          AND (p_dateTo   IS NULL OR d.DonationDate <= p_dateTo)
        GROUP BY a.Name, c.Name
        ORDER BY a.Name, c.Name;
END pr_stat_donations_by_association;
/

-- -------------------------------------------------------------
-- C. Adopciones exitosas vs mascotas en espera
--    Filtro opcional por tipo de mascota y raza
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_stat_adoptions_vs_waiting(
    p_idType  IN NUMBER,   -- nullable
    p_idBreed IN NUMBER,   -- nullable
    p_cursor  OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT
            ps.Name  AS PetState,
            COUNT(*) AS Total,
            ROUND(COUNT(*) * 100.0 /
                SUM(COUNT(*)) OVER (), 1) AS Percentage
        FROM Pet p
        JOIN PetState ps ON p.IdState = ps.Id
        WHERE ps.Name IN ('Adoptado', 'En Adopcion')
          AND (p_idType  IS NULL OR p.IdType  = p_idType)
          AND (p_idBreed IS NULL OR p.IdBreed = p_idBreed)
        GROUP BY ps.Name;
END pr_stat_adoptions_vs_waiting;
/

-- -------------------------------------------------------------
-- D. Mascotas no adoptadas por rango de edad
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_stat_nonadopted_by_age(
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT
            CASE
                WHEN p.Age < 1              THEN '0-1 yrs (Puppies)'
                WHEN p.Age BETWEEN 1 AND 4  THEN '1-5 yrs'
                WHEN p.Age BETWEEN 5 AND 9  THEN '5-9 yrs'
                WHEN p.Age BETWEEN 10 AND 12 THEN '10-12 yrs'
                ELSE '+12 yrs'
            END AS AgeRange,
            COUNT(*) AS Total,
            ROUND(COUNT(*) * 100.0 /
                SUM(COUNT(*)) OVER (), 1) AS Percentage
        FROM Pet p
        JOIN PetState ps ON p.IdState = ps.Id
        WHERE ps.Name = 'En Adopcion'
          AND p.Age IS NOT NULL
        GROUP BY
            CASE
                WHEN p.Age < 1              THEN '0-1 yrs (Puppies)'
                WHEN p.Age BETWEEN 1 AND 4  THEN '1-5 yrs'
                WHEN p.Age BETWEEN 5 AND 9  THEN '5-9 yrs'
                WHEN p.Age BETWEEN 10 AND 12 THEN '10-12 yrs'
                ELSE '+12 yrs'
            END
        ORDER BY MIN(p.Age);
END pr_stat_nonadopted_by_age;
/

-- -------------------------------------------------------------
-- E. Tiempo promedio de adopción por tipo y raza (ADICIONAL)
--    Calcula días entre AvailableDate y AdoptionDate
-- -------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_stat_avg_adoption_time(
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT
            pt.Name  AS PetType,
            pb.Name  AS PetBreed,
            ROUND(AVG(a.AdoptionDate - a.AvailableDate), 1) AS AvgDays,
            COUNT(*) AS TotalAdoptions
        FROM Adoption a
        JOIN Pet      p  ON a.IdPet   = p.Id
        JOIN PetType  pt ON p.IdType  = pt.Id
        JOIN PetBreed pb ON p.IdBreed = pb.Id
        WHERE a.State = 'Adopted'
          AND a.AvailableDate IS NOT NULL
          AND a.AdoptionDate  IS NOT NULL
          AND a.AdoptionDate > a.AvailableDate
        GROUP BY pt.Name, pb.Name
        HAVING COUNT(*) > 0
        ORDER BY pt.Name, AvgDays ASC;
END pr_stat_avg_adoption_time;
/
