--------------------------------------------------------------------------------
-- Example Data for Testing ----------------------------------------------------
--------------------------------------------------------------------------------

-- Insert data into `contact_info`
INSERT INTO contact_info (email, phone, address) VALUES
('example@example.com'       , 'XXX-XXX-XXXX', 'XX Example Drive, Example'      ),
('jkrowling@example.com'     , '123-456-7890', '12 Grimmauld Place, London'     ),
('georgerrmartin@example.com', '234-567-8901', '742 Evergreen Terrace, Santa Fe'),
('penguin@example.com'       , '345-678-9012', '375 Hudson St, New York'        ),
('harpercollins@example.com' , '456-789-0123', '195 Broadway, New York'         ),
('johnsmith@example.com'     , '567-890-1234', '123 Maple St, Springfield'      ),
('janedoe@example.com'       , '678-901-2345', '456 Oak St, Metropolis'         ),
('michaelbrown@example.com'  , '789-012-3456', '789 Pine St, Gotham'            ),
('emilywhite@example.com'    , '890-123-4567', '101 Birch St, Star City'        ),
('davidjohnson@example.com'  , '901-234-5678', '202 Cedar St, Central City'     ),
('sarahwilson@example.com'   , '012-345-6789', '303 Walnut St, Coast City'      );

-- Insert data into `author`
INSERT INTO author (name, contact_id) VALUES
('J.K. Rowling'       , 2),
('George R.R. Martin' , 3),
('Agatha Christie'    , 1),
('Stephen King'       , 1),
('Jane Austen'        , 1),
('Mark Twain'         , 1),
('Ernest Hemingway'   , 1),
('F. Scott Fitzgerald', 1),
('Charles Dickens'    , 1),
('Leo Tolstoy'        , 1);

-- Insert data into `publisher`
INSERT INTO publisher (name, contact_id) VALUES
('Penguin Random House'      , 4),
('HarperCollins'             , 5),
('Simon & Schuster'          , 1),
('Macmillan Publishers'      , 1),
('Hachette Livre'            , 1),
('Scholastic Corporation'    , 1),
('Oxford University Press'   , 1),
('Cambridge University Press', 1),
('Bloomsbury Publishing'     , 1),
('Random House'              , 1);

-- Insert data into `client`
INSERT INTO client (name, contact_id, membership_type, account_status) VALUES
('John Smith'   , 6 , 'regular'  , 'active'),
('Jane Doe'     , 7 , 'student'  , 'active'),
('Michael Brown', 8 , 'senior'   , 'active'),
('Emily White'  , 9 , 'librarian', 'active'),
('David Johnson', 10 , 'regular'  , 'active'),
('Sarah Wilson' , 11, 'student'  , 'active');

-- Insert data into `media`
INSERT INTO media (title, media_type) VALUES
('Harry Potter and the Sorcerer''s Stone', 'book'    ),
('A Game of Thrones'                     , 'book'    ),
('The Hobbit (DVD)'                      , 'digital' ),
('The Lord of the Rings (DVD)'           , 'digital' ),
('National Geographic - January 2025'    , 'magazine'),
('Time Magazine - February 2025'         , 'magazine'),
('Pride and Prejudice'                   , 'book'    ),
('1984 (DVD)'                            , 'digital' ),
('The Great Gatsby'                      , 'magazine'),
('War and Peace'                         , 'book'    );

-- Insert data into `book`
INSERT INTO book (media_id, isbn, page_count, publisher, publication_year, language) VALUES
(1 , '978-0-7475-3269-9', 309 , 1, 1997, 'EN'),
(2 , '978-0-553-10354-0', 694 , 2, 1996, 'EN'),
(7 , '978-0-19-953556-9', 279 , 3, 1813, 'EN'),
(10, '978-0-14-044793-4', 1225, 4, 1869, 'EN');

-- Insert data into `digital`
INSERT INTO digital (media_id, isbn, format, publisher, publication_year) VALUES
(3, '978-0-261-10221-7', 'dvd', 1, 2001),
(4, '978-0-261-10236-1', 'dvd', 2, 2003),
(8, '978-0-452-28423-4', 'dvd', 3, 1984);

-- Insert data into `magazine`
INSERT INTO magazine (media_id, issue_number, publisher, publication_date) VALUES
(5, 1, 1, '2025-01-01'),
(6, 2, 2, '2025-02-01'),
(9, 3, 3, '2025-03-01');

-- Insert data into `genre`
INSERT INTO genre (genre_name) VALUES
('Fantasy'           ),
('Science Fiction'   ),
('Mystery'           ),
('Thriller'          ),
('Romance'           ),
('Historical Fiction'),
('Biography'         ),
('Non-Fiction'       ),
('Classic'           ),
('Adventure'         );

-- Insert data into `media_author`
INSERT INTO media_author (media_id, author_id) VALUES
(1 , 1 ),
(2 , 2 ),
(3 , 3 ),
(4 , 4 ),
(5 , 5 ),
(6 , 6 ),
(7 , 7 ),
(8 , 8 ),
(9 , 9 ),
(10, 10);

-- Insert data into `media_genre`
INSERT INTO media_genre (media_id, genre_id) VALUES
(1 , 1 ),
(2 , 2 ),
(3 , 3 ),
(4 , 4 ),
(5 , 5 ),
(6 , 6 ),
(7 , 7 ),
(8 , 8 ),
(9 , 9 ),
(10, 10);

-- Insert data into `copy`
INSERT INTO copy (media_id) VALUES
(1), (1), (2), (3), (4), (5);

-- Insert data into `loan`
INSERT INTO loan (copy_id, client_id, loan_date, return_date) VALUES
(1, 1, '2025-01-01', '2025-01-15'),
(2, 2, '2025-01-05', NULL        ),
(3, 3, '2025-01-10', '2025-01-20'),
(4, 4, '2025-01-15', NULL        ),
(5, 5, '2025-01-20', '2025-01-30');

-- Insert data into `reservation`
INSERT INTO reservation (media_id, client_id, reservation_date) VALUES
(3, 2, '2025-02-05');

--------------------------------------------------------------------------------