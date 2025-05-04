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
-- other authors: 'Bill Wallace", "Tom Clancy"

-- Find books by publication year
-- Retrieve a list of books published in a specific year.
SELECT m.title AS book_title
FROM  book  b
JOIN  media m ON b.media_id = m.media_id
WHERE b.publication_year = 1998;
-- other years: 2015, 1472

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

-- INCOMPLETE, will require seed data manipulation, need to create overdue loans
-- Fine calculation 
-- Calculate the total fines owed by each member, considering overdue books and a daily fine rate (e.g., $0.25 per day).
SELECT 
    c.client_id,
    c.name AS client_name,
    COUNT(l.loan_id) AS overdue_loans,
    SUM(DATEDIFF(CURDATE(), l.due_date) * 0.25) AS total_fines
FROM loan l
JOIN client c ON l.client_id = c.client_id
WHERE l.return_date IS NULL
  AND l.due_date < CURDATE()
GROUP BY c.client_id, c.name
ORDER BY total_fines DESC;


-- Book availability
-- Display a list of all available books (not currently borrowed) within a specific genre.
SELECT 
    b.book_id,
    m.title,
    b.isbn,
    b.language,
    b.publication_year,
    GROUP_CONCAT(DISTINCT g.genre_name ORDER BY g.genre_name SEPARATOR ', ') AS genres,
    COUNT(c.copy_id) AS available_copies
FROM book b
JOIN media m ON b.media_id = m.media_id
JOIN copy c ON c.media_id = m.media_id
LEFT JOIN loan l ON l.copy_id = c.copy_id AND l.return_date IS NULL
JOIN media_genre mg ON mg.media_id = m.media_id
JOIN genre g ON g.genre_id = mg.genre_id
WHERE l.loan_id IS NULL AND g.genre_name = 'art'
GROUP BY b.book_id, m.title, b.isbn, b.language, b.publication_year
ORDER BY m.title;
-- Note: use 'nintendo' as alternate value to get results
-- This query is limited due to very few database entries matching the description
-- I think I just deleted some random loans to free these up

-- Frequent borrowers of a specific genre 
-- Identify the members who have borrowed the most books in a particular genre (e.g., "Mystery") in the last year.
SELECT 
    cl.client_id,
    cl.name AS client_name,
    COUNT(*) AS borrowed_count
FROM loan l
JOIN copy cp ON l.copy_id = cp.copy_id
JOIN media m ON cp.media_id = m.media_id
JOIN media_genre mg ON mg.media_id = m.media_id
JOIN genre g ON g.genre_id = mg.genre_id
JOIN client cl ON cl.client_id = l.client_id
WHERE g.genre_name = 'Mystery'
  AND l.loan_date >= CURDATE() - INTERVAL 1 YEAR
GROUP BY cl.client_id, cl.name
ORDER BY borrowed_count DESC;


-- Books due soon 
-- Generate a report of all books due within the next week, sorted by due date.
SELECT 
    l.loan_id,
    cl.name AS client_name,
    m.title AS book_title,
    l.due_date
FROM loan l
JOIN copy cp ON l.copy_id = cp.copy_id
JOIN media m ON cp.media_id = m.media_id
JOIN client cl ON cl.client_id = l.client_id
WHERE l.return_date IS NULL
  AND l.due_date BETWEEN CURDATE() AND CURDATE() + INTERVAL 7 DAY
ORDER BY l.due_date ASC;


-- INCOMPLETE, requires editing seed file to create overdue books
-- Members with overdue books: 
-- List all members who currently have at least one overdue book, along with the titles of the overdue books.
SELECT 
    cl.client_id,
    cl.name AS client_name,
    m.title AS overdue_book_title,
    l.due_date
FROM loan l
JOIN copy cp ON l.copy_id = cp.copy_id
JOIN media m ON cp.media_id = m.media_id
JOIN client cl ON cl.client_id = l.client_id
WHERE l.return_date IS NULL
  AND l.due_date < CURDATE()
ORDER BY cl.name, l.due_date;
-- NOTE: do 'CURDATE() + INTERVAL 15 DAY' to get results, this proves the statement works, just no overdue books at the moment



-- Average borrowing time:
-- Calculate the average number of days members borrow books for a specific genre.
SELECT 
    g.genre_name,
    AVG(DATEDIFF(l.return_date, l.loan_date)) AS average_borrow_days
FROM loan l
JOIN copy cp ON l.copy_id = cp.copy_id
JOIN media m ON cp.media_id = m.media_id
JOIN media_genre mg ON mg.media_id = m.media_id
JOIN genre g ON g.genre_id = mg.genre_id
WHERE l.return_date IS NOT NULL
  AND g.genre_name = 'Science'
