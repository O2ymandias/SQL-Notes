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
        Schema solves 3 main problems
            1. Naming Conflicts
                You cannot create two objects with the same name inside the same schema.

            2. Logical organization
                Schemas provide logical grouping of database objects.

            3. Security
                Schemas allow you to control permissions at a higher level.

        Creating schema (DDL)
            CREATE SCHEMA schemaName 

        Altering schema (DDL)
            Is mainly used to transfer objects (tables, views, etc.) from one schema to another.

            ALTER SCHEMA schemaName 
            TRANSFER sourceSchema.objectName; 

        Dropping schema 
            The schema must be empty.

            DROP SCHEMA schemaName


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
            Mechanism:
            - Groups rows that have the same values in specified columns into summary rows.
            - Often used with aggregate functions (COUNT, SUM, AVG, MIN, MAX) to perform calculations on each group.

            Rules:
                - All columns in the SELECT must be either aggregated or part of the GROUP BY.

            Limits:
                - Can't do aggregations and provide details of individual rows at the same time.

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

            WITH TIES
                Include additional rows that have the same value as the last row.
                ORDER BY is MANDATORY when using WITH TIES.

                SELECT TOP n WITH TIES col
                FROM table;
                ORDER BY col ASC

    SELECT + Shuffle
        NEWID() -> returns a unique identifier GUID
        
        SELECT *
        FROM table
        ORDER BY NEWID();
        SQL engine creates GUID for each row and order by this unique identifier

    
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
        [7] TOP/LIMIT
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

-- * Where Operators
/*
    [1] Comparison Operators
        =, >, <, >=, <=, (<> !=)

    [2] Logical Operators
        AND, OR, NOT

    [3] Range Operators
        BETWEEN ... AND ... (inclusive) 

    [4] Membership Operators
        (IN -> Simplifying the OR) , NOT IN

    [5] Search Operators
        LIKE (pattern)
            _ (Exactly one character)
            % (Zero or more characters)

        To search for a literal (% or _)
            SQL Server bracket escape:
                [_] -> literal underscore
                [%] -> literal percent

            ANSI ESCAPE clause:
                '\_'  ESCAPE '\'
                '\%'  ESCAPE '\'

        To search for a range
            [a-zA-z] -> (a to z and A to Z)
            [0-9] -> (0 to 9)

        To exclude characters [^...]
            [^a-z] -> any char not a to z
            [^abc] -> any char not a, b, or c

        To search for (a or b or c)
            [abc] -> a or b or c
*/

-- * Joins
/*
    To combine data (columns) from multiple tables
    [1] INNER JOIN
        Returns only matching rows from both tables.
        The order of the tables IS NOT important.

        SELECT *
        FROM table1
        INNER JOIN table2
        ON PK = FK;


    [2] LEFT (OUTER) JOIN
        Returns all rows from the left table, and only the matching rows from the right table.
        The order of the tables IS important.
        SQL shows NULLs for non-matching rows.

        SELECT *
        FROM table1
        LEFT JOIN table2
        ON PK = FK;

    [3] RIGHT (OUTER) JOIN
        The opposite of left join just with the order of the tables switched.

    [4] FULL (OUTER) JOIN
        Returns all rows from both tables.
        The order of the tables IS NOT important.
        SQL shows NULLs for non-matching rows.

        SELECT *
        FROM table1
        FULL JOIN table2
        ON PK = FK;

    [5] Left Anti Join
        Returns rows from the left table that has NO MATCH in the right table.
        The order of the tables IS important.

        SELECT *
        FROM table1
        LEFT JOIN table2
        ON PK = FK
        WHERE FK IS NULL;

    [6] Right Anti Join
        The opposite of left anti join just with the order of the tables switched.

    [7] Full Anti Join
        Returns rows from both tables that has NO MATCH.
        The order of the tables IS NOT important.

        SELECT *
        FROM table1
        FULL JOIN table2
        ON PK = FK
        WHERE PK IS NULL OR FK IS NULL;

    [8] Cross Join (Cartesian Product)
        Returns all possible combinations of rows from both tables.
        The order of the tables IS NOT important.

        SELECT *
        FROM table1
        CROSS JOIN table2;

    [9] Self Join
        Used to join a table to itself for a unary relationship when rows in the same table are related.
        The engine creates a temporary virtual copy of the same table during execution.
        The physical table (in DB) is always the child table (Has FK)
        The virtual table acts as the parent table (Has PK)
        Must use aliases to differentiate between the two roles.

        SELECT *
        FROM table1 AS child
        JOIN table1 AS parent
        ON parent.PK = child.FK;
*/

-- * Set Operators
/*
    Used to combine rows (data) from two or more queries into a single result set.

    Rules Of Set Operators
        1. ORDER BY can only be used once
        2. Same number of columns
        3. Matching data types
        4. Same order of columns
        5. First query controls aliases
        6. Mapping correct column.

    [1] UNION
        Removes duplicate rows (returns only distinct rows).

        SELECT col
        FROM table1
        UNION
        SELECT col
        FROM table2;

    [2] UNION ALL
        Does not remove duplicates (includes all rows from both queries).
        Faster than UNION, since it does not check for duplicates.

        SELECT col
        FROM table1
        UNION ALL
        SELECT col
        FROM table2;

    [3] EXCEPT (MINUS)
        Returns the DISTINCT rows from the first query that are NOT in the second query.
        The order of the tables matters (first -> source, second -> filter).
        The SQL Engine uses the second query as a check list.

        SELECT col
        FROM table1
        EXCEPT
        SELECT col
        FROM table2;

    [4] INTERSECT
        Returns the DISTINCT rows from the first query that are also in the second query.

        SELECT col
        FROM table1
        INTERSECT
        SELECT col
        FROM table2;
*/

-- * Row-level functions
/*
    [1] Single Row
        Takes one row as an input, and returns one value.
        Is applied to each row individually.
        Types:
            1. String Functions
                CONCAT
                UPPER
                LOWER
                TRIM
                REPLACE(value, old, new)
                LEN
                LEFT(value, length)
                RIGHT
                SUBSTRING(value, start "1-based-indexed", length)
                STRING_AGG(value, separator)

            2. Numeric Functions
                ROUND(value, decimal_places)
                ABS

            3. Date & Time Functions

            4. NULL Functions


    [2] Multiple Row 
        Takes multiple rows as an input, and returns one value.
        Types:
            1. Aggregate Functions
            2. Window Functions
*/

-- * Date & Time Functions
/*
    Is part of single row functions

    Date & Time Format: yyyy-MM-dd HH:mm:ss

    GETDATE(): datetime2
        Returns the current date and time.

    DAY(date): int
    MONTH(date): int
    YEAR(date): int

    DATEPART(datepart, date): int
        Extract a specific part of a date as a number (integer).
        The datepart could be:
            YEAR,
            MONTH,
            DAY,
            HOUR,
            MINUTE,
            SECOND,
            MILLISECOND
            MICROSECOND
            NANOSECOND
            WEEK,
            WEEKDAY,
            QUARTER

    DATENAME(datepart, date): varchar
        Extract a specific part of a date as a name (varchar).

    DATETRUNC(datepart, date): datetime2
        Truncate a date to a specific part of the date. the truncated parts is being reset.

    EOMONTH(date): date
        Returns the date of the last day of the month.
        To get the first day of the month, use DATETRUNC(month, date)

    DATEADD(datepart, value(+/-), date): datetime2
        Add or subtract a specific time interval to/from a date.

    DATEDIFF(datepart, start_date, end_date)
        Finds the difference between two dates.

    ISDATE(value): bit(0|1)
        Checks if the date is valid based on the standard format.
        Accepted Formats:
            - yyyy-MM-dd HH:mm:ss
            - yyyy-MM-dd (date only)
            - yyyy (year only)

        Year boundaries 1753 - 9999
*/

-- * Formatting & Casting Functions
/*
    Is part of single row functions

    1. CAST
    Casting only (NO formatting)
    Converts: Any Type -> Any Type
    Usage example:
        CAST(123 AS VARCHAR(10))

    2. CONVERT
    Casting + Date/Time formatting
    Converts: Any Type -> Any Type
    Can format ONLY Date & DateTime using style codes
    Usage example:
        CONVERT(VARCHAR(20), GETDATE(), 34)

    3. FORMAT
    Full formatting (Date, Time, Number, Money)
    Converts: Any Type -> STRING only
    Supports culture/locale ('en-US', 'ar-EG')
    Usage example:
        FORMAT(GETDATE(), 'dddd, dd MMM yyyy', 'en-US')   

    4. CONCAT
        Converts: Any Type -> String
        Replace NULLs with an empty string
        Example: 
            Select FName + ‘ ‘ + Convert (Varchar (3), Age) From Students 
                If FName or Age is null, this whole string will return null

            Select Concat(FName, ‘ ‘ , Age) From Students 
*/

