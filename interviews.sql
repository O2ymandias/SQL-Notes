-- * Difference Between DELETE and TRUNCATE
/*
    [1] Purpose
        DELETE -> removes specific rows from a table using a WHERE clause.
        TRUNCATE -> removes all rows from a table instantly.

    [2] WHERE Clause
        DELETE -> Can use WHERE to filter rows.
        TRUNCATE -> Cannot use WHERE (always deletes everything).

    [3] Locking Behavior
        DELETE -> Uses row-level locks. Each row is locked and removed one by one.
        TRUNCATE -> Uses a table-level lock. The whole table is locked at once.

    [4] Type of SQL Command
        DELETE -> DML (Data Manipulation Language).
        TRUNCATE -> DDL (Data Definition Language).

    [5] Identity Column Behavior
        DELETE -> Does not reset IDENTITY values (next row continues the sequence).
        TRUNCATE -> Resets the IDENTITY to the original seed value.

    [6] Required Permissions
        DELETE -> Requires DELETE permission on the table.
        TRUNCATE -> Requires ALTER permission (higher privilege).

    [7] Transaction Log Usage
        DELETE -> Logs each row deletion (heavy on the transaction log).
        TRUNCATE -> Logs only page deallocations (minimal transaction log usage).

    [8] Indexed Views
        DELETE -> Can be used on tables referenced by indexed views.
        TRUNCATE -> Not allowed on tables referenced by indexed views.

    [9] Performance
        DELETE -> Slower, because it deletes row-by-row.
        TRUNCATE -> Very fast, because it deallocates data pages.

    [10] Triggers
        DELETE -> Fires DELETE triggers (each deletion is logged).
        TRUNCATE -> Does not fire triggers (no row-level logging).
*/
