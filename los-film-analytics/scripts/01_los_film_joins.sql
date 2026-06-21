-- ====================================================================================
-- MODULE: LosFilm Analytics (Algebra University Case Study)
-- SCRIPT: 02_los_film_joins.sql
-- DESCRIPTION: Relational synthesis across Movies, Members, Collections, and Geography.
-- ====================================================================================

-- TASK 1: Display all movie titles alongside their associated media format names.
-- Note: Uses LEFT JOIN to ensure movies without an assigned media format are still listed.
SELECT 
    Film.Naziv AS naziv_filma, 
    Medij.Naziv AS medij_filma
FROM Film
LEFT JOIN Medij ON Film.MedijID = Medij.ID;

-- TASK 2: Extend the previous analysis to display movie titles, media formats, and their respective genres.
SELECT 
    Film.Naziv AS naziv_filma, 
    Medij.Naziv AS medij_filma,
    Zanr.Naziv AS zanr_filma
FROM Film
LEFT JOIN Medij ON Film.MedijID = Medij.ID
LEFT JOIN Zanr ON Film.ZanrID = Zanr.ID;

-- TASK 3: Retrieve all movies rented by a specific member, filtered by their unique Member ID (ID = 4).
SELECT 
    Clan.ImePrezime AS clan, 
    Film.Naziv AS naziv_filma
FROM Posudba
JOIN Film ON Posudba.FilmID = Film.ID
JOIN Clan ON Clan.ID = Posudba.ClanID
WHERE Clan.ID = 4;

-- TASK 4: List all members who have rented a specific movie (e.g., 'Fight Club'), sorted alphabetically by member name.
SELECT DISTINCT 
    Film.Naziv AS naziv_filma, 
    Clan.ImePrezime AS clan
FROM Posudba
JOIN Film ON Film.ID = Posudba.FilmID
JOIN Clan ON Clan.ID = Posudba.ClanID
WHERE Film.Naziv = 'Fight Club'
ORDER BY clan;

-- TASK 5: Extract full names and complete addresses of all members who have paid a late fee.
SELECT DISTINCT
    Clan.ImePrezime AS Clan,
    Clan.Ulica + ' ' + Clan.KucniBroj AS kucna_adresa,
    Mjesto.PostanskiBroj + ' ' + Mjesto.Naziv + ', ' + Mjesto.Naselje + ', ' + Mjesto.Zupanija AS mjesto
FROM Zakasnina
JOIN Clan ON Clan.ID = Zakasnina.ClanID
JOIN Mjesto ON Clan.MjestoID = Mjesto.ID
WHERE Zakasnina.NaplacenaZakasnina IS NOT NULL;

-- TASK 6: Generate a unique matrix of all movie titles and the specific locations (cities) where they were rented.
SELECT DISTINCT
    Film.Naziv AS film,
    Mjesto.Naziv AS mjesto    
FROM Film
JOIN Posudba ON Film.ID = Posudba.FilmID
JOIN Clan ON Posudba.ClanID = Clan.ID
JOIN Mjesto ON Clan.MjestoID = Mjesto.ID;

-- TASK 7: Retrieve a distinct list of genres each member has historically interacted with, preventing duplicates.
SELECT DISTINCT
    Clan.ImePrezime AS clan,
    Zanr.Naziv AS zanr
FROM Posudba
JOIN Clan ON Clan.ID = Posudba.ClanID
JOIN Film ON Film.ID = Posudba.FilmID
JOIN Zanr ON Film.ZanrID = Zanr.ID;

-- TASK 8: Provide an audit trail showing member details, full addresses, and titles of movies that incurred a processed late fee.
SELECT 
    Clan.ImePrezime AS clan,
    Clan.Ulica + ' ' + Clan.KucniBroj AS kucna_adresa,
    Mjesto.PostanskiBroj + ' ' + Mjesto.Naziv + ', ' + Mjesto.Naselje + ', ' + Mjesto.Zupanija AS mjesto,
    Film.Naziv AS film
FROM Clan
LEFT JOIN Mjesto ON Clan.MjestoID = Mjesto.ID
JOIN Zakasnina ON Clan.ID = Zakasnina.ClanID
JOIN Film ON Zakasnina.FilmID = Film.ID
WHERE Zakasnina.NaplacenaZakasnina IS NOT NULL
ORDER BY clan;

-- TASK 9: Isolate movie rentals for a target asset (ID = 2) and map out every location where this film was distributed.
SELECT DISTINCT
    Film.Naziv AS film,
    Mjesto.Naziv AS mjesto
FROM Film
JOIN Posudba ON Film.ID = Posudba.FilmID
JOIN Clan ON Clan.ID = Posudba.ClanID
JOIN Mjesto ON Clan.MjestoID = Mjesto.ID
WHERE Film.ID = 2;

-- TASK 11: Generate a comprehensive catalogue of all inventory movies alongside their active reservations (if any exist).
SELECT 
    Film.ID AS film_ID, 
    Film.Naziv AS film,
    Rezervacija.DatumRezervacije AS datum
FROM Film
LEFT JOIN Rezervacija ON Film.ID = Rezervacija.FilmID;

-- TASK 12: Enrich the previous reservation catalogue by pulling the full name of the member who placed the hold.
SELECT 
    Film.ID AS film_ID, 
    Film.Naziv AS film,
    Rezervacija.DatumRezervacije AS datum,
    Clan.ImePrezime AS clan
FROM Rezervacija         
JOIN Film ON Film.ID = Rezervacija.FilmID
JOIN Clan ON Clan.ID = Rezervacija.ClanID;

-- TASK 13: Audit regional registration by listing all registered locations and the members residing in them (returns NULL for vacant cities).
SELECT 
    Mjesto.Naziv AS mjesto, 
    Clan.ImePrezime AS clan
FROM Mjesto
LEFT JOIN Clan ON Clan.MjestoID = Mjesto.ID
ORDER BY clan DESC, mjesto DESC;

-- TASK 14: Trace fulfillment geography by listing all distinct cities where rentals occurred and the explicit movie titles delivered there.
SELECT DISTINCT
    Mjesto.Naziv AS mjesto, 
    Film.Naziv AS film
FROM Film
JOIN Posudba ON Film.ID = Posudba.FilmID
JOIN Clan ON Clan.ID = Posudba.ClanID
JOIN Mjesto ON Mjesto.ID = Clan.MjestoID
ORDER BY film;

-- TASK 15: Deep cross-join resolution - Supplement the delivery trace with genre profiles, allowing non-rented genres to persist as NULL via FULL OUTER JOIN.
SELECT DISTINCT
    Mjesto.Naziv AS mjesto, 
    Film.Naziv AS film,
    Zanr.Naziv AS zanr
FROM Film
FULL OUTER JOIN Zanr ON Film.ZanrID = Zanr.ID
LEFT JOIN Posudba ON Film.ID = Posudba.FilmID
LEFT JOIN Clan ON Clan.ID = Posudba.ClanID
LEFT JOIN Mjesto ON Mjesto.ID = Clan.MjestoID
ORDER BY film;
