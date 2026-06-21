-- ====================================================================================
-- MODULE: AdventureWorks Analytics (OBP Custom Schema)
-- SCRIPT: 03_adventure_works_dml.sql
-- DESCRIPTION: Data Manipulation Language (DML) - CRUD operations
-- ====================================================================================

-- TASK 1: Delete customers whose first name does not end with the letter "a" (Handling Foreign Key constraints first).
-- Step 1: Delete dependent line items (Stavka)
DELETE Stavka 
FROM Stavka
INNER JOIN Racun ON Racun.IDRacun = Stavka.RacunID
INNER JOIN Kupac ON Kupac.IDKupac = Racun.KupacID
WHERE Kupac.Ime NOT LIKE '%a';

-- Step 2: Delete dependent invoice headers (Racun)
DELETE Racun 
FROM Racun
INNER JOIN Kupac ON Kupac.IDKupac = Racun.KupacID
WHERE Kupac.Ime NOT LIKE '%a';

-- Step 3: Delete target customers (Kupac)
DELETE FROM Kupac 
WHERE Ime NOT LIKE '%a';


-- TASK 2: Delete customers whose last name starts with "Van" (Handling Foreign Key constraints first).
-- Step 1: Purge dependent line items
DELETE Stavka 
FROM Stavka
INNER JOIN Racun ON Racun.IDRacun = Stavka.RacunID
INNER JOIN Kupac ON Kupac.IDKupac = Racun.KupacID
WHERE Kupac.Prezime LIKE 'Van%';

-- Step 2: Purge dependent invoice headers
DELETE Racun 
FROM Racun
INNER JOIN Kupac ON Kupac.IDKupac = Racun.KupacID
WHERE Kupac.Prezime LIKE 'Van%';

-- Step 3: Purge target customer accounts
DELETE FROM Kupac 
WHERE Prezime LIKE 'Van%';


-- TASK 3: Insert new countries and relate a new city to the added country.
SELECT * FROM Drzava;

INSERT INTO Drzava (Naziv) VALUES ('Madagaskar');
INSERT INTO Drzava (Naziv) VALUES ('Argentina'); -- Assigned ID: 8

SELECT * FROM Grad;
INSERT INTO Grad (Naziv, DrzavaID) VALUES ('Buenos Aires', 8);


-- TASK 4: Insert a new category, a new subcategory, and a new product.
SELECT * FROM Kategorija;
INSERT INTO Kategorija (Naziv) VALUES ('Razno'); -- Assigned ID: 5

SELECT * FROM Potkategorija WHERE Naziv = 'Playeri';
INSERT INTO Potkategorija (KategorijaID, Naziv) VALUES (5, 'Playeri'); -- Assigned ID: 38

SELECT * FROM Proizvod;
INSERT INTO Proizvod (Naziv, CijenaBezPDV, PotkategorijaID, MinimalnaKolicinaNaSkladistu, BrojProizvoda)
VALUES ('Sony Player', 985.50, 38, 0, 'SP-5537');


-- TASK 5: Verify city ID and insert a new customer profile.
SELECT * FROM Kupac;
SELECT * FROM Grad WHERE Naziv = 'Gospić'; -- Verified ID: 19
SELECT * FROM Drzava; -- Verified Croatia ID: 1

INSERT INTO Grad (Naziv, DrzavaID) VALUES ('Gospić', 1);
INSERT INTO Kupac (Ime, Prezime, Email, GradID) VALUES ('Josipa', 'Josić', 'josipa@gmail.com', 19);

SELECT * FROM Kupac;


-- TASK 6: Insert a new credit card record.
SELECT * FROM KreditnaKartica;
INSERT INTO KreditnaKartica (Tip, Broj, IstekMjesec, IstekGodina)
VALUES ('Visa', '777785713600249', 10, 2027);


-- TASK 7: Create VIP customer subsets using SELECT INTO methods.
-- Method A: Preview specific customers
SELECT Ime, Prezime FROM Kupac WHERE Ime IN ('Karen', 'Jimmy', 'Mary');

-- Method B: Copy specific customers into a new table (KupacVIP2)
SELECT Ime, Prezime INTO KupacVIP2
FROM Kupac
WHERE Ime IN ('Karen', 'Jimmy', 'Mary');

SELECT * FROM KupacVIP2;

