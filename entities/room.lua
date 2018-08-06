Room = Object:extend()

ROOM_DOOR_NONE = 0
ROOM_DOOR_CLOSE = 1
ROOM_DOOR_OPEN = 2

bullets = {}
particles = {}
function Room:new(x,y,image_name,tileID,finished,doors)
  self.fade = 1
  self.tileID = tileID
  self.infade = true
  self.fadestep = -1
  self.state = "active"
  self.exitDirection = {x = 0, y=0}
  if(finished) then
    self.doorsfade = 0
  else  
    self.doorsfade = 1.2
  end
  self.finished = finished
  bullets = {}  
  particles = {}
  self.doors = doors

  self.imageBack = image_name.."_back"

  
  self.imageHover = image_name.."_hover"
  self.imageCollision = image_name.."_collision"
  self.imageBordure = image_name.."_bordure"
  
  self.quad = love.graphics.newQuad(self.tileID*64,0,64,64,ImagesManager:get(self.imageBack..".png"):getWidth(),ImagesManager:get(self.imageBack..".png"):getHeight())
  self.collisionDatas = love.image.newImageData(self.imageCollision..".png")
  
  self.x = x
  self.y = y

end

function Room:update(dt)

  if(self.finished) then
    self.doorsfade = self.doorsfade-dt*2
  end


  if InputsManager:pressed 'jump' then
    self.finished=true
  end

  if InputsManager:pressed 'nextenv' then
    EnvManager:next()
  end

  if InputsManager:pressed 'prevenv' then
    EnvManager:prev()
  end


  if(EnvManager:current().name == "ice") then
    table.insert(particles,{ 
      x = love.math.random(-5,70), 
      y= love.math.random(-5,70), 
      vy = love.math.random(5,10),
      vx = love.math.random(-5,5),
      layer = 1,
      life = 5,
      startlife = 10, 
      color = {r=0.9,g=0.9,b=0.9}
    })
  end


  self:updateBullets(dt)
  self:updateParticles(dt)
  self:checkPlayerCollision(dt)
  self:checkBulletsCollision(dt)
end

function Room:enableShader()
  if(EnvManager:current().name ~= "herb") then
    love.graphics.setShader(shader) 
    shader:send("found_color", unpack(EnvManager:current().datas.foundColor))
    shader:send("replace_color",unpack(EnvManager:current().datas.replaceColor))
  end
end

function Room:disableShader()
  love.graphics.setShader()
end

function Room:draw()


  self:enableShader()
  self:drawBackground()
  self:disableShader()
  
  
  self:DrawBullets()


  self:enableShader()
  self:drawBorder()
  self:drawDoors()
  self:disableShader()
  self:DrawParticles(0)
  player:draw()

  self:drawHover()
  self:DrawParticles(1)
--  self:drawCollision()
end

function Room:updateBullets(dt)
  for i=#bullets,1,-1 do
    bullets[i]:update(dt)
    if(bullets[i].life <= 0) then
      table.remove(bullets,i)
    end
  end
end

function Room:updateParticles(dt)
  for i=#particles,1,-1 do
    particles[i].life = particles[i].life - dt
    particles[i].x = particles[i].x+particles[i].vx*dt
    particles[i].y = particles[i].y+particles[i].vy*dt
    if(particles[i].life <= 0) then
      table.remove(particles,i)
    end
  end
end


function Room:Fade(dt)

  self.fade = self.fade+self.fadestep*dt

  if(self.fade>=1) then
    self.fade = 1
  end

  if(self.fade<=0) then
    self.fade =0
    self.infade = false
  end
end

function Room:checkBorderCollision(x,y)
  if(self.finished) then
    if(x<6 or x > 56 or y < 7 or y > 56) then
      --gauche
      if(self.doors.left ~= ROOM_DOOR_NONE and x>0 and x < 6 and y > 25 and y < 37 ) then
        return false
      end
      --droite
      if(self.doors.right ~= ROOM_DOOR_NONE and x>56 and x <63  and y > 25 and y < 37 ) then
        return false
      end
      --haut
      if(self.doors.up ~= ROOM_DOOR_NONE and x>25 and x <39  and y > 0 and y < 7 ) then
        return false
      end
      --bas
      if(self.doors.down ~= ROOM_DOOR_NONE and x>25 and x <39  and y > 56 and y < 63 ) then
        return false
      end

      return true
    else
      return false
    end
  else
    return x<6 or x > 56 or y < 7 or y > 56
  end


