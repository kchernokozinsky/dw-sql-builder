%dw 2.0
import * from builder::Condition
import * from builder::Table

type SQLQuery = String

type Column = String

type Operation = 
    "SELECT" |   // Retrieve data from a database
    "UPDATE" |   // Update data in a database
    "DELETE" |   // Delete data from a database
    "INSERT"     // Insert data into a database

type SQLStruct = {
    operation: Operation,
    columns: Array<Column> | "*",
    from: Table | SQLStruct,
    where?: Condition,
    groupBy?: Array<Column>,
    having?: Condition,
    orderBy?: Array<Column>,
    limit?: Number
}
                
var SQL : SQLStruct = {
                 operation: "SELECT",
                 columns: [],
                 from: ""
                 }


fun operation(sql : SQLStruct, op : Operation) : SQLStruct = sql  update {
    case .operation -> op
}

fun columns (sql : SQLStruct, cols : Array<Column> | "*") : SQLStruct = sql  update {
    case .columns -> cols
}

fun appendColumn (sql : SQLStruct, col : Column) : SQLStruct = sql  update {
    case .columns-> if ($ is Array) $ + col else '*'
}

fun FROM (sql : SQLStruct, table : Table | SQLStruct) : SQLStruct = sql update {
    case .from -> table
}

fun WHERE(sql : SQLStruct, where : Condition) : SQLStruct = sql  update {
    case .where! ->  where
}

fun GROUPBY(sql : SQLStruct, cols : Array<Column>) : SQLStruct = sql  update {
    case .groupBy! -> cols
}

fun HAVING(sql : SQLStruct, condition : Condition) : SQLStruct = sql  update {
    case .having! ->  condition
}

fun ORDERBY(sql : SQLStruct, cols : Array<Column>) : SQLStruct = sql  update {
    case .orderBy! -> cols
}

fun LIMIT(sql : SQLStruct, limit : Number) : SQLStruct = sql  update {
    case .limit! -> limit
}


fun queryBeginning(sql: SQLStruct): String = "$(sql.operation) $( if(sql.columns == "*") "*" else sql.columns reduce((item, acc = "") -> acc ++ (if (acc != "") ", " else "") ++ item))"