-- 1. Create and select the database

USE music_database;

-- 2. Disable Foreign Key checks temporarily to safely drop existing tables
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS playlist_track;
DROP TABLE IF EXISTS playlist;
DROP TABLE IF EXISTS invoice_line;
DROP TABLE IF EXISTS invoice;
DROP TABLE IF EXISTS track;
DROP TABLE IF EXISTS media_type;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS album;
DROP TABLE IF EXISTS artist;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS employee;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- 2. CREATE TABLES
-- =============================================================================

CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    title VARCHAR(50),
    reports_to INT,
    levels VARCHAR(10),
    birthdate VARCHAR(30),
    hire_date VARCHAR(30),
    address VARCHAR(120),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    postal_code VARCHAR(20),
    phone VARCHAR(30),
    fax VARCHAR(30),
    email VARCHAR(100)
);


CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    company VARCHAR(100),
    address VARCHAR(120),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    postal_code VARCHAR(20),
    phone VARCHAR(30),
    fax VARCHAR(30),
    email VARCHAR(100),
    support_rep_id INT,
    FOREIGN KEY (support_rep_id) REFERENCES employee(employee_id) ON DELETE SET NULL
);


CREATE TABLE artist (
    artist_id INT PRIMARY KEY,
    name VARCHAR(120)
);


CREATE TABLE album (
    album_id INT PRIMARY KEY,
    title VARCHAR(160),
    artist_id INT,
    FOREIGN KEY (artist_id) REFERENCES artist(artist_id) ON DELETE CASCADE
);


CREATE TABLE genre (
    genre_id INT PRIMARY KEY,
    name VARCHAR(120)
);


CREATE TABLE media_type (
    media_type_id INT PRIMARY KEY,
    name VARCHAR(120)
);


CREATE TABLE track (
    track_id INT PRIMARY KEY,
    name VARCHAR(200),
    album_id INT,
    media_type_id INT,
    genre_id INT,
    composer VARCHAR(220),
    milliseconds INT,
    bytes INT,
    unit_price DECIMAL(10, 2),
    FOREIGN KEY (album_id) REFERENCES album(album_id) ON DELETE CASCADE,
    FOREIGN KEY (media_type_id) REFERENCES media_type(media_type_id),
    FOREIGN KEY (genre_id) REFERENCES genre(genre_id)
);


CREATE TABLE invoice (
    invoice_id INT PRIMARY KEY,
    customer_id INT,
    invoice_date VARCHAR(30),
    billing_address VARCHAR(120),
    billing_city VARCHAR(50),
    billing_state VARCHAR(50),
    billing_country VARCHAR(50),
    billing_postal_code VARCHAR(20),
    total DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);


CREATE TABLE invoice_line (
    invoice_line_id INT PRIMARY KEY,
    invoice_id INT,
    track_id INT,
    unit_price DECIMAL(10, 2),
    quantity INT,
    FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id) ON DELETE CASCADE,
    FOREIGN KEY (track_id) REFERENCES track(track_id) ON DELETE CASCADE
);


CREATE TABLE playlist (
    playlist_id INT PRIMARY KEY,
    name VARCHAR(120)
);


CREATE TABLE playlist_track (
    playlist_id INT,
    track_id INT,
    PRIMARY KEY (playlist_id, track_id),
    FOREIGN KEY (playlist_id) REFERENCES playlist(playlist_id) ON DELETE CASCADE,
    FOREIGN KEY (track_id) REFERENCES track(track_id) ON DELETE CASCADE
);

SHOW TABLES;


USE music_database;

SELECT 'employee' AS table_name, COUNT(*) AS total_rows FROM employee
UNION ALL
SELECT 'customer', COUNT(*) FROM customer
UNION ALL
SELECT 'artist', COUNT(*) FROM artist
UNION ALL
SELECT 'album', COUNT(*) FROM album
UNION ALL
SELECT 'genre', COUNT(*) FROM genre
UNION ALL
SELECT 'media_type', COUNT(*) FROM media_type
UNION ALL
SELECT 'track', COUNT(*) FROM track
UNION ALL
SELECT 'invoice', COUNT(*) FROM invoice
UNION ALL
SELECT 'invoice_line', COUNT(*) FROM invoice_line
UNION ALL
SELECT 'playlist', COUNT(*) FROM playlist
UNION ALL
SELECT 'playlist_track', COUNT(*) FROM playlist_track;

