Animation = Object:extend()


function Animation:new(imagePath, framesize)
  self.image = ImagesManager:get(imagePath)
  self.framesize = framesize
  self.animations = {
  }
  self.currentFrame = 1
  self.elapsed = 0
  self.currentAnimation = nil
end

function Animation:getQuadById(id) 
  local y = 0
  local x = id * self.framesize
  y =  math.floor(x / self.image:getWidth()) * self.framesize
  x = x - ( (y/self.framesize)*self.image:getWidth())
  return love.graphics.newQuad(x,y,self.framesize,self.framesize,self.image:getWidth(),self.image:getHeight())
end

function Animation:Add(name, frames, delay)
  local newAnim = {}
  newAnim.delay = delay
  newAnim.name = name
  newAnim.frames = {}
  for i=1,#frames,1 do
    
    local newFrame = self:getQuadById(frames[i])
    table.insert(newAnim.frames, newFrame)
  end

  table.insert(self.animations, newAnim)
  if(self.currentAnimation == nil) then
    self.currentAnimation = self.animations[1]
  end

end

function Animation:setAnimation(name)
  for i=1,#self.animations,1 do
    if(self.animations[i].name == name) then
      self.currentAnimation = self.animations[i]
    end
  end 
end

function Animation:getFrame()
  return {image= self.image, quad=self.currentAnimation.frames[self.currentFrame]}
end


function Animation:update(dt)
  if(self.currentAnimation ~= nil) then
    self.elapsed=self.elapsed+dt
    if(self.elapsed>self.currentAnimation.delay) then
      self.elapsed=self.elapsed-self.currentAnimation.delay
      self.currentFrame=self.currentFrame+1
      if(self.currentFrame > #self.currentAnimation.frames) then
        self.currentFrame=1
      end
    end
  end
end
