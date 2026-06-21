-- ====================================================================================
-- MODULE: AdventureWorks Analytics (OBP Custom Schema)
-- SCRIPT: 02_adventureworks_joins.sql
-- DESCRIPTION: Relational synthesis across Sales, Customers, and Geography tables.
-- ====================================================================================


-- TASK 1: Retrieve a list of all invoices alongside their corresponding customer data.

SELECT
    Racun.DatumIzdavanja AS Datum,
    Racun.BrojRacuna AS Br_racuna,
    Kupac.Ime + ' ' + Kupac.Prezime AS Kupac
FROM Racun
LEFT JOIN Kupac 
    ON Racun.KupacID = Kupac.IDKupac;


-- TASK 2: Extract a distinct list of all products purchased by a specific customer (ID = 2).

SELECT DISTINCT
    Proizvod.Naziv AS Proizvod
FROM Kupac
INNER JOIN Racun 
    ON Racun.KupacID = Kupac.IDKupac
INNER JOIN Stavka 
    ON Racun.IDRacun = Stavka.RacunID
INNER JOIN Proizvod 
    ON Proizvod.IDProizvod = Stavka.ProizvodID
WHERE 
    Kupac.IDKupac = 2;


-- TASK 3: Analyze product categories purchased by a specific customer (ID = 3).

SELECT DISTINCT
    Kategorija.Naziv AS Kategorija
FROM Kupac
INNER JOIN Racun 
    ON Racun.KupacID = Kupac.IDKupac
INNER JOIN Stavka 
    ON Racun.IDRacun = Stavka.RacunID
INNER JOIN Proizvod 
    ON Proizvod.IDProizvod = Stavka.ProizvodID
INNER JOIN Potkategorija 
    ON Potkategorija.IDPotkategorija = Proizvod.PotkategorijaID
INNER JOIN Kategorija 
    ON Potkategorija.KategorijaID = Kategorija.IDKategorija
WHERE 
    Kupac.IDKupac = 3;


-- TASK 4: Preview subcategories and products mapped under a specific category (ID = 1).

SELECT DISTINCT
    Potkategorija.Naziv AS potkategorija,
    Proizvod.Naziv AS proizvod
FROM Kategorija
LEFT JOIN Potkategorija 
    ON Potkategorija.KategorijaID = Kategorija.IDKategorija
LEFT JOIN Proizvod 
    ON Potkategorija.IDPotkategorija = Proizvod.PotkategorijaID
WHERE 
    Kategorija.IDKategorija = 1;


-- TASK 5: Identify credit card types utilized for high-value item purchases (> 3000).

SELECT DISTINCT
    KreditnaKartica.Tip AS tip_kartice
FROM Racun
INNER JOIN Stavka 
    ON Stavka.RacunID = Racun.IDRacun
INNER JOIN KreditnaKartica 
    ON KreditnaKartica.IDKreditnaKartica = Racun.KreditnaKarticaID
WHERE 
    Stavka.CijenaPoKomadu > 3000;


-- TASK 6: Extract unique product colors for transactions settled with cash (No Credit Card).

SELECT DISTINCT
    Proizvod.Boja AS boja
FROM Racun
INNER JOIN Stavka 
    ON Stavka.RacunID = Racun.IDRacun
INNER JOIN Proizvod 
    ON Proizvod.IDProizvod = Stavka.ProizvodID
WHERE 
    Racun.KreditnaKarticaID IS NULL 
    AND Proizvod.Boja IS NOT NULL;


-- TASK 7: Detect inactive customers with no purchase history (Version A - LEFT OUTER JOIN).

SELECT 
    Kupac.Ime + ' ' + Kupac.Prezime AS kupac    
FROM Kupac
LEFT JOIN Racun 
    ON Kupac.IDKupac = Racun.KupacID
WHERE 
    Racun.IDRacun IS NULL;

-- TASK 8: Detect inactive customers with no purchase history (Version B - RIGHT OUTER JOIN).

SELECT 
    Kupac.Ime + ' ' + Kupac.Prezime AS kupac    
FROM Racun
RIGHT JOIN Kupac 
    ON Kupac.IDKupac = Racun.KupacID
WHERE 
    Racun.IDRacun IS NULL;


-- TASK 9: Geographic validation - Isolate cities without a mapped country or vice versa.

SELECT
    Grad.Naziv AS grad,
    Drzava.Naziv AS drzava
FROM Drzava
FULL OUTER JOIN Grad 
    ON Drzava.IDDrzava = Grad.DrzavaID
WHERE 
    Grad.Naziv IS NULL 
    OR Drzava.Naziv IS NULL;

-- TASK 10: List all customers alongside their invoice numbers and order dates.

SELECT 
    Kupac.Ime + ' ' + Kupac.Prezime AS kupac,
    Racun.DatumIzdavanja AS datum_prodaje,
    Racun.BrojRacuna AS racun_br
FROM Kupac
INNER JOIN Racun 
    ON Racun.KupacID = Kupac.IDKupac;


-- TASK 11: Products and full category lineage sold under a specific invoice (ID = 43659).

SELECT DISTINCT
    Proizvod.Naziv AS proizvod,
    Kategorija.Naziv AS kategorija,
    Potkategorija.Naziv AS potkategorija
FROM Racun
INNER JOIN Stavka 
    ON Racun.IDRacun = Stavka.RacunID
INNER JOIN Proizvod 
    ON Proizvod.IDProizvod = Stavka.ProizvodID
LEFT JOIN Potkategorija 
    ON Potkategorija.IDPotkategorija = Proizvod.PotkategorijaID
LEFT JOIN Kategorija 
    ON Kategorija.IDKategorija = Potkategorija.KategorijaID
WHERE 
    Racun.IDRacun = 43659;


-- TASK 12: List complete inventory lineup sorted by category and subcategory hierarchy.

SELECT DISTINCT
    Proizvod.Naziv AS proizvod,
    Potkategorija.Naziv AS potkategorija,
    Kategorija.Naziv AS kategorija    
FROM Proizvod
LEFT JOIN Potkategorija 
    ON Potkategorija.IDPotkategorija = Proizvod.PotkategorijaID 
LEFT JOIN Kategorija 
    ON Kategorija.IDKategorija = Potkategorija.KategorijaID
ORDER BY 
    Kategorija.Naziv ASC,
    Potkategorija.Naziv ASC;


-- TASK 13: Global sales distribution - Extract sold product categories per destination country.

SELECT DISTINCT
    Drzava.Naziv AS drzava,
    Kategorija.Naziv AS kategorija
FROM Racun
INNER JOIN Kupac 
    ON Racun.KupacID = Kupac.IDKupac
INNER JOIN Grad 
    ON Kupac.GradID = Grad.IDGrad
INNER JOIN Drzava 
    ON Drzava.IDDrzava = Grad.DrzavaID
INNER JOIN Stavka 
    ON Racun.IDRacun = Stavka.RacunID
INNER JOIN Proizvod 
    ON Stavka.ProizvodID = Proizvod.IDProizvod
INNER JOIN Potkategorija 
    ON Proizvod.PotkategorijaID = Potkategorija.IDPotkategorija
INNER JOIN Kategorija 
    ON Potkategorija.KategorijaID = Kategorija.IDKategorija
ORDER BY 
    Drzava.Naziv ASC, 
    Kategorija.Naziv ASC;