SET FOREIGN_KEY_CHECKS = 0;

SELECT * FROM customer;
SELECT * FROM track;
SELECT * FROM invoice;
SELECT * FROM invoice_line;
SELECT * FROM playlist_track;

SET FOREIGN_KEY_CHECKS = 1;


SELECT 'employee' AS table_name, COUNT(*) AS total_rows FROM employee
UNION ALL
SELECT 'customer', COUNT(*) FROM customer
UNION ALL
SELECT 'artist', COUNT(*) FROM artist
UNION ALL
SELECT 'album', COUNT(*) FROM album
UNION ALL
SELECT 'genre', COUNT(*) FROM genre
UNION ALL
SELECT 'media_type', COUNT(*) FROM media_type
UNION ALL
SELECT 'track', COUNT(*) FROM track
UNION ALL
SELECT 'invoice', COUNT(*) FROM invoice
UNION ALL
SELECT 'invoice_line', COUNT(*) FROM invoice_line
UNION ALL
SELECT 'playlist', COUNT(*) FROM playlist
UNION ALL
SELECT 'playlist_track', COUNT(*) FROM playlist_track;

USE music_database;

-- 1. Enable local file loading and disable Foreign Key checks
SET GLOBAL local_infile = 1;
SET FOREIGN_KEY_CHECKS = 0;

-- 2. Clear only the incomplete tables
TRUNCATE TABLE employee;
TRUNCATE TABLE track;
TRUNCATE TABLE invoice_line;
TRUNCATE TABLE playlist_track;

-- 3. Reload Employee (9 rows)
LOAD DATA LOCAL INFILE '"C:\Users\VANDAN\Desktop\Sql_learning\music store data\employee.csv"'
INTO TABLE employee
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- 4. Reload Track (3,503 rows)
LOAD DATA LOCAL INFILE 'C:/path/to/track.csv'
INTO TABLE track
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- 5. Reload Invoice Line (4,757 rows)
LOAD DATA LOCAL INFILE 'C:/path/to/invoice_line.csv'
INTO TABLE invoice_line
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- 6. Reload Playlist Track (8,715 rows)
LOAD DATA LOCAL INFILE 'C:/path/to/playlist_track.csv'
INTO TABLE playlist_track
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- 7. Re-enable Foreign Key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Question Set 1 

-- Q1: Who is the senior-most employee based on job title?

SELECT title, last_name, first_name
FROM employee
ORDER BY levels DESC
LIMIT 1;

-- Q2: Which countries have the most Invoices?

SELECT billing_country, COUNT(*) AS total_invoices
FROM invoice
GROUP BY billing_country
ORDER BY total_invoices DESC;

-- Q3: What are the top 3 values of total invoice?

SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;

-- Q4: Which city has the best customers?
-- (Find the city that has the highest sum of invoice totals to throw a promotional Music Festival).

SELECT billing_city, SUM(total) AS total_revenue
FROM invoice
GROUP BY billing_city
ORDER BY total_revenue DESC
LIMIT 1;

-- Q5: Who is the best customer?
-- (The customer who has spent the most money).

SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    ROUND(SUM(i.total), 2) AS total_spent 
FROM customer c 
JOIN invoice i ON c.customer_id = i.customer_id 
GROUP BY c.customer_id, c.first_name, c.last_name 
ORDER BY total_spent DESC 
LIMIT 1;


-- Question Set 2

-- Q1: Write query to Return the email, first name, and last name & Genre of of all Rock Music listeners.
-- Return your list ordered alteralphabetically by email staring whit A

SELECT DISTINCT 
    c.email, 
    c.first_name, 
    c.last_name 