-- * NULL Functions
/*
    Is part of single row functions

    What is NULL?
        NULL means "unknown".
        NULL is not equal to anything
            NULL = NULL -> False
            NULL != NULL -> False
            NULL = 0 -> False
            NULL != 0 -> False
            NULL = '' -> False
            NULL != '' -> False
            NULL = anyValue -> False
            NULL != anyValue -> False

            NULL + NULL -> NULL
            NULL + 5 -> NULL
            NULL + 'abc' -> NULL
        
    [1] ISNULL(value, replacement_value)
        - Replace NULL with a specific value.
        - Faster
        - SQL Server specific

        Example:
            SELECT ISNULL(salary, 'Unknown') AS Salary
            FROM Employees;

    [2] COALESCE(value1, value2, value3, ...)
        - Returns the first non-NULL value from a list.
        - Slower than ISNULL
        - Universal

        Example:
            SELECT COALESCE(salary, 0) AS Salary
            FROM Employees;

    [3] NULLIF(value1, value2)
        Returns:
            NULL -> if value1 and value2 are equal.
            value1 -> if value1 and value2 are not equal.

        Example (Fixing a division by zero error)
            SELECT
                OrderId,
                Sales,
                Quantity,
                Sales/NULLIF(Quantity, 0) AS Price
            FROM Sales.Orders;

    [4] IS NULL / IS NOT NULL
        Is used for filtering rows with NULLs as (=) operator won't work.
        Example:
            SELECT *
            FROM Employees
            WHERE first_name IS NULL / IS NOT NULL;


    Use Cases:
        1. Handle the NULLs before doing data aggregations.
            Most aggregation functions ignore NULLs.
            Only COUNT(*) counts all rows, including those with NULLs.
            Example:
                SELECT AVG(COALESCE(salary, 0))
                FROM Employees;

        2. Handle the NULLs before doing mathematical operations or concatenations.
            In SQL, any operation with NULL results in NULL
            NULL + 5 -> NULL
            NULL + 'abc' -> NULL
            Example:
                SELECT
                    ISNULL(first_name, '') + ' ' + ISNULL(last_name, '') AS FullName, 
                    ISNULL(salary, 0) + 5000 AS NewSalary
                FROM Employees;

        3. Handle the NULLs before joining tables.

            Table a:
            +------+-------+--------+
            | year | type  | orders |
            +------+-------+--------+
            | 2024 | NULL  | 120    |
            | 2024 | 'A'   | 200    |
            +------+-------+--------+

            Table b:
            +------+-------+--------+
            | year | type  | sales  |
            +------+-------+--------+
            | 2024 | NULL  | 300    |
            | 2024 | 'A'   | 600    |
            +------+-------+--------+

            The problem is when joining these two tables on a.year = b.year AND a.type = b.type, the records with NULLs will be lost. This is because NULL = NULL -> False 

            SELECT
                a.year,
                a.type,
                a.orders,
                b.sales
            FROM a
            INNER JOIN b
            ON a.year = b.year 
            AND ISNULL(a.type, '') = ISNULL(b.type, '')

            Result:
            +------+-------+--------+--------+
            | year | type  | orders | sales  |
            +------+-------+--------+--------+
            | 2024 | NULL  | 120    | 300    |
            | 2024 | 'A'   | 200    | 600    |
            +------+-------+--------+--------+

        4. Handle the NULLs before sorting.
            By default, SQL place NULLs at the beginning or end based on the ORDER BY clause.
                - ORDER BY ASC  : NULLs appear first
                - ORDER BY DESC : NULLs appear last

            Example (Sort ascending and move NULLs to the bottom)
                SELECT
                    CustomerID,
                    Score
                FROM Sales.Customers
                ORDER BY
                    CASE
                        WHEN Score IS NULL THEN 1
                        ELSE 0
                    END,
                    Score ASC;

                How it works:
                    - The CASE statement assigns 0 to non-NULL scores and 1 to NULLs.
                    - ORDER BY sorts first on (0,1), putting NULLs at the bottom.
                    - Then it sorts the non-NULL scores in ascending order.
*/

-- * CASE Statement 
/*
    Evaluates a list of conditions and returns a value based on the first condition that matches.

    Rules: The data type of the results MUST be the same.

    Syntax:

        Full Form (Searched CASE):
            CASE
                WHEN condition1 THEN result1
                WHEN condition2 THEN result2
                ...
                ELSE default_result
            END

        Short Form (Simple CASE):
            CASE column
                WHEN value1 THEN result1
                WHEN value2 THEN result2
                ...
                ELSE default_result
            END

        Notes:
            - If there is no ELSE clause, SQL returns NULL if no condition matches. 
            - You can only use one column in the short form.
            - The comparison operator is always "=" in the short form.

    Use Cases:

        1. Categorizing data
            Example:
                SELECT
                    CASE
                        WHEN salary > 10000 THEN 'High'
                        WHEN salary > 5000  THEN 'Medium'
                        ELSE 'Low'
                    END AS SalaryCategory
                FROM Employees;

        2. Mapping data
            Example:
                SELECT
                    CASE Gender
                        WHEN 'F' THEN 'Female'
                        WHEN 'M' THEN 'Male'
                        ELSE 'Unknown'
                    END AS Gender
                FROM Customers;

        3. Handling NULLs
            Example:
                SELECT
                    CASE
                        WHEN salary IS NULL THEN 'Unknown'
                        ELSE salary
                    END AS Salary
                FROM Employees;

        4. Conditional Aggregation
            Example:
                SELECT
                    CustomerID,
                    SUM(CASE WHEN OrderDate > '2025-01-01' THEN 1 ELSE 0 END) AS RecentOrders,
                    COUNT(*) AS TotalOrders
                FROM Customers
                GROUP BY CustomerID;
*/

-- * Window Functions
/*
    Part of the "multiple-row functions" category.

    A Window Function performs calculations across a set of rows "window" that are related to the current row without losing the higher level of detail.

    Unlike aggregate functions used with GROUP BY, which collapse multiple rows into a single summary row (Only the grouped keys and aggregated values are available), window functions do not collapse rows instead, they keep the original rows and add the calculated value next to each row.

    Syntax:
        window_function OVER (
            PARTITION BY 
            ORDER BY
            ROWS/RANGE
        )

    Types of Window Functions:
        - Aggregate functions are used as window functions (SUM, AVG, COUNT, MIN, MAX)
        - Ranking functions (ROW_NUMBER, RANK, DENSE_RANK, NTILE)
        - Value functions (LAG, LEAD, FIRST_VALUE, LAST_VALUE)

    OVER clause:
        - Tells SQL to treat the function as a window function.
        - It defines the window (set of rows) for the calculation via:

            1. PARTITION BY (optional):
                Divides dataset into partitions/groups/sets/windows to which the window function is applied independently.
                If not specified, the entire dataset is treated as a single partition.

            2. ORDER BY (optional): Defines the order of rows within each partition.

            3. Frame (optional): Defines a subset of rows within each partition that is relevant to the current row for the window function calculation.

                Frame Types:
                    - ROWS: Based on physical row positions.
                    - RANGE: Based on logical values.

                Frame Boundaries:
                    - UNBOUNDED PRECEDING: From the start of the partition.
                    - n PRECEDING: n rows before the current row.
                    - CURRENT ROW: The current row.
                    - n FOLLOWING: n rows after the current row.
                    - UNBOUNDED FOLLOWING: To the end of the partition.

                Rules:
                    1. Frame clause can ONLY be used together with ORDER BY clause.
                    2. Lower boundary must come before upper boundary.

                Example:
                    SELECT 
                        OrderID,
                        OrderDate,
                        OrderStatus,
                        Sales,
                        SUM(Sales) OVER(
                            PARTITION BY OrderStatus
                            ORDER BY OrderDate
                            ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
                        )
                    FROM Sales.Orders

                Compact Frame:
                    For only PRECEDING, The CURRENT ROW can be omitted.
                        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW -> ROWS 2 PRECEDING

                Default Frame:
                    If ORDER BY is specified without a frame, the default frame is:
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

                Running(Moving) Total:
                    Summarizes all values from the first row of the window up to the current row.
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW -- Default if ORDER BY is used
                    Example:
                        SELECT 
                            OrderID,
                            OrderDate,
                            Sales,
                            SUM(Sales) OVER(
                                ORDER BY OrderDate
                                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                            ) AS RunningTotal
                        FROM Sales.Orders

                Rolling Total:
                    Summarizes a fixed number of consecutive rows calculated within a moving window.
                    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
                    Example:
                        SELECT 
                            OrderID,
                            OrderDate,
                            Sales,
                            SUM(Sales) OVER(
                                ORDER BY OrderDate
                                ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
                            ) AS RollingTotal
                        FROM Sales.Orders


    Rules of using window functions:
        [1] Window functions can be used only in the SELECT and ORDER BY clauses.
            You CANNOT use window functions in:
            WHERE, GROUP BY, HAVING, JOIN conditions
            Because they are evaluated in the SELECT clause


        [2] Nested window functions are not allowed.
            SUM( AVG(Sales) OVER(PARTITION BY CustomerID) ) OVER() -> NOT ALLOWED


        [4] Window functions can be used with GROUP BY is the same query ONLY if they don't reference non-aggregated values/non-grouped columns.

            When you use GROUP BY, the only available columns in the SELECT clause are:
                - Grouped columns
                - Aggregated values
            All other columns are lost.
            So window function must work only on columns that still exist after grouping.

            Example:
                SELECT
                    CustomerID,
                    SUM(Sales) AS [Total Sales],
                    RANK() OVER(ORDER BY SUM(Sales) DESC) AS RankedByTotalSales,
                    RANK() OVER(ORDER BY CustomerID) AS RankedByCustomerID
                FROM Sales.Orders
                GROUP BY CustomerID;

                Why valid?
                    - The window function uses only:
                        1. Aggregated data (SUM(Sales)), not raw columns
                        2. Grouped columns (CustomerID)
*/

-- * Aggregation Functions (COUNT, SUM, AVG, MIN, MAX) 
/*
    Part of the "single-row functions" category.

    Used to calculate a single value from a group of rows.

    Often used with GROUP BY.

    If not used with GROUP BY:
        - Is applied to the whole table as one group.
        - Can't SELECT any other columns.
    
    Ignore NULL values.

    ONLY COUNT(*) doesn't ignore NULL values, as it counts the rows.

    COUNT(*) == COUNT(1)
*/

