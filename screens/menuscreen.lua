MenuScreen = Object:extend()

function MenuScreen:new()
  fonttitile = love.graphics.newFont("assets/fonts/dpcomic.ttf", 15)
  fonttext = love.graphics.newFont("assets/fonts/dpcomic.ttf", 16)
  --fonttext = love.graphics.newFont("assets/fonts/mini.ttf", 12)
  love.graphics.setFont(fonttitile)

  tiles.caseone = Tile("assets/images/tileset.png", {x=0,y=0,width=15,height=15}, {x=8,y=8} )
  ColorsManager:add("darkback",68,61,79)
  ColorsManager:add("white",255,255,255)
 
  player = Player()
end


function Game:Update(dt)

  if InputsManager:pressed 'leftClick' then
    local mouseX, mouseY = screen:getMousePosition()
    local myEmiter = ParticlesEmiter(mouseX,mouseY,love.math.random(5,15))
    table.insert( emiters, myEmiter)
  end

  for i=1,#emiters do
    emiters[i]:Update(dt)
  end
  
  -- local mx, my = InputsManager:get 'move'
  -- x = x + mx*dt*50
  -- if InputsManager:pressed 'jump' then
  --   y = y - 10
  -- end

player:update(dt)

end

function Game:Draw()
  love.graphics.clear(ColorsManager:get("darkback"))

  love.graphics.setColor(ColorsManager:get("white"))
  love.graphics.points(10,20)
  love.graphics.points(45,37)
  love.graphics.points(27,48)

    
  love.graphics.draw( ImagesManager:get("assets/images/splash.png"),0,0)
  for i=1,#emiters do
    emiters[i]:Draw()
  end

  love.graphics.setColor(1,1,1,1)
  player:draw()
  love.graphics.setFont(fonttext)
  love.graphics.setColor(1,0.5,0.5,1)
  love.graphics.print("test font",9,48)

  love.graphics.setFont(fonttitile)
  love.graphics.setColor(1,1,1,1)
  love.graphics.print("test font",10,50)
  
end

