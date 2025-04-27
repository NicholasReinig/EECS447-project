################################################################################
# This script generates a SQL seeding script for a library database. ###########
################################################################################

# @NOTE: Code quality is not the best, but it gets the job done.

import requests
import random
import json
import faker

OUTPUT_FILE      = "seed_data.sql"
OPEN_LIBRARY_API = "https://openlibrary.org"

# Determine which subject endpoints to collect
# See available: https://openlibrary.org/subjects
SUBJECTS = [
    "architecture",
    "design",
    "cats",
    "kittens",
    "dogs",
    "puppies",
    "fantasy",
    "historical_fiction",
    "horror",
    "humor",
    "magic",
    "mystery_and_detective_stories",
    "plays",
    "poetry",
    "science_fiction",
    "short_stories",
    "thriller",
    "young_adult",
    "biology",
    "chemistry",
    "mathematics",
    "physics",
    "programming",
    "entrepreneurship",
    "finance",
    "autobiography",
    "history"
]

publishers = [
    {"name": "Penguin Random House"      , "email": "contact@penguinrandomhouse.com", "phone": "(212) 782-9000", "address": "1745 Broadway, New York, NY 10019"              },
    {"name": "HarperCollins"             , "email": "info@harpercollins.com"        , "phone": "(212) 207-7000", "address": "195 Broadway, New York, NY 10007"               },
    {"name": "Simon & Schuster"          , "email": "support@simonandschuster.com"  , "phone": "(800) 223-2336", "address": "1230 Avenue of the Americas, New York, NY 10020"},
    {"name": "Macmillan Publishers"      , "email": "info@macmillan.com"            , "phone": "(646) 307-5151", "address": "120 Broadway, New York, NY 10271"               },
    {"name": "Hachette Livre"            , "email": "contact@hachette.com"          , "phone": "(212) 364-1100", "address": "1290 Avenue of the Americas, New York, NY 10104"},
    {"name": "Scholastic Corporation"    , "email": "info@scholastic.com"           , "phone": "(212) 343-6100", "address": "557 Broadway, New York, NY 10012"               },
    {"name": "Oxford University Press"   , "email": "support@oup.com"               , "phone": "(919) 677-0977", "address": "198 Madison Avenue, New York, NY 10016"         },
    {"name": "Cambridge University Press", "email": "info@cambridge.org"            , "phone": "(212) 337-5000", "address": "1 Liberty Plaza, New York, NY 10006"            },
    {"name": "Bloomsbury Publishing"     , "email": "contact@bloomsbury.com"        , "phone": "(212) 419-5300", "address": "1385 Broadway, New York, NY 10018"              },
    {"name": "Random House"              , "email": "info@randomhouse.com"          , "phone": "(212) 782-9000", "address": "1745 Broadway, New York, NY 10019"              }
]

################################################################################

def create_isbn():
    """
    Generate a random 13-digit ISBN.
    """
    return ''.join(str(random.randint(0, 9)) for _ in range(13))

def create_email(first_name, last_name = "hello"):
    """
    Generate a random email address.
    """
    domains = ["gmail.com", "icloud.com", "outlook.com"]
    return f"{first_name.lower()}.{last_name.lower()}@{random.choice(domains)}"

def create_active():
    """
    Generate a random active status.
    """
    return random.choice(["active", "inactive"])

def create_membership():
    """
    Generate a random membership type.
    """
    return random.choices(
        ["regular", "student", "senior", "librarian"], 
        weights=[70, 15, 10, 5]
    )[0]    

def genre_is_valid(genre):
    """
    Check if the genre is valid.
    """
    return (len(genre.split()) == 1 and \
            ":" not in genre and        \
            "." not in genre and        \
            " " not in genre and        \
            "," not in genre and        \
            "-" not in genre and        \
            "_" not in genre and        \
            "(" not in genre and        \
            ")" not in genre)

def get_genres(subjects):
    """
    Get good genres from the subjects.
    """
    return [genre.replace("\'", "\'\'").lower() for genre in subjects \
           if genre_is_valid(genre)]

def author_is_valid(author):
    """
    Check if the author is valid.
    """
    return ("/" not in author and 
            not any(char.isdigit() for char in author))

def get_authors(authors):
    """
    Get authors from the Open Library API.
    """
    return [author["name"].replace("\'", "\'\'") for author in authors \
            if author_is_valid(author["name"])]

def no_newline(string):
    """
    Remove newlines from an address.
    """
    return string.replace("\n", " ")