-- * Ranking Functions
/*
    Two types:
        1. Integer-Based Ranking
            - ROW_NUMBER()
            - RANK()
            - DENSE_RANK()
            - NTILE(n)

        2. Percentage-Based Ranking
            - CUME_DIST()
            - PERCENT_RANK()

    Rules:
        PARTITION BY Clause is optional.
        ORDER BY Clause is required.
        Frame Clause is NOT allowed.


    [1] ROW_NUMBER()
        Assigns a UNIQUE rank to each row (No Gaps).
        It does NOT handle ties.

    [2] RANK()
        Assigns a rank to each row.
        Ties receive the same rank, and the next rank is skipped.

    [3] DENSE_RANK()
        Assigns a rank to each row.
        Ties receive the same rank, and the next rank is NOT skipped.

    [4] NTILE(n)
        Divides the rows into "n" approximately "around" equal groups (tiles/buckets).
        Each row is assigned a tile number from 1 to n.
        Bucket size = Total Rows / n(The number of buckets)
        Larger buckets come first.


    [1] CUME_DIST() - Cumulative Distribution
        
        Purpose:
            Calculates the cumulative distribution of a value within an ordered dataset.
            Shows what fraction of rows have values less than or equal to the current row.
        
        Returns: 
            A decimal value in the range (0, 1]
            (Always greater than 0, up to and including 1)
        
        Formula:
            CUME_DIST = (Number of rows ≤ current value) / (Total rows in partition)
            
            Or equivalently:
            CUME_DIST = (Rank of last row with current value) / (Total rows)
        
        Tie Handling:
            - Rows with identical ORDER BY values receive the SAME CUME_DIST
            - Uses the LAST position among tied rows for calculation
            - Example: If 3 rows tie at positions 5-7, all get CUME_DIST based on position 7
        
        Example:
            Salary: 30K, 40K, 40K, 50K, 60K
            CUME_DIST: 0.2, 0.6, 0.6, 0.8, 1.0
            (The two 40K salaries both use position 3 of 5 = 0.6)

    [2] PERCENT_RANK() - Percentile Rank
        
        Purpose:
            Calculates the relative rank of a row as a percentage within an ordered dataset.
            Shows how the current row compares to others (0% = lowest, 100% = highest).
        
        Returns: 
            A decimal value in the range [0, 1]
            (From 0 to 1 inclusive)
        
        Formula:
            PERCENT_RANK = (RANK - 1) / (Total rows - 1)
            Where RANK is the row's position in the ordered set
        
        Tie Handling:
            - Rows with identical ORDER BY values receive the SAME PERCENT_RANK
            - Uses the FIRST position among tied rows for calculation
            - Example: If 3 rows tie at positions 5-7, all get PERCENT_RANK based on position 5
        
        Special Case:
            - If there's only 1 row, PERCENT_RANK = 0 (avoids division by zero)
        
        Example:
            Salary: 30K, 40K, 40K, 50K, 60K
            RANK: 1, 2, 2, 4, 5
            PERCENT_RANK: 0.0, 0.25, 0.25, 0.75, 1.0
            (The two 40K salaries both use rank 2: (2-1)/(5-1) = 0.25)


    Key Differences Between CUME_DIST and PERCENT_RANK
        CUME_DIST:
            - Uses LAST position of tied rows
            - Never returns 0 (minimum is 1/n where n = total rows)
            - Answers: "What % of rows are ≤ this value?"

        PERCENT_RANK:
            - Uses FIRST position of tied rows  
            - First row always returns 0
            - Answers: "Where does this row rank relative to others?"

        Both:
            - Require ORDER BY clause
            - Can use PARTITION BY for groups
            - Tied rows get identical values
*/

-- * Value Functions
/*
    Part of the "multiple-row functions" category.
    Used to access data from other rows in the result set without using a self-join.

    [1] LEAD
        Allows accessing data from the next row within a window.

        Syntax:
            LEAD(
                Column Name        -> The column from which to retrieve the value.
                , Offset           -> optional, default = 1 (how many rows ahead to look)
                , Default Value    -> optional, default = NULL (value to return if the lead row does not exist)
            )
            OVER (
                PARTITION BY  -> optional
                ORDER BY      -> required
                FRAME         -> NOT ALLOWED
            )

    [2] LAG
        Allows accessing data from the previous row within a window.

    [3] FIRST_VALUE
        Returns the first **non-null** value within a window.

    [4] LAST_VALUE
        Returns the last **non-null** value within a window.

        Important:
            The frame clause is critical to get the correct result.

        Default Frame:
            UNBOUNDED PRECEDING
            AND CURRENT ROW
            -> With this default, LAST_VALUE returns the value of the **current row**, not the actual last row in the partition.

        To Get the Actual Last Value in the Partition:
            Specify the frame explicitly:
                ROWS BETWEEN CURRENT ROW
                AND UNBOUNDED FOLLOWING
*/

-- * Database Structure Overview
/*
    [1] Database Engine
        The core service responsible for storing, retrieving, and processing data.
        It handles: Query execution, Transactions, Concurrency control, Security

    [2] Database Storage

        [A] Disk Storage
            - Long-term storage (persistent).
            - Capacity: Very large.
            - Speed: Slower read/write operations compared to memory.

            Types of Disk Storage:
                (1) User Data Storage
                    - The MAIN content of the database.
                    - Stores the actual data created by users and applications.
                    - Includes tables and indexes.

                (2) System Catalog Storage
                    - Internal storage for database metadata (data about data).
                    - Contains information about tables, columns, indexes, constraints, etc.
                    - You can query metadata using INFORMATION_SCHEMA and system views.

                (3) Temp Storage
                    - Used for temporary operations (sorting, hashing, intermediate results).
                    - Data is deleted after the operation completes.
                    - Backed by physical disk (TempDB in SQL Server).

        [B] Cache Storage
            - Short-term, in-memory storage.
            - Capacity: Limited.
            - Speed: Extremely fast (RAM).
            - Purpose: Speeds up frequently accessed data and reduces disk operations.

    Logical Structure:
        Each SQL Server instance has multiple databases
        Each database has multiple schemas
        Each schema has multiple objects (tables, views, stored procedures, etc.).

        SQL Server Instance
        │
        ├── Database 1
        │   │
        │   ├── Schema: dbo
        │   │   ├── Table: Users
        │   │   ├── View: UserSummary
        │   │   ├── Stored Procedure: GetUsers
        │   │   └── Function: fn_UserCount
        │   │
        │   ├── Schema: sales
        │   │   ├── Table: Orders
        │   │   └── View: MonthlySales
        │   │
        │   └── Schema: security
        │       └── Table: Roles
        │
        ├── Database 2
        │   │
        │   ├── Schema: dbo
        │   │   ├── Table: Products
        │   │   └── Stored Procedure: GetProducts
        │   │
        │   └── Schema: inventory
        │       └── Table: Stock
        │
        └── Database 3
            └── Schema: dbo
                └── Table: Logs
*/

-- * Subqueries
/*
    Definition:
        A subquery is a query nested inside another query.

    Result Types:
        [1] Scalar Subquery
            - Returns a SINGLE value (one row, one column).

        [2] Row Subquery
            - Returns MULTIPLE rows but ONLY ONE column.
            - Often used with IN, ANY, ALL, EXISTS.

        [3] Table Subquery
            - Returns multiple rows and multiple columns.
            - Behaves like a regular table.

    Types of Subqueries:

    [A] Non-Correlated Subquery
        - A subquery that can run INDEPENDENTLY of the main query.

        NOTES:
            1. The subquery is executed FIRST.
            2. The subquery result is passed to the main query.

    [B] Correlated Subquery
        - A subquery that RELIES on values from the main query.

        Execution:
            1. SQL executes the MAIN QUERY first.
            2. SQL processes the main query result ROW BY ROW.
            3. The main query passes the CURRENT ROW values to the subquery.
            4. SQL executes the subquery using those values.
            5. SQL checks if the subquery returned a result.
            6. If so, SQL includes the CURRENT ROW in the final output.
            7. SQL repeats this process for EVERY row.
            8. SQL returns the FINAL RESULT.

        NOTES:
            1. The MAIN QUERY runs first.
            2. The SUBQUERY runs ONCE PER ROW of the main query.

        Example:
            SELECT
                *,
                (SELECT COUNT(*)
                FROM Sales.Orders AS o
                WHERE c.CustomerID = o.CustomerID
                ) AS TotalOrders
            FROM Sales.Customers AS c
            In this example, the subquery is executed ONCE FOR EACH ROW of the main query.

                  

    Where You Can Use Subqueries:

        [1] FROM Clause (Derived Table / Inline View)
            - Used as a temporary table for the main query.
                Example:
                    SELECT *
                    FROM (
                        SELECT
                            *,
                            AVG(Price) OVER() AS AvgPrice
                        FROM Sales.Products
                    ) AS temp
                    WHERE Price > AvgPrice;

        [2] SELECT Clause (Scalar subqueries only)
                Example:
                    SELECT
                        *,
                        (SELECT AVG(Price) FROM Sales.Products) AS AvgPrice
                    FROM Sales.Products;

                Notes:
                    - MUST return a single value.
                    - Same effect as:
                        SELECT
                            *,
                            AVG(Price) OVER() AS AvgPrice
                        FROM Sales.Products;

        [3] JOIN Clause
            - Used to prepare data before joining it with another table.
            Example:
                SELECT *
                FROM Sales.Customers AS c
                LEFT JOIN (
                    SELECT
                        CustomerID,
                        COUNT(*) AS TotalOrders
                    FROM Sales.Orders
                    GROUP BY CustomerID
                ) AS temp
                ON c.CustomerID = temp.CustomerID


        [4] WHERE Clause
            [A] With Comparison Operators
                Subquery MUST be scalar.
                Example: 
                    SELECT * FROM Sales.Products
                    WHERE Price > 
                        (SELECT AVG(Price) FROM Sales.Products) -- Scalar Subquery

                
            [B] With Logical Operators (IN, ANY, ALL, EXISTS)
                (1) IN
                    SELECT *
                    FROM Sales.Orders
                    WHERE CustomerID IN (
                        SELECT CustomerID
                        FROM Sales.Customers
                        WHERE Country = 'Germany'
                    );

                (2) Comparison Operator + ANY
                    Checks if a value matches ANY of the values in the subquery.
                    SELECT *
                    FROM Sales.Employees
                    WHERE Gender = 'F'
                    AND Salary > Any (
                        SELECT Salary
                        FROM Sales.Employees
                        WHERE Gender = 'M'
                    )

                (3) Comparison Operator + ALL
                    Checks if a value matches ALL of the values in the subquery.
                    SELECT *
                    FROM Sales.Employees
                    WHERE Gender = 'F'
                    AND Salary > All (
                        SELECT Salary
                        FROM Sales.Employees
                        WHERE Gender = 'M'
                    )

                (4) EXISTS (Correlated Subquery)
                    - Checks whether the subquery returns ANY rows.
                    - EXISTS returns TRUE as soon as the subquery returns at least one row.

                    Example:
                        SELECT *
                        FROM Sales.Orders AS o
                        WHERE EXISTS (
                            SELECT 1
                            FROM Sales.Customers AS c
                            WHERE c.Country = 'Germany'
                            AND c.CustomerID = o.CustomerID
                        )

                    Explanation:
                        - SQL processes the Orders table row by row.
                        - For each order, SQL runs the subquery to check whether there exists
                        a customer from Germany with the SAME CustomerID.
                        - The condition c.CustomerID = o.CustomerID makes it a CORRELATED
                        subquery because the subquery depends on values from the main query.
                        - If the subquery returns at least one row, EXISTS = TRUE and the order
                        is included in the final output.
*/

