ParticlesEmiter = Object:extend()

function ParticlesEmiter:new(x,y,count)
  self.count = count
  self.x = x
  self.y = y
  self.off = false
  self.c = {r=love.math.random(0,255)/255,g=love.math.random(0,255)/255,b=love.math.random(0,255)/255}
  self:emit()

end

function ParticlesEmiter:emit()
  self.particles = {}

  for i=1,self.count do
    local myParticle = {
      x= self.x + love.math.random(-5,5),
      y= self.y + love.math.random(-5,5),
      life= love.math.random(1,3),
      vx =  love.math.random(-15,15),
      vy =  love.math.random(-15,15),
      r = love.math.random(0,math.pi),
    }
    myParticle.startlife =myParticle.life
    table.insert(self.particles, myParticle)
  end
  self.off = false
end

function ParticlesEmiter:Update(dt)
  if self.off == false then
  for i=#self.particles,1,-1 do
    self.particles[i].life =self.particles[i].life - dt
    self.particles[i].x = self.particles[i].x + self.particles[i].vx * dt
    self.particles[i].y = self.particles[i].y + self.particles[i].vy * dt
    if self.particles[i].life <= 0 then
      table.remove(self.particles,i)
    end
  end
  if #self.particles < 1 then 
    self.off = true
    self:emit() 
  end
  end
end

function ParticlesEmiter:Draw()
  
  
  --shadows
  for i=1,#self.particles do

    local perc = self.particles[i].life / self.particles[i].startlife

    love.graphics.setColor(self.c.r*0.3,self.c.g*0.3,self.c.b*0.3,0.8*perc)
    love.graphics.points(self.particles[i].x+1,self.particles[i].y+1)
  --  love.graphics.draw(ImagesManager:get("assets/images/particle.png"), self.particles[i].x+1,self.particles[i].y+1,self.particles[i].r)
  end
  

  --real
  for i=1,#self.particles do
    local perc = self.particles[i].life / self.particles[i].startlife
    love.graphics.setColor(self.c.r,self.c.g,self.c.b,1.0*perc)
    love.graphics.points(self.particles[i].x,self.particles[i].y)
   -- love.graphics.draw(ImagesManager:get("assets/images/particle.png"), self.particles[i].x,self.particles[i].y,self.particles[i].r)
  end
end