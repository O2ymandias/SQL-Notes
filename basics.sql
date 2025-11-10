-- * Intro
/*
    Database
        A container to store data in a structured way.

    SQL (Structured Query Language)
        A language used to manage data (CRUD) inside a database.

    DBMS (Database Management System)
        Software that manages one or more databases.

    Server
        A machine where databases live.
        A single server can host multiple databases.

    Types of Databases
        [1] Relational (SQL)
            Data is stored in related tables.
                - SQL Server
                - PostgreSQL
                - MySQL

        [2] Non-Relational (NoSQL)
            Key-Value
                - Redis            
            Document
                - MongoDB
            Column-Based
            Graph

    SCHEMA
        A logical container to group related database objects.
        A database can have multiple schemas.

    TABLE
        Stores data in columns (fields) and rows (records).

    Primary Key (PK)
        A unique identifier for each row.

    Data Types
        [1] Numeric
            - INT
            - DECIMAL

        [2] String
            - CHAR
            - VARCHAR

        [3] Boolean
            - BOOLEAN

        [4] Date & Time
            - DATE
            - TIME
*/

-- * Database Commands
/*
    [1] DDL (Data Definition Language)
        Used to define or modify database structure
        - CREATE
        - ALTER
        - DROP

    [2] DML (Data Manipulation Language)
        Used to change data inside tables
        - INSERT
        - UPDATE
        - DELETE

    [3] DQL (Data Query Language)
        Used to read data
        - SELECT
*/

-- * Data Types
/*
    [1] Numeric
        INT (4 bytes)
        BIGINT (8 bytes)
        SMALLINT (2 bytes)
        TINYINT (1 byte)

    [2] String
        CHAR(n) -> ASCII, fixed length
        VARCHAR(n) -> ASCII, variable length
        NCHAR(n) -> Unicode, fixed length (2 bytes/char)
        NVARCHAR(n) -> Unicode, variable length (2 bytes/char)

        If string length exceeds the limit, it will be truncated.
        VARCHAR(MAX) / NVARCHAR(MAX) -> up to 2GB
    

    [3] Boolean
        BIT -> 0 or 1

    [4] Date & Time
        DATE -> YYYY-MM-DD
        TIME(n) -> HH:MM:SS.n 
        DATETIME -> YYYY-MM-DD HH:MM:SS.FFF
        SMALLDATETIME -> YYYY-MM-DD HH:MM
        DATETIME2(n) -> YYYY-MM-DD HH:MM:SS.n
        DATETIMEOFFSET(n) -> YYYY-MM-DD HH:MM:SS.n+/-HH:MM

        DATETIME2 is preferred over DATETIME

    [5] Fractions
        DECIMAL(p, s) -> p total digits, s decimal places
            p = precision (1-38 total digits, default 18)
            s = scale (0-p decimal places, default 0)
            Example: DECIMAL(7, 3) -> 1234.567

        FLOAT(n) ->
            FLOAT(24) or FLOAT -> 4 bytes (~7 digits precision)
            FLOAT(53) -> 8 bytes (~15 digits precision)

        REAL -> 4 bytes (~7 digits precision)

        MONEY
            4 decimal places 
            8 bytes
            Range: -922,337,203,685,477.5808 to 922,337,203,685,477.5807

        SMALLMONEY
            4 decimal places
            4 bytes
            Range: -214,748.3648 to 214,748.3647
            

    [6] Binary
        BINARY(n)
        VARBINARY(n)
        VARBINARY(MAX)

    [7] Guid
        UNIQUEIDENTIFIER -> 16 bytes
*/

