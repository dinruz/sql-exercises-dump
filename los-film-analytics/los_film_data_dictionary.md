# 📖 Data Dictionary (LosFilm Schema)

This dictionary maps the localized Croatian database objects and column names for the LosFilm platform to standard English terminology, matching the production ER diagram layout.

### Table: `Mjesto` (Location / City)
| Column Name (Hrvatski) | English Mapping | Data Type | Description |
| :--- | :--- | :--- | :--- |
| **`ID`** | Location ID | INT (PK, Identity) | Unique system identifier for a location record. |
| **`PostanskiBroj`** | Postal Code | INT | Postal code of the municipality (e.g., 21220). |
| **`Naziv`** | Location Name | NVARCHAR(255) | Name of the city/town (e.g., 'Trogir'). |
| **`Naselje`** | Settlement | NVARCHAR(255) | Specific settlement or neighborhood area. |
| **`Zupanija`** | County | NVARCHAR(255) | Regional county division (e.g., 'ISTARSKA'). |

### Table: `Clan` (Member / Customer)
| Column Name (Hrvatski) | English Mapping | Data Type | Description |
| :--- | :--- | :--- | :--- |
| **`ID`** | Member ID | INT (PK) | Unique identifier for a club member account. |
| **`ImePrezime`** | Full Name | NVARCHAR(255) | First and last name of the member. |
| **`Ulica`** | Street Address | NVARCHAR(255) | Street name of the member's residence. |
| **`KucniBroj`** | House Number | NVARCHAR(50) | House/Apartment number. |
| **`MjestoID`** | Location ID | INT (FK) | Links the member to their primary location in the `Mjesto` table. |
| **`Telefon`** | Phone Number | NVARCHAR(50) | Contact phone number of the member (can be NULL). |

### Table: `Zanr` (Genre)
| Column Name (Hrvatski) | English Mapping | Data Type | Description |
| :--- | :--- | :--- | :--- |
| **`ID`** | Genre ID | INT (PK, Identity) | Unique identifier for a movie genre. |
| **`Naziv`** | Genre Name | NVARCHAR(255) | Name of the genre (e.g., 'SF', 'Drama'). |

### Table: `Medij` (Media Format)
| Column Name (Hrvatski) | English Mapping | Data Type | Description |
| :--- | :--- | :--- | :--- |
| **`ID`** | Media ID | INT (PK) | Unique identifier for the physical media format. |
| **`Naziv`** | Format Name | NVARCHAR(255) | Format classification (e.g., 'Blu-ray', 'DVD'). |

### Table: `Film` (Movie / Inventory)
| Column Name (Hrvatski) | English Mapping | Data Type | Description |
| :--- | :--- | :--- | :--- |
| **`ID`** | Movie ID | INT (PK) | Unique identifier for a movie record. |
| **`MedijID`** | Media ID | INT (FK) | Links the movie to its physical media format in the `Medij` table. |
| **`Naziv`** | Movie Title | NVARCHAR(255) | Commercial title of the film. |
| **`Trajanje`** | Duration | INT | Runtime of the movie in minutes. |
| **`Reziser`** | Director | NVARCHAR(255) | Name of the film director. |
| **`GlavniGlumci`** | Main Cast | NVARCHAR(MAX) | List of lead actors. |
| **`SporedniGlumci`** | Supporting Cast | NVARCHAR(MAX) | List of supporting actors (can be NULL). |
| **`ZanrID`** | Genre ID | INT (FK) | Links the movie to its genre category in the `Zanr` table. |
| **`KratkiOpis`** | Plot Summary | NVARCHAR(MAX) | Brief synopsis or plot outline. |

### Table: `Posudba` (Rental Transaction)
| Column Name (Hrvatski) | English Mapping | Data Type | Description |
| :--- | :--- | :--- | :--- |
| **`FilmID`** | Movie ID | INT (FK) | Binds the transaction to the rented movie. |
| **`ClanID`** | Member ID | INT (FK) | Binds the transaction to the member who rented the film. |
| **`DatumPosudbe`** | Rental Date | DATETIME | The date when the movie was checked out. |
| **`DatumVracanja`** | Return Date | DATETIME | The date when the movie was returned (can be NULL). |

### Table: `Rezervacija` (Movie Reservation)
| Column Name (Hrvatski) | English Mapping | Data Type | Description |
| :--- | :--- | :--- | :--- |
| **`FilmID`** | Movie ID | INT (FK) | Links the reserved movie asset. |
| **`DatumRezervacije`** | Reservation Date | DATETIME | The timestamp when the movie hold was created. |
| **`ClanID`** | Member ID | INT (FK) | Links the member who requested the reservation. |

### Table: `Zakasnina` (Late Fee)
| Column Name (Hrvatski) | English Mapping | Data Type | Description |
| :--- | :--- | :--- | :--- |
| **`ClanID`** | Member ID | INT (FK) | Links the penalized member. |
| **`FilmID`** | Movie ID | INT (FK) | Links the overdue movie. |
| **`Datum`** | Fine Date | DATETIME | Timestamp tracking when the fine was registered. |
| `NaplacenaZakasnina`| Fine Amount | DECIMAL / MONEY | The cash amount charged for the late return. |