GROUP BY g.genre_name;


-- Most popular author in the last month 
-- Determine the author whose books have been borrowed the most in the last month.
SELECT 
    a.author_id,
    a.name AS author_name,
    COUNT(*) AS borrow_count
FROM loan l
JOIN copy cp ON l.copy_id = cp.copy_id
JOIN media m ON cp.media_id = m.media_id
JOIN media_author ma ON ma.media_id = m.media_id
JOIN author a ON a.author_id = ma.author_id
WHERE l.loan_date >= CURDATE() - INTERVAL 1 MONTH
GROUP BY a.author_id, a.name
ORDER BY borrow_count DESC
LIMIT 1;

-- INCOMPLETE, see if it is fixed when we create overdue books
-- may need to create very specific loan that was returned overdue in the last month
-- Monthly fees report: 
-- Generate a report of total fees collected within the last month, broken down by membership type.
SELECT 
    c.membership_type,
    SUM(DATEDIFF(CURDATE(), l.due_date) * 0.25) AS total_fees_collected
FROM loan l
JOIN client c ON l.client_id = c.client_id
WHERE l.return_date IS NULL
  AND l.due_date < CURDATE()
  AND l.loan_date >= CURDATE() - INTERVAL 1 MONTH
GROUP BY c.membership_type;

-- Exceeded borrowing limits
-- Produce a list of clients who have exceeded their borrowing limits.
SELECT 
    c.client_id,
    c.name,
    c.membership_type,
    COUNT(l.loan_id) AS active_loans
FROM client c
JOIN loan l ON c.client_id = l.client_id
WHERE l.return_date IS NULL
GROUP BY c.client_id, c.name, c.membership_type
HAVING (
    (c.membership_type = 'regular'   AND COUNT(l.loan_id) > 3) OR
    (c.membership_type = 'student'   AND COUNT(l.loan_id) > 5) OR
    (c.membership_type = 'senior'    AND COUNT(l.loan_id) > 5)
);
-- NOTE: Our trigger limit_loans_per_client makes the existence of clients who have exceeded borrowing limits impossible, it will return an empty set


-- Frequent borrowed items by client type 
-- Determine the most frequently borrowed items by each client type.
SELECT 
    c.membership_type,
    m.title,
    COUNT(*) AS borrow_count
FROM loan l
JOIN copy cp ON l.copy_id = cp.copy_id
JOIN media m ON cp.media_id = m.media_id
JOIN client c ON c.client_id = l.client_id
GROUP BY c.membership_type, m.title
ORDER BY c.membership_type, borrow_count DESC;


-- Never late returns
-- Find out which clients have never returned an item late.
SELECT 
    c.client_id,
    c.name AS client_name
FROM client c
WHERE NOT EXISTS (
    SELECT 1
    FROM loan l
    WHERE l.client_id = c.client_id
      AND l.return_date IS NOT NULL
      AND l.return_date > l.due_date
);


-- Average loan duration
-- Calculate the average time an item stays on loan before being returned
SELECT 
    AVG(DATEDIFF(return_date, loan_date)) AS avg_loan_duration_days
FROM loan
WHERE return_date IS NOT NULL;


