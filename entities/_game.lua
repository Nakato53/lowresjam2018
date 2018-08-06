Game = Object:extend()

local x,y = 0,100
local tiles = {}
local r = 0
local player
local font
local explosion
map = nil
mapCollision = nil
local emiters = {}

function Game:new()
  self.bullets = {}
  font = love.graphics.newImageFont("assets/fonts/font2.png"," !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~")
  --fonttext = love.graphics.newFont("assets/fonts/mini.ttf", 12)
  love.graphics.setFont(font)

  --tiles.caseone = Tile("assets/images/tileset.png", {x=0,y=0,width=15,height=15}, {x=8,y=8} )
  ColorsManager:add("darkback",68,61,79)
  ColorsManager:add("white",255,255,255)
 
  player = Player()
  player.x = 30
  explosion = Animation("assets/images/explo.png", 8)
  explosion:Add("boom",{0,1,2,3,4,5,6,7,9,10,11,12,13},0.05)

  map = ImagesManager:get("assets/images/map.png")
  mapCollision = love.image.newImageData("assets/images/map_collision.png")

  --map:Add("base",{0,1,5},10)
  


end


function Game:Update(dt)

  if InputsManager:down 'leftClick' and player.slide ==false then
    local maBoulette = {}
    local mouseX, mouseY = screen:getMousePosition()
    
    local angle = math.atan2((mouseY - player.y), (mouseX - player.x))
      
    maBoulette.life = 1
    maBoulette.x = player.x
    maBoulette.y = player.y
    maBoulette.c = "white"
    maBoulette.vx = math.cos(angle)*30
    maBoulette.vy= math.sin(angle)*30

    --local myEmiter = ParticlesEmiter(mouseX,mouseY,love.math.random(5,15))
    table.insert( self.bullets, maBoulette)
  end

  for i=1,#emiters do
    emiters[i]:Update(dt)
  end

  for i=#self.bullets,1,-1 do
    self.bullets[i].life = self.bullets[i].life-dt
    


    self.bullets[i].x = self.bullets[i].x + self.bullets[i].vx*dt
    self.bullets[i].y = self.bullets[i].y + self.bullets[i].vy*dt
    if(self.bullets[i].life <= 0) then table.remove(self.bullets,i) end
  end
  explosion:update(dt)
 -- map:update(dt)
  
  -- local mx, my = InputsManager:get 'move'
  -- x = x + mx*dt*50
  -- if InputsManager:pressed 'jump' then
  --   y = y - 10
  -- end

player:update(dt)


  --check coll

  local r,g,b,a = mapCollision:getPixel(player.x,player.y)
  if (r == 1) then
    player.x = player.previousX
    player.y = player.previousY

    if(player.slide) then
    player.slidestart.x = player.slidestart.x -  player.slidex*dt*20
    player.slidestart.y = player.slidestart.y -  player.slidey*dt*20
    end
  end
  

end

function Game:Draw()
  love.graphics.clear(ColorsManager:get("darkback"))

  love.graphics.setColor(ColorsManager:get("white"))
  love.graphics.points(10,20)
  love.graphics.points(45,37)
  love.graphics.points(27,48)

    
  -- for i=1,#emiters do
  --   emiters[i]:Draw()
  -- end
  


  love.graphics.setColor(1,1,1,1)
  --local frame = map:getFrame()
  love.graphics.draw(map,0,0)

  for i=1,#self.bullets do
    love.graphics.setColor(ColorsManager:get(self.bullets[i].c))
    love.graphics.points(self.bullets[i].x,self.bullets[i].y)
  end
  
  
  love.graphics.setColor(1,1,1,1)
  player:draw()

  love.graphics.setColor(1,1,1,1)
  --local frame = map:getFrame()
  --love.graphics.draw(mapCollision,0,0)


  -- love.graphics.setFont(fonttext)
  -- love.graphics.setColor(1,0.5,0.5,1)
  -- love.graphics.print("test font",9,48)

  -- love.graphics.setFont(fonttitile)
  -- love.graphics.setColor(1,1,1,1)
  love.graphics.print("My Super Game !!",00,50)

  frame = explosion:getFrame()
 -- love.graphics.draw(frame.image, frame.quad ,32,32)
  
end

