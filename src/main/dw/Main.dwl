%dw 2.0
output text/plain
import * from SQLBuilder
import * from SQLBuilderTypes
import * from Transformer

--- 
SELECT columns  ["a", "b"] 
appendColumn "kek"
FROM ("a" INNERJOIN "b" ON condition("as", "=", "dsf") AS "lol") 
WHERE (condition("as", "=", "dsf") AND NOT(condition("as", "IN", "dsf")) OR condition("as", "=", "dsf")) 
build true
