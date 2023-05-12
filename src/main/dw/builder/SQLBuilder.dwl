%dw 2.0
// import * from 
import * from builder::Table
import * from builder::Condition
import * from builder::SQL

var SELECT = SQL

var UPDATE = SQL operation "UPDATE"

var INSERT = SQL operation "INSERT"

var DELETE = SQL operation "DELETE"
fun condition(lvalue : String | Number, op : Operator, rvalue : String | Number) : Condition = builder::Condition::condition(lvalue, op, rvalue)

fun AND(lCondition : Condition, rCondition : Condition) : Condition =  builder::Condition::AND(lCondition, rCondition)

fun OR(lCondition : Condition, rCondition : Condition) : Condition = builder::Condition::OR(lCondition, rCondition)

fun NOT(condition: Condition) = builder::Condition::NOT(condition)

fun columns (sql : SQLStruct, cols : Array<Column>) : SQLStruct = builder::SQL::columns(sql, cols)

fun appendColumn (sql : SQLStruct, col : Column) : SQLStruct = builder::SQL::appendColumn(sql, col)

fun FROM (sql : SQLStruct, table : Table) : SQLStruct = builder::SQL::FROM(sql, table)

fun WHERE(sql : SQLStruct, where : Condition) : SQLStruct = builder::SQL::WHERE(sql, where)

fun INNERJOIN(leftTable: Table, rightTable : Table) : JoinedTable = builder::Table::INNERJOIN(leftTable, rightTable)

fun FULLJOIN(leftTable: Table, rightTable : Table) : JoinedTable = builder::Table::FULLJOIN(leftTable, rightTable)

fun LEFTJOIN(leftTable: Table, rightTable : Table) : JoinedTable = builder::Table::LEFTJOIN(leftTable, rightTable)

fun RIGHTJOIN(leftTable: Table, rightTable : Table) : JoinedTable = builder::Table::RIGHTJOIN(leftTable, rightTable)

fun ON (join: JoinedTable, condition : Condition) : Table = builder::Table::ON(join, condition)

fun AS(table : String, alias : String) : Table = builder::Table::AS(table, alias)

fun build(sql: SQLStruct, flag: Boolean = true) : SQLQuery | SQLStruct = if (flag) "$(queryBeginning(sql))\n$(tableToSQLQuery(sql.from))\nWHERE $(conditionToSQLQuery(sql.where))"
                                                             else sql