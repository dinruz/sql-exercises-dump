-- ====================================================================================
-- MODULE: AdventureWorks Analytics (OBP Custom Schema)
-- SCRIPT: 04_adventureworks_dml.sql
-- DESCRIPTION: Data Manipulation Language (DML) - Complete CRUD, Cascades, and Updates
-- ====================================================================================

-- TASK 1: Delete customers whose first name does NOT end with the letter "a".
-- Step 1a: Remove dependent line items (Stavka) to satisfy foreign key constraints.
DELETE Stavka 
FROM Stavka
INNER JOIN Racun ON Racun.IDRacun = Stavka.RacunID
INNER JOIN Kupac ON Kupac.IDKupac = Racun.KupacID
WHERE Kupac.Ime NOT LIKE '%a';

-- Step 1b: Remove dependent invoice headers (Racun).
DELETE Racun 
FROM Racun
INNER JOIN Kupac ON Kupac.IDKupac = Racun.KupacID
WHERE Kupac.Ime NOT LIKE '%a';

-- Step 1c: Delete the target customer accounts.
DELETE FROM Kupac 
WHERE Ime NOT LIKE '%a';


-- TASK 2: Delete customers whose last name begins with the prefix "Van".
-- Verification check before purging
SELECT * FROM Kupac WHERE Prezime LIKE 'Van%';

-- Step 2a: Purge dependent line items from transactions.
DELETE Stavka             
FROM Stavka
INNER JOIN Racun ON Racun.IDRacun = Stavka.RacunID
INNER JOIN Kupac ON Kupac.IDKupac = Racun.KupacID
WHERE Kupac.Prezime LIKE 'Van%';

-- Step 2b: Purge dependent invoice headers.
DELETE Racun                
FROM Racun
INNER JOIN Kupac ON Kupac.IDKupac = Racun.KupacID
WHERE Kupac.Prezime LIKE 'Van%';

-- Step 2c: Purge target customer records.
DELETE FROM Kupac              
WHERE Prezime LIKE 'Van%';

-- Verification check after purging (Should return 0 rows)
SELECT * FROM Kupac WHERE Prezime LIKE 'Van%';


-- TASK 3: Append the suffix "treći" to the customer named Gary Vargas.
-- PORTFOLIO NOTE: Due to the execution of TASK 1, this update will affect 0 rows 
-- because the first name 'Gary' does not end in 'a' and was already purged.
SELECT * FROM Kupac WHERE Prezime = 'Vargas' AND Ime = 'Gary';

UPDATE Kupac
SET Prezime += ' treći'
WHERE Prezime = 'Vargas' AND Ime = 'Gary';


-- TASK 4: Conditional Multi-Criteria Purging & Advanced Sub-setting
-- a) Delete customers named Ana or Tamara residing in Osijek.
-- b) Delete customers whose last name starts with "D" and contains the string "re".
-- c) Update exactly half (TOP 50 PERCENT) of records for customers named "Jack" setting their last name to NULL.

-- Pre-execution verification for City IDs (Osijek Verified ID = 2)
SELECT * FROM Grad WHERE Naziv = 'Osijek'; 

-- Step 4a/b: Cascade delete line items matching the complex criteria for target groups.
DELETE Stavka
FROM Stavka
INNER JOIN Racun ON Stavka.RacunID = Racun.IDRacun
INNER JOIN Kupac ON Racun.KupacID = Kupac.IDKupac
WHERE (Kupac.GradID = 2 AND (Kupac.Ime = 'Ana' OR Kupac.Ime = 'Tamara')) 
   OR (Kupac.Prezime LIKE 'D%re%');

-- Step 4a/b: Cascade delete invoice headers matching the complex criteria.
DELETE Racun 
FROM Racun
INNER JOIN Kupac ON Kupac.IDKupac = Racun.KupacID
WHERE (Kupac.GradID = 2 AND (Kupac.Ime = 'Ana' OR Kupac.Ime = 'Tamara')) 
   OR (Kupac.Prezime LIKE 'D%re%');

-- Step 4a/b: Delete target customer profiles.
DELETE FROM Kupac
WHERE (GradID = 2 AND (Ime = 'Ana' OR Ime = 'Tamara')) 
   OR (Prezime LIKE 'D%re%');

-- Step 4c: Truncate last names for exactly 50% of customers named "Jack".
-- PORTFOLIO NOTE: This query will execute on 0 rows because 'Jack' was dropped in TASK 1.
SELECT * FROM Kupac WHERE Ime = 'Jack';

UPDATE TOP (50) PERCENT Kupac
SET Prezime = NULL 
WHERE Ime = 'Jack';


