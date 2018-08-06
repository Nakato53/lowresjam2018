Gun = BaseWeapon:extend()

function Gun:new()
  self.super.new(self)
  self.nextFire =0
  self.rate = 0.2
  self.bullet = BaseBullet()
end
