local functions = {}

functions.tableLength = function(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

functions.printProperty = function(aTable, prop)
  assert(prop, "You didn't pass a property into printProperty")
  for i in pairs(aTable)do
    print(aTable[i][prop])
  end
end

functions.removeFromTableByType = function(aTable, type)
  local tempStack = {}
  local initialCount = #aTable
  for i = 1, initialCount, 1 do
      tempStack[i] = aTable[initialCount - (i - 1)]
      aTable[initialCount - (i - 1)] = nil
      if tempStack[i].type == type then
          tempStack[i] = nil
          functions.removeFromTableByType(aTable, type)
          break
      end
  end
  for i = #tempStack, 1, -1 do
      aTable[initialCount - (i + 1)] = tempStack[i]
      tempStack[i] = nil
  end
end

functions.readAll = function(file)
  local f = assert(io.open(file, "rb"))
  local content = f:read("*all")
  f:close()
  return content
end

functions.copy_table = function(u, t)
  for k, v in pairs(t) do u[k] = v end
  --return setmetatable(u, getmetatable(t))
end

return functions