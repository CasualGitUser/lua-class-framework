function class(name)
  local classBluePrint = {}
  local meta = {}
  local super;
  
  --metatable magic
  setmetatable(classBluePrint, meta)
  
  --more metatable magic
  function classBluePrint:extends(super)
    super = getmetatable(super)
    local c = class(name)
    c:setSuper(super)
    return c
  end
  
  function classBluePrint:setSuper(superVal) self.super = superVal end
  
  --the class body
  meta.__call = function(self, prototype)
    prototype.__index = prototype
    --for the constructor. this is boilerplate
    prototype.__call = function(class, ...)
      local o = {}
      setmetatable(o, prototype)
      return prototype.constructor(o, arg)
    end
    --funny tongue twister lays ahead
    --if a super prototype exists, set the prototype of the prototype to the super prototype
    --aka inheritance
    if self.super then setmetatable(prototype, self.super) end
    --overrides the current metatable (discards extends and setSuper functions) with the specified prototype
    setmetatable(classBluePrint, prototype)
    return classBluePrint
  end
  
  return classBluePrint
end

local person = class "person" {
  age = 25,
  name = "default",
  talk = function(self)
    print(self.name)
  end,
  constructor = function(self, name)
    self.age = 10
    self.name = name
    return self
  end
}

local p = person("john")

print(p.name, person.name)

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

local manager = class "manager" : extends(employee) {
  salary = 100000,
  position = "steel factory",
}
