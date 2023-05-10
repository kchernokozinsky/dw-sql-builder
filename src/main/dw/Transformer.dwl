%dw 2.0
import * from SQLBuilderTypes

fun castCondition(val : Condition | String | Number) = val as NestedInnerCondition default val as SimpleCondition  default val as String

fun conditionToSQLRunner(condition) = conditionToSQL(castCondition(condition default ""))
fun conditionToSQL(condition: NestedInnerCondition) = "($(conditionToSQL(castCondition(condition.lCondition))) $(condition.biOperation) $(conditionToSQL(castCondition(condition.rCondition))))"
fun conditionToSQL(condition: SimpleCondition) = "$(condition.lvalue) $(condition.operator) '$(condition.rvalue)'"
fun conditionToSQL(condition: String | Number) = condition as String

fun whereToSQL(condition: Condition | Null) : String = "WHERE $(conditionToSQLRunner(condition))"
                                                
fun fromToSQL(table: Table): String = do {
    fun castCondition(val) = val as JoinedTable default val as SimpleJoinedTable  default val as String
    fun toStr(val: String) = val as String
    fun toStr(val: SimpleJoinedTable) =  "$(toStr(val.leftTable)) $(val.joinType) $(toStr(val.rightTable))" ++ 
                                  (" ON $(conditionToSQLRunner(val.joinCondition))" default "")
    fun toStr(val: JoinedTable) =  "$(toStr(castCondition(val.leftTable))) $(val.joinType) $(toStr(castCondition(val.rightTable)))" //TO DO ALIAS
    ---
    "FROM $(toStr(castCondition(table)))"
}

fun OpAndColsToSql(sql: SQLStruct): String = "$(sql.operation) $(sql.columns reduce((item, acc = "") -> acc ++ (if (acc != "") ", " else "") ++ item))"

fun build(sql: SQLStruct, flag: Boolean) : SQLQuery = "$(OpAndColsToSql(sql))\n$(fromToSQL(sql.from))\n$(whereToSQL(sql.where))"