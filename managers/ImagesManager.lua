_ImagesManager = Object:extend()

function _ImagesManager:new()
  self.liste = {}
end

function _ImagesManager:load(path)
  self.liste[path] = love.graphics.newImage(path)
end

function _ImagesManager:get(path)
  if( self.liste[path] == nil) then
    self:load(path)
  end
  return self.liste[path]
end

return _ImagesManager()