FROM customer c 
JOIN invoice i ON c.customer_id = i.customer_id 
JOIN invoice_line il ON i.invoice_id = il.invoice_id 
WHERE il.track_id IN (
    SELECT t.track_id 
    FROM track t 
    JOIN genre g ON t.genre_id = g.genre_id 
    WHERE g.name = 'Rock'
)
ORDER BY c.email ASC;


-- Q2: Invite the artists who have written the most rock music. 
-- Return the Artist name and total track count of the top 10 rock bands.

SELECT 
    ar.artist_id, 
    ar.name, 
    COUNT(t.track_id) AS total_rock_tracks 
FROM track t 
JOIN album al ON t.album_id = al.album_id 
JOIN artist ar ON al.artist_id = ar.artist_id 
JOIN genre g ON t.genre_id = g.genre_id 
WHERE g.name = 'Rock' 
GROUP BY ar.artist_id, ar.name 
ORDER BY total_rock_tracks DESC 
LIMIT 10;


-- Q3: Return all track names that have a song length longer than the average song length.

SELECT name, milliseconds 
FROM track 
WHERE milliseconds > (
    SELECT AVG(milliseconds) 
    FROM track
) 
ORDER BY milliseconds DESC;


-- Question Set 3

-- Q1: Find how much amount is spent by each customer on the top best-selling artist.

WITH best_selling_artist AS (
    SELECT 
        ar.artist_id, 
        ar.name AS artist_name, 
        SUM(il.unit_price * il.quantity) AS total_sales 
    FROM invoice_line il 
    JOIN track t ON il.track_id = t.track_id 
    JOIN album al ON t.album_id = al.album_id 
    JOIN artist ar ON al.artist_id = ar.artist_id 
    GROUP BY ar.artist_id, ar.name 
    ORDER BY total_sales DESC 
    LIMIT 1
)
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    bsa.artist_name, 
    ROUND(SUM(il.unit_price * il.quantity), 2) AS amount_spent 
FROM customer c 
JOIN invoice i ON c.customer_id = i.customer_id 
JOIN invoice_line il ON i.invoice_id = il.invoice_id 
JOIN track t ON il.track_id = t.track_id 
JOIN album al ON t.album_id = al.album_id 
JOIN best_selling_artist bsa ON al.artist_id = bsa.artist_id 
GROUP BY c.customer_id, c.first_name, c.last_name, bsa.artist_name 
ORDER BY amount_spent DESC;

-- Q2: Find the most popular music genre for each country (highest purchase count).


WITH popular_genre AS (
    SELECT 
        c.country, 
        g.name AS genre_name, 
        COUNT(il.quantity) AS total_purchases, 
        DENSE_RANK() OVER(
            PARTITION BY c.country 
            ORDER BY COUNT(il.quantity) DESC
        ) AS rank_num 
    FROM invoice_line il 
    JOIN invoice i ON il.invoice_id = i.invoice_id 
    JOIN customer c ON i.customer_id = c.customer_id 
    JOIN track t ON il.track_id = t.track_id 
    JOIN genre g ON t.genre_id = g.genre_id 
    GROUP BY c.country, g.name
)
SELECT 
    country, 
    genre_name, 
    total_purchases 
FROM popular_genre 
WHERE rank_num = 1 
ORDER BY country ASC;


-- Q3: Determine the customer that has spent the most on music for each country.

WITH customer_country_spending AS (
    SELECT 
        c.country, 
        c.customer_id, 
        c.first_name, 
        c.last_name, 
        ROUND(SUM(i.total), 2) AS total_spending, 
        DENSE_RANK() OVER(
            PARTITION BY c.country 
            ORDER BY SUM(i.total) DESC
        ) AS rank_num 
    FROM customer c 
    JOIN invoice i ON c.customer_id = i.customer_id 
    GROUP BY c.country, c.customer_id, c.first_name, c.last_name
)
SELECT 
    country, 
    first_name, 
    last_name, 
    total_spending 
FROM customer_country_spending 
WHERE rank_num = 1 
ORDER BY country ASC;
