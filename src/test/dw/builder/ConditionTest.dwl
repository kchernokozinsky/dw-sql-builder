%dw 2.0
import * from dw::test::Tests
import * from dw::test::Asserts

import * from builder::Condition
---
"Condition" describedBy [
    "conditionToSQLQuery" describedBy [
        "It should condition transformation with unary operators" in do {
            var operators = ["IS NOT NULL", "IS NULL"]
            var tests = operators reduce ((operator, acc = {conditionResult: [], expectedOutput: []}) -> acc  update {
                case .conditionResult -> $ ++ [conditionToSQLQuery(condition("column", operator))]
                case .expectedOutput -> $ ++ ["column $(operator)"]
            })
            ---
                tests.conditionResult must equalTo(tests.expectedOutput)
                },
        "It should condition transformation with binary operators" in do {
            var operators = ["=", "!=", "<>", ">", "<", ">=", "<="]
            var tests = operators reduce ((operator, acc = {conditionResult: [], expectedOutput: []}) -> acc  update {
                case .conditionResult -> $ ++ [conditionToSQLQuery(condition("column", operator, "'value'"))]
                case .expectedOutput -> $ ++ ["column $(operator) 'value'"]
            })
            ---
                tests.conditionResult must equalTo(tests.expectedOutput)
                },
    ],
]
