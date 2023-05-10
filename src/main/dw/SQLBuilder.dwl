%dw 2.0
import * from SQLBuilderTypes


var SQL : SQLStruct = {
                 operation: "SELECT",
                 columns: [],
                 from: ""
                 }


fun operation(sql : SQLStruct, op : Operation) : SQLStruct = sql  update {
    case .operation -> op
}

var SELECT = SQL
var UPDATE = SQL operation "UPDATE"
var INSERT = SQL operation "INSERT"
var DELETE = SQL operation "DELETE"

fun columns (sql : SQLStruct, cols : Array<Column>) : SQLStruct = sql  update {
    case .columns -> cols
}

fun appendColumn (sql : SQLStruct, col : Column) : SQLStruct = sql  update {
    case .columns-> if ($ is Array) $ + col else '*'
}

fun FROM (sql : SQLStruct, table : Table) : SQLStruct = sql update {
    case .from -> table
}

fun INNERJOIN(leftTable: Table, rightTable : Table) : JoinedTable = {
    leftTable: leftTable,                    
    rightTable: rightTable,                    
    joinType: "INNER JOIN"                   
}

fun FULLJOIN(leftTable: Table, rightTable : Table) : JoinedTable = {
    leftTable: leftTable,                    
    rightTable: rightTable,                    
    joinType: "FULL JOIN"                   
}

fun LEFTJOIN(leftTable: Table, rightTable : Table) : JoinedTable = {
    leftTable: leftTable,                    
    rightTable: rightTable,                    
    joinType: "LEFT JOIN"                   
}

fun RIGHTJOIN(leftTable: Table, rightTable : Table) : JoinedTable = {
    leftTable: leftTable,                    
    rightTable: rightTable,                    
    joinType: "RIGHT JOIN"                   
}

fun ON (join: JoinedTable, condition : Condition) : Table = {
    leftTable: join.leftTable,                    
    rightTable: join.rightTable,                    
    joinType: join.joinType,
    joinCondition: condition                   
}

fun condition(lvalue : String | Number, op : Operator, rvalue : String | Number) : Condition =  {
  lvalue: lvalue,
  operator: op,
  rvalue: rvalue
}

fun WHERE(sql : SQLStruct, where : Condition) : SQLStruct = sql  update {
    case .where! ->  where

}

fun AND(lCondition : Condition, rCondition : Condition) : Condition = 
{
    lCondition: lCondition,
    biOperation: "AND",
    rCondition: rCondition
}

fun OR(lCondition : Condition, rCondition : Condition) : Condition = 
{
    lCondition: lCondition,
    biOperation: "OR",
    rCondition: rCondition
}

fun AS(table : Table, alias : String) : Table = if (table is String) {name: table, alias: alias}
                                                else table update {
                                                            case .alias! -> alias
                                                            } 

fun NOT(condition: Condition) = condition  update {
    case .biOperation! -> "NOT"
}