-- Method C: Copy into a new table with an auto-incrementing ID column (KupacVIP3)
SELECT
    IDENTITY(INT, 1, 1) AS IDKupac2,
    Ime, 
    Prezime INTO KupacVIP3
FROM Kupac
WHERE Ime IN ('Karen', 'Jimmy', 'Mary');

SELECT * FROM KupacVIP3;


-- TASK 8: Update city ID for a specific customer (Kim Abercrombie).
SELECT * FROM Kupac WHERE Ime = 'Kim' AND Prezime = 'Abercrombie';
SELECT * FROM Grad; -- Osijek ID: 2

UPDATE Kupac
SET GradID = 2
WHERE Ime = 'Kim' AND Prezime = 'Abercrombie';

SELECT * FROM Kupac WHERE Ime = 'Kim' AND Prezime = 'Abercrombie';


-- TASK 9: Bulk update city ID for all customers whose last name starts with "A".
SELECT * FROM Grad WHERE Naziv = 'Rijeka'; -- Rijeka ID: 4
SELECT * FROM Kupac WHERE Prezime LIKE 'A%';

UPDATE Kupac
SET GradID = 4
WHERE Prezime LIKE 'A%';


-- TASK 10: Bulk update email address for a specific group of customer IDs.
SELECT * FROM Kupac WHERE IDKupac IN (40, 41, 42);

UPDATE Kupac
SET Email = 'nepoznato@nepoznato.com'
WHERE IDKupac IN (40, 41, 42);


-- TASK 11: Update first name for a specific customer (Eduardo Diaz -> Edo).
SELECT * FROM Kupac WHERE Ime = 'Eduardo' AND Prezime = 'Diaz';

UPDATE Kupac
SET Ime = 'Edo'
WHERE Ime = 'Eduardo' AND Prezime = 'Diaz';

SELECT * FROM Kupac WHERE Ime = 'Edo' AND Prezime = 'Diaz';


-- TASK 12: Add a comment to invoices from a specific date that have no representative or credit card assigned.
SELECT * FROM Racun
WHERE DatumIzdavanja = '20040401' AND KomercijalistID IS NULL AND KreditnaKarticaID IS NULL;

UPDATE Racun
SET Komentar = 'Dodatno provjeriti'
WHERE DatumIzdavanja = '20040401' AND KomercijalistID IS NULL AND KreditnaKarticaID IS NULL;


-- TASK 13: Bulk update invoice comments for all customers located in Croatia using multi-table joins.
SELECT * FROM Racun
INNER JOIN Kupac ON Kupac.IDKupac = Racun.KupacID
INNER JOIN Grad ON Grad.IDGrad = Kupac.GradID
INNER JOIN Drzava ON Drzava.IDDrzava = Grad.DrzavaID
WHERE Drzava.Naziv = 'Hrvatska';

UPDATE Racun
SET Komentar = 'Provjeriti kreditnu karticu'
FROM Racun
INNER JOIN Kupac ON Kupac.IDKupac = Racun.KupacID
INNER JOIN Grad ON Grad.IDGrad = Kupac.GradID
INNER JOIN Drzava ON Drzava.IDDrzava = Grad.DrzavaID
WHERE Drzava.Naziv = 'Hrvatska';


-- TASK 14: Analyze foreign key restrictions and perform a manual cascade deletion for a customer.
-- Example A: Deleting a country or city fails if it's referenced elsewhere

SELECT * FROM Drzava; -- BiH ID: 3

-- DELETE FROM Drzava WHERE Naziv = 'Bosna i Hercegovina'; -- Fails: locked by Grad table

SELECT * FROM Grad;

-- DELETE FROM Grad WHERE DrzavaID = 3; -- Fails: locked by Kupac table

-- Example B: Manually deleting a customer (ID 71) by clearing child records first

SELECT * FROM Kupac WHERE Prezime = 'Beck'; -- Targeted ID: 71

DELETE FROM Stavka WHERE RacunID IN (47447, 48386, 49510, 50722, 53562, 59063, 65271, 71938);
DELETE FROM Racun WHERE IDRacun IN (47447, 48386, 49510, 50722, 53562, 59063, 65271, 71938);
DELETE FROM Kupac WHERE IDKupac = 71;

-- Check specific invoice details

SELECT * FROM Racun WHERE IDRacun = 75123;