-- * CTE (Common Table Expressions)
/*
    Temporary, named result set (virtual table) that can be used multiple times in a query to simplify and organize a complex query.

    Accessing the data from a CTE is usually faster than repeatedly scanning physical tables, because the result is calculated once and reused (logical optimization).    

    Syntax:
        WITH CTE_name AS (
            SELECT
                col1,
                col2
            FROM table
            WHERE condition
        )
        SELECT
            col1,
            col2
        FROM CTE_name
        WHERE condition

    CTE RULES:
        1. Can't use ORDER BY directly inside a CTE unless accompanied by TOP or used inside a window function.

    Types of CTEs:
        [1] Non-Recursive CTE
            Is executed only ONCE.

            [A] Standalone CTE
                Runs independently as it's self-contained and doesn't rely on other CTEs or queries.

                Example (Single Standalone CTE)
                    WITH CTE_totalSales AS (
                        SELECT 
                            CustomerID,
                            SUM(Sales) AS TotalSales
                        FROM Sales.Orders
                        GROUP BY CustomerID
                    )
                    SELECT
                        c.CustomerID,
                        c.FirstName,
                        c.LastName,
                        ts.TotalSales
                    FROM Sales.Customers AS c
                    LEFT JOIN CTE_totalSales AS ts
                        ON ts.CustomerID = c.CustomerID

                Example (Multiple Standalone CTEs)
                    WITH CTE_totalSales AS (
                        SELECT 
                            CustomerID,
                            SUM(Sales) AS TotalSales
                        FROM Sales.Orders
                        GROUP BY CustomerID
                    ),
                    CTE_lastOrderDate AS (
                        SELECT
                            CustomerID,
                            MAX(OrderDate) AS lastOrderDate
                        FROM Sales.Orders
                        GROUP BY CustomerID
                    )
                    SELECT
                        c.CustomerID,
                        c.FirstName,
                        c.LastName,
                        ts.TotalSales,
                        lod.lastOrderDate
                    FROM Sales.Customers AS c
                    LEFT JOIN CTE_totalSales AS ts
                        ON ts.CustomerID = c.CustomerID
                    LEFT JOIN CTE_lastOrderDate AS lod
                        ON lod.CustomerID = c.CustomerID

            [B] Nested CTE
                A nested CTE uses the result of another CTE, so it CAN'T run independently.

                Example
                    WITH CTE_TotalSales AS (
                        SELECT
                            CustomerID,
                            SUM(Sales) AS TotalSales
                        FROM Sales.Orders -- Standalone CTE, it doesn't depend on any other CTE
                        GROUP BY CustomerID
                    ),
                    CTE_LastOrderDate AS (
                        SELECT
                            CustomerID,
                            MIN(OrderDate) AS LastOrderDate
                        FROM Sales.Orders -- Standalone CTE, it doesn't depend on any other CTE
                        GROUP BY CustomerID
                    ),
                    CTE_CustomerRank AS
                    (
                        SELECT
                            *,
                            RANK() OVER(ORDER BY TotalSales DESC) AS CustomerRank
                        FROM CTE_TotalSales -- Nested CTE, it depends on CTE_TotalSales
                    )
                    SELECT
                        c.CustomerID,
                        CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
                        ts.TotalSales,
                        lod.LastOrderDate,
                        rts.CustomerRank
                    FROM Sales.Customers AS c
                    LEFT JOIN CTE_TotalSales AS ts
                        ON c.CustomerID = ts.CustomerID
                    LEFT JOIN CTE_LastOrderDate AS lod
                        ON c.CustomerID = lod.CustomerID
                    LEFT JOIN CTE_CustomerRank AS rts
                        ON c.CustomerID = rts.CustomerID

        [2] Recursive CTE
            A self-referencing query that repeatedly processes data
            until a specified condition is met.

            Syntax:
            WITH CTE_Name AS (
                -- Anchor Member
                SELECT
                    col1,
                    col2
                FROM table
                WHERE condition

                UNION ALL

                -- Recursive Member
                SELECT
                    t.col1,
                    t.col2
                FROM table t
                INNER JOIN CTE_Name c -- Self-reference
                    ON join_condition -- Break condition
                WHERE break_condition -- Break condition
            )
            -- Main Query
            SELECT
                col1,
                col2
            FROM CTE_Name
            OPTION (MAXRECURSION 10); -- default = 100, max = 32767 

            Execution Flow:
            [1] SQL Server executes the anchor member once
                and stores the initial result set.

            [2] SQL Server executes the recursive member using
                the result from the previous iteration.

                - If the break condition is NOT met, recursion continues.
                - If the break condition IS met, recursion stops.

            Example (1): Number Series
            WITH CTE_Series AS (
                -- Anchor Member
                SELECT 1 AS Number

                UNION ALL

                --Recursive Member
                SELECT Number + 1
                FROM CTE_Series
                WHERE Number < 20
            )
            SELECT *
            FROM CTE_Series;

            Example (2): Employee Hierarchy
            WITH CTE_Hierarchy AS (
                -- Anchor Member
                SELECT
                    EmployeeID,
                    CONCAT(FirstName, ' ', LastName) AS Name,
                    ManagerID,
                    1 AS Level
                FROM Sales.Employees
                WHERE ManagerID IS NULL

                UNION ALL

                -- Recursive Member
                SELECT
                    e.EmployeeID,
                    CONCAT(e.FirstName, ' ', e.LastName) AS Name,
                    e.ManagerID,
                    h.Level + 1
                FROM Sales.Employees e
                INNER JOIN CTE_Hierarchy h
                    ON e.ManagerID = h.EmployeeID
            )
            SELECT *
            FROM CTE_Hierarchy;
*/

-- * Example: Recursive CTE – Employee Hierarchy (Step by Step)
/*
    Example Data (Sales.Employees):

    | EmployeeID | FirstName | LastName | ManagerID |
    | ---------- | --------- | -------- | --------- |
    | 1          | John      | Smith    | NULL      |
    | 2          | Sara      | Lee      | 1         |
    | 3          | Omar      | Ali      | 1         |
    | 4          | Lina      | Noor     | 2         |
    | 5          | Adam      | Saleh    | 2         |


    Visual Hierarchy:
    John (Level 1)
    ├─ Sara (Level 2)
    │  ├─ Lina (Level 3)
    │  └─ Adam (Level 3)
    └─ Omar (Level 2)


    SQL:
        WITH CTE_Hierarchy AS (
            -- Anchor Member
            SELECT
                EmployeeID,
                CONCAT(FirstName, ' ', LastName) AS Name,
                ManagerID,
                1 AS Level
            FROM Sales.Employees
            WHERE ManagerID IS NULL

            UNION ALL

            -- Recursive Member
            SELECT
                e.EmployeeID,
                CONCAT(e.FirstName, ' ', e.LastName) AS Name,
                e.ManagerID,
                h.Level + 1
            FROM Sales.Employees e
            INNER JOIN CTE_Hierarchy h
                ON e.ManagerID = h.EmployeeID
        )
        SELECT *
        FROM CTE_Hierarchy;

    Step 1: Anchor Query (Level 1)
        SELECT
            EmployeeID,
            CONCAT(FirstName, ' ', LastName) AS Name,
            ManagerID,
            1 AS Level
        FROM Sales.Employees
        WHERE ManagerID IS NULL

        -> Finds top-level employees (employees with no manager)
        -> Sets their hierarchy Level to 1

        Result After Anchor Member:
        | EmployeeID | Name       | ManagerID | Level |
        | ---------- | ---------- | --------- | ----- |
        | 1          | John Smith | NULL      | 1     |


    Step 2: First Recursive Iteration (Level 2)
        SELECT
            e.EmployeeID,
            CONCAT(e.FirstName, ' ', e.LastName) AS Name,
            e.ManagerID,
            h.Level + 1
        FROM Sales.Employees e
        INNER JOIN CTE_Hierarchy h
            ON e.ManagerID = h.EmployeeID

        -> Finds employees whose ManagerID exists in the CTE
        -> Sets their hierarchy Level to (parent Level + 1)

        Employees managed by John (EmployeeID = 1):
        | EmployeeID | Name     | ManagerID | Level |
        | ---------- | -------- | --------- | ----- |
        | 2          | Sara Lee | 1         | 2     |
        | 3          | Omar Ali | 1         | 2     |

        Result After First Recursive Iteration:
        | EmployeeID | Name       | ManagerID | Level |
        | ---------- | ---------- | --------- | ----- |
        | 1          | John Smith | NULL      | 1     |
        | 2          | Sara Lee   | 1         | 2     |
        | 3          | Omar Ali   | 1         | 2     |


    Step 3: Second Recursive Iteration (Level 3)
        -> The CTE now contains:
           John (1), Sara (2), Omar (3)

        -> Only the newly added rows from the previous iteration
           (Sara and Omar) are used to find more employees.

        Employees managed by Sara (EmployeeID = 2):
        | EmployeeID | Name       | ManagerID | Level |
        | ---------- | ---------- | --------- | ----- |
        | 4          | Lina Noor  | 2         | 3     |
        | 5          | Adam Saleh | 2         | 3     |

        Employees managed by Omar (EmployeeID = 3):
        | EmployeeID | Name | ManagerID | Level |
        | ---------- | ---- | --------- | ----- |
        | NO ROWS    |      |           |       |

        CTE now contains:
        | EmployeeID | Name       | ManagerID | Level |
        | ---------- | ---------- | --------- | ----- |
        | 1          | John Smith | NULL      | 1     |
        | 2          | Sara Lee   | 1         | 2     |
        | 3          | Omar Ali   | 1         | 2     |
        | 4          | Lina Noor  | 2         | 3     |
        | 5          | Adam Saleh | 2         | 3     |


    --------------------------------------------------------------
    Step 4: Third Recursive Iteration (Level 4)
    --------------------------------------------------------------
        -> Newly added rows: Lina (4) and Adam (5)
        -> SQL attempts to find employees managed by them

        Employees managed by Lina (EmployeeID = 4):
        | NO ROWS |

        Employees managed by Adam (EmployeeID = 5):
        | NO ROWS |

        -> No new rows are produced

        SQL Server stops recursion automatically and returns the final result set.
*/

