# 📖 Data Dictionary (AdventureWorks Schema)

This dictionary maps the localized Croatian database objects and column names to standard English terminology, fully matching the production ER diagram schema.

### Table: `Drzava` (Country)

| Column Name (Hrvatski) | English Mapping | Data Type | Description |
| :--- | :--- | :--- | :--- |
| **`IDDrzava`** | Country ID | INT (PK, Identity) | Unique system identifier for a country record. |
| **`Naziv`** | Country Name | NVARCHAR(255) | Name of the country (e.g., 'Argentina'). |

### Table: `Grad` (City)

| Column Name (Hrvatski) | English Mapping | Data Type | Business Description |
| :--- | :--- | :--- | :--- |
| **`IDGrad`** | City ID | INT (PK, Identity) | Unique system identifier for a city record. |
| **`Naziv`** | City Name | NVARCHAR(255) | Name of the city (e.g., 'Gospić', 'Buenos Aires'). |
| **`DrzavaID`** | Country ID | INT (FK) | Links the city to its parent country in the `Drzava` table. |

---

### Table: `Kupac` (Customer)

| Column Name (Hrvatski) | English Mapping | Data Type | Description |
| :--- | :--- | :--- | :--- |
| **`IDKupac`** | Customer ID | INT (PK, Identity) | Unique identifier for a customer account. |
| **`Ime`** | First Name | NVARCHAR(255) | First name of the customer. |
| **`Prezime`** | Last Name | NVARCHAR(255) | Last name of the customer. |
| **`Email`** | Email Address | NVARCHAR(255) | Customer's email address (can be NULL). |
| **`Telefon`** | Phone Number | NVARCHAR(50) | Customer's contact phone number (can be NULL). |
| **`GradID`** | City ID | INT (FK) | Links the customer to their primary city in the `Grad` table. |

### Table: `KreditnaKartica` (Credit Card)

| Column Name (Hrvatski) | English Mapping | Data Type | Description |
| :--- | :--- | :--- | :--- |
| **`IDKreditnaKartica`** | Credit Card ID | INT (PK, Identity) | Unique identifier for a payment card. |
| **`Tip`** | Card Provider Type | NVARCHAR(50) | Brand of the credit card (e.g., 'Visa', 'MasterCard'). |
| **`Broj`** | Card Number | NVARCHAR(50) | Alphanumeric card number string. |
| **`IstekMjesec`** | Expiration Month | INT | The month the credit card expires. |
| **`IstekGodina`** | Expiration Year | INT | The year the credit card expires. |

### Table: `Komercijalist` (Sales Representative)

| Column Name (Hrvatski) | English Mapping | Data Type | Description |
| :--- | :--- | :--- | :--- |
| **`IDKomercijalist`** | Sales Rep ID | INT (PK, Identity) | Unique identifier for an internal sales agent. |
| **`Ime`** | First Name | NVARCHAR(255) | First name of the sales representative. |
| **`Prezime`** | Last Name | NVARCHAR(255) | Last name of the sales representative. |
| **`StalniZaposlenik`** | Full-Time Employee | BIT / INT | Flags employment status (`1` = Full-time employee, `0` = Contractor). |

---

### Table: `Racun` (Invoice Header)

| Column Name (Hrvatski) | English Mapping | Data Type | Description |
| :--- | :--- | :--- | :--- |
| **`IDRacun`** | Invoice ID | INT (PK, Identity) | Unique transaction ID for the entire order header. |
| **`DatumIzdavanja`** | Order Date | DATETIME | The date and time when the invoice was issued. |
| **`BrojRacuna`** | Invoice Number | NVARCHAR(50) | Official commercial business number of the invoice. |
| **`KupacID`** | Customer ID | INT (FK) | Links the transaction to the purchasing customer in the `Kupac` table. |
| **`KomercijalistID`** | Sales Rep ID | INT (FK) | Links the internal sales rep who managed the order (can be NULL). |
| **`KreditnaKarticaID`** | Credit Card ID | INT (FK) | Links the card used for payment (NULL if paid with cash). |
| **`Komentar`** | Invoice Comments | NVARCHAR(MAX) | Free-form notes or comments attached to the invoice. |

### Table: `Stavka` (Invoice Line Item)

| Column Name (Hrvatski) | English Mapping | Data Type | Description |
| :--- | :--- | :--- | :--- |
| **`IDStavka`** | Line Item ID | INT (PK, Identity) | Unique identifier for a specific item row inside an invoice. |
| **`RacunID`** | Invoice ID | INT (FK) | Binds the line item back to its main invoice header in the `Racun` table. |
| **`Kolicina`** | Quantity | INT | The number of product units purchased in this line item. |
| **`ProizvodID`** | Product ID | INT (FK) | Links the line item to the purchased product in the `Proizvod` table. |
| **`CijenaPoKomadu`** | Unit Price | MONEY / DECIMAL | The unit price of the product at the time of purchase. |
| **`PopustUPostocima`** | Discount Percentage | DECIMAL / NUMERIC | The discount percentage applied to this line item (e.g., 0.10 for 10%). |
| **`UkupnaCijena`** | Line Total | MONEY / DECIMAL | The total cost for this line after applying quantity and discounts. |

---

### Table: `Kategorija` (Category)

| Column Name (Hrvatski) | English Mapping | Data Type | Description |
| :--- | :--- | :--- | :--- |
| **`IDKategorija`** | Category ID | INT (PK, Identity) | Highest grouping level for inventory products. |
| **`Naziv`** | Category Name | NVARCHAR(255) | Name of the category (e.g., 'Razno', 'Bikes'). |

### Table: `Potkategorija` (Subcategory)

| Column Name (Hrvatski) | English Mapping | Data Type | Description |
| :--- | :--- | :--- | :--- |
| **`IDPotkategorija`** | Subcategory ID | INT (PK, Identity) | Secondary, mid-level grouping layer under a category. |
| **`KategorijaID`** | Category ID | INT (FK) | Links the subcategory back to its parent category in the `Kategorija` table. |
| **`Naziv`** | Subcategory Name | NVARCHAR(255) | Name of the subcategory (e.g., 'Playeri', 'Helmets'). |

### Table: `Proizvod` (Product)

| Column Name (Hrvatski) | English Mapping | Data Type | Description |
| :--- | :--- | :--- | :--- |
| **`IDProizvod`** | Product ID | INT (PK, Identity) | Unique system identifier for a product. |
| **`Naziv`** | Product Name | NVARCHAR(255) | Commercial consumer name of the product. |
| **`BrojProizvoda`** | Part Number / SKU | NVARCHAR(50) | Alphanumeric manufacturer stock keeping unit (SKU) code. |
| **`Boja`** | Product Color | NVARCHAR(50) | Product color attribute (can be NULL). |
| **`MinimalnaKolicinaNaSkladistu`**| Safety Stock Level | INT | Minimum inventory threshold required before a restock is triggered. |
| **`CijenaBezPDV`** | Net Price (Excl. Tax) | MONEY / DECIMAL | Base price of the product before government tax is applied. |
| **`PotkategorijaID`** | Subcategory ID | INT (FK) | Links the product directly to its subcategory in the `Potkategorija` table. |