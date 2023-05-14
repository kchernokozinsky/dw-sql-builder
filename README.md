# DW-SQL-Builder

![DW-SQL-Builder](https://tenor.com/ru/view/pepe-the-frog-left-and-right-swaying-dancing-graphics-gif-17809232)

DW-SQL-Builder is a DataWeave library that allows you to build dynamic SQL queries. This simplifies the process of generating SQL queries inside Mule apps, providing more flexibility and customization when querying databases.

## Features

- Dynamic SQL query building using DataWeave.
- Flexible and customizable queries.
- Easy to integrate with Mule applications.
- Simple to use and implement.

## Getting Started

To get started with DW-SQL-Builder, simply clone the repository and follow the instructions in the [documentation](https://github.com/username/dw-sql-builder/docs).

## Usage

DW-SQL-Builder is easy to use and can be integrated with your Mule application in a few simple steps:

DW script: 
```

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

```

Output:

```

SELECT a, b
FROM (a AS alias INNER JOIN b ON column1 = value1) INNER JOIN c ON column1 = value1
WHERE ((NOT column1 IS NOT NULL AND NOT (column2 <> 'c')) OR column2 <> 'c')
GROUP BY a
HAVING column1 = value1
LIMIT 2000

```

For more usage examples, check out the documentation.

## TO DO
1. group By ✅
2. order by ✅
3. limit    ✅
4. fix alias ❌
5. fix NOT function ✅
6. Implement operators: ``BETWEEN LIKE IN EXISTS ANY ALL`` ❌ 

## Contributing
Contributions to DW-SQL-Builder are always welcome! If you have any ideas, suggestions or bug reports, please open an issue or a pull request.

Feel free to customize this template with your project's specific information.