-- * Views
/*
    A View is a virtual table based on the result set of a stored SQL query.
    It stores ONLY the query definition and metadata, NOT the actual data.

    Table VS View
        Table
            - Data is physically persisted in the database
            - Used for transactional operations (INSERT, UPDATE, DELETE).

        View
            - Data is NOT persisted (virtual result set)
            - Used for read-only operations (SELECT).

    CTE VS View
        CTE
            - Used to reduce redundancy in ONE query.
            - Improves reusability within a single query.
            - Temporary and exists only during query execution.
            - Automatically cleaned up after execution.

        View
            - Reduces redundancy across MULTIPLE queries.
            - Reusable at database / project level.
            - Persisted query logic.
            - Requires maintenance (CREATE / ALTER / DROP)

    Use Cases
        1. Central Query Logic
            - Store complex joins, filters, and calculations in one place.
            - Reduce duplication across the project.
            - Improve consistency and maintainability.

        2. Hide the Complexity of the Data
            - Abstract complex table structures and relationships.
            - Expose a simple and clean interface to consumers.
            - Prevent users from dealing with joins and business logic.

        3. Enforce Security and Hide Sensitive Data
            - Expose only required columns to users.
            - Hide sensitive data such as salaries or personal information.
            - Control data access using permissions on views instead of tables.

    Syntax:
        CREATE VIEW Schema.View_Name AS (
            SELECT
                col1,
                col2
            FROM table
            WHERE condition
        )

    Example
        CREATE VIEW Sales.V_MonthlySummary AS (
            SELECT
                MONTH(OrderDate) AS Month,
                COUNT(*) AS TotalOrders,
                SUM(Quantity) AS TotalQuantities,
                SUM(Sales) AS TotalSales
            FROM Sales.Orders
            GROUP BY MONTH(OrderDate)
        )

    Drop View
        DROP VIEW Schema.View_Name

    Update View
        ALTER VIEW Schema.View_Name AS (
            SELECT
                newCol1,
                newCol2
            FROM table
            WHERE condition
        )
        OR

        IF OBJECT_ID('Schema.View_Name', 'V') IS NOT NULL
            DROP VIEW Schema.View_Name
        GO
        CREATE VIEW Schema.View_Name AS (
            SELECT
                newCol1,
                newCol2
            FROM table
            WHERE condition
        )
    
    How SQL Server Executes Views
        1. When a view is created, SQL Server stores the view definition (the SELECT statement) and metadata in the system catalog.

        2. When a view is queried, SQL Server replaces the view name with its stored SELECT statement and builds one final query.

        3. SQL Server executes this final query directly on the underlying physical tables and returns the result set.

        4. When a view is dropped, only the view definition is removed. The data in the base tables is NOT affected.
*/

-- * Types Of Tables
/*
    [1] Permanent Tables

        A: CREATE / INSERT
            CREATE (DDL)
                - Defines the structure of the table (columns, data types, constraints).
            INSERT (DML)
                - Adds data to the table after it is created.

            Syntax:
                CREATE TABLE table_name (
                    column1 datatype,
                    column2 datatype,
                    ...
                );

                INSERT INTO table_name (column1, column2, ...)
                VALUES
                    (value1, value2, ...),
                    (value1, value2, ...),
                    (value1, value2, ...);

        B: CTAS (Create Table As Select)
            - Creates a new permanent table based on the result of a SELECT query.
            - Table structure and data are created at the same time.

            Syntax (MySQL, PostgreSQL, Oracle):
                CREATE TABLE new_table_name AS
                SELECT
                    col1,
                    col2,
                    ...
                FROM
                    existing_table_name
                WHERE
                    condition;

            Syntax (SQL Server):
                SELECT
                    col1,
                    col2,
                    ...
                INTO
                    new_table_name
                FROM
                    existing_table_name
                WHERE
                    condition;

            Example:
                SELECT
                    DATENAME(MONTH, OrderDate) AS OrderMonth,
                    COUNT(*) AS TotalOrders
                INTO Sales.MonthlyOrders
                FROM Sales.Orders
                GROUP BY DATENAME(MONTH, OrderDate);


            Coping the structure without data from existing table
                SELECT *
                INTO new_table 
                FROM existing_table 
                WHERE 1 = 2; -- False condition  

            Updating a CTAS Table
                - CTAS tables do NOT update automatically.
                - Common approach: drop the table and recreate it.

            Example:
                IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL
                    DROP TABLE Sales.MonthlyOrders;
                GO

                SELECT
                    DATENAME(MONTH, OrderDate) AS OrderMonth,
                    COUNT(*) AS TotalOrders
                INTO Sales.MonthlyOrders
                FROM Sales.Orders
                GROUP BY DATENAME(MONTH, OrderDate);

            Use Cases:
                1. Performance Optimization
                    - Persist complex query logic in table and provide fast read as data is already materialized.

                2. Data Snapshots
                    - Useful for capturing data at a specific point in time.


    [2] Temporary Tables
        Stores intermediate results in a temporary storage (PHYSICAL) within database during the session.

        The database will automatically drops the temporary table once the session ends.
        (System databases -> tempdb -> Temporary Tables)

        Syntax:
            SELECT
                col1,
                col2,
                ...
            INTO
                #temp_table_name -- This '#' what made it temporary.
            FROM
                existing_table_name
            WHERE
                condition;
*/

-- * Comparison (Subquery vs CTE vs TMP vs CTAS vs VIEW)
/*
    [1] Subquery
        Storage: Cache
        Lifetime: Temporary
        When Deleted: End of Query
        Scope: Single Query
        Reusability: Limited (1 time - 1 query)
        Up2Date: Yes

    [2] CTE (Common Table Expression)
        Storage: Cache
        Lifetime: Temporary
        When Deleted: End of Query
        Scope: Single Query
        Reusability: Limited (multi-times - 1 query)
        Up2Date: Yes

    [3] TMP (Temporary Table)
        Storage: Disk (tempdb)
        Lifetime: Temporary
        When Deleted: End of Session
        Scope: Multi-Queries
        Reusability: Medium (multi queries during session)
        Up2Date: No

    [4] CTAS (Create Table As Select)
        Storage: Disk
        Lifetime: Permanent
        When Deleted: DDL (DROP)
        Scope: Multi-Queries
        Reusability: High (multi queries)
        Up2Date: No

    [5] VIEW
        Storage: No Storage
        Lifetime: Permanent
        When Deleted: DDL (DROP)
        Scope: Multi-Queries
        Reusability: High (multi queries)
        Updatable: Yes
*/

-- * Query Lifecycle
/*
    [1] Parsing
        - SQL Server checks the query for syntax errors.
        - Ensures SQL keywords, clauses, and structure are valid.
        - Performs name resolution (tables, columns, schemas).

    [2] OPTIMIZATION PHASE (Query Optimizer) 
        - SQL Server decides how to execute the query efficiently.
        - Uses metadata and statistics to evaluate multiple strategies.
        - Chooses the lowest-cost execution plan (CPU, I/O, memory).

    [3] QUERY TREE (Logical Processing Order)
        - SQL Server converts the optimized logic into a logical query tree.
        - Execution follows a SPECIFIC logical order:
            [1] FROM
            [2] WHERE
            [3] GROUP BY
            [4] HAVING
            [5] (SELECT -> DISTINCT "is applied during selection")
            [6] ORDER BY
            [7] TOP / LIMIT(MYSQL, POSTGRESQL)

    [4] EXECUTION PLAN (Physical Execution)
        - SQL Server generates a PHYSICAL execution plan.
        - Defines HOW data is accessed and processed.
        - The plan is stored in PLAN CACHE for reuse.
        - For stored procedures, the plan can be reused (improves performance)
*/

