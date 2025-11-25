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
            [a-z] -> (a to z) OR (A to Z) -> case insensitive
            [0-9] -> (0 to 9)

        To exclude characters [^...]
            [^a-z] -> any char not a to z
            [^abc] -> any char not a, b, or c 
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
    Converts: Any Type → Any Type
    Can format ONLY Date & DateTime using style codes
    Usage example:
        CONVERT(VARCHAR(20), GETDATE(), 34)

    3. FORMAT
    Full formatting (Date, Time, Number, Money)
    Converts: Any Type → STRING only
    Supports culture/locale ('en-US', 'ar-EG')
    Usage example:
        FORMAT(GETDATE(), 'dddd, dd MMM yyyy', 'en-US')   
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

-- * Built-in Functions
/*

    [2] Window Functions
        LAG()
            Allows you to access data from a previous row in the result set without using a self-join.

            Syntax:
                LAG(column, offset, default_value) OVER (
                    [PARTITION BY partition_column]
                    ORDER BY order_column
                )

            Parameters:
                column:
                    The column value you want to retrieve from the previous row

                offset (optional):
                    Number of rows back to look (default is 1)

                default_value (optional):
                    Value to return if there's no previous row (default is NULL)

                PARTITION BY (optional):
                    Divides data into partitions

                ORDER BY (required):
                    Determines which row is considered "previous" without it, SQL wouldn't know how to sequence data.         
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
                        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

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



    Rank Functions:
        [1] RANK()
            Assigns a rank to each row within a partition of a result set.
            Ties receive the same rank, and the next rank is skipped.
            ORDER BY is required at the OVER clause.
            Example:
                SELECT
                    RANK() OVER (ORDER BY Score DESC) AS Rank
                FROM Students;

        [2] ROW_NUMBER()
            Assigns a unique sequential integer to rows within a partition of a result set, starting at 1 for the first row in each partition.
            No ties, each row gets a distinct number.

        [3] DENSE_RANK()
            Similar to RANK(), but without gaps in ranking values when there are ties.

        [4] NTILE(n)
            Divides the ordered rows in a partition into n approximately equal groups (tiles) and assigns a tile number to each row.
*/