-- Monthly summary report
-- Generate a report summarizing the total number of items loaned, total fees collected, and most popular items for the month.
SELECT 
    -- Total items loaned this month
    (SELECT COUNT(*) 
     FROM loan 
     WHERE loan_date >= CURDATE() - INTERVAL 1 MONTH) AS total_items_loaned,

    -- Total overdue fees collected this month
    (SELECT SUM(DATEDIFF(CURDATE(), due_date) * 0.25) 
     FROM loan 
     WHERE return_date IS NULL 
       AND due_date < CURDATE() 
       AND loan_date >= CURDATE() - INTERVAL 1 MONTH) AS total_fees_collected,

    -- Most popular item and borrow count
    (SELECT m.title 
     FROM loan l
     JOIN copy c ON l.copy_id = c.copy_id
     JOIN media m ON c.media_id = m.media_id
     WHERE l.loan_date >= CURDATE() - INTERVAL 1 MONTH
     GROUP BY m.title
     ORDER BY COUNT(*) DESC
     LIMIT 1 OFFSET 0) AS most_popular_item,
     
    (SELECT COUNT(*) 
     FROM loan l
     JOIN copy c ON l.copy_id = c.copy_id
     JOIN media m ON c.media_id = m.media_id
     WHERE l.loan_date >= CURDATE() - INTERVAL 1 MONTH
     GROUP BY m.title
     ORDER BY COUNT(*) DESC
     LIMIT 1 OFFSET 0) AS most_popular_item_count,

    -- Second most popular item and count
    (SELECT m.title 
     FROM loan l
     JOIN copy c ON l.copy_id = c.copy_id
     JOIN media m ON c.media_id = m.media_id
     WHERE l.loan_date >= CURDATE() - INTERVAL 1 MONTH
     GROUP BY m.title
     ORDER BY COUNT(*) DESC
     LIMIT 1 OFFSET 1) AS second_most_popular_item,

    (SELECT COUNT(*) 
     FROM loan l
     JOIN copy c ON l.copy_id = c.copy_id
     JOIN media m ON c.media_id = m.media_id
     WHERE l.loan_date >= CURDATE() - INTERVAL 1 MONTH
     GROUP BY m.title
     ORDER BY COUNT(*) DESC
     LIMIT 1 OFFSET 1) AS second_most_popular_item_count,

    -- Third most popular item and count
    (SELECT m.title 
     FROM loan l
     JOIN copy c ON l.copy_id = c.copy_id
     JOIN media m ON c.media_id = m.media_id
     WHERE l.loan_date >= CURDATE() - INTERVAL 1 MONTH
     GROUP BY m.title
     ORDER BY COUNT(*) DESC
     LIMIT 1 OFFSET 2) AS third_most_popular_item,

    (SELECT COUNT(*) 
     FROM loan l
     JOIN copy c ON l.copy_id = c.copy_id
     JOIN media m ON c.media_id = m.media_id
     WHERE l.loan_date >= CURDATE() - INTERVAL 1 MONTH
     GROUP BY m.title
     ORDER BY COUNT(*) DESC
     LIMIT 1 OFFSET 2) AS third_most_popular_item_count;
-- NOTE: This is a wordy return, currently set up to give the three most popular items of the last month



-- Statistics breakdown 
-- Breakdown the statistics by client type and item category (books, digital media, magazines).
SELECT 
    c.membership_type,
    CASE 
        WHEN b.book_id IS NOT NULL THEN 'book'
        WHEN d.digital_id IS NOT NULL THEN 'digital'
        WHEN mg.magazine_id IS NOT NULL THEN 'magazine'
        ELSE 'unknown'
    END AS item_category,
    COUNT(*) AS total_loans,
    SUM(CASE 
            WHEN l.return_date IS NULL AND l.due_date < CURDATE() THEN DATEDIFF(CURDATE(), l.due_date) * 0.25
            ELSE 0
        END) AS total_fines
FROM loan l
JOIN client c ON l.client_id = c.client_id
JOIN copy cp ON l.copy_id = cp.copy_id
JOIN media m ON cp.media_id = m.media_id
LEFT JOIN book b ON b.media_id = m.media_id
LEFT JOIN digital d ON d.media_id = m.media_id
LEFT JOIN magazine mg ON mg.media_id = m.media_id
WHERE l.loan_date >= CURDATE() - INTERVAL 1 MONTH
GROUP BY c.membership_type, item_category
ORDER BY c.membership_type, item_category;


-- Client borrowing report
-- Produce an individual report for each client showing their borrowing history, outstanding fees, and any reserved items.
SELECT 
    c.client_id,
    c.name AS client_name,
    l.loan_id,
    m1.title AS borrowed_title,
    l.loan_date,
    l.due_date,
    l.return_date,
    ROUND(
        CASE 
            WHEN l.return_date IS NULL AND l.due_date < CURDATE() THEN DATEDIFF(CURDATE(), l.due_date) * 0.25
            ELSE 0
        END, 2
    ) AS outstanding_fee,
    res.reservation_id,
    res.reserved_title,
    res.reservation_date
FROM client c
LEFT JOIN loan l ON l.client_id = c.client_id
LEFT JOIN copy cp1 ON l.copy_id = cp1.copy_id
LEFT JOIN media m1 ON cp1.media_id = m1.media_id
LEFT JOIN (
    SELECT 
        r.client_id,
        r.reservation_id,
        m.title AS reserved_title,
        r.reservation_date
    FROM reservation r
    JOIN media m ON r.media_id = m.media_id
) AS res ON res.client_id = c.client_id
ORDER BY c.client_id, l.loan_date DESC, res.reservation_date DESC;
-- NOTE: I recommend adding LIMIT 10 at the end to see the structure better



