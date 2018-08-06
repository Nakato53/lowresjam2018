_ColorsManager = Object:extend()

function _ColorsManager:new()
  self.liste = {}
end

function _ColorsManager:add(name, r,g,b,a)
  a = a == nil and 255 or a
  self.liste[name] = {r/255,g/255,b/255,a/255}
end

function _ColorsManager:get(name)
  if( self.liste[name] == nil) then
    return unpack({0,0,0,1})
  end
  return unpack(self.liste[name])
end

return _ColorsManager()