-- TASK 5: Standardize missing data profiles.
-- For all customers without a defined suffix, append the string "nema".
-- We filter out rows that already contain traditional suffixes (Jr, Sr, mlađi, stariji, treći).
SELECT * FROM Kupac 
WHERE Prezime NOT LIKE '% Jr'
  AND Prezime NOT LIKE '% Sr'
  AND Prezime NOT LIKE '% mlađi'
  AND Prezime NOT LIKE '% stariji'
  AND Prezime NOT LIKE '% treći';

UPDATE Kupac
SET Prezime += ' nema'
WHERE Prezime NOT LIKE '% Jr'
  AND Prezime NOT LIKE '% Sr'
  AND Prezime NOT LIKE '% mlađi'
  AND Prezime NOT LIKE '% stariji'
  AND Prezime NOT LIKE '% treći';


-- TASK 6: Insert new countries and relate a new city to the added country record.
SELECT * FROM Drzava;

INSERT INTO Drzava (Naziv) VALUES ('Madagaskar');
INSERT INTO Drzava (Naziv) VALUES ('Argentina'); -- Example Assigned ID: 8

SELECT * FROM Grad;
INSERT INTO Grad (Naziv, DrzavaID) VALUES ('Buenos Aires', 8);


-- TASK 7: Insert a new category, a new subcategory, and a new product into inventory.
SELECT * FROM Kategorija;
INSERT INTO Kategorija (Naziv) VALUES ('Razno'); -- Example Assigned ID: 5

SELECT * FROM Potkategorija WHERE Naziv = 'Playeri';
INSERT INTO Potkategorija (KategorijaID, Naziv) VALUES (5, 'Playeri'); -- Example Assigned ID: 38

SELECT * FROM Proizvod;
INSERT INTO Proizvod (Naziv, CijenaBezPDV, PotkategorijaID, MinimalnaKolicinaNaSkladistu, BrojProizvoda)
VALUES ('Sony Player', 985.50, 38, 0, 'SP-5537');


-- TASK 8: Verify regional placement and insert a new customer profile linked to Gospić.
SELECT * FROM Grad WHERE Naziv = 'Gospić';

SELECT * FROM Drzava; 

INSERT INTO Grad (Naziv, DrzavaID) VALUES ('Gospić', 1); -- Linked to Croatia (ID 1)
INSERT INTO Kupac (Ime, Prezime, Email, GradID) VALUES ('Josipa', 'Josić', 'josipa@gmail.com', 19);


-- TASK 9: Insert a new credit card record with future expiration thresholds.
SELECT * FROM KreditnaKartica;
INSERT INTO KreditnaKartica (Tip, Broj, IstekMjesec, IstekGodina)
VALUES ('Visa', '777785713600249', 10, 2027);


-- TASK 10: Create VIP customer subsets using runtime SELECT INTO storage methods.
-- Method A: Copy specific customers into a standard runtime backup table
SELECT Ime, Prezime INTO KupacVIP2
FROM Kupac
WHERE Ime IN ('Karen', 'Jimmy', 'Mary');

-- Method B: Copy into a new table while injecting a dynamic auto-incrementing ID column
SELECT
    IDENTITY(INT, 1, 1) AS IDKupac2,
    Ime, 
    Prezime INTO KupacVIP3
FROM Kupac
WHERE Ime IN ('Karen', 'Jimmy', 'Mary');


-- TASK 11: Relocate a specific customer account to a different municipality (Kim Abercrombie -> Osijek).
SELECT * FROM Kupac WHERE Ime = 'Kim' AND Prezime = 'Abercrombie';

UPDATE Kupac
SET GradID = 2 -- Osijek ID: 2
WHERE Ime = 'Kim' AND Prezime = 'Abercrombie';


-- TASK 12: Bulk update geographical assignments for all customers whose last name starts with "A".
SELECT * FROM Grad WHERE Naziv = 'Rijeka'; -- Rijeka ID: 4

UPDATE Kupac
SET GradID = 4
WHERE Prezime LIKE 'A%';


-- TASK 13: Bulk update contact details to placeholder metrics for specific account groups.
UPDATE Kupac
SET Email = 'nepoznato@nepoznato.com'
WHERE IDKupac IN (40, 41, 42);


-- TASK 14: Inject transactional notes/comments based on compound entity attributes and regional scopes.
-- 14a: Add warnings to unassigned invoices from a specific target date
UPDATE Racun
SET Komentar = 'Dodatno provjeriti'
WHERE DatumIzdavanja = '20040401' AND KomercijalistID IS NULL AND KreditnaKarticaID IS NULL;

-- 14b: Bulk update invoice remarks for all transactions originating within Croatia via multi-table alignment
UPDATE Racun
SET Komentar = 'Provjeriti kreditnu karticu'
FROM Racun
INNER JOIN Kupac ON Kupac.IDKupac = Racun.KupacID
INNER JOIN Grad ON Grad.IDGrad = Kupac.GradID
INNER JOIN Drzava ON Drzava.IDDrzava = Grad.DrzavaID
WHERE Drzava.Naziv = 'Hrvatska';