end

function Room:checkPlayerCollision(dt)
  --check bounds
  local r,g,b,a = self.collisionDatas:getPixel( self.tileID*64 + player.x,player.y)
  if (r == 1 or self:checkBorderCollision(player.x-1,player.y)) then
    player.x = player.previousX
    player.y = player.previousY

    if(player.slide) then
    player.slidestart.x = player.slidestart.x -  player.slidex*dt*20
    player.slidestart.y = player.slidestart.y -  player.slidey*dt*20
    end
  end
  
end

function Room:checkBulletsCollision(dt)
  for i=#bullets,1,-1 do
    local r,g,b,a = self.collisionDatas:getPixel(self.tileID*64 + bullets[i].x,bullets[i].y)
    if (r == 1 or self:checkBorderCollision(bullets[i].x-1,bullets[i].y)) then
      --spawns collision particles
      local angle = math.atan2(bullets[i].vy, bullets[i].vx) + math.pi - math.pi/4
      for y=0,2,1 do
        local tmpangle = angle-(math.pi/4)+love.math.random( math.pi/2 )
        table.insert(particles,{ 
          x = bullets[i].x, 
          y= bullets[i].y, 
          vx = math.cos(tmpangle)*10,
          vy = math.sin(tmpangle)*10,
          layer = 0,
          life = 0.5,
          startlife = 0.5, 
          color = {r=0.7,g=0.7,b=0.7}
        })
      end

      table.remove(bullets,i)
    end
  end
end

function Room:DrawBullets()
  for i=1,#bullets do
    bullets[i]:draw()
  end
end

function Room:DrawParticles(layer)
  for i=1,#particles do
    if(particles[i].layer == layer) then
      love.graphics.setColor(particles[i].color.r,particles[i].color.g,particles[i].color.b,particles[i].life/particles[i].startlife)
      love.graphics.points(particles[i].x,particles[i].y)
    end
  end
  love.graphics.setColor(1,1,1,1)
end
function Room:drawBackground()
  
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(ImagesManager:get(self.imageBack..".png"), self.quad,0,0)
end

function Room:drawHover()
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(ImagesManager:get(self.imageHover..".png"), self.quad,0,0)
end

function Room:drawDoors()
  
  love.graphics.setColor(1,1,1,self.doorsfade)

  if(self.doors.up~=ROOM_DOOR_NONE) then
    love.graphics.draw(ImagesManager:get("assets/images/door.png"),32,32,0,1,1,32,32)
  end
  if(self.doors.right~=ROOM_DOOR_NONE) then
    love.graphics.draw(ImagesManager:get("assets/images/door.png"),32,32,math.pi/2,1,1,32,32)
  end
  if(self.doors.down~=ROOM_DOOR_NONE) then
    love.graphics.draw(ImagesManager:get("assets/images/door.png"),32+1,32,math.pi,1,1,32,32)
  end
  if(self.doors.left~=ROOM_DOOR_NONE) then
    love.graphics.draw(ImagesManager:get("assets/images/door.png"),32,32,-math.pi/2,1,1,32,32)
  end
  love.graphics.setColor(1,1,1,1)
end

function Room:drawBorder()

  local tile = 0
  if(self.doors.up~=ROOM_DOOR_NONE) then
    tile = tile +1
  end
  if(self.doors.right~=ROOM_DOOR_NONE) then
    tile = tile +4
  end
  if(self.doors.down~=ROOM_DOOR_NONE) then
    tile = tile +8
  end
  if(self.doors.left~=ROOM_DOOR_NONE) then
    tile = tile +2
  end

  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(
    ImagesManager:get(self.imageBordure..".png"),
    love.graphics.newQuad(tile*64,0,64,64,ImagesManager:get(self.imageBordure..".png"):getWidth(),ImagesManager:get(self.imageBordure..".png"):getHeight()),
    0,
    0)
end

function Room:drawCollision()
  love.graphics.setColor(1,1,1,0.1)
  love.graphics.draw(ImagesManager:get(self.imageCollision..".png"),0,0)
  love.graphics.setColor(1,1,1,1)
end