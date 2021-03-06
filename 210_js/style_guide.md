# Javascript Style Guide 
## for Launch School and Beyond

See also: [Airbnb Javascript Style Guide](https://github.com/airbnb/javascript)

### Variables

* Always declare variables at the top of their scope

* For names of variables, functions, and object properties, use **camelCase**, always starting with a lowercase letter.  

```javascript
var firstName = 'Brent';
var lastName = 'Hinds';

var addValues = function (a, b) {
  return a + b;
};

var myObject = {
  myNumber: 26,
  myMethod: function () {}
};


```

Constants should contain all uppercase letters, with multiple words separated by underscores: `MY_CONSTANT`. The functionality is the same as for other variables, because Javascript has only one type of variable.

Constant and variable names can also be acronyms.

### Spacing

* Use soft tabs set to 2 spaces
* Never use tab characters
* Place one space before the leading brace.
```javascript
function test() {
  console.log('test');
}
```

* Place one space before the opening parenthesis in control statements (`if`, `while`, etc.).
* Place no space between the argument list and the function name in function calls and declarations.
* Place one space between the closing parenthesis and the opening brace. 
```javascript
if (isJedi) {
  fight();
}
```

* Set off operators with spaces.
* Do not add spaces inside parentheses.
```javascript
var a = 2 * (2 + 3);
```

* Do not add space between unary special-character operators (`!`, `++`) and their operand.
```javascript
i++;
```

* Do not add space before comma or semi-colon.

* No whitespace at the end of lines.

* Add space to both sides of `?` and `:` in a ternary conditional.
* Ternaries should not be nested or on multiple lines.
```javascript
var maybe1 > maybe2 ? 'bar' : null;
```

* Avoid unneeded ternary statements:
```javascript
// bad
var foo = a ? a : b;
var bar = c ? true : false;
var baz = c ? false : true;

// good
var foo = a || b;
var bar = !!c;
var baz = !c;
```

### Blocks

* Leave a blank line after blocks and before the next statement.
* Do not pad blocks with blank lines.
```javascript
if (foo) {
  return bar;
}

return baz;
```

* Use braces with all multi-line blocks.
* For blocks of multiple lines, place the first curly brace on the same line as the initial statement and the ending line on its own line. 
* Put `else` on the same line as the `if` block's closing brace.
```javascript
if (test) {
  return false;
} else {
  return true;
}
```

* For single-line statements, the block can be contained to one line, but check that the line is not too long.

* Use only one var declaration per variable.

```javascript
// Bad
var firstName = 'Brann',
    lastName = 'Dailor',
    roles = ['drums', 'vocals'];

// Good
var firstName = 'Brann';
var lastName = 'Dailor';
var roles = ['drums', 'vocals'];
```

### Semicolons

* Semicolons always terminate a statement, except for statements ending with a block (**semicolons should be used after statements ending with a function expression, however**). 
* (Without the semicolon, Javascript may not properly interpret the end of the statement.)

```javascript
// bad
var number
number = 5
number = number + 1

// good
var number;
number = 5;
number = number + 1;

// bad
while (number > 0) {
  number -= 1;
};

// good
while (number > 0) {
  number -= 1;
}

// BUT

// bad
function foo {
  return 'function declaration';
};

var bar = function () {
  return 'function expression';
}

// good
function foo {
  return 'function declaration';
}

var bar = function () {
  return 'function expression';
};
```

### Strings

* Use single quotes for strings.
* Use explicit type coercion.
```javascript
var a = 9;
var string = String(a);
```

### Numbers

* Use `Number` for typecasting and `parseInt` always with a radix for parsing strings.

```javascript
var inputValue = '4';

var val = Number(inputValue);
// OR
var val = parseInt(inputValue, 10);
```

### Booleans

* Use `Boolean` or not not (`!!`) operator for typecasting to boolean.
```javascript
var age = 0;

var hasAge = Boolean(age);
// OR
var hasAge = !!age; // better
```

* Always use strict equality operators (`===` and `!==`)

### Functions

* Always declare functions before calling them

* Never declare a function in a non-function block (`if`, `while`, etc).

```javascript
// bad
if (currentUser) {
  function test() {
    console.log('Nope.');
  }
}

// good
var test;
if (currentUser) {
  test = function () {
    console.log('Yup.');
  };
}
```

* Never name a parameter `arguments`. This takes precedence over the `arguments` object that is given to every function scope.

```javascript
// bad
function nope(name, options, arguments) {
  // ...stuff...
}

// good
function yup(name, options, args) {
  // ...stuff...
}
```

### Objects

* Custom objects using object literal notation should have a trailing comma when written across multiple lines (i.e., the last line of properties should end with a comma).
* This allows easy reorganization of the entries.
* `git diff` will show 2 lines of change for one added property without the trailing comma. A new comma has to be added to the previous line (counts as 1 line change) before the next line is added (the second line change). Using a trailing comma everywhere shows only one new line in the `git diff` output.
* For one-line literals, the trailing commma is not necessary: `var coordinates = { x: 25, y: 50};`

```javascript
var myObj = {
  prop1: 'sample data',
  method1: function () {},
  prop2: 'sample data',
};

var myObj = {
  prop1: 'sample data',
  prop2: 'sample data',
  method1: function () {},
};
```

### Operators

* Use `num += 1` and `num -= 1` instead of `++` and `--`