# Database Requirements

## Objective

Document the requirements of your database project. No formal template is required, but the following sections should be included in a requirement document (the italic parts are subsections).

## Introduction 

### Project Overview
The purpose of this project is to enhance the operations of a small library by facilitating the management of a collection of loanable items. This includes storing item, membership, and transaction information as well as enforcing various policies automatically. The system is intended to be used to manage the everyday operations of a library, either through automated interactions or through dedicated queries by a system administrator.

### Scope
The Library Management System will cover a wide range of responsibilities. It will include functionality pertaining to item management, i.e., storing book, digital media, and magazine identifiers alongside their attributes as well as tracking their availability status. To enable the ability to borrow the library's items, the system will keep client records (complete with membership categories), and enforce borrowing constraints. The system will perform transaction management by recording all borrowing, returning, and reservation transactions, tracking overdue items (and their corresponding fees), and implementing an item reservation system. Moreover, the system will have support for providing notifications to both clients (in the form of notices), and system administrators (in the form of reports). Finally, performance and security are also within the scope of the project. Outside of the boundaries of the project are components such as the user interface. Indeed, this project will focus primarily on the database implementation and not the front end.

### Glossary
- DB: Database
- DBMS: Database Management System
- DVD: Digital Versatile Disc
- EECS: Electrical Engineering and Computer Science (department)
- ID: Identifier
- ISBN: International Standard Book Number
- SQL: Structured Query Language
- UUID: Universally Unique Identifier

## Stakeholders
Identify the database stakeholders, including end-users, administrators, and any other relevant parties. While some of these may need to be contrived, doing so demonstrates an understanding of the essential components of a requirements document.

## Requirements

### Functional Requirements
Specify the essential functions the database must perform. These functions can include user administration, data entry, retrieval, updates, deletions, and report generation. For report generation, refer to the sample queries/reports provided at the end of the project description for ideas. Additionally, as a team, brainstorm and propose other types of queries/reports that might be of interest to users. 

