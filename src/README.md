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

# Organization
### Table Definitions
The DDL statements used for creating the database are stored in `./library_schema.sql`. After modifying statements in this file, recreate the database using: `DROP DATABASE library; CREATE DATABASE library; USE library;`.

### Data Hydration
The file `data_seed.sql` provides a small set of hand-crafted data points to be used for testing small queries. A larger procedural population script will be added later.

### Example Queries
Some example queries have been provided in `test_queries.sql` these match suggestions from `00-library-database-project-description.pdf`.