def shuffle_together(list1, list2):
    combined = list(zip(list1, list2))
    random.shuffle(combined)
    shuffled1, shuffled2 = zip(*combined)
    return list(shuffled1), list(shuffled2)


################################################################################

def fetch_subject(subject, params=None):
    """
    Fetch books from the Open Library API endpoint.
    """
    try:
        response = requests.get(
            f"{OPEN_LIBRARY_API}/subjects/{subject}.json", 
            params=params
        )
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Fetch Error: {e}")
        return None

def fetch_all_books(params=None):
    """
    Fetch all books from all subjects from the Open Library API.
    """
    books        = []
    known_titles = set()

    for subject in SUBJECTS:
        data = fetch_subject(
            subject,
            params=params
        )
        if data and "works" in data:
            for work in data["works"]:
                title = work.get("title")
                if title and title not in known_titles:
                    books.append(work)
                    known_titles.add(title)
    return books

################################################################################

def create_media_data():
    """
    Create media data for books, magazines, and DVDs.
    """
    all_items = []
    all_media = fetch_all_books()
    types     = ["book", "digital", "magazine"]
    date      = faker.Faker().date_between(start_date="-5y", end_date="today")

    for media in all_media:
        all_items.append({
            "type"            : random.choice(types),                     # Just randomize media type
            "title"           : media.get("title").replace("\'", "\'\'"), # Title of media
            "publication_year": media.get("first_publish_year"),          # Publication year
            "genres"          : get_genres(media.get("subject", [])),     # All genres
            "isbn"            : create_isbn(),                            # Just randomize ISBN
            "authors"         : get_authors(media.get("authors", [])),     # All authors
            "publisher"       : random.randint(1, len(publishers)),       # Randomize publisher
            "page_count"      : random.randint(100, 1000),                # Randomize page count
            "issue_number"    : random.randint(1, 12),                    # Randomize issue number
            "publication_date": date,                                     # Randomize publication date
            "language"        : "en",                                     # Just use English for now
            "format"          : "dvd"                                     # Just use DVD for now
        })

    return all_items

def create_client_data(n=500):
    fake = faker.Faker()

    return [{
        "name"         : f"{name[0]} {name[1]}",
        "email"        : create_email(name[0], name[1]),
        "phone_number" : fake.phone_number(),
        "address"      : no_newline(fake.address()),
        "status"       : create_active(),
        "membership"   : create_membership()
    } for name in [(fake.first_name(), fake.last_name()) for _ in range(n)]]

################################################################################

