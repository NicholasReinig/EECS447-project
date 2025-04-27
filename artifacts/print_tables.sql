--------------------------------------------------------------------------------
-- Demonstrate tables & contents for part 5 ------------------------------------
--------------------------------------------------------------------------------

-- sudo mariadb -u root -p --table library < print_tables.sql > table_contents.txt

show tables;

select 'table: contact_info' as ' ';
describe contact_info;
select * from contact_info;

select 'table: author' as ' ';
describe author;
select * from author;

select 'table: publisher' as ' ';
describe publisher;
select * from publisher;

select 'table: client' as ' ';
describe client;
select * from client;

select 'table: media' as ' ';
describe media;
select * from media;

select 'table: book' as ' ';
describe book;
select * from book;

select 'table: digital' as ' ';
describe digital;
select * from digital;

select 'table: magazine' as ' ';
describe magazine;
select * from magazine;

select 'table: genre' as ' ';
describe genre;
select * from genre;

select 'table: media_author' as ' ';
describe media_author;
select * from media_author;

select 'table: media_genre' as ' ';
describe media_genre;
select * from media_genre;

select 'table: copy' as ' ';
describe copy;
select * from copy;

select 'table: loan' as ' ';
describe loan;
select * from loan;

select 'table: reservation' as ' ';
describe reservation;
select * from reservation;

--------------------------------------------------------------------------------