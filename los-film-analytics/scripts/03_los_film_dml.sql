-- ====================================================================================
-- MODULE: LosFilm Analytics (Algebra University Case Study)
-- SCRIPT: 03_losfilm_dml.sql
-- DESCRIPTION: Data Modification Language (DML) - INSERT, UPDATE, and Cascade DELETEs.
-- ====================================================================================

-- ------------------------------------------------------------------------------------
-- SECTION 1: Data Insertion (INSERT INTO)
-- ------------------------------------------------------------------------------------

-- TASK 1: Add two new members to the 'Clan' table.
-- Step 1a: Check and register the new city 'Trogir' if it doesn't exist in the 'Mjesto' table.
INSERT INTO Mjesto (PostanskiBroj, Naziv, Naselje, Zupanija) 
VALUES (21220, 'Trogir', 'Trogir', 'SPLITSKO-DALMATINSKA');

-- Step 1b: Insert the new members linking them to their respective MjestoID values.
INSERT INTO Clan (ID, ImePrezime, MjestoID) 
VALUES 
(8, 'Ivan Skerlecz', 8),
(9, 'Petar Berislavić', 451);

-- TASK 2: Insert two new movie records arriving on Blu-ray format.
-- Note: Ensure the media format ID exists in the 'Medij' table prior to execution.
INSERT INTO Medij (ID, Naziv) 
VALUES (5, 'Blu-ray');

INSERT INTO Film (ID, MedijID, Naziv, Trajanje, Reziser, GlavniGlumci, SporedniGlumci, ZanrID, KratkiOpis)
VALUES
(10, 5, 'Blade Runner', 117, 'Ridley Scott', 'Harrison Ford, Rutger Hauer', 'Daryl Hannah', 1, 'Set in a dystopian future...'),
(11, 5, 'Prohujalo s vihorom', 221, 'Victor Fleming', 'Clarck Gable, Vivian Leigh', NULL, 7, 'Set during the American Civil War...');

-- TASK 3: Process comprehensive rental logs and fee sub-entries for new members.
INSERT INTO Posudba (FilmID, ClanID, DatumPosudbe, DatumVracanja)
VALUES 
(1, 8, '1914-04-16', '1914-04-19'),  -- Rental entry 1
(4, 8, '1914-04-19', '1914-04-21'),  -- Rental entry 2
(11, 9, '1799-05-20', '1799-05-30'); -- Rental entry 3

INSERT INTO Zakasnina (ClanID, FilmID, DatumVracanja, NaplacenaZakasnina)
VALUES 
(8, 1, '1914-04-19', 15),
(9, 11, '1799-05-30', 16);

-- TASK 4: Record a new movie reservation placeholder for a member.
INSERT INTO Rezervacija (FilmID, DatumRezervacije, ClanID)
VALUES 
(3, '2026-05-17', 1),
(6, '2026-05-17', 1);


-- ------------------------------------------------------------------------------------
-- SECTION 2: Data Updates & Transformations (UPDATE)
-- ------------------------------------------------------------------------------------

-- TASK 5: Modify existing film record attributes, update cast logs, shift genre settings, and localize description fields in a single query.
UPDATE Film
SET
	GlavniGlumci = 'Keanu Reeves, Monica Bellucci',
	SporedniGlumci = 'Helmut Bakaitis, Valerie Berry',
	ZanrID = 3,
	KratkiOpis = 'Neo i vođe pobunjenika procjenjuju da imaju 72 sata prije nego što...'
WHERE ID = 1;

-- TASK 6: Bulk record closures - Mark all active rentals for a target member as returned today.
UPDATE Posudba 
SET DatumVracanja = GETDATE()
WHERE ClanID = 1;

-- TASK 7: Append string suffixes directly to text entries to update dynamic member classifications.
UPDATE Clan
SET ImePrezime += ' mlađi'
WHERE ImePrezime = 'Pero Perić';


-- ------------------------------------------------------------------------------------
-- SECTION 3: Complex Deletions & Constraint Enforcement (DELETE)
-- ------------------------------------------------------------------------------------

-- TASK 8: Delete rental transaction histories tied to a specific member name using an inner join check.
DELETE Posudba 
FROM Posudba
JOIN Clan ON Clan.ID = Posudba.ClanID
WHERE Clan.ImePrezime = 'Ana Milić';

-- TASK 9: Remove specific member clusters whose names end with the trailing character 'k'.
DELETE Clan 
FROM Clan
JOIN Zakasnina ON Clan.ID = Zakasnina.ClanID
WHERE ImePrezime LIKE '%k';

-- TASK 10: Cascade deletion via programmatic table dependencies - Wipe associated location records and references.
DELETE Zakasnina FROM Zakasnina JOIN Clan ON Clan.ID = Zakasnina.ClanID JOIN Mjesto ON Mjesto.ID = Clan.MjestoID WHERE Mjesto.Naziv LIKE 'Ve%';
DELETE Rezervacija FROM Rezervacija JOIN Clan ON Clan.ID = Rezervacija.ClanID JOIN Mjesto ON Mjesto.ID = Clan.MjestoID WHERE Mjesto.Naziv LIKE 'Ve%';
DELETE Clan FROM Clan JOIN Mjesto ON Mjesto.ID = Clan.MjestoID WHERE Mjesto.Naziv LIKE 'Ve%';
DELETE FROM Mjesto WHERE Naziv LIKE 'Ve%';

-- TASK 11: Core constraint handling - Purge a designated franchise ('Matrix') by lifting child transaction flags first.
DELETE Zakasnina FROM Zakasnina JOIN Film ON Zakasnina.FilmID = Film.ID WHERE Film.Naziv LIKE '%Matrix%';
DELETE FROM Film WHERE Naziv LIKE '%Matrix%';

-- TASK 12: String pattern clearing - Remove records from 'Mjesto' where the naming metrics indicate a single-word name structure.
DELETE FROM Mjesto WHERE Naziv NOT LIKE '% %';
DELETE FROM Mjesto WHERE Naziv LIKE '%/'; 

-- TASK 13: Bulk sweep - Purge multiple regional jurisdictions simultaneously using safe lookup arrays (IN operator).
DELETE FROM Mjesto WHERE Zupanija IN ('ZAGREBAČKA', 'MEDIMURSKA', 'ZADARSKA');

-- TASK 14: Inverse geographical data refinement - Clear entries that fall outside designated core boundaries.
DELETE FROM Mjesto WHERE Zupanija NOT IN ('ISTARSKA', 'KARLOVAČKA');

-- TASK 15: Absolute removal - Wipe distinct member rows validating complex composite key criteria (Name, Street, and Number).
DELETE FROM Clan
WHERE (ImePrezime = 'Pero Perić mlađi' AND Ulica = 'Unska' AND KucniBroj = '16')
   OR (ImePrezime = 'Ana Milić' AND Ulica = 'Zagrebačka' AND KucniBroj = '28')
   OR (ImePrezime = 'Sanja Tarak' AND Ulica = 'Anićeva' AND KucniBroj = '42');