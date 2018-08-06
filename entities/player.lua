Player = Object:extend()


function Player:new()
  self.image = ImagesManager:get("assets/images/testplayer.png");
  self.slide = false
  self.dirt = 0
  self.dirtRate = 0.3
  self.hp={
    current = 3,
    max = 3
  }
  self.talents = {
    controlSlide = false,
    slideLength = 15,
    slideSpeed = 30
  }
  self.weapon = Gun()
  self.animations = {
    iddle = {
      love.graphics.newQuad(0,0,6,6,self.image:getWidth(),self.image:getHeight()),
      love.graphics.newQuad(0,0,6,6,self.image:getWidth(),self.image:getHeight()),
      love.graphics.newQuad(0,0,6,6,self.image:getWidth(),self.image:getHeight()),
    },
    right = {
      love.graphics.newQuad(0,0,6,6,self.image:getWidth(),self.image:getHeight()),
      love.graphics.newQuad(6,0,6,6,self.image:getWidth(),self.image:getHeight()),
      love.graphics.newQuad(12,0,6,6,self.image:getWidth(),self.image:getHeight()),
      love.graphics.newQuad(18,0,6,6,self.image:getWidth(),self.image:getHeight())
    },
    left = {
      love.graphics.newQuad(0,6,6,6,self.image:getWidth(),self.image:getHeight()),
      love.graphics.newQuad(6,6,6,6,self.image:getWidth(),self.image:getHeight()),
      love.graphics.newQuad(12,6,6,6,self.image:getWidth(),self.image:getHeight()),
      love.graphics.newQuad(18,6,6,6,self.image:getWidth(),self.image:getHeight())
    },
    slide = {
      love.graphics.newQuad(0,12,6,6,self.image:getWidth(),self.image:getHeight()),
      love.graphics.newQuad(6,12,6,6,self.image:getWidth(),self.image:getHeight()),
      love.graphics.newQuad(12,12,6,6,self.image:getWidth(),self.image:getHeight()),
      love.graphics.newQuad(18,12,6,6,self.image:getWidth(),self.image:getHeight())
    },
    
  }
  self.currentFrame = 1
  self.elapsed = 0
  self.currentAnimation = self.animations.right
  self.x = 32
  self.y = 32


end

function distanceFrom(x1,y1,x2,y2) return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) end

function Player:draw()
  if(self.slide and self.slidex > 0) then
    love.graphics.draw( self.image, self.currentAnimation[self.currentFrame], self.x, self.y,0,-1,1,3,3)
  else
    love.graphics.draw( self.image, self.currentAnimation[self.currentFrame], self.x, self.y,0,1,1,3,3)
  end
end


