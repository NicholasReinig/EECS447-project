# Database Requirements

## Objective

Document the requirements of your database project. No formal template is required, but the following sections should be included in a requirement document (the italic parts are subsections).

## Introduction 

### Project Overview
Briefly describe the purpose of the database and its intended use. 

### Scope
Define the boundaries of the project, including what will and will not be covered (this could be a one paragraph shortened version from Project Part 1, repeated to maintain continuity). The previous two subsections establish continuity. 

### Glossary
Include a glossary of terms or acronyms (if any) used in the document.

## Stakeholders
Identify the database stakeholders, including end-users, administrators, and any other relevant parties. While some of these may need to be contrived, doing so demonstrates an understanding of the essential components of a requirements document.

## Requirements

### Functional Requirements
Specify the essential functions the database must perform. These functions can include user administration, data entry, retrieval, updates, deletions, and report generation. For report generation, refer to the sample queries/reports provided at the end of the project description for ideas. Additionally, as a team, brainstorm and propose other types of queries/reports that might be of interest to users. 

### Data Entities
List and describe the main data entities and their attributes and their data types or constraints. Note: these should represent major entities and their attributes (see the project description as the starting point); the list may be expanded upon when you develop the conceptual model.
--
The two main data entities will be items and users.
### ITEMS
Items will store all physical and non-physical media the library has. It will have the following values:

- **id** : `uuid` *Universally unique identifier assigned when added to the database*
- **publisher** : `text` *The publisher of the media. This will refer to the primary production studio for DVDs*
- **acquired** : `timestamp` *The time that the media was added to the library database*
- **link** : `text` *A link to the Wikipedia page of the media item*
- **genre** : `text[]` *Will contain all applicable genres for a given media item. Possible genres are "Fiction", "Non-Fiction", "Science Fiction & Fantasy", "Mystery & Thriller", "Comedy", "Romance", "History & Biography", "Science & Technology", "Health & Wellness", "Arts & Culture", "Business & Finance"*
- **media_type** : `text` *Value must be one of the following: "book", "ebook", "audiobook", "dvd", "magazine". Based on the value of media_type, additional attributes must be given values or set to null accordingly.*

**Additional attributes** will be defined according to `media_type`. Attributes will only be defined for an item if listed below; otherwise, they will be set to `NULL` for the item.

#### **book**
- **author** : `text` *The author's name, as it is listed by the book*
- **isbn** : `text` *International Standard Book Number*
- **page_count** : `integer` *Total length in pages of the physical book*

#### **ebook**
- **author** : `text` *The author's name, as it is listed by the book*
- **isbn** : `text` *International Standard Book Number*
- **word_count** : `integer` *Total length in words of the digital book*

#### **audiobook**
- **author** : `text` *The author's name, as it is listed by the book*
- **isbn** : `text` *International Standard Book Number*
- **narrator** : `text` *The narrator of the audiobook*

#### **dvd**
- **director** : `text` *The primary director of the movie or show*
- **runtime** : `float` *The total runtime of the DVD in hours*
- **rating** : `text` *The Motion Picture Association of America's rating for movies or the TV Parental Guideline rating for shows*
    
  ### USERS

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
