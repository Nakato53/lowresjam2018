Tile = Object:extend()


function Tile:new(imagePath, zoneQuad, origin)
  self.origin = {}
  if origin == nil then
    self.origin = {x=0,y=0}
  else
    self.origin = origin
  end
  self.image = imagePath
  local tmpImage = ImagesManager:get(self.image)
  self.zone = love.graphics.newQuad(zoneQuad.x,zoneQuad.y,zoneQuad.width,zoneQuad.height,tmpImage:getWidth(), tmpImage:getHeight())
end

function Tile:getImagePath()
  return self.image
end

function Tile:getQuad()
  return self.zone
end

function Tile:getImage()
  return ImagesManager:get(self.image)
end

function Tile:drawAt(x,y)
  love.graphics.draw( self:getImage(), self:getQuad(), x, y,0,1,1,self.origin.x,self.origin.y)
end


function Tile:drawScaledAt(x,y,scale)
  love.graphics.draw( self:getImage(), self:getQuad(), x, y,0,scale.x,scale.y,self.origin.x,self.origin.y)
end

--- Draw the tile at position and angle
-- @param x X position
-- @param y Y position
-- @param angle Angle in radian
function Tile:drawRotatedAt(x,y,angle)
  love.graphics.draw( self:getImage(), self:getQuad(), x, y, angle,1,1,self.origin.x,self.origin.y)
end

