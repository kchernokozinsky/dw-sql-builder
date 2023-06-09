%dw 2.0
import * from dw::Runtime
// --- CONDITION TYPES ---
type Condition = 
    String |
    Number |
    SimpleCondition |
    NestedInnerCondition | 
    Between|
    Not

type SimpleCondition = {
    lvalue: String | Number,
    operator: Operator | UnaryOperator,
    rvalue?: String | Number
}

type NestedInnerCondition = {
    lCondition: Condition,
    biOperation: BiOperation,
    rCondition: Condition
}

type NestedCondition = {
    conditions: Array<Condition | BiOperation>
}

type Not = { not: Condition}

type Between = {"between": {
    "column": String,
    "fstValue": Value,
    "sndValue": Value
}}

type Value = String | Number

type Operator =
    "=" |        // Equal to
    "!=" |       // Not equal to
    "<>" |       // Not equal to (alternative syntax)
    ">" |        // Greater than
    "<" |        // Less than
    ">=" |       // Greater than or equal to
    "<=" |       // Less than or equal to
    "BETWEEN" |  // Between an inclusive range
    "LIKE" |     // Search for a pattern
    "IN" |       // If value is within a set of values
    "EXISTS" |   // Checks if a subquery returns any result
    "ANY" |      // Checks if any value from a subquery meets a condition
    "ALL"        // Checks if all values from a subquery meet a condition

type UnaryOperator =
    "IS NULL" |   // Checks for a NULL value
    "IS NOT NULL" // Checks for a non-NULL value


type BiOperation = 
    "OR" |       // Logic OR operation, returns true if any of the conditions are true
    "AND"     // Logic AND operation, returns true if all the conditions are true
// --- CONDITION TYPES ---

fun condition(lvalue : String | Number, op : UnaryOperator) : Condition = {
    lvalue: lvalue,
    operator: op
}
fun condition(lvalue : String | Number, op : Operator, rvalue : String | Number) : Condition = {
    lvalue: lvalue,
    operator: op,
    rvalue: rvalue 
}

fun AND(lCondition : Condition, rCondition : Condition) : Condition = {
    lCondition: lCondition,
    biOperation: "AND",
    rCondition: rCondition
}

fun OR(lCondition : Condition, rCondition : Condition) : Condition = {
    lCondition: lCondition,
    biOperation: "OR",
    rCondition: rCondition
}

fun BETWEEN(col: String, fst: Value): (Value) -> Between = (snd) -> {
    between: {
            "column": col,
            "fstValue": fst,
            "sndValue": snd
    }
}

fun AND (func: (Value) -> Between, snd: Value): Between = func(snd)

fun NOT(condition: Condition) = not: condition


fun conditionToSQLQuery(condition: Condition): String = do {

    fun conditionToSQL(condition: NestedInnerCondition) = 
        "($(conditionToSQL(castConditionToNarrow(condition.lCondition))) $(condition.biOperation) $(conditionToSQL(castConditionToNarrow(condition.rCondition))))"

    fun conditionToSQL(condition: Not) = 
        "NOT (" ++ 
        conditionToSQL(castConditionToNarrow(condition.not)) ++ 
        ")"

    fun conditionToSQL(condition: Between) = 
        condition.between.column ++ 
        " BETWEEN " ++ 
        condition.between.fstValue as String ++ 
        " AND " ++ 
        condition.between.sndValue

    fun conditionToSQL(condition: SimpleCondition) =
        "$(condition.lvalue) $(condition.operator)" ++
        (if (condition.rvalue?)
            " $(condition.rvalue as String)"
         else
            "")
   fun conditionToSQL(condition: String | Number) = 
        condition as String
    ---
    conditionToSQL(castConditionToNarrow(condition))
}

fun castConditionToNarrow(val : Condition | String | Number) =
    val as NestedInnerCondition default
    val as SimpleCondition default
    val as Not default
    val as Between default
    val as String