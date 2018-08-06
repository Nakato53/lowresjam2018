BaseBullet = Object:extend()


function BaseBullet:new()
  self.x = 0
  self.y = 0
  self.dammage = 1
  self.vx = 0
  self.vy = 0
  self.life = 2
  self.speed = 30
  self.color = {r=253/255,g=224/255,b=1/255}
end

function BaseBullet:reset()
  self.x = player.x
  self.y = player.y

  local angle = math.atan2((mouseY - player.y), (mouseX - player.x))
      
  self.vx = math.cos(angle)*self.speed
  self.vy= math.sin(angle)*self.speed
end


function BaseBullet:update(dt)
  self.life = self.life - dt
  self.x = self.x +  self.vx*dt
  self.y = self.y +  self.vy*dt
end

function BaseBullet:draw()

  love.graphics.setColor(0.3,0.3,0.3,0.3)
  love.graphics.points(self.x+1,self.y+2)

  love.graphics.setColor(self.color.r,self.color.g,self.color.b,1)
  love.graphics.points(self.x,self.y)
  love.graphics.setColor(1,1,1,1)
end

function BaseBullet:clone()
  local tmpClone = BaseBullet()
  tmpClone:reset()
  return tmpClone
end