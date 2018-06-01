local methods = {}

methods.tablelength = function(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

methods.printProperty = function(aTable, prop)
  assert(prop, "You didn't pass a property into printProperty")
  for i in pairs(aTable)do
    print(aTable[i][prop])
  end
end
return methods