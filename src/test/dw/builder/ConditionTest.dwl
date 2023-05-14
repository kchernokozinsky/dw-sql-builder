%dw 2.0
import * from dw::test::Tests
import * from dw::test::Asserts

import * from builder::Condition
---
"Condition" describedBy [
    "conditionToSQLQuery" describedBy [
        "It should test condition transformation with unary operators" in do {
            var operators = ["IS NOT NULL", "IS NULL"]
            var tests = operators reduce ((operator, acc = {conditionResult: [], expectedOutput: []}) -> acc  update {
                case .conditionResult -> $ ++ [conditionToSQLQuery(condition("column", operator))]
                case .expectedOutput -> $ ++ ["column $(operator)"]
            })
            ---
                tests.conditionResult must equalTo(tests.expectedOutput)
                },
        "It should test condition transformation with binary operators" in do {
            var operators = ["=", "!=", "<>", ">", "<", ">=", "<="]
            var tests = operators reduce ((operator, acc = {conditionResult: [], expectedOutput: []}) -> acc  update {
                case .conditionResult -> $ ++ [conditionToSQLQuery(condition("column", operator, "'value'"))]
                case .expectedOutput -> $ ++ ["column $(operator) 'value'"]
            })
            ---
                tests.conditionResult must equalTo(tests.expectedOutput)
                },
    ],
    "AND" describedBy [
        "It should test 'AND' with two strings" in do {
            AND("column1 = 'val1", "column2 <> 'c'") must equalTo(readUrl("classpath://condition/and/with_two_strings.json", "application/json"))
        },
        "It should test 'AND' with string and simple condition" in do {
            AND(condition("column1", "=", "value1"), "column2 <> 'c'") must equalTo(readUrl("classpath://condition/and/with_string_and_simple_condition.json", "application/json"))
        },
        "It should test 'AND' with two simple conditions" in do {
            AND(condition("column1", "=", "value1"), condition("column2", ">=", "value2")) must equalTo(readUrl("classpath://condition/and/with_two_simple_conditions.json", "application/json"))
        },
        "It should test 'AND' with inner AND condition" in do {
            AND(AND(condition("column1", "=", "value1"), condition("column2", ">=", "value2")), "column2 <> 'c'") must equalTo(readUrl("classpath://condition/and/with_inner_and_condition.json", "application/json"))
        }   
    ]
]
