_LevelsManager = Object:extend()

function _LevelsManager:new()
  self.currentLevel = "choose"
  self.levels = {
    choose = {},
    herb = {},
    ice = {},
    fire = {},
    dirt = {},
    elemental = {}
  }
end

function _LevelsManager:currentLevelUpdate()
  
end

function _LevelsManager:get(name)
  if( self.levels[name] == nil) then
    return (self.liste[0])
  end
  return (self.liste[name])
end

return _LevelsManager()