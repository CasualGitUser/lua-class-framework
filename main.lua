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
      return prototype.__init(o, arg)
    end
    --funny tongue twister lays ahead
    --if a super prototype exists, set the prototype of the prototype to the super prototype
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
  __init = function(self, name)
    self.name = name[1]
    return self
  end
}

local john = person("john")
print(john.name)


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

local manager = class "manager" : extends(employee) {
  salary = 100000,
  position = "steel factory",
}

-- local employee = class "employee" : extends(person) {
--   salary = 25000,
--   flex = function(self)
--     print("my salary is: ", self.salary)
--   end,
--   __call = function(table, ...)
--     local o = {}
--     setmetatable(o, getmetatable(table))
--     return o
--   end
-- }

-- print(employee().age)

-- print(employee:extends(person))

-- local employee = class "employee" : extends(person) {
--   salary = 25000,
--   flex = function(self)
--     print("my salary is: ", self.salary)
--   end,
--   __call = function(table, ...)
--     local o = {}
--     setmetatable(o, getmetatable(table))
--     return o
--   end
-- }