-- * Stored Procedures
/*
    Definition:
        - A stored procedure is a precompiled set of SQL statements.
        - Can accept parameters (INPUT, OUTPUT, INPUT/OUTPUT).
        - Precompiled: SQL Server parses, validates, and creates an execution plan in advance.

    Syntax
        [A] Definition:
            CREATE PROCEDURE procedure_name
            AS
            BEGIN
                -- Logic
            END

        [B] Execution
            Positional parameters
            EXEC procedure_name arg1, arg2;

            Named parameters (recommended)
            EXEC procedure_name 
                @param1 = arg1, 
                @param2 = arg2;

            Using default value for @param2
            EXEC procedure_name arg1;

    Advantages of Stored Procedures
        1. Encapsulation & Reusability
            - Business logic centralized.
            - Can be reused by multiple applications or queries.

        2. Security
            - Limits direct table access.
            - Permissions granted on procedure instead of underlying tables.

        3. Performance
            - Execution plan cached and reused.
            - Reduces parsing and optimization overhead.

        4. Accepting Parameters
            - INPUT, OUTPUT, INPUT/OUTPUT supported.

        5. Error Handling
            - Supports TRY...CATCH blocks.

    WITH ENCRYPTION in Stored Procedures
        - Hide the definition (source code) of a stored procedure from users.
        - Users can view the definition using: sp_helptext procedure_name 
        Syntax
            CREATE PROCEDURE procedure_name
            WITH ENCRYPTION
            AS
            BEGIN
                -- Logic
            END

    Example (Handle Error and Control Flow)
        CREATE PROCEDURE sp_GetCustomerSummary
        @country VARCHAR(50) = 'USA'
        AS
        BEGIN
            BEGIN TRY
                -- Declare Variables
                DECLARE 
                    @totalCustomers INT,
                    @avgScore FLOAT;
            
                -- Preparing And Cleaning Data (Control Flow)
                IF EXISTS (
                    SELECT 1 FROM Sales.Customers
                    WHERE Country = @country
                    AND Score IS NULL
                )
                BEGIN
                    PRINT ('Updating NULL scores to 0.');

                    UPDATE Sales.Customers
                    SET Score = 0
                    WHERE Country = @country
                    AND Score IS NULL;
                END

                ELSE
                BEGIN
                    PRINT ('No NULL scores found.');
                END
            
                -- Generating Reports.
                -- Report 1 (Total Customers & Average Score)
                SELECT
                    @totalCustomers = COUNT(*),
                    @avgScore = AVG(CAST(Score AS FLOAT))
                FROM Sales.Customers
                WHERE Country = @country
                PRINT(CONCAT('Total customers from ', @country, ': ', @totalCustomers));
                PRINT(CONCAT('Average score from ', @country, ': ', @AvgScore));

                -- Report 2 (Total Orders & Total Sales)
                SELECT
                    COUNT(*) AS TotalOrders,
                    SUM(Sales) AS TotalSales,
                    1/0 -- Intentionally causing an error
                FROM Sales.Orders AS o
                JOIN Sales.Customers AS c
                    ON c.CustomerID = o.CustomerID
                WHERE c.Country = @country
            END TRY

            BEGIN CATCH
                PRINT('An error occurred.');
                PRINT(CONCAT('Error Message: ', ERROR_MESSAGE()));
                PRINT(CONCAT('Error Number: ', ERROR_NUMBER()));
                PRINT(CONCAT('Error Line: ', ERROR_LINE()));
                PRINT(CONCAT('Stored Procedure: ', ERROR_PROCEDURE()));
            END CATCH
        END

    INSERT based on EXECUTE
        Is used to insert the result set returned by a stored procedure into a table or table variable.

        INSERT INTO table_name/table_variable 
        EXEC procedure_name

        Example:
            CREATE PROCEDURE sp_GetEmployeeByID
                @id INT
            AS
            BEGIN
                SELECT
                    EmployeeID,
                    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
                    Salary
                FROM Sales.Employees
                WHERE EmployeeID = @id
            END

            GO

            DECLARE @T TABLE (
                EmployeeID INT,
                EmployeeName VARCHAR(100),
                Salary INT
            )

            INSERT INTO @T
            EXEC sp_GetEmployeeByID
                @id = 1;

            SELECT *
            FROM @T AS e
            JOIN Sales.Orders AS o
                ON e.EmployeeID = o.SalesPersonID

    Parameters in stored procedures:
        [1] INPUT (default)

        [2] OUTPUT
            CREATE OR ALTER PROCEDURE sp_GetEmployeeSalary
                @id INT,
                @salary INT OUTPUT
            AS
            BEGIN
                SELECT @salary = Salary
                FROM Sales.Employees
                WHERE EmployeeID = @id
            END

            DECLARE @empSalary INT;

            EXEC sp_GetEmployeeSalary 
                @id = 1,
                @salary = @empSalary OUTPUT

            SELECT @empSalary AS Salary

        [3] INPUT/OUTPUT
            CREATE PROCEDURE sp_GetCustomerScore
                @x INT OUTPUT
            AS
            BEGIN
                SELECT @x = Score
                FROM Sales.Customers
                WHERE CustomerID = @x
            END

            DECLARE @customerScore INT = 1;

            EXEC sp_GetCustomerScore
                @x = @customerScore OUTPUT 

            SELECT @customerScore AS CustomerScore

    Dynamic Query
        CREATE PROCEDURE sp_GetData
            @table VARCHAR(100),
            @column VARCHAR(100) = '*'
        AS
        BEGIN
            EXECUTE('SELECT ' + @column + ' FROM ' + @table)
        END

        EXEC sp_GetData
            @table = 'Sales.Orders',
            @column = 'Sales'

        Issues / Not Recommended:
            1. SQL Injection Risk
                - User can pass malicious table/column names to modify or delete data.
                Example:
                    EXEC sp_GetData
                        @table = 'Sales.Orders; DROP TABLE Sales.Orders;--',
                        @column = 'Sales'

            2. Exposes Database Objects
                - Any table or column can be accessed, revealing sensitive info.

            3. Performance
                - Dynamic SQL is not precompiled; execution plan cannot be cached efficiently.
                
            4. Maintenance
                - Changes in table/column names can break the procedure.

    Updating Stored Procedure
        ALTER PROCEDURE sp_GetCustomerSummary 
            @country VARCHAR(50) = 'USA'
        AS
        BEGIN
            -- Update logic
        END

    Dropping Stored Procedure
        DROP PROCEDURE procedure_name;
*/

-- * Triggers
/*
    Definition:
        Triggers are special stored procedures that execute automatically when specific events occur on a table or database.

    Trigger Types:
        [1] DML Triggers (Data Manipulation Language)
            Fired when data inside a table is modified.

            Events:
                - INSERT
                - UPDATE
                - DELETE

            Execution Types:
                - AFTER Trigger
                    Runs AFTER the event occurs.
                    The operation is already completed.
                    Can create more than one (AFTER trigger) on the same table. 


                - INSTEAD OF Trigger
                    Runs INSTEAD OF the event.
                    Replaces the original operation.
                    Can't Create more than one (INSTEAD OF trigger) on the same table.

            Example Use Cases:
                - Enforcing business rules
                - Auditing data changes
                - Preventing invalid data modifications


        [2] DDL Triggers (Data Definition Language)
            Fired when database schema objects are changed.

            Events:
                - CREATE
                - ALTER
                - DROP

            Scope:
                - Database-level
                - Server-level

            Example Use Cases:
                - Preventing schema changes
                - Auditing object creation or deletion
                - Enforcing naming conventions

            Creating a Read-only Table
                CREATE TRIGGER trg_ReadOnlyTable
                ON Sales.Employees
                INSTEAD OF INSERT, UPDATE, DELETE
                AS
                BEGIN
                    SELECT 'Read-only table. Insert, update, and delete operations are not allowed.'
                END 


        [3] LOGON Triggers
            Fired when a user attempts to log in to SQL Server.

            Scope:
                - Server-level only

            Example Use Cases:
                - Restricting login times

    Syntax:
        CREATE TRIGGER trigger_name
        ON table_name
        AFTER / INSTEAD OF (INSERT / UPDATE / DELETE)
        AS
        BEGIN
            -- Trigger logic
        END

    Example
        CREATE TRIGGER trg_AfterInsertEmployee
        ON Sales.Employees
        AFTER INSERT
        AS
        BEGIN
            INSERT INTO Sales.EmployeesLogs (EmployeeID, LogMessage, LogDate)
            SELECT 
                EmployeeID,
                CONCAT('New Employee Added: ', EmployeeID),
                GETDATE()
            FROM INSERTED -- Virtual table that holds a copy of the rows that are being inserted into the target table
        END

    Disabling and Enabling Triggers
        ALTER TABLE Student DISABLE TRIGGER trigger_name  
        ALTER TABLE Student ENABLE TRIGGER trigger_name


    Notes:
        1. The trigger will automatically take the schema name of table we create trigger on.
        2. When firing trigger (After/Instead of), two virtual tables are created (Same structure as original table):: 
            - Inserted 
            - Deleted

            Insert case: 
                Inserted table -> Contains the inserted values (Or try to insert). 
                Deleted table -> Empty 

            Delete case: 
                Inserted table -> Empty 
                Deleted table -> Contains the deleted values (Or try to delete). 

            Update case: 
                Inserted table -> Contains the new values 
                Deleted table -> Contains the old values 

        3. OUTPUT
            - Acts like a runtime trigger (but it is NOT a trigger)
            - Can be used with: INSERT, UPDATE, DELETE
            Example:
                UPDATE Topic
                SET Top_Name = 'Database Design'
                OUTPUT
                    SUSER_NAME() AS [CurrentUser],
                    inserted.*
                INTO anotherTable
                WHERE Top_Id = 5;
              
*/

-- * STRING_AGG
/*
    Is an SQL aggregate function that concatenates values from multiple rows into a single string, separated by a delimiter.

    Syntax:
        SELECT 
            STRING_AGG(column_name, delimiter) 
        FROM table_name
        WHERE condition

    With GROUP BY
        It supports aggregation within a group.

        Example:
            SELECT 
                Category,
                STRING_AGG(Product, ', ') AS Products
            FROM Orders
            GROUP BY Category;

    Ordering the Result
        Using WITHIN GROUP (ORDER BY Name)

        Example:
            SELECT 
                Category,
                STRING_AGG(Product, ', ') WITHIN GROUP (ORDER BY Product) AS Products
            FROM Orders
            GROUP BY Category;
*/

-- * Indexes
/*
    Definition:
        An index is a data structure that provides fast access to data, improving the performance of queries.

    Types:
        [1] By Structure
            A: Clustered Index
            B: Nonclustered Index

        [2] By Storage
            A: Row-store Index
            B: Column-store Index

        [3] By Function
            A: Unique Index
            B: Filtered Index

    How data stored in Database?
        Data is stored on disk in data files (.mdf files).
        Inside these files, data is stored in units called pages

        What is a page?
            The smallest unit of storage in a database (8kb).
            It stores anything (Data, Metadata, Indexes, etc).

            Types of pages:
                [1] Data Page
                [2] Index Page

        How is data stored in pages?
            Each page consists of:
                1. Header Section
                    - Stores metadata about the page.
                    - Examples: page ID (FileID:PageID like 1:150), page type, amount of free space, etc.

                2. Data Section
                    - Stores the actual rows.
                    - The SQL Server engine tries to fit as many rows as possible into a single page.

                3. Offset Array
                    - Contains pointers to the starting position of each row.
                    - Allows SQL Server to quickly locate rows inside the page.
*/