-- * DQL (Data Query Language)
/*
    SELECT Statement 
    Used to select/filter specific columns from a table.

    SELECT Clauses 
        [1] FROM
            Specifies which table to read from.

            SELECT (* -> all) /
                col1,
                col2,
                col3
            FROM table;

        [2] WHERE
            Filters rows based on a condition.

            SELECT *
            FROM table
            WHERE condition;

        [3] ORDER BY
            Sorts query results.
            By default, the table is sorted by PK.

            SELECT *
            FROM table
            ORDER BY col ASC/DESC;   default: ASC

            Nested ORDER BY
                First, data will be sorted by col1, then if the col1 has repetitions, then those repetitions will be sorted by col2

                SELECT *
                FROM table
                ORDER BY 
                    col1 ASC,
                    col2 DESC;

        [4] GROUP BY
            Collects rows that share the same value in one or more columns.
            Each unique combination of values in those columns becomes a group.
            Aggregate functions are then applied to each group.

            SELECT col
            FROM table
            GROUP BY col;

            Example:

            [1] Before Grouping
                +---------+----------+--------+
                |  City   | Category | Sales  |
                +---------+----------+--------+
                | Cairo   | Food     | 100    |
                | Cairo   | Clothes  | 300    |
                | Dubai   | Food     | 200    |
                | Cairo   | Food     | 150    |
                | Dubai   | Clothes  | 250    |
                | Cairo   | Clothes  | 50     |
                +---------+----------+--------+

            [2] GROUP BY City
                Cairo group:
                    (Cairo, Food, 100)
                    (Cairo, Clothes, 300)
                    (Cairo, Food, 150)
                    (Cairo, Clothes, 50)

                Dubai group:
                    (Dubai, Food, 200)
                    (Dubai, Clothes, 250)

                If we SELECT now, we gets only the Groups Keys, and that's why we can't SELECT any other column that's not part of the GROUP BY

                All columns in the SELECT be either aggregated or part of the GROUP BY

                +---------+
                |  City   |
                +---------+
                | Cairo   |
                | Dubai   |
                +---------+


            [3] Aggregation
                SELECT City, SUM(Sales)
                FROM Orders
                GROUP BY City;

                +---------+------------+
                |  City   | SUM(Sales) |
                +---------+------------+
                | Cairo   |        650 |
                | Dubai   |        450 |
                +---------+------------+

            GROUP BY (id) is not logical!! PK is unique, this means each row will be a group 

        [5] HAVING + (Aggregate Function)
            Filters GROUPS based on a condition.
            If there is no GROUP BY, the entire table is treated as a single group.

            SELECT col
            FROM table
            GROUP BY col
            HAVING condition;

        [6] DISTINCT
            Removes duplicate rows from the result set.
            Only rows that are completely identical (based on the selected columns) are removed.
            Don't use DISTINCT unless it's necessary.
            Using DISTINCT (* OR id) is not logical as PK is unique 

            SELECT DISTINCT col
            FROM table;

            SELECT DISTINCT col1, col2
            FROM table;
                removes the rows that have the same values in col1 and col2

        [7] TOP
            Limits the number of rows returned in the result set.

            SELECT TOP n col
            FROM table;

    AGGREGATE Functions (Count, Sum, Min, Max, Avg)
        Used to calculate a single value from a group of rows.
        Often used with GROUP BY, but can also be used without it (applies to the whole table as one group).
        Ignore NULL values. 

    Coding Order
        SELECT TOP n
            col1,
            SUM(col2)
        FROM table
        WHERE col1 = 'value'
        GROUP BY col1
        HAVING SUM(col2) > 0
        ORDER BY col ASC

    Execution Order
        [1] FROM
        [2] WHERE
        [3] GROUP BY
        [4] HAVING
        [5] (SELECT -> DISTINCT "is applied during selection")
        [6] ORDER BY
        [7] TOP
*/

-- * DDL (Data Definition Language)
/*
    Define the structure of a database using
        CREATE
        ALTER
        DROP
        TRUNCATE

    [1] CREATE
        1. Create a new table.
            CREATE TABLE table_name (
                col1 datatype constraint?, 
                col2 datatype constraint?,
                col3 datatype constraint?,
                CONSTRAINT constraint_name PRIMARY KEY (col1)
            );

    
    [2] ALTER
        1. Add new column
            ALTER TABLE table_name
            ADD col datatype constraint?;

        2. Remove column
            ALTER TABLE table_name
            DROP COLUMN col;

    
    [3] DROP
        1. Delete a table
            DROP TABLE table_name;

    
    [4] TRUNCATE
        1. Delete all rows from a table, but keep the table structure
            TRUNCATE TABLE table_name;
*/

-- * DML (Data Manipulation Language)
/*
    Used to manipulate data inside tables using:
        - INSERT
        - UPDATE
        - Delete

    [1] INSERT INTO
        1. Simple Insert
            INSERT INTO table_name (col1, col2, col3, ...)
            VALUES (value1, value2, value3)

        2. Row Constructor
            INSERT INTO table_name (col1, col2, col3, ...)
            VALUES
                (value1, value2, value3),
                (value1, value2, value3),
                (value1, value2, value3);

        3. Inserting data from another table
            INSERT INTO table1 (col1, col2, col3)
            SELECT col1, col2, col3
            FROM table2;

            SQL only cares about the data types of the columns, not the names.

        Notes:
            - If no columns are specified, SQL expects values for all columns in same order.
            - The number of values must match the number of columns specified.
            - The unspecified columns must either:
                1. Have a DEFAULT value
                2. Have a NOT NULL constraint
                3. Have an IDENTITY constraint

            

    [2] UPDATE .. SET
        UPDATE table_name
        SET 
            col1 = value1,
            col2 = value2,
            col3 = value3
        WHERE condition;

        If no WHERE clause is specified, SQL updates all rows.


    [3] DELETE FROM
        DELETE FROM table_name
        WHERE condition;

        If no WHERE clause is specified, SQL deletes all rows.
*/

-- * Key Differences: DELETE vs TRUNCATE
/*
    DELETE:
        1. Can use WHERE clause
        2. Fires triggers
        3. Doesn't reset IDENTITY counter
        4. Logs each row deletion (can rollback)
        5. Slower for large tables
        6. Can delete rows even if table has foreign key references to it
        7. Requires DELETE permission
        8. DELETE is a DML
    
    TRUNCATE:
        1. Removes ALL rows (no WHERE clause)
        2. Does NOT fire triggers
        3. Resets IDENTITY counter to seed value
        4. Minimal logging (usually can't rollback)
        5. Faster for large tables
        6 Can't truncate if table has foreign key references to it
        7. Requires ALTER TABLE permission
        8. TRUNCATE is a DDL

    Examples:
        Delete specific rows
            DELETE FROM Orders WHERE OrderDate < '2020-01-01';
        
        Delete all rows (logged, slow)
            DELETE FROM TempData;
        
        Remove all rows (fast, resets identity)
            TRUNCATE TABLE TempData;
        
        TRUNCATE fails if foreign keys reference this table
            TRUNCATE TABLE Customers; -- ERROR if Orders.CustomerID references this
        
        For large tables where you want to delete all rows, TRUNCATE is significantly faster.
*/

 