def create_insert_statements():
    """
    Create SQL insert statements for media and client data.
    """
    media_data  = create_media_data()
    client_data = create_client_data()

    fake = faker.Faker()

    contact_info = []                
    author       = []          
    publisher    = []             
    client       = []          
    media        = []         
    book         = []        
    digital      = []           
    magazine     = []            
    genre        = []         
    media_author = []                
    media_genre  = []               
    copy         = []        
    loan         = []        
    reservation  = []               

    genre_lookup  = []
    author_lookup = []
    copy_lookup   = []

    for p in publishers:
        contact_info += [f"('{p['email']}', '{p['phone']}', '{p['address']}')"]
        publisher    += [f"('{p['name']}', {len(contact_info)})"]
    
    for c in client_data:
        contact_info += [f"('{c['email']}', '{c['phone_number']}', '{c['address']}')"]
        client       += [f"('{c['name']}', {len(contact_info)}, '{c['membership']}', '{c['status']}')"]
    
    for m in media_data:
        media_type = m["type"]
        media_id   = len(media) + 1

        media += [f"('{m['title']}', '{media_type}')"]

        copy_count  = random.randint(1, 5)
        copy        += [f"({media_id})"] * copy_count
        copy_lookup += [media_id]        * copy_count
        
        if   media_type == "book"    : book     += [f"({media_id}, '{m['isbn']}', {m['page_count']}, {m['publisher']}, {m['publication_year']}, '{m['language']}')"]
        elif media_type == "digital" : digital  += [f"({media_id}, '{m['isbn']}', '{m['format']}', {m['publisher']}, {m['publication_year']})"]
        elif media_type == "magazine": magazine += [f"({media_id}, {m['issue_number']}, {m['publisher']}, '{m['publication_date']}')"]

        for g in set(m["genres"]):
            genre_index = genre_lookup.index(g) + 1 if g in genre_lookup else None
            if genre_index is None:
                genre_lookup += [g]
                genre        += [f"('{g}')"]
                genre_index  = len(genre_lookup)
            media_genre += [f"({media_id}, {genre_index})"]

        for a in set(m["authors"]):
            author_index = author_lookup.index(a) + 1 if a in author_lookup else None
            if author_index is None:
                author_lookup += [a]
                contact_info  += [f"('{create_email(*a.split()[0:2])}', '{fake.phone_number()}', '{no_newline(fake.address())}')"]
                author        += [f"('{a}', {len(contact_info)})"]
                author_index  = len(author_lookup)
            media_author += [f"({media_id}, {author_index})"]

    random.shuffle(media_genre)
    random.shuffle(media_author)
    copy, copy_lookup = shuffle_together(copy, copy_lookup)

    # Create fake loans
    for i in range(len(client_data)):
        for _ in range(random.randint(0, 8)):
             copy_id     = random.randint(1, len(copy))
             loan_date   = fake.date_between(start_date="-3y", end_date="today")
             return_date = fake.date_between(start_date=loan_date, end_date="today")
             loan += [f"({copy_id}, {i + 1}, '{loan_date}', '{return_date}')"]

    copy_iterator = 1
    for i, loan_client in enumerate(client_data):
        loan_limit = 3
        if loan_client["membership"] == "student" or \
           loan_client["membership"] == "senior"   : loan_limit = 5
        if loan_client["membership"] == "librarian": loan_limit = 10

        for _ in range(random.randint(0, loan_limit)):
            if copy_iterator > len(copy): break
            loan_date = fake.date_between(start_date="-3y", end_date="today")
            loan += [f"({copy_iterator}, {i + 1}, '{loan_date}', NULL)"]  
            copy_lookup.pop(0)
            copy_iterator += 1      
  
    random.shuffle(loan)

    # Create fake reservations
    for i in range(len(media_data)):
        if i + 1 in copy_lookup: continue

        for _ in range(random.randint(0, 10)):
            reservation_date = fake.date_between(start_date="-3y", end_date="today")
            reservation      += [f"({i + 1}, {random.randint(1, len(client_data))}, '{reservation_date}')"]
    
    random.shuffle(reservation)

    return "INSERT INTO contact_info (email, phone, address) VALUES\n    "                                     + ",\n    ".join(contact_info) + ";\n\n" + \
           "INSERT INTO author (name, contact_id) VALUES\n    "                                                + ",\n    ".join(author)       + ";\n\n" + \
           "INSERT INTO publisher (name, contact_id) VALUES\n    "                                             + ",\n    ".join(publisher)    + ";\n\n" + \
           "INSERT INTO client (name, contact_id, membership_type, account_status) VALUES\n    "               + ",\n    ".join(client)       + ";\n\n" + \
           "INSERT INTO media (title, media_type) VALUES\n    "                                                + ",\n    ".join(media)        + ";\n\n" + \
           "INSERT INTO book (media_id, isbn, page_count, publisher, publication_year, language) VALUES\n    " + ",\n    ".join(book)         + ";\n\n" + \
           "INSERT INTO digital (media_id, isbn, format, publisher, publication_year) VALUES\n    "            + ",\n    ".join(digital)      + ";\n\n" + \
           "INSERT INTO magazine (media_id, issue_number, publisher, publication_date) VALUES\n    "           + ",\n    ".join(magazine)     + ";\n\n" + \
           "INSERT INTO genre (genre_name) VALUES\n    "                                                       + ",\n    ".join(genre)        + ";\n\n" + \
           "INSERT INTO media_author (media_id, author_id) VALUES\n    "                                       + ",\n    ".join(media_author) + ";\n\n" + \
           "INSERT INTO media_genre (media_id, genre_id) VALUES\n    "                                         + ",\n    ".join(media_genre)  + ";\n\n" + \
           "INSERT INTO copy (media_id) VALUES\n    "                                                          + ",\n    ".join(copy)         + ";\n\n" + \
           "INSERT INTO loan (copy_id, client_id, loan_date, return_date) VALUES\n    "                        + ",\n    ".join(loan)         + ";\n\n" + \
           "INSERT INTO reservation (media_id, client_id, reservation_date) VALUES\n    "                      + ",\n    ".join(reservation)
 

################################################################################

def write_to_file(sql_statements):
    with open(OUTPUT_FILE, "w") as file:
        file.write("-- PROCEDURALLY GENERATED SEEDING SCRIPT \n\n")
        file.write(sql_statements)
    print(f"SQL seed data written to {OUTPUT_FILE}")

# Main function
def main():
    sql_statements = create_insert_statements()
    if sql_statements:
        write_to_file(sql_statements)

if __name__ == "__main__":
    main()

################################################################################