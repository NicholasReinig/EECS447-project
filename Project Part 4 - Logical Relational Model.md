### Project Overview
The purpose of this project is to enhance the operations of a small library by facilitating the management of a collection of loanable items. This includes storing item, membership, and transaction information as well as enforcing various policies automatically. The system is intended to be used to manage the everyday operations of a library, either through automated interactions or through dedicated queries by a system administrator.


### Relational Schema Mapping
<img width="613" alt="image" src="https://github.com/user-attachments/assets/d1029776-5164-4673-b788-9f81712699c3" />
### Notes:
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

#### USERS
Users will contain the members of the library, both staff and customers. It will have the following attributes:

- **id** : `uuid` *Universally unique identifier assigned when added to the database*
- **joined** : `timestamp` *The time that the user was added to the library database*
- **is_administrator** : `boolean` *True if the user has administrative access to the database*
- **is_student** : `boolean` *True if the user is a student at any of the community's schools*
- **is_senior** : `boolean` *True if the user is 65 years old or older*
- **is_premium** : `boolean` *True if the user is granted premium membership by the library*

#### LOANS
Users will take out loans on media items. It will have the following attributes

- **id** : `uuid` *Universally unique identifier assigned when added to the database*
- **user_id** : `uuid` *ID of the user performing the borrow*
- **item_id** : `uuid` *ID of the item to be borrowed*
- **date_made** : `timestamp` *The time that the user requested the loan*
- **date_received** : `timestamp` *The time that the user received the loan. Will be null while the user is on the waiting list*
- **date_due** : `timestamp` *The date that the loan is due. Will be null until the user returns the book*
- **date_returned** : `timestamp` *The date that the loan was returned*