-- Item availability and history
-- List all items, their current availability status, and their last borrowed date. Highlight items that have not been borrowed in the past six months.
SELECT 
    m.media_id,
    m.title,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM copy c 
            LEFT JOIN loan l ON l.copy_id = c.copy_id 
            WHERE c.media_id = m.media_id 
            GROUP BY c.copy_id
            HAVING MAX(CASE WHEN l.return_date IS NULL THEN 1 ELSE 0 END) = 0
        ) THEN 'Available'
        ELSE 'On Loan'
    END AS availability_status,
    MAX(l.loan_date) AS last_borrowed_date,
    CASE 
        WHEN MAX(l.loan_date) IS NULL OR MAX(l.loan_date) < CURDATE() - INTERVAL 6 MONTH THEN 'Not borrowed in 6+ months'
        ELSE 'Recently borrowed'
    END AS attention_flag
FROM media m
LEFT JOIN copy c ON c.media_id = m.media_id
LEFT JOIN loan l ON l.copy_id = c.copy_id
GROUP BY m.media_id, m.title
ORDER BY m.title;
--NOTE: Due to long loans, it is possible items to be both on loan and not borrowed in 6+ months


-- Overdue items report 
-- Generate a report listing all overdue items, the client responsible, and the calculated late fees.
SELECT 
    l.loan_id,
    c.client_id,
    c.name AS client_name,
    m.title AS item_title,
    l.loan_date,
    l.due_date,
    DATEDIFF(CURDATE(), l.due_date) AS days_overdue,
    ROUND(DATEDIFF(CURDATE(), l.due_date) * 0.25, 2) AS late_fee
FROM loan l
JOIN client c ON l.client_id = c.client_id
JOIN copy cp ON l.copy_id = cp.copy_id
JOIN media m ON cp.media_id = m.media_id
WHERE l.return_date IS NULL
  AND l.due_date < CURDATE()
ORDER BY l.due_date ASC;


-- Revenue summary
-- Summarize the library’s revenue from fees, showing the breakdown by membership type and item category
SELECT 
    c.membership_type,
    CASE 
        WHEN b.book_id IS NOT NULL THEN 'book'
        WHEN d.digital_id IS NOT NULL THEN 'digital'
        WHEN mg.magazine_id IS NOT NULL THEN 'magazine'
        ELSE 'unknown'
    END AS item_category,
    SUM(
        CASE 
            WHEN l.return_date IS NULL AND l.due_date < CURDATE() THEN DATEDIFF(CURDATE(), l.due_date) * 0.25
            WHEN l.return_date > l.due_date THEN DATEDIFF(l.return_date, l.due_date) * 0.25
            ELSE 0
        END
    ) AS total_fees
FROM loan l
JOIN client c ON l.client_id = c.client_id
JOIN copy cp ON l.copy_id = cp.copy_id
JOIN media m ON cp.media_id = m.media_id
LEFT JOIN book b ON b.media_id = m.media_id
LEFT JOIN digital d ON d.media_id = m.media_id
LEFT JOIN magazine mg ON mg.media_id = m.media_id
GROUP BY c.membership_type, item_category
ORDER BY c.membership_type, item_category;


--SUPER COOL BONUS QUERY!!!!!!
-- this query takes a client, and returns some recommended items they have never taken on loan before
-- it calculates this by finding items that users with similar loan histories have commonly taken on loan, that the client has never taken on loan
WITH target_loans AS (
    SELECT DISTINCT cp.media_id
    FROM loan l
    JOIN copy cp ON l.copy_id = cp.copy_id
    WHERE l.client_id = 5
),
similar_users AS (
    SELECT l.client_id, COUNT(DISTINCT cp.media_id) AS overlap_score
    FROM loan l
    JOIN copy cp ON l.copy_id = cp.copy_id
    WHERE cp.media_id IN (SELECT media_id FROM target_loans)
      AND l.client_id != 5
    GROUP BY l.client_id
),
similar_loans AS (
    SELECT l.client_id, cp.media_id
    FROM loan l
    JOIN copy cp ON l.copy_id = cp.copy_id
    WHERE l.client_id IN (SELECT client_id FROM similar_users)
),
filtered_recommendations AS (
    SELECT sl.client_id, sl.media_id
    FROM similar_loans sl
    WHERE sl.media_id NOT IN (SELECT media_id FROM target_loans)
),
recommendation_weighted AS (
    SELECT 
        fr.media_id,
        su.overlap_score
    FROM filtered_recommendations fr
    JOIN similar_users su ON fr.client_id = su.client_id
),
recommendation_ranking AS (
    SELECT 
        m.media_id,
        m.title,
        SUM(rw.overlap_score) AS weighted_popularity_score
    FROM recommendation_weighted rw
    JOIN media m ON m.media_id = rw.media_id
    GROUP BY m.media_id, m.title
)
SELECT *
FROM recommendation_ranking
ORDER BY weighted_popularity_score DESC
LIMIT 10;
