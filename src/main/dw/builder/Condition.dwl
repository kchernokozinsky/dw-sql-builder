%dw 2.0

// --- CONDITION TYPES ---
type Condition = 
    String |
    SimpleCondition |
    NestedInnerCondition

type SimpleCondition = {
    lvalue: String | Number,
    biOperation?: BiOperation,
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
    "AND" |      // Logic AND operation, returns true if all the conditions are true
    "NOT"        // Logic NOT operation, returns true if the condition is false
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

fun NOT(condition: Condition) = 
    if (condition is String) 
        "NOT ($(condition))"  
    else 
        condition  update {
            case .biOperation! -> "NOT"
        }



fun conditionToSQLQuery(condition) = do {
    fun castCondition(val : Condition | String | Number) = 
        val as NestedInnerCondition default 
        val as SimpleCondition default 
        val as String
    fun conditionToSQL(condition: NestedInnerCondition) = 
        "($(conditionToSQL(castCondition(condition.lCondition))) $(condition.biOperation) $(conditionToSQL(castCondition(condition.rCondition))))"
   fun conditionToSQL(condition: SimpleCondition) =
        (if (keysOf(condition) contains "biOperation" as Key)
            "NOT "
        else
            "") ++
        "$(condition.lvalue) $(condition.operator)" ++
        (if (condition.rvalue?)
            " $(condition.rvalue as String)"
        else
            "")
   fun conditionToSQL(condition: String | Number) = 
        condition as String
    ---
    conditionToSQL(castCondition(condition default ""))
}