function Player:update(dt)

    self.previousX = self.x
    self.previousY = self.y
    self.weapon:update(dt)

    if InputsManager:down 'showmap' then
      currentLevel.map = true
    else
      currentLevel.map = false
    end
    
  if(self.slide) then

    if(self.talents.controlSlide == true) then

      local mouseX, mouseY = screen:getMousePosition()
      local angle = math.atan2((mouseY - self.y), (mouseX - self.x))
      
      self.slidex = math.cos(angle)
      self.slidey = math.sin(angle)

    end
    table.insert(particles,{ 
      x = self.x, 
      y= self.y, 
      vx = 0,
      vy = 0,
      life = 0.5,
      layer = 0,
      startlife = 1, 
      color = {r=0.4,g=0.4,b=0.4}
    })
    table.insert(particles,{ 
      x = self.x, 
      y= self.y-1, 
      vx = 0,
      vy = 0,
      layer = 0,
      life = 0.5,
      startlife = 1, 
      color = {r=0.4,g=0.4,b=0.4}
    })
    table.insert(particles,{ 
      x = self.x+1, 
      y= self.y, 
      vx = 0,
      vy = 0,
      life = 0.5,
      layer = 0,
      startlife = 1, 
      color = {r=0.4,g=0.4,b=0.4}
    })
    table.insert(particles,{ 
      x = self.x-1, 
      y= self.y, 
      vx = 0,
      vy = 0,
      layer = 0,
      life = 0.5,
      startlife = 1, 
      color = {r=0.4,g=0.4,b=0.4}
    })
    table.insert(particles,{ 
      x = self.x, 
      y= self.y+1, 
      vx = 0,
      vy = 0,
      layer = 0,
      life = 0.5,
      startlife = 1, 
      color = {r=0.7,g=0.7,b=0.7}
    })
    self.x =self.x + self.slidex*dt*self.talents.slideSpeed
    self.y =self.y + self.slidey*dt*self.talents.slideSpeed
    self.slidedistance = self.slidedistance+math.abs(self.slidex*dt*self.talents.slideSpeed)+math.abs(self.slidey*dt*self.talents.slideSpeed)
    
    local distance = self.slidedistance -- distanceFrom(self.slidestart.x,self.slidestart.y,self.x,self.y)
    
    if( distance > self.talents.slideLength and self.currentFrame == 0) then
      self.currentFrame=self.currentFrame+1
    end

    if( distance > self.talents.slideLength+3 and self.currentFrame == 1) then
      self.currentFrame=self.currentFrame+1
    end

    if( distance > self.talents.slideLength+5 and self.currentFrame == 2) then
      self.currentFrame=self.currentFrame+1
    end
    
    if( distance > self.talents.slideLength+7 and self.currentFrame == 3) then
      self.currentFrame=self.currentFrame+1
    end

    if(self.currentFrame > 3) then
      self.slide = false
    end


  else
    

    if InputsManager:down 'leftClick' then
        self.weapon:fire()
    end

  self.elapsed=self.elapsed+dt
  if(self.elapsed>0.2) then
    self.elapsed=self.elapsed-0.2
    self.currentFrame=self.currentFrame+1
     
    if(self.currentFrame>3) then
      self.currentFrame=1
    end

  end

    if InputsManager:pressed 'rightClick' then

      local mouseX, mouseY = screen:getMousePosition()
      self.slide = true
      self.slidedistance = 0
      local angle = math.atan2((mouseY - self.y), (mouseX - self.x))
      
      self.slidex = math.cos(angle)
      self.slidey = math.sin(angle)
      self.slidestart = { x = self.x, y = self.y }
      self.currentAnimation = self.animations.slide
      self.currentFrame = 2

    else
      mx, my = InputsManager:get 'move'
      if( mx == 0 and my ==0 ) then
        self.currentAnimation = self.animations.iddle
        self.currentFrame = 1
      else

        self.dirt = self.dirt-dt
        
        if(self.dirt < 0) then
          self.dirt = self.dirtRate

          table.insert(particles,{ 
            x = self.x+love.math.random(-1,0), 
            y= self.y+love.math.random(1,2), 
            vx = 0,
            vy = 0,
            life = 0.8,
            layer = 0,
            startlife = 1, 
            color = {r=0.2,g=0.2,b=0.2}
          })
        end


        if(my == 0 or mx == 0)then
          if(my > 0) then 
            self.currentAnimation = self.animations.right
            self.y = self.y +15*dt
          end
          if(my < 0) then 
            self.currentAnimation = self.animations.left 
            self.y = self.y -15*dt
          end
          if(mx < 0) then 
            self.x = self.x-15*dt
            self.currentAnimation = self.animations.left 
          end
          if(mx > 0) then 
            self.currentAnimation = self.animations.right 
            self.x = self.x+15*dt
          end
        else
          if(my > 0) then 
            self.currentAnimation = self.animations.right
            self.y = self.y +12*dt
          end
          if(my < 0) then 
            
            self.currentAnimation = self.animations.left 
            self.y = self.y -12*dt
          end
          if(mx < 0) then 
            self.x = self.x-12*dt
            self.currentAnimation = self.animations.left 
          end
          if(mx > 0) then 
            self.currentAnimation = self.animations.right 
            self.x = self.x+12*dt
          end
        end
      end
    end
  end


end
