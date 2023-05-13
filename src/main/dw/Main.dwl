%dw 2.0
output text/plain
import * from builder::SQLBuilder

--- 
SELECT columns ["a", "b"]
FROM ("a" AS "alias" INNERJOIN "b" ON condition("column1", "=", "value1")  INNERJOIN "c" ON condition("column1", "=", "value1")) 
WHERE ( NOT (condition("column1", "IS NOT NULL")) AND NOT("column2 <> 'c'") OR "column2 <> 'c'") 
GROUPBY ["a"]
HAVING condition("column1", "=", "value1")
LIMIT 2000
build true

