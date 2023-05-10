%dw 2.0

type SQLQuery = String

type Column = String

type Table = String | {name: String, alias?: String} | JoinedTable | SimpleJoinedTable

type Condition = 
SimpleCondition |
NestedInnerCondition

type SimpleCondition = {
  lvalue: String | Number,
  biOperation?: BiOperation,
  operator: Operator,
  rvalue: String | Number
}

type NestedInnerCondition = {
  lCondition: Condition,
  biOperation: BiOperation,
  rCondition: Condition
}

type NestedCondition = {
    conditions: Array< Condition | BiOperation > 
}

type JoinType = 
    "INNER JOIN" |    // Returns records that have matching values in both tables
    "LEFT JOIN" |     // Returns all records from the left table, and the matched records from the right table
    "RIGHT JOIN" |    // Returns all records from the right table, and the matched records from the left table
    "FULL JOIN"       // Returns all records when there is a match in either the left or the right table

type JoinedTable = {
    leftTable: Table,                     // The left table in the join operation
    rightTable: Table,                    // The right table in the join operation
    joinType: JoinType,                   // The type of join operation
    joinCondition?: Condition,
    alias?: String                // The condition under which the tables will be joined
}

type SimpleJoinedTable = {
    leftTable: String,                     // The left table in the join operation
    rightTable: String,                    // The right table in the join operation
    joinType: JoinType,                   // The type of join operation
    joinCondition?: Condition,
    alias?: String              // The condition under which the tables will be joined
}

type Operation = 
    "SELECT" |   // Retrieve data from a database
    "UPDATE" |   // Update data in a database
    "DELETE" |   // Delete data from a database
    "INSERT" |   // Insert data into a database
    "CREATE" |   // Create a new table
    "DROP" |     // Delete a table
    "ALTER" |    // Modify a table
    "TRUNCATE"   // Empty a table

type BiOperation = 
    "OR" |       // Logic OR operation, returns true if any of the conditions are true
    "AND" |      // Logic AND operation, returns true if all the conditions are true
    "NOT"       // Logic NOT operation, returns true if the condition is false

type Operator =
    "=" |        // Equal to
    "!=" |       // Not equal to
    ">" |        // Greater than
    "<" |        // Less than
    ">=" |       // Greater than or equal to
    "<=" |       // Less than or equal to
    "BETWEEN" |  // Between an inclusive range
    "LIKE" |     // Search for a pattern
    "IN"         // If value is within a set of values

type SQLStruct = {
                 operation: Operation,
                 columns: Array<Column> | "*",
                 from: Table,
                 where?: Condition
                 }