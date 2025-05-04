--------------------------------------------------------------------------------
-- Table Creation --------------------------------------------------------------
--------------------------------------------------------------------------------

-- Contact info for authors, publishers, and clients.
CREATE TABLE contact_info (
    contact_info_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    email           VARCHAR(255),
    phone           VARCHAR(31),
    address         VARCHAR(512)
);

-- Author of media.
CREATE TABLE author (
    author_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(255) NOT NULL,
    contact_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (contact_id) REFERENCES contact_info(contact_info_id)
);

-- Publisher of media.
CREATE TABLE publisher (
    publisher_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    contact_id   INT UNSIGNED NOT NULL,
    FOREIGN KEY (contact_id) REFERENCES contact_info(contact_info_id)
);

-- Client of the library. Membership can be:
-- regular, student, senior, or librarian.
-- Membership determines allowed loan limit.
CREATE TABLE client (
    client_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(255) NOT NULL,
    contact_id INT UNSIGNED NOT NULL,
    membership_type ENUM('regular', 'student', 'senior', 'librarian') DEFAULT 'regular'  NOT NULL,
    account_status  ENUM('active', 'inactive')                        DEFAULT 'inactive' NOT NULL,
    FOREIGN KEY (contact_id) REFERENCES contact_info(contact_info_id)
);

-- Parent table for all media types
-- e.g. book, digital, and magazine.
CREATE TABLE media (
    media_id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title      VARCHAR(255) NOT NULL,
    media_type ENUM('book', 'digital', 'magazine') DEFAULT 'book' NOT NULL
);

-- *Media Specialization*
-- Child table for books.
CREATE TABLE book (
    book_id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    media_id         INT UNSIGNED NOT NULL,
    isbn             VARCHAR(17) UNIQUE NOT NULL,
    page_count       INT UNSIGNED,
    publisher        INT UNSIGNED,
    publication_year INT CHECK (publication_year IS NULL OR publication_year >= 0),
    language         VARCHAR(3) DEFAULT 'EN',
    FOREIGN KEY (media_id)  REFERENCES media(media_id) ON DELETE CASCADE,
    FOREIGN KEY (publisher) REFERENCES publisher(publisher_id),
    CONSTRAINT language_upper_case CHECK(language = UPPER(language))
);

-- *Media Specialization*
-- Child table for digital media.
-- Includes items like DVDs, etc.
CREATE TABLE digital (
    digital_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    media_id   INT UNSIGNED NOT NULL,
    isbn       VARCHAR(17) UNIQUE NOT NULL,
    format     ENUM('dvd') DEFAULT 'dvd' NOT NULL,
    publisher  INT UNSIGNED,
    publication_year INT CHECK (publication_year IS NULL OR publication_year >= 0),
    FOREIGN KEY (media_id)  REFERENCES media(media_id) ON DELETE CASCADE,
    FOREIGN KEY (publisher) REFERENCES publisher(publisher_id)
);

-- *Media Specialization*
-- Child table for magazines.
CREATE TABLE magazine (
    magazine_id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    media_id         INT UNSIGNED NOT NULL,
    issue_number     INT UNSIGNED,
    publisher        INT UNSIGNED,
    publication_date DATE,
    FOREIGN KEY (media_id)  REFERENCES media(media_id) ON DELETE CASCADE,
    FOREIGN KEY (publisher) REFERENCES publisher(publisher_id)
);

-- Genre table.
CREATE TABLE genre (
    genre_id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(255) NOT NULL
);

-- Media to author join table (many-to-many).
-- Note: Media can have multiple authors.
CREATE TABLE media_author (
    media_id  INT UNSIGNED NOT NULL,
    author_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (media_id)  REFERENCES media(media_id)   ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES author(author_id) ON DELETE CASCADE,
    PRIMARY KEY (media_id, author_id)
);

-- Media to genre join table (many-to-many).
-- Note: Media can have multiple genres.
CREATE TABLE media_genre (
    media_id INT UNSIGNED NOT NULL,
    genre_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (media_id) REFERENCES media(media_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genre(genre_id) ON DELETE CASCADE,
    PRIMARY KEY (media_id, genre_id)
);

-- Copy of a media item. A media
-- can have many physical copies.
CREATE TABLE copy (
    copy_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    media_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (media_id) REFERENCES media(media_id) ON DELETE CASCADE
);

-- Loan of a copy to a client.
CREATE TABLE loan (
    loan_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    copy_id     INT UNSIGNED NOT NULL,
    client_id   INT UNSIGNED NOT NULL,
    loan_date   DATETIME DEFAULT CURRENT_TIMESTAMP,
    due_date    DATETIME, 
    return_date DATE,
    FOREIGN KEY (copy_id)   REFERENCES copy(copy_id)     ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

-- Reservation of a copy to a client.
CREATE TABLE reservation (
    reservation_id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    media_id          INT UNSIGNED NOT NULL,
    client_id         INT UNSIGNED NOT NULL,
    reservation_date  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (media_id)  REFERENCES media(media_id)   ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- Integrity Enforcement -------------------------------------------------------
--------------------------------------------------------------------------------

DELIMITER $$ -- INTEGRITY TRIGGER
-- Limit the number of loans per client based
-- on their membership type
CREATE TRIGGER limit_loans_per_client
BEFORE INSERT ON loan
FOR EACH ROW
BEGIN
    DECLARE loan_limit INT;
    SELECT CASE
        -- Borrow limit per membership type.
        WHEN membership_type = 'regular'   THEN 3
        WHEN membership_type = 'student'   THEN 5
        WHEN membership_type = 'senior'    THEN 5
        WHEN membership_type = 'librarian' THEN NULL
    END INTO loan_limit
    FROM client
    WHERE client_id = NEW.client_id;

    IF loan_limit IS NOT NULL THEN
        IF (
                SELECT COUNT(*) 
                FROM loan 
                WHERE client_id = NEW.client_id 
                AND return_date IS NULL
            ) > loan_limit THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Loan limit exceeded for this client.';
        END IF;
    END IF;
END$$
DELIMITER ;

DELIMITER $$ -- INTEGRITY TRIGGER
-- Prevent reservation if NOT all copies of the
-- desired media are already on loan.
CREATE TRIGGER check_all_copies_borrowed
BEFORE INSERT ON reservation
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM copy C
        LEFT JOIN loan L ON C.copy_id = L.copy_id
        WHERE C.media_id = 12
        GROUP BY C.copy_id
        HAVING COUNT(L.loan_id) = 0 OR MAX(ISNULL(L.return_date)) <> 1
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation not allowed: Not all copies of the media are currently on loan.';
    END IF;
END$$
DELIMITER ;

DELIMITER $$

DROP TRIGGER IF EXISTS set_due_date_default$$
-- Make the default due date two weeks from the start of the loan
CREATE TRIGGER set_due_date_default
BEFORE INSERT ON loan
FOR EACH ROW
BEGIN
    IF NEW.due_date IS NULL THEN
        SET NEW.due_date = DATE_ADD(
            COALESCE(NEW.loan_date, CURRENT_TIMESTAMP), 
            INTERVAL 2 WEEK
        );
    END IF;
END$$

DELIMITER ;


--------------------------------------------------------------------------------