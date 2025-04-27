--------------------------------------------------------------------------------
-- Example Queries to Demonstrate DB Usage -------------------------------------
--------------------------------------------------------------------------------

-- List all books by a specific author
-- Display all books in the library collection written by a particular author.
SELECT m.title AS book_title
FROM  book         b
JOIN  media        m  ON b.media_id   = m.media_id
JOIN  media_author ma ON m.media_id   = ma.media_id
JOIN  author       a  ON ma.author_id = a.author_id
WHERE a.name = 'William Shakespeare';

-- Find books by publication year
-- Retrieve a list of books published in a specific year.
SELECT m.title AS book_title
FROM  book  b
JOIN  media m ON b.media_id = m.media_id
WHERE b.publication_year = 1997;

-- Check membership status
-- Display the current status and account information for a specific client based on their unique ID.
SELECT 
    c.client_id,
    c.name AS client_name,
    c.membership_type,
    c.account_status,
    ci.email,
    ci.phone,
    ci.address
FROM  client c
JOIN  contact_info ci ON c.contact_id = ci.contact_info_id
WHERE c.client_id = 1;

-- @TODO: Fine Calculation Example

-- Book availability
-- Display a list of all available books (not currently borrowed) within a specific genre.
SELECT m.title AS book_title
FROM book        b
JOIN media       m  ON b.media_id  = m.media_id
JOIN media_genre mg ON m.media_id  = mg.media_id
JOIN genre       g  ON mg.genre_id = g.genre_id
LEFT JOIN copy   c  ON b.media_id  = c.media_id
LEFT JOIN loan   l  ON c.copy_id   = l.copy_id
WHERE g.genre_name = 'fantasy'
AND (l.loan_id IS NULL OR l.return_date IS NOT NULL)
GROUP BY m.media_id;

-- @TODO: More examples...