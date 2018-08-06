function DeepCopy( Table, Cache ) -- Makes a deep copy of a table. 
  if type( Table ) ~= 'table' then
      return Table
  end

  Cache = Cache or {}
  if Cache[Table] then
      return Cache[Table]
  end

  local New = {}
  Cache[Table] = New
  for Key, Value in pairs( Table ) do
      New[DeepCopy( Key, Cache)] = DeepCopy( Value, Cache )
  end

  return New
end