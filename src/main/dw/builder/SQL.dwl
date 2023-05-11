%dw 2.0
import * from builder::Condition
import * from builder::Table

type SQLQuery = String

type Column = String

type Operation = 
    "SELECT" |   // Retrieve data from a database
    "UPDATE" |   // Update data in a database
    "DELETE" |   // Delete data from a database
    "INSERT" |   // Insert data into a database
    "CREATE" |   // Create a new table
    "DROP" |     // Delete a table
    "ALTER" |    // Modify a table
    "TRUNCATE"   // Empty a table

type SQLStruct = {
                 operation: Operation,
                 columns: Array<Column> | "*",
                 from: Table,
                 where?: Condition
                 }
                
var SQL : SQLStruct = {
                 operation: "SELECT",
                 columns: [],
                 from: ""
                 }


fun operation(sql : SQLStruct, op : Operation) : SQLStruct = sql  update {
    case .operation -> op
}

fun columns (sql : SQLStruct, cols : Array<Column>) : SQLStruct = sql  update {
    case .columns -> cols
}

fun appendColumn (sql : SQLStruct, col : Column) : SQLStruct = sql  update {
    case .columns-> if ($ is Array) $ + col else '*'
}

fun FROM (sql : SQLStruct, table : Table) : SQLStruct = sql update {
    case .from -> table
}

fun WHERE(sql : SQLStruct, where : Condition) : SQLStruct = sql  update {
    case .where! ->  where
}

fun queryBeginning(sql: SQLStruct): String = "$(sql.operation) $(sql.columns reduce((item, acc = "") -> acc ++ (if (acc != "") ", " else "") ++ item))"