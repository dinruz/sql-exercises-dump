-- ====================================================================================
-- MODULE: LosFilm Analytics (Algebra University Case Study)
-- SCRIPT: 02_los_film_aggregations.sql
-- DESCRIPTION: Core data retrieval, string formatting, JOINs and aggregations.
-- ====================================================================================

-- ------------------------------------------------------------------------------------
-- SECTION 1: Baseline Date & String Manipulations
-- ------------------------------------------------------------------------------------

-- PRE-TASK A: Extract unique months in which movie rentals occurred to pinpoint seasonality.
SELECT DISTINCT 
    DATEPART(month, DatumPosudbe) AS mjesec_posudbe 
FROM Posudba;

-- PRE-TASK B: Clean up data entry anomalies by trimming redundant trailing and leading spaces from text strings.
SELECT 
    TRIM('              Pero ide u šumu            ') AS trimmano;

-- PRE-TASK C: Calculate precise age metrics in days, months, and hours based on a sample birthdate.
SELECT 
    DATEDIFF(day, '1992-10-17', GETDATE()) AS starost_dani,
    DATEDIFF(month, '1992-10-17', GETDATE()) AS starost_mj,
    DATEDIFF(hour, '1992-10-17', GETDATE()) AS starost_h;


-- ------------------------------------------------------------------------------------
-- SECTION 2: Structured Course Exercises (Tasks 1 - 11)
-- ------------------------------------------------------------------------------------

-- TASK 1: Calculate the average runtime (in minutes) across all movies in the database.
SELECT 
    AVG(Trajanje) AS prosjek_min 
FROM Film;

-- TASK 2: Calculate the average runtime specifically for movies belonging to the 'SF' (Sci-Fi) genre.
SELECT 
    AVG(Trajanje) AS prosjek_SF 
FROM Film
JOIN Zanr ON Film.ZanrID = Zanr.ID
WHERE Zanr.Naziv = 'SF';

-- TASK 3: Retrieve a list of all distinct months when rentals were processed.
SELECT DISTINCT 
    DATEPART(month, DatumPosudbe) AS mjesec_posudbe 
FROM Posudba;

-- TASK 4: Aggregate the total number of movie rentals processed during the month of April.
SELECT 
    COUNT(*) AS BrojPosudjenihFilmova 
FROM Posudba 
WHERE MONTH(DatumPosudbe) = 4;

-- TASK 5: Analyze inventory volume by counting how many films are recorded for each media format.
SELECT 
    Medij.Naziv AS medij,
    COUNT(Film.Naziv) AS br_filmova
FROM Film
JOIN Medij ON Film.MedijID = Medij.ID
GROUP BY Medij.Naziv;

-- TASK 6: Calculate the average runtime of movies that belong to either the 'SF' or 'Drama' genres.
-- Note: Includes an advanced 'WITH ROLLUP' bonus query to handle the grand total row generation.
SELECT 
    ISNULL(Zanr.Naziv, 'Ukupno') AS zanr, 
    AVG(Film.Trajanje) AS trajanje
FROM Film
JOIN Zanr ON Film.ZanrID = Zanr.ID
WHERE Zanr.Naziv IN ('SF', 'Drama')
GROUP BY Zanr.Naziv WITH ROLLUP;

-- TASK 7: Count the number of movies rented in the month of March, categorized by their respective genres.
SELECT 
    Zanr.Naziv, 
    COUNT(*) AS posudjeni_filmovi
FROM Posudba
JOIN Film ON Posudba.FilmID = Film.ID
JOIN Zanr ON Zanr.ID = Film.ZanrID
WHERE MONTH(DatumPosudbe) = 3
GROUP BY Zanr.Naziv;

-- TASK 8: Generate a complete list of locations where movies were rented, along with the total rental count for each location.
SELECT 
    Mjesto.Naziv AS mjesto, 
    COUNT(*) AS br_filmova
FROM Posudba
JOIN Clan ON Posudba.ClanID = Clan.ID
JOIN Mjesto ON Mjesto.ID = Clan.MjestoID
GROUP BY Mjesto.Naziv;

-- TASK 9: Filter the location rental metrics to isolate only those municipalities with more than 1 rental processed (HAVING clause).
SELECT 
    Mjesto.Naziv AS mjesto, 
    COUNT(*) AS br_filmova
FROM Posudba
JOIN Clan ON Posudba.ClanID = Clan.ID
JOIN Mjesto ON Mjesto.ID = Clan.MjestoID
GROUP BY Mjesto.Naziv
HAVING COUNT(*) > 1;

-- TASK 10: Isolate genres where the maximum movie runtime is strictly greater than 138 minutes.
SELECT 
    Zanr.Naziv, 
    MAX(Trajanje) AS trajanje_filma
FROM Film
JOIN Zanr ON Zanr.ID = Film.ZanrID
GROUP BY Zanr.Naziv
HAVING MAX(Trajanje) > 138;

-- TASK 11: Find genres whose average movie runtime is at least 2% higher than the absolute minimum runtime within that same genre profile.
SELECT 
    Zanr.Naziv, 
    AVG(Trajanje) AS trajanje_filma
FROM Film
JOIN Zanr ON Zanr.ID = Film.ZanrID
GROUP BY Zanr.Naziv
HAVING AVG(Trajanje) >= MIN(Trajanje) * 1.02;