-- * Indexes By Structure (1. Clustered Index)
/*
    What is a Heap Table?
        - A table without a clustered index.
        - Rows aren't stored in any particular order.

        Advantages:
            - Fast inserts (writes) as SQL Server doesn't need to maintain any order.

        Disadvantages:
            - Slower reads as SQL Server must scan all data pages and within each page, it scans each row to find matching data [Full Table Scan].

    What happens when you create a Clustered Index?
        
        1. Physical Data Ordering
            SQL Server physically sorts the data inside the Data Pages based on the clustered index key.

        2. B-Tree Creation
            SQL Server builds a B-Tree (Balanced Tree) to efficiently locate rows.
            
            B-Tree Structure (Bottom to Top):

                1) Leaf Nodes (Data Pages) - Level 0
                    - Contain the ACTUAL data.
                    - Pages are linked in a doubly-linked list for efficient range scans.
                    - Data is sorted by the clustered index key.

                    Example:
                        Data Page: 1:100 (IDs 1–5)
                            Data:
                                1, Bob, 25, 'New York'
                                2, Alice, 30, 'London'
                                3, Charlie, 28, 'Paris'
                                4, David, 35, 'Tokyo'
                                5, Eve, 22, 'Berlin'
                            ↓ (Next Page Pointer)
                        
                        Data Page: 1:101 (IDs 6–10)
                            Data:
                                6, John, 40, 'Sydney'
                                7, Mary, 27, 'Rome'
                                8, Tom, 33, 'Madrid'
                                9, Sarah, 29, 'Dublin'
                                10, Mike, 31, 'Oslo'
                            ↓ (Next Page Pointer)

                2) Intermediate Nodes (Index Pages) - Level 1+
                    - Contain key-range pairs:
                        key   -> The minimum key value in the leaf data pages.
                        value -> Pointer to the leaf data page.
                    - Multiple intermediate nodes levels may exist for large tables.
                    - Do NOT contain actual table data.

                    Example:
                        Index Page: 1:200 (Level 1)
                            Key -> Page Pointer:
                                1   -> 1:100   -- Points to page with IDs 1–5
                                6   -> 1:101   -- Points to page with IDs 6–10
                                11  -> 1:102   -- Points to page with IDs 11–15
                                16  -> 1:103   -- Points to page with IDs 16–20
                                ...

                        Index Page: 1:201 (Level 1)
                            Key -> Page Pointer:
                                51  -> 1:105
                                61  -> 1:106
                                71  -> 1:107
                                ...

                3) Root Node (Index Page) - Top Level
                    - Contains pointers to the Intermediate Nodes.
                    - Only ONE root node per index.

                    Example:
                        Root Page: 1:300
                            Key -> Page Pointer:
                                1   -> 1:200   -- Points to intermediate page for IDs 1–50
                                51  -> 1:201   -- Points to intermediate page for IDs 51–100
                                101 -> 1:202   -- Points to intermediate page for IDs 101–150
                                ...

        3. Search Process Example
            Query: SELECT * FROM Users WHERE UserID = 13

            Step 1: Start at Root Node (1:300)
                - SQL Server reads: "13 falls between 1 and 51"
                - Follows pointer to Intermediate Node 1:200

            Step 2: Navigate to Intermediate Node (1:200)
                - SQL Server reads: "13 falls between 11 and 16"
                - Follows pointer to Data Page 1:102

            Step 3: Read Data Page (1:102)
                - SQL Server scans the page to find UserID = 13
                - Returns the entire row: 13, Frank, 26, 'Amsterdam'

            I/O Operations:
                B-Tree Structure: 3 page reads (Root → Intermediate → Data)
                vs
                Heap Structure: Could require reading ALL pages in the table

    Clustered Index Characteristics:

        Advantages:
            1. Fast Range Queries (ORDER BY, BETWEEN, >, <):
                Because data is physically sorted by the clustered index key 
                and each data page points to the next data page (doubly-linked list).

                Example: 
                    SELECT * FROM Orders WHERE OrderDate BETWEEN '2024-01-01' AND '2024-01-31'

                    **With Clustered Index on OrderDate**
                        Physical Storage (Data Pages sorted by OrderDate):

                        Page 1:100 (Jan 1-5)
                        ┌─────────────────────────────────────┐
                        │ 2024-01-01, Order details...        │
                        │ 2024-01-02, Order details...        │
                        │ 2024-01-03, Order details...        │
                        │ 2024-01-04, Order details...        │
                        │ 2024-01-05, Order details...        │
                        └─────────────────────────────────────┘
                                ↓ (Next page pointer)

                        Page 1:101 (Jan 6-10)
                        ┌─────────────────────────────────────┐
                        │ 2024-01-06, Order details...        │
                        │ 2024-01-07, Order details...        │
                        │ 2024-01-08, Order details...        │
                        │ 2024-01-09, Order details...        │
                        │ 2024-01-10, Order details...        │
                        └─────────────────────────────────────┘
                                ↓ (Next page pointer)

                        Page 1:102 (Jan 11-15)
                        ┌─────────────────────────────────────┐
                        │ 2024-01-11, Order details...        │
                        │ 2024-01-12, Order details...        │
                        │ ...                                 │
                        └─────────────────────────────────────┘
                                ↓
                            ... continues to Jan 31

                    **How SQL Server Executes the Query**
                        Step 1: Index Seek to Find Starting Point
                            - Navigate B-Tree to find first row where OrderDate = '2024-01-01'
                            - Lands on Page 1:100
                            - I/O Cost: 2-3 page reads (Root → Intermediate → Leaf/Data)

                        Step 2: Sequential Read (Range Scan)
                            - Start reading from the first matching row
                            - Follow the "next page" pointers through the doubly-linked list
                            - Read pages sequentially: 1:100 → 1:101 → 1:102 → ... → 1:131
                            - Stop when OrderDate > '2024-01-31'
                            - I/O Type: Sequential (fast, contiguous reads)

                        Step 3: Return Results
                            - All matching rows are found in contiguous pages
                            - No jumping around on disk
                            - Data already sorted (no additional sorting needed)

                    With Heap Structure (No Clustered Index), SQL Server must scan all data pages and within each page, it scans each row to find matching data [Full Table Scan]

            2. Fast Lookups on the Clustered Key:
                Direct navigation through B-Tree to data.

        Disadvantages:
            1. Slower Writes (INSERT, UPDATE, DELETE):
                Must maintain physical sort order.
                May cause page splits.

            2. Page Splits:
                What: When a data page is full and a new row must be inserted in the middle.
                How: SQL Server splits the page, moving ~50% of rows to a new page.
                Impact:
                    - Increases I/O operations.
                    - Wastes storage space.
                Example:
                    Page 1:100 is FULL with OrderDates [2025-01-01, 2025-01-02, 2025-01-04, 2025-01-05]
                    INSERT new row with OrderDate = 2025-01-03
                    Result:
                        Page 1:100: [2025-01-01, 2025-01-02]
                        Page 1:150: [2025-01-03, 2025-01-04, 2025-01-05]  <- New page created

            3. Only ONE Clustered Index Per Table:
                Data can only be physically sorted only ONCE.

    Clustered Index vs Primary Key:

        Primary Key:
            - A logical constraint ensuring uniqueness and non-NULL.
            - By default, SQL Server creates a CLUSTERED index on the primary key.
            - Can be NONCLUSTERED if specified.

        Clustered Index:
            - A physical storage structure.
            - Doesn't have to be on the primary key.
            - Doesn't have to be unique (but SHOULD be for best performance).
                If not unique, SQL Server adds a hidden 4-byte "uniqueifier" to make rows unique.

        Syntax Examples:
            A) Primary Key with Clustered Index (default)
                CREATE TABLE Orders (
                    OrderID INT PRIMARY KEY,  -- Creates clustered index
                    OrderDate DATETIME
                );

            B) Primary Key with Non-Clustered Index
                CREATE TABLE Orders (
                    OrderID INT PRIMARY KEY NONCLUSTERED,  -- Non-clustered
                    OrderDate DATETIME,
                    INDEX IX_OrderDate CLUSTERED (OrderDate)  -- Clustered on different column
                );

            C) Clustered Index without Primary Key
                CREATE TABLE Orders (
                    OrderID INT UNIQUE NONCLUSTERED,
                    OrderDate DATETIME,
                    INDEX IX_OrderDate CLUSTERED (OrderDate)  -- No primary key needed
                );

    Best Practices for Clustered Index Key:

        1. Narrow (Small Size):
            Use: INT (4 bytes), BIGINT (8 bytes)
            Avoid: GUID (16 bytes), VARCHAR(100+)
            Why: Non-clustered indexes store the clustered key, so wide keys waste space.

        2. Unique:
            Use: Primary key or unique column
            Avoid: Non-unique columns
            Why: If not unique, SQL Server adds a 4-byte uniqueifier to each row.
            Impact: Increases index size and reduces performance.

        3. Static (Unchanging):
            Use: Identity columns, immutable values
            Avoid: Frequently updated columns (Status, LastModified)
            Why: 
                - Updating the clustered key moves the entire row.
                - Updates ALL non-clustered indexes pointing to that row.
            Example:
                Bad: Clustered index on CustomerName (users change names)
                Good: Clustered index on CustomerID (never changes)

        4. Ever-Increasing (Sequential):
            Use: IDENTITY, auto-incrementing values, NEWSEQUENTIALID()
            Avoid: NEWID() (random GUID), random values
            Why: New rows are added at the end, avoiding page splits.
            Example:
                Good:
                    CustomerID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED
                    Inserts: 1, 2, 3, 4, 5... (always at the end)
                
                Bad:
                    CustomerID UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY CLUSTERED
                    Inserts: {random GUID} causes page splits throughout the table

    When to Use Heap Tables (No Clustered Index):

        1. Very small tables (< 100 rows):
            Overhead of B-Tree not worth it.
            Table scan is already fast.

        2. Write-once, read-never tables (logging/auditing):
            If data is archived and rarely queried.

    Notes:
        - A table can have only ONE clustered index because data can be physically ordered only once.
        - Leaf nodes contain the ACTUAL table data (all columns), unlike non-clustered indexes.
        - All non-clustered indexes reference the clustered key (or RID if heap).
        - In most cases, an INT IDENTITY column is the best choice for a clustered index key.
*/