The following are functional requirements of the database. Requirements may be altered, removed, or appended throughout development.
- A user who wishes to check out a currently available item for loan will not be allowed to do so if they are at the maximum amount of held loans or have any items overdue. Otherwise the user should be allowed to take the item on loan.
- A user may join a waitlist for a requested item if it is currently not available. Users must renew their position on the wait list every five days.
- Digital media will still be limited on the number of people it can be loaned out to just like physical media. The library must track the number of copies it has available of all digital media.
- Digital media will be automatically returned.
- Users should be able to refine a search by the type of media, name, genre, and author (with the author referencing the director and publishing company of DVD's and magazines respectively). Users should also be able to refine their search to see only currently available items.
- Users should be able to sort a search by the name of the media (alphabetically forwards or backwards) or the date added to the library database.
- All library staff will also be granted access to the library as customers.
- Administrative users will have the ability to edit the database by adding, removing, or editing items and users.
- A record of loans will be kept. Administrative users will not be allowed to edit any of the records of loans.
- Users may have any amount of additional classifications.
- Different classifications of users may have different limits on the number of held items, loan durations, and fees for overdue media.
- If a user has multiple classifications associated, they will be given the most generous policy associated with any one of those roles.
- If a user has been a part of the library for at least six months and returned at least six loans on time, they can be granted premium access by appointment with the staff. Staff are granted premium membership by default even if they do not meet the usual requirements.

The following are queries that may be made of the database. These queries may be altered, removed, or appended throughout development.  
**Item information** : Gather all the information associated with an item from its attributes. Additionally return how many copies of the item is currently available.  
**Active loans** : A user should be able to see the relevant information for their active loans, such as due dates and the day the loan was made. If it is overdue they should be able to see their associated fine.  
**User information** : A user should be able to view all the information about their membership.  
**Common genres** : A user should be presented with media that is the same genre as they have taken on loan in the past.  
**Whats hot** : A user should be presented with media that has been the most popular in the last month.    
**"Readers like you"** : A complex query that should return to a user any media that they have never taken on loan, but has been frequently loaned out by users with similar interests. Other users with similar interests will be established by the users taking the same items on loan over time.  
**Non-administrative users should never receive data about other users when they perform any of these queries**  

The following queries are ones that only administrative users like library staff should be able to make:  
**Detailed item information** : Will return all results associated with **Item information** with additional detailed information about any active loans on the item.  
**User lookup** : Will return the results of **User information** for a desired user.  
**Overdue loans** : Will return a list of currently overdue loans and the associated user and fine for each.  

### Data Entities
The two main data entities will be items and users.

#### ITEMS
Items will store all physical and non-physical media the library has. It will have the following attributes:

- **id** : `uuid` *Universally unique identifier assigned when added to the database*
- **copies** : `integer` *The total number of copies the library has of an item, including those currently on loan*
- **publisher** : `text` *The publisher of the media. This will refer to the primary production studio for DVDs*
- **author** : `text` *The author's name, as it is listed by the book. In the case of DVD's it will be the primary director's name. In the case of magazines this field will be set to the same as the publisher field*
- **acquired** : `timestamp` *The time that the media was added to the library database*
- **link** : `text` *A link to the Wikipedia page of the media item*
- **genre** : `text[]` *Will contain all applicable genres for a given media item. Possible genres are "Fiction", "Non-Fiction", "Science Fiction & Fantasy", "Mystery & Thriller", "Comedy", "Romance", "History & Biography", "Science & Technology", "Health & Wellness", "Arts & Culture", "Business & Finance"*
- **media_type** : `text` *Value must be one of the following: "book", "ebook", "audiobook", "dvd", "magazine". Based on the value of media_type, additional attributes must be given values or set to null accordingly.*

**Additional attributes** will be defined according to `media_type`. Attributes will only be defined for an item if listed below; otherwise, they will be set to `NULL` for the item.

##### **book**
- **isbn** : `text` *International Standard Book Number*
- **page_count** : `integer` *Total length in pages of the physical book*

##### **ebook**
- **isbn** : `text` *International Standard Book Number*
- **word_count** : `integer` *Total length in words of the digital book*

##### **audiobook**
- **isbn** : `text` *International Standard Book Number*
- **narrator** : `text` *The narrator of the audiobook*

##### **dvd**
- **runtime** : `float` *The total runtime of the DVD in hours*
- **rating** : `text` *The Motion Picture Association of America's rating for movies or the TV Parental Guideline rating for shows*

##### **magazine**  
- **issue_number** : `text` *Issue identifier for the magazine*  
- **publication_date** : `date` *Date the issue was published*  

### USERS
Users will contain the members of the library, both staff and customers. It will have the following attributes:

- **id** : `uuid` *Universally unique identifier assigned when added to the database*
- **joined** : `timestamp` *The time that the user was added to the library database*
- **is_administrator** : `boolean` *True if the user has administrative access to the database*
- **is_student** : `boolean` *True if the user is a student at any of the community's schools*
- **is_senior** : `boolean` *True if the user is 65 years old or older*
- **is_premium** : `boolean` *True if the user is granted premium membership by the library*


### Non-Functional Requirements (_Optional_)
Performance Requirements:
  - Database quieries should take 5 seconds or less under normal load conditions.
  - The system should support at least 50 users at a time under normal conditions without performance dips.

Availability & Reliability:
  - The system should be operational 23 hours a day (1 hour of downtime at the most)
  - System should maintain data integrity even during a shutdown (power goes out, etc)
  - Regular automated backups should be performed every month.

Security:
  - The system should be invulernable to SQL injection attacks (inputs should be sanatized)
  - All passwords and other secure information will be stored using hashing algorithms, not as plaintext.
  - Database connections should be encrypted.

Scalability:
  - Database should be scalable. We should be able to support more and more items and more and more members.

Maintainability:
  - Schema changes should be possible without taking the entire system down.
  - System should include comprehensive logging.

## Hardware and Software Requirements
Specify the hardware and software requirements for the database system. Note: your database is likely to be standalone (running on MariaDB on EECS servers), on MySQL on one of your laptops, or on the cloud. Clearly define the expected hardware and software components. While this may seem trivial, including these details demonstrates an understanding of the essential parts of a requirements document.

## Appendices
If there are other important contents that you would like to include, you are welcome to add them here.
