# 210: Computational Thinking and Javascript Programming

## Functions and Variable Scope

* [Defining Functions](#defining-functions)
* [Invoking Functions](#invoking-functions)
* [Parameters and Arguments](#parameters-arguments)
* [Pass by Value or Pass by Reference](#pass-by-value)
* [Nested Functions](#nested-functions)
* [Functional Scopes and Lexical Scoping](#functional-lexical-scoping)
* [Function Declarations and Function Expressions](#function-declarations-expressions)
* [Hoisting](#hoisting)
* [Best Practices](#best-practices)


<a name="defining-functions"></a>
### Defining Functions

In Javascript, we refer to procedures as *functions*. A procedure/function extracts common code to one place to be reused elsewhere. Functions must be declared before they can be used. The declaration involves:
* The `function` keyword
* The name of the function
* Parameters separated by commas
* A block of statements (the *function body*)

```javascript
function triple(number) {
  console.log('tripling in process...');
  return number + number + number;
}

// call function with a value argument
console.log(triple(5));                // logs 15

// call function with a variable argument
var someNumber = 5;
console.log(triple(someNumber));       // logs 15

// call function and store result in a variable
var result = triple(5);
console.log(result);                   // logs 15
```

**The implicit return value of a function is `undefined` (i.e., if it does not have an explicit return statement or value).** Don't forget the `return` in the explicit return statement (it cannot be left out as in Ruby).

>If a function does not contain an explicit return statement, or the return statement does not include a value, the function implicitly returns the value undefined. This is a reason why functions are said to "have returned" rather than "finished execution". When we talk about closures in a later course this distinction will become more apparent. For now, just be mindful of the disambiguation between the return value (explicit or implicit) of a function and the statement that a "function that has returned or returns". (Launch School)

<a name="invoking-functions"></a>
### Invoking Functions

To invoke a function, append `()` to the function name.
```javascript
function startle() {
  console.log('Yikes!');
}

startle(); // Yikes!
```

Function names are simply local variables with a function as a value. We can assign a function to a new variable name and call the function with it.

```javascript
var surprise = startle;
surprise();

// logs:
Yikes!
```

<a name="parameters-arguments"></a>
### Parameters and Arguments

The parameters are the local variables in the function *definition*. The arguments are the values passed to the function at *invocation* and also the local variables in the function body. 

```javascript
// When we define the function, a and b are called parameters.
function multiply(a, b) {
  // When this code runs, they are called arguments.
  return a * b;
}

multiply(5, 6);  // 5 and 6 are also arguments
```

What happens if we don't provide the same number of arguments as parameters in the function's declaration? 

```javascript
function takeTwo(a, b) {
  console.log(a);
  console.log(b);
  console.log(a + b);
}

takeTwo(1, 2);

// logs:
1
2
3

takeTwo(1);

// logs:
1
undefined
NaN // 1 + undefined = NaN

takeTwo(1, 2, 4);

// logs:
1
2
3
```

* An error is not raised
* An argument not provided in the function call is assigned the value `undefined`
* Extra arguments are ignored.

<a name="pass-by-value"></a>
### Pass by Value or Pass by Reference

Javascript is **pass by value**. Passing a variable to a function binds the local function variable to the passed variable's value (a copy of that value). Both variables now reference the same value but have no effect on each other. So primitives are passed by value and are immutable.

```javascript
var a = 7;

function myValue(b) {
  b += 10;
}

myValue(a);
console.log(a); // 7
```

**However**, when passing an object (e.g., an array), **the value is the *reference* to the object** and objects are mutable.

```javascript
var a = [1, 2, 3];

function myValue(b) {
  b[2] += 7;
}

myValue(a);     // side effect: the function changes the array a
console.log(a); // [1, 2, 10] (the array in the global scope is mutated)
```

In the above, the local variable `b` is assigned to the same value that `a` references (the array in global scope).
When `b[2] += 7` is executed, it is executed on the array object itself.

<a name="nested-functions"></a>
### Nested Functions

Functions can be nested inside other functions. There is no limit to how deeply functions can be nested.

```javascript
function circumference(radius) {
  function double(number) {      // nested function declaration
    return 2 * number;
  }

  return 3.14 * double(radius);  // call the nested function
}
```

<a name="functional-lexical-scoping"></a>
### Functional Scopes and Lexical Scoping

A variable's scope is the part of the program that can access that variable by name and tells how and where the language finds and retrieves values from declared variables. In Javascript, **every function creates a new variable scope**.

Remember these important variable scoping rules:

* Every function declaration creates a new variable scope.
* All variables in the same or surrounding scopes are available to your code.

#### The Global Scope

```javascript
var name = 'Julian';
console.log(name);

for (var i = 0; i < 3; i += 1) {
  console.log(name);
}

console.log(name);
```

The variable `name` is available everywhere in this program because it exists in the same scope as the rest of the program.

#### Function Scope

Function scopes nest inside each other. The code inside the function's scope can access variables in the same scope or **any surrounding scope**.

```javascript
var name = 'Julian';

function greet() {
  function say() {
    console.log(name);
  }

  say();
}

greet(); // logs: Julian
```

Here, the variable `name` is initialized in the global scope and is available to each function's local scope.

#### Closures

A function creates a **closure**, which means it retains access to (*encloses*) the variable scope that exists when the closure is created. The function can then access those references wherever the function is invoked.

Closures are most relevant when a function returns a function. This is because a function creates a new local scope, which is garbage collected after it returns. If a function exists inside that outer function, any variables it may have access to would also be garbage collected. A closure saves those variables for the inner function to use.

The **value** of a variable can change after a closure is created that includes the variable. The closure then sees the new value, and the old value is no longer available.

```javascript
var count = 1;

function logCount() {  // creates a closure
  console.log(count);
}

logCount();            // logs: 1

count += 1;            // reassign count
logCount();            // closure sees new value for count; logs: 2
```

Below, `createFunctions(5)` returns an array of five functions. Each function has the same variable `i` in its closure from the `createFunctions` scope, and `i` is incremented 5 times during the creation of these functions. Since the individual function at index 3 is called after all 5 functions are created and added to the returned array, the value of `i` in its closure at the time of its calling is 5.

The fix shown below works because each function keeps a variable in its closure that is not altered in the `createFunctions` scope. Each function added to `callbacks` still has the same variable `i` in its closure, but it also has a variable `index` that is in the scope of the `callback` function. The value of this variable is unique for each function, as it is assigned the current value of `i` at the time the function is defined. Though `i` is incremented (reassigned to its current value plus 1) in the outer scope, `index` is not.

i = 1;          // 1 (in outer scope)
var index = i;  // 1 (on creation of new scope during function call)
i += 1;         // 2 (in outer scope)
index;          // 1 (saved in closure, never incremented)

Note also the function information:
`createFunctions(5);`
[ƒ]
  ...
  3: f()
    ...
    [[Scopes]]
      0: Closure (callback)
        index: 3
      1: Closure (createFunction)
        i: 5
      ...

```javascript
function createFunctions(n) {
  var callbacks = [];
  var i;

  for (i = 0; i < n; i += 1) {
    callbacks.push(function() { // new function saved to 'callbacks' 5 times, value of i incremented 5 times (including before loop breaks)
      return i;                 // i is in createFunctions scope
    });
  }
  
  return callbacks;
}

createFunctions(5)[3](); // 5

// Doesn't fix it:
function createFunctions(n) {
  var callbacks = [];
  var i;

  for (i = 0; i < n; i += 1) {
    var index = i;
    callbacks.push(function () {
      return i;
    });
  }

  return callbacks;
}

createFunctions(5)[3](); // 4 (though 'i' is incremented a final time in the 'for' structure, 'index' is not)

// FIX:

function createFunctions(n) {
  var callbacks = [];
  var callback = function(index) { // new 'callback' local scope created each time
    return function() {            // closure saves value of 'i' to 'index', which is never reassigned
      return index;
    }
  }

  var i;
  
  for (i = 0; i < n; i += 1) {
    callbacks.push(callback(i));  // 
  }
  
  return callbacks;
}

createFunctions(5)[3](); // 3

```

Simpler example, partial application of closure:
```javascript
let c = 4
function addX(x) {     // x is part of the closure of line 3's anonymous function
  return function(n) {
     return n + x      // x is accessible from this function's closure
  }
}
const addThree = addX(3)
let d = addThree(c) // contains x = 3 in its closure
console.log('example partial application', d)
```

Example from [Olivier De Meulder](https://medium.com/dailyjs/i-never-understood-javascript-closures-9663703368e8)
```javascript
function counter() {
  var count = 0;
  var incrementer = function() { // count is in this function's closure
    return count += 1;
  }

  return incrementer;
}

var increment = counter();
var c1 = increment();
var c2 = increment();
var c3 = increment();
console.log(c1, c2, c3); // 1 2 3
```

**In the above example:** 
  * Lines 1 to 8: A new variable `counter` is declared in the global scope and is assigned a function definition.
  * Line 9: A new variable `increment` is declared in the global scope and is assigned the return value of `counter`, so `counter` must be called.
  * Lines 1 to 8: Calling `counter`, a new local scope is created, and the local variable `count` is declared and assigned `0`. 
  * Lines 3 to 6: A new variable `incrementer` is declared and is assigned a function definition. A closure is also created and included as part of the function definition. This function is returned on line 7 and assigned to `increment` on line 9.
  * Returning from `counter` means its local scope and all its local variables are garbage collected, and `incrementer` and `count` no longer exist. However, `count` is saved in the closure (with a value of `0`).
  * The function (and its closure) saved to `increment` is called on lines 10, 11, and 12 (with variables `c1`, `c2`, and `c3` declared and assigned respectively to the return value of each `increment` execution).
  * Each time `increment` is called, a new local scope is created. 
  * Line 4: Javascript looks up the variable `count`. As it was garbage collected earlier, this variable should no longer exist, but it was saved in the function's closure with a value of `0`. It is incremented 3 times, and each time the new value is saved to `count` in the closure.

#### Lexical Scoping

If a function has lexical scope, it has access to variables defined in its calling context. 

Lexical scoping is used to resolve variables, meaning it searches for a variable in the hierarchy of scopes from the local scope up to the program's global scope. It stops and returns the first variable it finds with a matching name. **Variables in a lower scope can *shadow* variables with the same name in a higher scope**.

**Note**: Code blocks do not create a new local scope (*functions* do).

```javascript
function getSelectedColumns(numbers, cols) {
  var result = [];

  for (var i = 0, length = numbers.length; i < length; i += 1) { // recall length variable is hoisted
    for (var j = 0, length = cols.length; j < length; j += 1) { // length gets REASSIGNED here
      if (!result[j]) {
        result[j] = [];
      }

      result[j][i] = numbers[i][cols[j]];
    }
  }

  return result;
}

var array1 = [[1, 2, 3], [4, 5, 6], [7, 8, 9]];

getSelectedColumns(array1, [0]);     // [[1]];            expected: [[1, 4, 7]], actual: [[1]]
```

#### Adding Variables to the Current Scope

There are three ways to create a variable in the current scope: 
* Using the `var` keyword
* Using arguments passed to a function
* The function declaration itself

```javascript
function lunch() {    // A Function declaration creates a new variable scope
  var food = 'taco';  // 1. Add a new variable 'food' within the current variable scope
}

function eat(food) {  // 2. Parameters create variables during Function invocation
  console.log('I am eating ' + food);
}

function drink() {    // 3. Add a new variable 'drink' within the global variable scope
  console.log('I am drinking a glass of water');
}
```


#### Variable Assignment

The variable scoping rules described above also apply to assignment. 
For example, `country = 'Liechtenstein';` checks the current scope and each higher scope, and Javascript sets the first `country` variable it finds to `'Liechtenstein'`.

If Javascript can't find a matching variable, it creates a new global variable instead (due to the lack of `var`). This should be avoided!

```javascript
var country = 'Spain';
function update() {
  country = 'Liechtenstein';
}

console.log(country);  // logs: Spain

update();
console.log(country);  // logs: Liechtenstein (as expected)
```

```javascript
// no other code above
function assign() {
  var country1 = 'Liechtenstein';
  country2 = 'Spain';
}

assign();
console.log(country2);   // logs: Spain, country2 is a global variable and is available here
console.log(country1);   // gets ReferenceError, country1 is not available in the outer scope
// no other code below

```

#### Variable Shadowing

If a variable is declared inside a function with the same name as a variable in the outer scope, the variable in the function shadows the outer one, which is now not accessible.

```javascript
var name = 'Julian';

function greet() {
  var name = 'Logan';
  console.log(name);
}

greet(); // logs: Logan
```

If a function has an argument with the same name as a variable from an outer scope, the argument shadows the outer variable. Below, the variable `name` receives the value passed to the function in the invocation.

```javascript
var name = 'Julian';

function greet(name) {
  console.log(name);
}

greet('Sam'); // logs: Sam
```

A **ReferenceError** is thrown if Javascript can't find a variable in the scope hierarchy.

<a name="function-declarations-expressions"></a>
### Function Declarations and Function Expressions

#### Function Declarations

**A  function declaration defines a function, declares a variable with the same name as the function, and then assigns the function to that variable.** So for every function declaration, a variable is initialized.

```javascript
function hello() {
  return 'hello world!';
}

console.log(typeof hello);    // function
```

This function declaration (statement) defines a variable (`hello`) whose type is `function`, and it does not require assignment to another variable. **The function variable's value is the function itself**. This variable obeys scoping rules and it can be used like any other variable.

```javascript
function outer() {
  function hello() {
    return 'hello world!';
  }

  return hello();
}

console.log(typeof hello);    // can't access a local scope from here

var foo = outer;              // assign the function to another variable
foo();                        // "hello world!" (we can then use it to invoke the function)
```

A function defined using a function declaration must always have a name (it cannot be an anonymous function). **In addition to creating a named function, a function declaration also creates a variable with the same name as that function's name and assigns the function to that variable.** For example, the following two function definitions both define two things: a named function and a variable with the same name as that function.

```javascript
var foo = function foo() {
  return 'a named function expression assigned to a variable';
};

function bar() {
  return 'a function declaration';
}
```

Note also:
```
var stringVar = 'string reference';
var numberVar = 42;                      // number reference

function functionVar() {
  return 'function reference';
}

console.log(typeof stringVar);           // string
console.log(typeof numberVar);           // number
console.log(typeof functionVar);         // function

// Reassignment works as expected:
stringVar   = functionVar;               // `stringVar` now references a function
functionVar = 'string reference';        // `functionVar` now references a string

console.log(typeof stringVar);           // function
console.log(typeof functionVar);         // string
```

#### Function Expressions

A function expression defines a function as part of a larger expression syntax, such as variable assignment.

Note, a function expression is not equivalent to a function declaration (due to [hoisting](#hoisting)).

```javascript
// Define an anonymous function and assign it to variable `hello
// Only the variable 'hello' is declared during hoisting.
var hello = function () {     
  return 'hello';
};

console.log(typeof hello);    // function
console.log(hello());         // hello

// Similar but not really equivalent to function declaration.
// Variable 'hello' AND function body hoisted all at once.
function hello() {
  return 'hello';
}

console.log(typeof hello);   // function
console.log(hello());        // hello
```

```javascript
var foo = function () {
  return function () {   // function expression as return value
    return 1;
  };
};

var bar = foo();         // bar is assigned to the returned function

bar();                   // 1
```

Above, the function `foo` returns an anonymous function. Then `foo` is called and we assign its returned *function expression* to `bar`, which can then be called to get the return value `1` of the anonymous function.

#### Named Function Expressions

Function expressions can also be named, but **the name can only be referenced from within the function's local scope**. Named function expressions are mostly used for debugging, since the debugger can show the function's name in the call stack, and for recursive functions.

```javascript
var hello = function foo() {
  console.log(typeof foo);   // function
};

hello();

foo();                       // Uncaught ReferenceError: foo is not defined
```

The difference between a function declaration and a function expression is the following: It is a function declaration if a **statement** begins with the `function` keyword, a function expression otherwise.

```javascript
function foo() {
  console.log('function declaration');
}

(function bar() {
  console.log('function expression');
});

foo();    // logs 'function declaration'
bar();    // Uncaught ReferenceError: bar is not defined
```


<a name="hoisting"></a>
### Hoisting

See also: [https://javascriptweblog.wordpress.com/2010/07/06/function-declarations-vs-function-expressions/](https://javascriptweblog.wordpress.com/2010/07/06/function-declarations-vs-function-expressions/)

#### Hoisting for Variable Declarations

Javascript processes variable declarations before it executes any code within a scope, effectively moving variable **declarations** to the top of the scope. **Note**: It does not actually move any code, but rather behaves that way since it declares the variables first, then executes the code.


```javascript
console.log(a);  // logs `undefined`
var a = 123;     
var b = 456;
```

```javascript
// This is equivalent to:

var a;           // hoisted to the top of the global scope
var b;

console.log(a);  // logs `undefined`
a = 123;
b = 456;
```

(Recall that Javascript hoists only variable declarations, not assignments).

#### Hoisting for Function Declarations

Function declarations are also hoisted to the top of the scope. With function declarations, everything is hoisted, **both the function name and body**.

```javascript
console.log(hello());

function hello() {
  return 'hello world';
}
```

```javascript
// This is equivalent to:

function hello() {
  return 'hello world';
}

console.log(hello());      // logs "hello world"
```

#### Hoisting for Function Expressions

Since function expressions involve a declared variable, they are just variable declarations and obey the same rules for hoisting.

See also: [http://www.ecma-international.org/ecma-262/5.1/#sec-10.5](http://www.ecma-international.org/ecma-262/5.1/#sec-10.5)

```javascript
console.log(hello());

var hello = function () {
  return 'hello world';
};
```

```javascript
//This is equivalent to:

var hello;

console.log(hello());    // raises "Uncaught TypeError: hello is not a function"

hello = function () {
  return 'hello world';
};
```

#### Hoisting Variable and Function Declarations

When both a variable and a function declaration exist, the function declaration is hoisted first. 

```javascript
bar();              // logs undefined since foo is still undefined
var foo = 'hello';

function bar() {
  console.log(foo);
}
```

```javascript
// This is equivalent to: 

function bar() {
  console.log(foo);
}

var foo;

bar();          // logs undefined since foo is still undefined
foo = 'hello';
```

What if the same name is used for a variable and a function? Javascript ignores the variable declaration, as it is redundant, and reassignment occurs.

```javascript
bar();             // logs "world"
var bar = 'hello';

function bar() {
  console.log('world');
}
```

```javascript
var bar = 'hello';
bar();             // raises "Uncaught TypeError: bar is not a function"
bar;               // 'hello'

function bar() {
  console.log('world');
}
```

These are equivalent to:
```javascript
function bar() {
  console.log('world');
}

bar();
bar = 'hello'; // note the omission of the variable declaration
```

```javascript
function bar() {
  console.log('world');
}

bar = 'hello'; // variable bar is reassigned to string 'hello'
bar();         // raises "Uncaught TypeError: bar is not a function"
```

Note also:
```javascript
var a = 'outer';

console.log(a); // 'outer'
setScope();
console.log(a); // Uncaught TypeError: setScope is not a function

var setScope = function () {
  a = 'inner';
};


// Equivalent to
var a;
var setScope;

a = 'outer';

console.log(a); // 'outer'

setScope();     // setScope is not a function
setScope = function() {
  a = 'inner';
};

```

Another interesting example:
```javascript
function foo() {
  console.log('Waiting for bar!');
}

function foo() {    // global variable foo reassigned to this function
  console.log(foo); // 1. logs function body
  function bar() {
    console.log('bar again');
  }

  bar();

  function bar() { // hoisted, variable 'bar' reassigned to this function before bar is called
    console.log('bar again and again'); // 2. logs 'bar again and again'
  }
}

console.log(foo()); // 3. logs undefined
```

<a name="functions-as-return-values"></a>
### Functions as Return Values

* Two sets of parentheses on a function call means the first function itself returns a function, and that second function is called immediately with any arguments given in the second set of parentheses.

```javascript
function one() {
  function log(result) {
    console.log(result);
  }

  function anotherOne() {
    var result = '';
    var i;
    for (i = 0; i < arguments.length; i += 1) {
      result += String.fromCharCode(arguments[i]);
    }

    log(result);
  }

  function anotherAnotherOne() {
    console.log(String.fromCharCode(87, 101, 108, 99, 111, 109, 101)); // Welcome
    anotherOne(116, 111); // to
  }

  anotherAnotherOne();
  anotherOne(116, 104, 101); // the
  return anotherOne; // calls anotherOne(77, 97, 116, 114, 105, 120, 33), logs 'Matrix!'
}

one()(77, 97, 116, 114, 105, 120, 33);

// The function named 'one' returns the function anotherOne, and that function is called immediately with the set of arguments 77, 97, etc.
// When the anotherOne function is returned, it still has access to the 'log' function defined in its closure.
// logs:
// Welcome
// to
// the
// Matrix!

// The function calls are the following:
// one();
// anotherAnotherOne();
// anotherOne(116, 111);
// log(result);
// anotherOne(116, 104, 101);
// log(result);
// anotherOne(77, 97, 116, 114, 105, 120, 33);
// log(result);
```


<a name="best-practices"></a>
### Best Practices

* Always declare variables at the top of their scope
* Always declare functions before calling them
