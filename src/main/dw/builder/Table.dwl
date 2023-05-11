%dw 2.0
import * from builder::Condition

// ---------------- TABLE TYPES 

type Table = String | TableAlias | JoinedTable | SimpleJoinedTable

type JoinType = 
    "INNER JOIN" |    // Returns records that have matching values in both tables
    "LEFT JOIN" |     // Returns all records from the left table, and the matched records from the right table
    "RIGHT JOIN" |    // Returns all records from the right table, and the matched records from the left table
    "FULL JOIN"       // Returns all records when there is a match in either the left or the right table

type JoinedTable = {
    leftTable: Table,                     // The left table in the join operation
    rightTable: Table,                    // The right table in the join operation
    joinType: JoinType,                   // The type of join operation
    joinCondition?: Condition,             // The condition under which the tables will be joined
}

type SimpleJoinedTable = {
    leftTable: String | TableAlias,                     // The left table in the join operation
    rightTable: String | TableAlias,                    // The right table in the join operation
    joinType: JoinType,                   // The type of join operation
    joinCondition?: Condition,             // The condition under which the tables will be joined
}

type TableAlias = {
    name: String, 
    alias?: String
}

// ---------------- TABLE TYPES 

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

fun AS(table : String, alias : String) : Table = if (table is String) {name: table, alias: alias}
                                                else table update {
                                                            case .alias! -> alias
                                                            } 

fun tableToSQLQuery(table: Table): String = do {
    fun alias(table : Object) = if (keysOf(table) contains "alias" as Key) "AS $(table.alias)" else ""
    fun castCondition(val) = val as JoinedTable default val as SimpleJoinedTable  default val as String
    fun toStr(val: String) = val as String

    fun toStr(val: TableAlias) =  val.name ++ " " ++ alias(val)
    fun toStr(val: SimpleJoinedTable) =  "$(toStr(val.leftTable)) $(val.joinType) $(toStr(val.rightTable))" ++ 
                                        (" ON $(conditionToSQLQuery(val.joinCondition))" default "")
    fun toStr(val: JoinedTable) =  "$(toStr(castCondition(val.leftTable))) $(val.joinType) $(toStr(castCondition(val.rightTable))) $(alias(val))"
    ---
    "FROM $(toStr(castCondition(table)))"
}