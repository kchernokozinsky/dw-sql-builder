# Builder Functions Documentation

This documentation provides an overview of the functions available in the builder module. These functions assist in constructing SQL queries using DW SQL Builder.
 
## Condition Functions

1. `condition(lvalue: String | Number, op: UnaryOperator): Condition`

   Creates a simple condition with a unary operator. The `lvalue` represents the value to be compared, and the `op` represents the unary operator used in the condition.

2. `condition(lvalue: String | Number, op: Operator, rvalue: String | Number): Condition`

   Creates a simple condition with a binary operator. The `lvalue` represents the left value to be compared, the `op` represents the binary operator used in the condition, and the `rvalue` represents the right value to be compared.

3. `condition(func: (Condition) -> SQLStruct, condition: String): SQLStruct`

   Applies a function to a condition. The `func` is a function that takes a condition as an argument and returns an SQLStruct. The `condition` parameter is the condition to be passed to the function.

4. `AND(lCondition: Condition, rCondition: Condition): Condition`

   Combines two conditions using the logical AND operator.

5. `OR(lCondition: Condition, rCondition: Condition): Condition`

   Combines two conditions using the logical OR operator.

6. `BETWEEN(col: String, fst: Value): (Value) -> Between`

   Creates a condition that checks if a column value is between two specified values. The `col` parameter represents the column name, and the `fst` parameter represents the first value of the range. The function returns a function that takes the second value of the range and returns a Between condition.

7. `AND(func: (String) -> Between, snd: Value): Between`

   Applies a function that creates a Between condition with a column name and the first value of the range and combines it with the second value using the logical AND operator.

8. `NOT(condition: Condition): Condition`

   Negates a condition using the logical NOT operator.

## SQL Structure Functions

9. `columns(sql: SQLStruct, cols: Array<Column> | "*"): SQLStruct`

   Sets the columns to be selected in the SQLStruct. The `sql` parameter is the SQLStruct, and the `cols` parameter is either an array of column names or "*" to select all columns.

10. `appendColumn(sql: SQLStruct, col: Column): SQLStruct`

    Appends a column to the list of columns to be selected in the SQLStruct.

11. `FROM(sql: SQLStruct, table: Table | SQLStruct): SQLStruct`

    Sets the table or SQLStruct to retrieve data from in the SQLStruct.

12. `WHERE(sql: SQLStruct, where: Condition): SQLStruct`

    Sets the condition for filtering the data in the SQLStruct.

13. `WHERE(sql: SQLStruct, not: (Condition) -> Condition): (Condition) -> SQLStruct`

    Applies a function that creates a negated condition to the WHERE clause in the SQLStruct.

14. `GROUPBY(sql: SQLStruct, cols: Array<Column>): SQLStruct`

    Sets the columns for grouping the data in the SQLStruct.

15. `HAVING(sql: SQLStruct, condition: Condition): SQLStruct`

    Sets the condition for filtering the grouped data in the SQLStruct.

16. `HAVING(sql: SQLStruct, not: (Condition) -> Condition): (Condition) -> SQLStruct`

    Applies a function that creates a negated condition to the HAVING clause in the SQLStruct.

17. `ORDERBY(sql: SQLStruct, cols: Array<Column>): SQLStruct`

    Sets the columns for ordering the data in the SQLStruct.

18. `LIMIT(sql: SQLStruct, limit: Number): SQLStruct`

    Sets the limit on the number of records to be retrieved in the SQLStruct.

## Table Functions

19. `INNERJOIN(leftTable: Table, rightTable: Table): JoinedTable`

    Creates a joined table using the INNER JOIN operation.

20. `FULLJOIN(leftTable: Table, rightTable: Table): JoinedTable`

    Creates a joined table using the FULL JOIN operation.

21. `LEFTJOIN(leftTable: Table, rightTable: Table): JoinedTable`

    Creates a joined table using the LEFT JOIN operation.

22. `RIGHTJOIN(leftTable: Table, rightTable: Table): JoinedTable`

    Creates a joined table using the RIGHT JOIN operation.

23. `ON(join: JoinedTable, condition: Condition): Table`

    Specifies the join condition for a joined table.

24. `AS(table: String, alias: String): Table`

    Specifies an alias for a table.

## Build Function

25. `build(sql: SQLStruct, flag: Boolean = true, indent: String = ""): SQLQuery`

    Builds the SQL query string from the SQLStruct. The `flag` parameter indicates whether to include the query's parentheses, the `indent` parameter specifies the indentation for subqueries, and the function returns the SQL query string.
