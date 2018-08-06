BaseWeapon = Object:extend()


function BaseWeapon:new()
  self.nextFire = 0
  self.rate = 0
  self.bullet = BaseBullet()
end


function BaseWeapon:update(dt)
  self.nextFire = self.nextFire - dt
  
end

function BaseWeapon:fire()
  if(self.nextFire <=0) then
    self.nextFire = self.rate
    local newbullet = self:makeBullet()
    table.insert(bullets,newbullet)
  end
end

function BaseWeapon:makeBullet()
  local newBullet = self.bullet:clone()
  return newBullet
end