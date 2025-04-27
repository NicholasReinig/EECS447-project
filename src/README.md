# Get Started
### Using remote servers:
1. Connect to cycle servers: `ssh <KUID>@cycle1.eecs.ku.edu`.
2. Connect to MariaDB: `mysql -h mysql.eecs.ku.edu -u <USERID> -p` \
   *NOTE:* USERID and password is provided by the instructor.

### Installing locally:
RECOMMENDED APPROACH
1. Download and install MariaDB locally (varies for OS).
2. Start the MariaDB server (varies for OS).
3. Log in as root: `sudo mysql -u root`.

### Create the Database:
While connected to MariaDB CLI:
1. Create DB: `CREATE DATABASE library;`
2. Enter DB: `USE library;`
3. Create tables: `SOURCE </.../path/to/src/library_schema.sql>`
4. Seed the tables `SOURCE </.../path/to/src/seeding/seed_data.sql>`

# Organization
### Table Definitions
The DDL statements used for creating the database are stored in `./library_schema.sql`. After modifying statements in this file, recreate the database using: `DROP DATABASE library; CREATE DATABASE library; USE library;`.

### Data Hydration
The file `seed_data.sql` provides a **large** set of example data to hydrate the database with. Said file is procedurally generated using `create_seed.sql`, this script uses data from [https://openlibrary.org](https://openlibrary.org). \\
Additionally, a smaller data seeding file, `small_seed_data.sql` is provided for situations where the larger dataset is unwieldy.

### Example Queries
Some example queries have been provided in `test_queries.sql` these match suggestions from `00-library-database-project-description.pdf`.