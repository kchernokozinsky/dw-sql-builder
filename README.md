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
import * from SQLBuilder
import * from Transformer

--- 
SELECT columns  ["a", "b"] 
appendColumn "c"
FROM ("a" INNERJOIN "b" ON condition("column1", "=", "value1") AS "lol") 
WHERE (condition("column1", "=", "value1") AND NOT(condition("column2", "!=", "value1")) OR condition("column2", "=", "value2")) 
build true

```

Output:

```

SELECT a, b, c
FROM a INNER JOIN b ON column1 = 'value1'
WHERE ((column1 = 'value1' AND column2 != 'value1') OR column2 = 'value2')

```

For more usage examples, check out the documentation.

Contributing
Contributions to DW-SQL-Builder are always welcome! If you have any ideas, suggestions or bug reports, please open an issue or a pull request.

Feel free to customize this template with your project's specific information.
