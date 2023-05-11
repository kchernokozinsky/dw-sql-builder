%dw 2.0
output text/plain
import * from builder::SQLBuilder
--- 
SELECT columns ["a", "dsf"]
FROM ("a" AS "dsds" INNERJOIN "b" ON condition("column1", "=", "value1")  INNERJOIN "c" ON condition("column1", "=", "value1")) 
WHERE (condition("column1", "=", "value1") AND NOT(condition("column2", "!=", "value1")) OR condition("column2", "=", "value2")) 
build true