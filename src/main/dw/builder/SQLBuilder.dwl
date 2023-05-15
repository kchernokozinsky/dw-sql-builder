%dw 2.0
import * from builder::Table
import * from builder::Condition
import * from builder::SQL

var SELECT = SQL
var UPDATE = SQL operation "UPDATE"
var INSERT = SQL operation "INSERT"
var DELETE = SQL operation "DELETE"

fun condition(lvalue : String | Number, op : UnaryOperator) : Condition = 
    builder::Condition::condition(lvalue, op)

fun condition(lvalue : String | Number, op : Operator, rvalue : String | Number) : Condition = 
    builder::Condition::condition(lvalue, op, rvalue)

fun condition(func: (Condition) -> SQLStruct, condition: String) : SQLStruct = func(condition as String)

fun AND(lCondition : Condition, rCondition : Condition) : Condition =  
    builder::Condition::AND(lCondition, rCondition)

fun OR(lCondition : Condition, rCondition : Condition) : Condition = 
    builder::Condition::OR(lCondition, rCondition)

fun BETWEEN(col: String, fst: Value): (Value) -> Between =  
    builder::Condition::BETWEEN(col, fst)

fun AND (func: (String) -> Between, snd: Value): Between = 
    builder::Condition::AND(func, snd)

fun NOT(condition: Condition) = builder::Condition::NOT(condition)

fun columns (sql : SQLStruct, cols : Array<Column> | "*") : SQLStruct = 
    builder::SQL::columns(sql, cols)

fun appendColumn (sql : SQLStruct, col : Column) : SQLStruct = 
    builder::SQL::appendColumn(sql, col)

fun FROM (sql : SQLStruct, table : Table | SQLStruct) : SQLStruct = 
    builder::SQL::FROM(sql, table)

fun FROM (sql : SQLStruct, table : Table | SQLStruct) : SQLStruct = 
    builder::SQL::FROM(sql, table)

fun WHERE(sql : SQLStruct, where : Condition) : SQLStruct = 
    builder::SQL::WHERE(sql, where)

fun WHERE(sql : SQLStruct, not : (Condition) -> Condition) : (Condition) -> SQLStruct = (condition) -> sql  update {
    case .where! ->  not(condition)
}

fun GROUPBY(sql : SQLStruct, cols : Array<Column>) : SQLStruct =  builder::SQL::GROUPBY(sql, cols)

fun HAVING(sql : SQLStruct, condition : Condition) : SQLStruct = builder::SQL::HAVING(sql, condition)

fun HAVING(sql : SQLStruct, not : (Condition) -> Condition) : (Condition) -> SQLStruct = (condition) -> sql  update {
    case .having! ->  not(condition)
}
fun ORDERBY(sql : SQLStruct, cols : Array<Column>) : SQLStruct = builder::SQL::ORDERBY(sql, cols)

fun LIMIT(sql : SQLStruct, limit : Number) : SQLStruct = sql  update {
    case .limit! -> limit
}
fun INNERJOIN(leftTable: Table, rightTable : Table) : JoinedTable = 
    builder::Table::INNERJOIN(leftTable, rightTable)

fun FULLJOIN(leftTable: Table, rightTable : Table) : JoinedTable = 
    builder::Table::FULLJOIN(leftTable, rightTable)

fun LEFTJOIN(leftTable: Table, rightTable : Table) : JoinedTable = 
    builder::Table::LEFTJOIN(leftTable, rightTable)

fun RIGHTJOIN(leftTable: Table, rightTable : Table) : JoinedTable = 
    builder::Table::RIGHTJOIN(leftTable, rightTable)

fun ON (join: JoinedTable, condition : Condition) : Table = 
    builder::Table::ON(join, condition)

fun AS(table : String, alias : String) : Table = 
    builder::Table::AS(table, alias)

fun build(sql: SQLStruct, flag: Boolean = true, indent: String = "") : SQLQuery = do {
    var newLine = "\n"
    fun go(sql: SQLStruct, flag: Boolean, indent: String) = 
    log("Indent",indent) ++
    "(" ++ 
    queryBeginning(sql) ++ 
    newLine ++
    indent ++ (if (sql.from is Table) tableToSQLQuery(sql.from) 
               else "FROM\n" ++ go(sql.from, true, indent ++"\t")) ++
    newLine ++
    indent ++ 
    "WHERE " ++ 
    conditionToSQLQuery(sql.where) ++
    (if (sql.groupBy?) newLine ++ 
                       indent ++ 
                       "GROUP BY " ++ 
                       (sql.groupBy reduce((item, acc = "") -> acc ++ (if (acc != "") ", " else "") ++ item)) 
     else "") ++
    (if (sql.having?) newLine ++ 
                      indent ++ 
                      "HAVING " ++ 
                      conditionToSQLQuery(sql.having) else "") ++
    (if (sql.orderBy?) newLine ++ 
                       "ORDER BY " ++ 
                       (sql.orderBy reduce((item, acc = "") -> acc ++ (if (acc != "") ", " else "") ++ item)) 
     else "") ++
    (if (sql.limit?) newLine ++ 
                     indent ++ 
                     "LIMIT " ++ 
                     sql.limit as String 
     else "") ++
    ")"
    ---
    go(sql, flag, indent)[1 to -2]
}

