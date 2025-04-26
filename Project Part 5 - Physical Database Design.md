### Project Overview
The purpose of this project is to enhance the operations of a small library by facilitating the management of a collection of loanable items. This includes storing item, membership, and transaction information as well as enforcing various policies automatically. The system is intended to be used to manage the everyday operations of a library, either through automated interactions or through dedicated queries by a system administrator.

### Scope
The Library Management System will cover a wide range of responsibilities. It will include functionality pertaining to item management, i.e., storing book, digital media, and magazine identifiers alongside their attributes as well as tracking their availability status. To enable the ability to borrow the library's items, the system will keep client records (complete with membership categories), and enforce borrowing constraints. The system will perform transaction management by recording all borrowing, returning, and reservation transactions, tracking overdue items (and their corresponding fees), and implementing an item reservation system. Moreover, the system will have support for providing notifications to both clients (in the form of notices), and system administrators (in the form of reports). Finally, performance and security are also within the scope of the project. Outside of the boundaries of the project are components such as the user interface. Indeed, this project will focus primarily on the database implementation and not the front end.

### Glossary
- DB: Database
- DBMS: Database Management System
- EECS: Electrical Engineering and Computer Science (department)
- ISBN: International Standard Book Number
- MySQL: A popular RDBMS developed by Oracle
- MariaDB: An open source fork of MySQL
- RDBMS: Relation Database Management System
- SQL: Structured Query Language

### Platform
We have decided to use MariaDB as our database platform for this project. MariaDB is a fork of MySQL, it expands on MySQL's functionality through a community-driven development effort while simultaneously maintaining cross-compatibility. This suits are needs since we want a DBMS that was relational and feature rich. We chose this RDBMS in particular since MySQL and by extension MariaDB uses well known syntax which is valuable to learn for applications within industry (notably, MariaDB has better licensing and performance than MySQL). More importantly, however, the University of Kansas's EECS department provides students with a free MariaDB account hosted on their infrastructure which we have decided to leverage for improved development workflow. Having the database deployed on a remote host allows all team members to observe the same database instance enabling improved communication. Moreover, the performance characteristics of the EECS servers better mirror the performance one would expect in real production, allowing us to make more accurate inferences about the performance of our system.

### Physical Schema
All the DDL statements used to construct our library database can be found in:
**[/src/library_schema.sql](src/library_schema.sql)**. 
Notably, this includes both table creation statements as well as triggers for ensuring database integrity in complex situations.

#### Data Population
Our project includes data population scripts

*@TODO: Add reference here...*

### Table Contents
A snapshot of the table contents for our database after seeding can be found in:
**[/artifacts/table_contents.txt](artifacts/table_contents.txt)**.
Each table is shown filled with the example data explained above.

#### Functionality testing
Useful SQL queries used for confirming the database's functionality can be found in:
*[/src/queries](src/queries/)*.