-- * Indexes By Structure (2. Non-Clustered Index)
/*

    What happens when you create a Non-Clustered Index?
        
        1. Data Pages Remain Unchanged:
            SQL Server does NOT reorder the data inside the Data Pages.
            Data can remain as a heap or in clustered index order.

        2. B-Tree Creation:
            SQL Server builds a separate B-Tree structure.

            B-Tree Structure (Bottom to Top):

                1) Leaf Nodes (Index Pages) - Level 0:
                    - SQL Server creates index pages (NOT data pages).
                    - Each index page contains key-value pairs:
                        key   -> The column(s) on which the non-clustered index is created.
                        value -> A pointer to the actual row location.

                    Row Locator (Pointer) Types:
                        If table has a Clustered Index: value = Clustered Index Key
                        If table is a Heap: value = Row Identifier (RID)

                    Example (Heap Table):
                        Index Page: 1:200
                            Key (LastName)  -> RID:
                                'Anderson'  -> 1:102:96   -- File 1, Page 102, Slot 96
                                'Brown'     -> 1:101:140
                                'Clark'     -> 1:101:188
                                'Davis'     -> 1:103:52
                                'Evans'     -> 1:102:220
                                ...

                        Index Page: 1:201
                            Key (LastName)  -> RID:
                                'Fisher'    -> 1:102:224
                                'Garcia'    -> 1:102:224
                                'Lewis'     -> 1:102:228
                                'Morgan'    -> 1:102:232
                                'Nelson'    -> 1:102:236

                    Example (Table with Clustered Index on CustomerID):
                        Index Page: 1:200
                            Key (LastName)  -> Clustered Key:
                                'Anderson'  -> 1025   -- CustomerID
                                'Brown'     -> 3041
                                'Clark'     -> 1856
                                'Davis'     -> 4129
                                'Evans'     -> 2347
                                ...

                        Index Page: 1:201
                            Key (LastName)  -> Clustered Key:
                                'Fisher'    -> 2348
                                'Garcia'    -> 2349
                                'Lewis'     -> 2350
                                'Morgan'    -> 2351
                                'Nelson'    -> 2352

                2) Intermediate Nodes (Index Pages) - Level 1+:
                    - Contain key-range pairs:
                        key   -> Minimum key value in leaf index pages
                        value -> Pointer to child page
                    - Multiple levels may exist for large indexes.

                    Example:
                        Index Page: 1:300
                            Key         -> Page Pointer:
                            'Anderson'  -> 1:200   -- Page with names A-E
                            'Fisher'    -> 1:201   -- Page with names F-K
                            'Lewis'     -> 1:202   -- Page with names L-R

                        Index Page: 1:301
                            Key         -> Page Pointer:
                            'Morgan'    -> 1:203   -- Page with names M-Z
                            'Owens'     -> 1:204   -- Page with names O-S
                            'Smith'     -> 1:205   -- Page with names S-Z

                3) Root Node (Index Page) - Top Level:
                    - Starting point for all non-clustered index seeks.
                    - Points to Intermediate Nodes or directly to Leaf Pages.

                    Example:
                        Root Page: 1:400
                            Key -> Page Pointer:
                            'A'   -> 1:300   -- Points to intermediate page for names A-L
                            'M'   -> 1:301   -- Points to intermediate page for names M-Z


        3. Search Process Example:

            Scenario 1: Table with Clustered Index
                Query: SELECT * FROM Customers WHERE LastName = 'Garcia'

                Step 1: Start at Root Node of Non-Clustered Index
                    - Find that 'Garcia' is in range pointing to page 1:300

                Step 2: Navigate to Intermediate Node (1:300)
                    - Find that 'Garcia' falls in range 'Fisher' to 'Lewis'
                    - Follow pointer to Leaf Page 1:201

                Step 3: Read Leaf Page of Non-Clustered Index (1:201)
                    - Find 'Garcia' -> Clustered Key = 3041

                Step 4: Lookup in Clustered Index (KEY LOOKUP)
                    - Use clustered key 3041 to navigate clustered index B-Tree
                    - Find the data page containing CustomerID = 3041
                    - Read the entire row

                I/O Operations: 
                    3 reads for non-clustered index (Root → Intermediate → Leaf)
                    + 3 reads for clustered index lookup
                    = 6 total page reads

                This is called a KEY LOOKUP or BOOKMARK LOOKUP

            Scenario 2: Heap Table
                Query: SELECT * FROM Customers WHERE LastName = 'Garcia'

                Step 1-3: Same as above, but leaf page returns RID
                    'Garcia' -> RID: 1:101:380

                Step 4: RID Lookup
                    - Directly access File 1, Page 101, Slot 380
                    - Read the row

                I/O Operations:
                    3 reads for non-clustered index
                    + 1 read for RID lookup
                    = 4 total page reads

                This is called an RID LOOKUP

    Non-Clustered Index Characteristics:

        Advantages:
            1. Multiple Non-Clustered Indexes Per Table:
                - Can create up to 999 non-clustered indexes per table.
                - Each index can optimize a different query pattern
                    -- For searching by Email
                    CREATE NONCLUSTERED INDEX IX_Email ON Users(Email);

                    -- For searching by CreatedAt
                    CREATE NONCLUSTERED INDEX IX_CreatedAt ON Users(CreatedAt);


            2. Doesn't Affect Data Storage:
                No physical reordering of data.

        Disadvantages:
            1. Requires Additional Storage:
                Separate structure from the table data.

            2. Key Lookups Can Be Expensive:
                If many rows match the query.
                Each matching row requires a separate lookup(another fetch of the data) to get the other columns data.
                SQL Server may choose table scan instead.

            3. Slows Down Writes (INSERT, UPDATE, DELETE):
                Every write must update all non-clustered indexes.
                More indexes = slower writes.

    Best Practices for Non-Clustered Indexes:

        1. Create indexes based on query patterns:
            - Index columns used in WHERE, JOIN, and ORDER BY clauses
            - Prefer highly selective columns

        2. Index column order matters:
            - Put the most selective (highest cardinality) column first
            - SQL Server can SEEK on:
                (first column) or (first + next columns)
            - SQL Server CANNOT SEEK on:
                non-leading columns alone

            Example:
                CREATE INDEX IX_Orders ON Orders(CustomerID, OrderDate);
                -- Supports: WHERE CustomerID = ?
                -- Supports: WHERE CustomerID = ? AND OrderDate = ?
                -- Does NOT support: WHERE OrderDate = ?

        3. Avoid over-indexing:
            - Every index slows INSERT, UPDATE, DELETE operations
            - More indexes = higher storage and maintenance cost
            - Typical target: 3–5 non-clustered indexes per table

        4. Remove unused indexes:
            - Unused indexes waste space and slow writes

    Notes:
        - Data inside Index Pages is sorted by the non-clustered index key.
        - Data inside Data Pages is NOT sorted by the non-clustered index.
        - At the leaf level, non-clustered indexes store INDEX PAGES, not actual table data.
        - Non-clustered indexes on a table with clustered index store the clustered key as the value.

        **Why does a non-clustered index store the clustered key instead of the physical row location (RID)?**
            Because physical row locations are not stable.
            In clustered tables, rows can move due to page splits, updates, or index maintenance.
            Storing RIDs would require updating all non-clustered indexes on every row move, which is expensive and inefficient.
*/

-- * Difference Between Clustered Index and Non-Clustered Index
/* 
   [1] Clustered Index
        Definition:
        - Physically sorts and stores table rows on disk

        Number of Indexes:
        - One clustered index per table only

        Read Performance:
        - Faster (data is already sorted)

        Write Performance:
        - Slower
        - Reason: inserting/updating may require data row reordering

        Storage Efficiency:
        - More storage-efficient
        - Data itself is the index

        Use Cases:
        - Unique column (e.g. Primary Key)
        - Column not frequently modified
        - Improves range queries (BETWEEN, >, <)

    [2] Non-Clustered Index
        Definition:
        - Separate structure that stores index keys
        - Contains pointers to the actual data rows

        Number of Indexes:
        - Multiple non-clustered indexes allowed per table

        Read Performance:
        - Slower than clustered (extra lookup needed)

        Write Performance:
        - Faster
        - Physical data order is not affected

        Storage Efficiency:
        - Requires additional storage space
        - Index + pointers to data

        Use Cases:
        - Columns frequently used in WHERE conditions
        - JOIN columns
        - Exact match queries (=)

    Syntax
        CREATE [CLUSTERED|NONCLUSTERED] INDEX IndexName
        ON TableName (Column1 ASC|DESC, Column2 ASC|DESC, ...);

    Notes:
        - Default type: NONCLUSTERED if not specified.
        - ASC | DESC:
            Clustered: determines physical order of data rows in the table.
            Non-clustered: determines order of entries in the index only, not the actual table rows.


    Examples
        1. Clustered index on CustomerID
            CREATE CLUSTERED INDEX IX_Customers ON Customers(CustomerID);

            - Table rows will be physically sorted by CustomerID
            - Only one clustered index per table allowed

        2. Non-clustered index on LastName + FirstName
            CREATE NONCLUSTERED INDEX IX_Customers ON Customers(LastName, FirstName);

            - Speeds up searches and sorts on LastName and FirstName
            - Data rows remain in original table order

        3. Non-clustered index with mixed sort order (ASC, DESC)
            CREATE INDEX IX_Customers ON Customers(LastName ASC, FirstName DESC);

            - Defaults to NONCLUSTERED
            - Index pages will be sorted by LastName ascending and FirstName descending
            - Useful for queries with ORDER BY LastName ASC, FirstName DESC
*/
