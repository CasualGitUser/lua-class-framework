# Class like OOP in Lua
This library demonstrates that it is possible to have class-like definitions of classes in Lua using currying, braceless functions and a bunch of metatable magic.

## Features
- ✅Single Inheritance
- ✅Method Overriding
- ✅Familiar class syntax
- ✅Constructor arguments
- ✅Type checking / Polymorphism
- ❌Private and protected members/methods

Due to the underlying implementation, which is using metatables for both convenience and performance reasons, private and protected members/methods wont be added.

## Usage
Import the module. The exported item in it is the "class" function (it acts more as a keyword - see the examples below).

## Examples

### Define a class
To define a class definition, follow the following steps:
1. Create a variable to store it in (this will serve as the constructor later on)
2. define the class as shown below in the example code in the form: class "className" {body}
3. define a constructor in the body by having a field named constructor and assign a function to it that takes a self argument and other arguments that you want

Now, just call this class definition you stored in a variable like className() and pass it the variables it needs.
Note that you dont pass the self argument, just the arguments after it.
```lua
local person = class "person" {
  age = 25,
  name = "default",
  talk = function(self)
    print(self.name)
  end,
  constructor = function(self, name, age)
    self.age = age
    self.name = name
    return self
  end
}

local john = person("john", 10)
```

### Inheritance
The syntax for inheritance is similar to how it would be done in a feature with OOP support.
To inherit, write a colon (:) after your class name and extends(superClass).
The super class needs to be the actual class, not a instance of that class.
The subclass inherits all members and methods and all of them may or may not be overwritten in the subclass.
```lua
local employee = class "employee" : extends(person) {
  salary = 25000,
  flex = function(self)
    print("my salary is: ", self.salary)
  end,
  constructor = function(self, ...)
    self.age = 10
    return self
  end
}

local bob = employee()
bob.name = "name"
```

### Polymorphism
Every class and instance has a .type property that can be compared.
The .type property refers to the class type.
Note that you cant compare .type with a string because of metamethod limitations.
```lua
local robot = class "robot" {
  fuel = 100,
  drive = function()
    print("driving")
  end,
  constructor = function(self)
    return self
  end
}

print(john.type == person.type) //true
print(bob.type == employee.type) // true
print(bob.type == person.type) // true
print(bob.type == john.type) // true
print(bob.type == robot.type) // false
print(john.type == "person") // false, due to limitations of the __eq metamethod (in this case it compares the primitives, aka a table with a string, which is obviously false).
```
