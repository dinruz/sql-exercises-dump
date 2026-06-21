-- ====================================================================================
-- MODULE: LosFilm Analytics (Algebra University Case Study)
-- SCRIPT: 04_losfilm_ddl.sql
-- DESCRIPTION: Data Definition Language (DDL) - Schema Creation, Constraints, and Indexing.
-- ====================================================================================

-- ------------------------------------------------------------------------------------
-- SECTION 1: Schema Re-Creation (Table Structures)
-- ------------------------------------------------------------------------------------

-- Step 1: Create Core Lookup Tables (Independent Entities)
CREATE TABLE Mjesto (
    ID INT IDENTITY(1,1),
    PostanskiBroj INT NOT NULL,
    Naziv NVARCHAR(255) NOT NULL,
    Naselje NVARCHAR(255) NULL,
    Zupanija NVARCHAR(255) NOT NULL,
    CONSTRAINT PK_Mjesto PRIMARY KEY (ID)
);

CREATE TABLE Zanr (
    ID INT IDENTITY(1,1),
    Naziv NVARCHAR(255) NOT NULL,
    CONSTRAINT PK_Zanr PRIMARY KEY (ID)
);

CREATE TABLE Medij (
    ID INT IDENTITY(1,1),
    Naziv NVARCHAR(255) NOT NULL,
    CONSTRAINT PK_Medij PRIMARY KEY (ID)
);

-- Step 2: Create Member and Inventory Tables (Dependent Entities)
CREATE TABLE Clan (
    ID INT NOT NULL,
    ImePrezime NVARCHAR(255) NOT NULL,
    Ulica NVARCHAR(255) NULL,
    KucniBroj NVARCHAR(50) NULL,
    MjestoID INT NOT NULL,
    CONSTRAINT PK_Clan PRIMARY KEY (ID),
    CONSTRAINT FK_Clan_Mjesto FOREIGN KEY (MjestoID) REFERENCES Mjesto(ID)
);

CREATE TABLE Film (
    ID INT NOT NULL,
    MedijID INT NOT NULL,
    Naziv NVARCHAR(255) NOT NULL,
    Trajanje INT NOT NULL,
    Reziser NVARCHAR(255) NULL,
    GlavniGlumci NVARCHAR(MAX) NULL,
    SporedniGlumci NVARCHAR(MAX) NULL,
    ZanrID INT NOT NULL,
    KratkiOpis NVARCHAR(MAX) NULL,
    CONSTRAINT PK_Film PRIMARY KEY (ID),
    CONSTRAINT FK_Film_Medij FOREIGN KEY (MedijID) REFERENCES Medij(ID),
    CONSTRAINT FK_Film_Zanr FOREIGN KEY (ZanrID) REFERENCES Zanr(ID)
);

-- Step 3: Create Junction Tables for Transactions (Many-to-Many Implementations)
CREATE TABLE Posudba (
    FilmID INT NOT NULL,
    ClanID INT NOT NULL,
    DatumPosudbe DATETIME NOT NULL,
    DatumVracanja DATETIME NULL,
    CONSTRAINT FK_Posudba_Film FOREIGN KEY (FilmID) REFERENCES Film(ID),
    CONSTRAINT FK_Posudba_Clan FOREIGN KEY (ClanID) REFERENCES Clan(ID)
);

CREATE TABLE Rezervacija (
    FilmID INT NOT NULL,
    ClanID INT NOT NULL,
    DatumRezervacije DATETIME NOT NULL,
    CONSTRAINT FK_Rezervacija_Film FOREIGN KEY (FilmID) REFERENCES Film(ID),
    CONSTRAINT FK_Rezervacija_Clan FOREIGN KEY (ClanID) REFERENCES Clan(ID)
);

CREATE TABLE Zakasnina (
    ClanID INT NOT NULL,
    FilmID INT NOT NULL,
    DatumVracanja DATETIME NOT NULL,
    NaplacenaZakasnina DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Zakasnina_Clan FOREIGN KEY (ClanID) REFERENCES Clan(ID),
    CONSTRAINT FK_Zakasnina_Film FOREIGN KEY (FilmID) REFERENCES Film(ID)
);

-- ------------------------------------------------------------------------------------
-- SECTION 2: Advanced Relational Integrity & Performance (
-- ------------------------------------------------------------------------------------

-- Add specialized constraints to preserve business rules
-- Ensure that film runtimes and late fee fine amounts cannot be negative.
ALTER TABLE Film 
ADD CONSTRAINT CHK_Film_Trajanje CHECK (Trajanje > 0);

ALTER TABLE Zakasnina 
ADD CONSTRAINT CHK_Zakasnina_Iznos CHECK (NaplacenaZakasnina >= 0);