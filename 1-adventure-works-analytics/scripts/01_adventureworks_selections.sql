-- ====================================================================================
-- MODULE: AdventureWorks Analytics (OBP Custom Schema)
-- SCRIPT: 01_adventureworks_selections.sql
-- DESCRIPTION: Core data retrieval, filtering, and structural sorting baselines.
-- ====================================================================================

-- TASK 1: Preview all products in the inventory database

SELECT *
FROM Proizvod

-- TASK 2: Retrieve a complete list of all product names

SELECT Naziv
FROM Proizvod

-- TASK 3: Retrieve all product colors (including and excluding duplicates)
-- 3a - Including duplicates (Complete color log):

SELECT Boja 
FROM Proizvod

-- 3b -  Excluding duplicates (Unique color profiles):

SELECT DISTINCT Boja
FROM Proizvod

-- TASK 4: List products with their minimum safety stock levels, sorted descending.

SELECT Naziv, MinimalnaKolicinaNaSkladistu AS MinKol
FROM Proizvod
ORDER BY MinKol DESC

-- TASK 5: Retrieve the top 15 products with the lowest minimum safety stock levels.

SELECT TOP 15 * FROM Proizvod
ORDER BY MinimalnaKolicinaNaSkladistu


-- TASK 6: Filter all products where the minimum stock level
-- a) less than 100 units

SELECT *
FROM Proizvod
WHERE MinimalnaKolicinaNaSkladistu < 100


-- b) between 300 and 400 units, sorted by color

SELECT *
FROM Proizvod
WHERE MinimalnaKolicinaNaSkladistu BETWEEN 300 AND 400
ORDER BY Boja


-- TASK 7: Retrieve all sales representatives who are permanently employed

SELECT *
FROM Komercijalist
WHERE StalniZaposlenik = 1

-- TASK 8: Retrieve all credit card types (with and without duplicates), sorted descending
-- a) Including duplicates:

SELECT Tip
FROM KreditnaKartica
ORDER BY Tip DESC

--b) Excluding duplicates:

SELECT DISTINCT Tip
FROM KreditnaKartica
ORDER BY Tip DESC

-- TASK 9: Retrieve all customers who have a verified email address on record

SELECT *
FROM Kupac
WHERE Email IS NOT NULL

-- TASK 10: Generate a unique list of city names and country IDs, sorted alphabetically by country and city

SELECT DISTINCT Naziv, DrzavaID
FROM Grad
ORDER BY DrzavaID, Naziv


-- TASK 11: Generate a unique list of city names in Croatia (Country ID = 1), sorted in reverse alphabetical order.

SELECT DISTINCT Naziv 
FROM Grad
WHERE DrzavaID = 1
ORDER BY Naziv DESC