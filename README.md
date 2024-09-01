# Class like OOP in Lua
This library demonstrates that it is possible to have class-like definitions of classes in Lua using currying, braceless functions and a bunch of metatable magic in quite few lines of code.

## Features
✅Single Inheritance
✅Method Overriding
✅Familiar class syntax
❌Traditional constructors
❌Private and protected members/methods

## Usage
Import the module. The only item in it is the "class" function (it acts more as a keyword - see the examples below).

## Examples

# Define a class
To define a class definition, follow the following steps:
1. Create a variable to store it in (this will serve as the constructor later on)
2. define the class as shown below in the example code in the form: class "className" {body}
3. define a constructor using the __call method in the body
4. the setmetatable call in the __call metamethod is necessary to work, but i plan on making this implicit soon

Now, just call this class definition you store in a variable like className().
Constructor arguments are currently not supported.
'''
local person = class "person" {
  age = 25,
  name = "default",
  talk = function(self)
    print(self.name)
  end,
  __call = function(self, ...)
    local o = {}
    setmetatable(o, getmetatable(self))
    return o
  end
}

local p = person()
p.age = 5
'''

# Inheritance
The syntax for inheritance is similar to how it would be done in a feature with OOP support.
To inherit, write a colon (:) after your class name and extends(superClass).
The super class needs to be the actual class, not a instance of that class.
The subclass inherits all members and methods and all of them may or may not be overwritten in the subclass.
'''
local employee = class "employee" : extends(person) {
  salary = 25000,
  flex = function(self)
    print("my salary is: ", self.salary)
  end,
  __call = function(self, ...)
    local o = {}
    setmetatable(o, getmetatable(self))
    return o
  end
}
'''
