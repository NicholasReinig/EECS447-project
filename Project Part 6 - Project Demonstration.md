# Testing
#### We intend to demonstrate our project live and our team administrator will plan this demo via email. The following instructions for remotely testing our project are not designed for grading.

### Using remote servers:
1. Connect to cycle servers: `ssh <KUID>@cycle2.eecs.ku.edu`.
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
4. Seed the tables `SOURCE </.../path/to/src/seeding/modified_seed_data.sql>`

### Executing Queries:
After creating the database:

#### Quick Checking
Execute `SOURCE </.../path/to/src/formatted_test_queries.sql>`
This will perform all the queries from the requirements with labels. Queries may be modified or limited to keep the printout readable. But not all desired behavior may be observed due to the limits. For example, a prompt to display all members with outstanding fines may be shortened to only the ten with the largest amount of outstanding fines.

#### Thorough Checking
Refer to `src/test_queries.sql` and perform individual queries by copy and pasting.

##### In either case, please do read over the sql files themselves as they contain relevant comments.
