%dw 2.0
output application/json
import * from builder::SQLBuilder

--- 
SELECT columns ["a", "dsf"]
FROM ("a" AS "dsds" INNERJOIN "b" ON condition("column1", "=", "value1")  INNERJOIN "c" ON condition("column1", "=", "value1")) 
WHERE ( NOT (condition("column1", "=", "value1")) AND NOT("column2 <> 'c'") OR "column2 <> 'c'") 
build false

