-- ====================================================================================
-- MODULE: AdventureWorks Analytics (OBP Custom Schema)
-- SCRIPT: 03_adventureworks_aggregations.sql
-- DESCRIPTION: Scalar Functions, Mathematical Constraints, and Group Filtering (HAVING)
-- ====================================================================================

-- TASK 1: Display product names alongside their prices rounded to 2 decimal places.
SELECT 
    Naziv,
    ROUND(CijenaBezPDV, 2) AS Cijena
FROM Proizvod;


-- TASK 2: Analyze item unit prices, extracting the raw price, the nearest lower integer (FLOOR), and nearest higher integer (CEILING).
SELECT 
    Proizvod.Naziv AS Proizvod,
    ROUND(CijenaPoKomadu, 2) AS Cijena,
    FLOOR(CijenaPoKomadu) AS Najblizi_manji,
    CEILING(CijenaPoKomadu) AS Najblizi_veci
FROM Stavka
INNER JOIN Proizvod ON Proizvod.IDProizvod = Stavka.ProizvodID;


-- TASK 3: Return the absolute value of a negative threshold number.
SELECT ABS(-91) AS Apsolutni_br;


-- TASK 4: Extract the square root and square metrics for line item identifiers.
SELECT 
    IDStavka,
    SQRT(IDStavka) AS korijen,
    SQUARE(IDStavka) AS kvadrat
FROM Stavka;


-- TASK 5: Generate a randomized fractional scalar converted to a non-zero integer scale up to 100.
SELECT CEILING(RAND() * 100) AS Slucajni_Broj_1_100;


-- TASK 6: Calculate total invoice lines processed per unique product item.
SELECT 
    ProizvodID, 
    COUNT(*) AS Broj_Pojavljivanja
FROM Stavka
GROUP BY ProizvodID;


-- TASK 7: Isolate subcategories containing more than 10 total distinct products.
SELECT
    Potkategorija.Naziv AS Potkategorija,
    COUNT(IDProizvod) AS Broj_proizvoda
FROM Proizvod
INNER JOIN Potkategorija ON Potkategorija.IDPotkategorija = Proizvod.PotkategorijaID
GROUP BY Potkategorija.Naziv
HAVING COUNT(IDProizvod) > 10;


-- TASK 8: Extract gross revenue margins and absolute volume counts sold for each product line.
SELECT
    Proizvod.Naziv AS proizvod,
    ROUND(SUM(UkupnaCijena), 2) AS zaradjeni_iznos,
    SUM(Kolicina) AS broj_prodanih_kom
FROM Proizvod
INNER JOIN Stavka ON Stavka.ProizvodID = Proizvod.IDProizvod
GROUP BY Proizvod.Naziv
ORDER BY proizvod;

-- TASK 9: Filter performance matrices to target items generating higher volume velocity (units sold > 2000).
SELECT
    Proizvod.Naziv AS proizvod,
    ROUND(SUM(UkupnaCijena), 2) AS zaradjeni_iznos,
    SUM(Kolicina) AS broj_prodanih_kom
FROM Proizvod
INNER JOIN Stavka ON Stavka.ProizvodID = Proizvod.IDProizvod
GROUP BY Proizvod.Naziv
HAVING SUM(Kolicina) > 2000
ORDER BY broj_prodanih_kom DESC;

-- TASK 10: Analyze total sales volume per category with subtotal aggregation using ROLLUP.
-- This query provides a grand total and subtotals per category, perfect for financial reporting.
SELECT
    Kategorija.Naziv AS Kategorija,
    COUNT(Proizvod.IDProizvod) AS Broj_proizvoda,
    SUM(Stavka.Kolicina) AS Ukupna_kolicina
FROM Proizvod
INNER JOIN Potkategorija ON Potkategorija.IDPotkategorija = Proizvod.PotkategorijaID
INNER JOIN Kategorija ON Kategorija.IDKategorija = Potkategorija.KategorijaID
INNER JOIN Stavka ON Stavka.ProizvodID = Proizvod.IDProizvod
GROUP BY Kategorija.Naziv WITH ROLLUP; -- ROLLUP inace po defaultu null bez ovog ISNULL