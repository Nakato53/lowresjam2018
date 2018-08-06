_EnvManager = Object:extend()

function _EnvManager:new()
  self.liste = {}
  self.currentID = 1
end

function _EnvManager:add(vname, vdatas)
  table.insert(self.liste,{name=vname, datas=vdatas})
end

function _EnvManager:get(name)
  for i=0,#self.liste do
    if(self.liste[i].name == name) then
      return self.liste[i]
    end
  end
  return {}
end

function _EnvManager:current()
  return self.liste[self.currentID]
end

function _EnvManager:next()
  self.currentID=self.currentID+1
  if(self.currentID>#self.liste) then
    self.currentID = 1
  end
end

function _EnvManager:prev()
  self.currentID=self.currentID-1
  if(self.currentID<1) then
    self.currentID = #self.liste
  end
end

return _EnvManager()