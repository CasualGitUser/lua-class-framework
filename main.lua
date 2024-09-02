-- rescursively compares all the self and selfSuperTypes with the type of other
function compareClassTypes(self, other, originalSelf)
  local selfSuper = getmetatable(self)
  local otherSuper = getmetatable(other)
  
  if self.type == other.type then return true
  elseif selfSuper then return compareClassTypes(selfSuper, other, originalSelf)
  elseif otherSuper then return compareClassTypes(originalSelf, otherSuper, originalSelf)
  else return false end
end

--lookup table for typeMetaTables
local metaTypeClasses = {}

-- makes the == work between a instance.type and another instance.type
-- note: doesnt work with a instance.type == string due to limitations of the __eq metamethod
function classTypeMeta(typeName)
  if metaTypeClasses[typeName] then return metaTypeClasses[typeName] end
  local meta = {}
  meta.type = typeName
  meta.__index = meta
  meta.__eq = function(self, other)
    return compareClassTypes(self, other, self)
  end
  metaTypeClasses[typeName] = meta
  return meta
end

--handles the creation of classes
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
    --for polymorphism and type checking
    prototype.type = {}
    setmetatable(prototype.type, classTypeMeta(name))
    
    --for the constructor. this reduces boilerplate
    prototype.__call = function(class, ...)
      local o = {}
      setmetatable(o, prototype)
      return prototype.constructor(o, ...)
    end
    
    --funny tongue twister lays ahead
    --if a super prototype exists, set the prototype of the prototype to the super prototype
    --aka inheritance
    if self.super then
      setmetatable(prototype, self.super)
      setmetatable(prototype.type, self.super.type)
    end
    
    --overrides the current metatable (discards extends and setSuper functions) with the specified prototype
    setmetatable(classBluePrint, prototype)
    return classBluePrint
  end
  
  return classBluePrint
end

--------------------EXAMPLES--------------------

local robot = class "robot" {
  fuel = 100,
  drive = function()
    print("driving")
  end,
  constructor = function(self)
    return self
  end
}

local r = robot()

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

local p = person("john", 10)
local p2 = person("bob", 20)

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

local e = employee()
e.salary = 30000

local manager = class "manager" : extends(employee) {
  salary = 100000,
  position = "steel factory",
}

--export the function
return class
