Game = Object:extend()
font = nil


particles = {}


function Game:new()

  font = love.graphics.newImageFont("assets/fonts/font2.png"," !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~")
  love.graphics.setFont(font)
  ColorsManager:add("darkback",68,61,79)
  ColorsManager:add("white",255,255,255)
 
  player = Player()
  player.x = 34
  
  currentLevel  = Level()
  currentLevel:generate()

  EnvManager:add("herb",{
    foundColor = {
     
    },
    replaceColor = {
    }

  })
  EnvManager:add("sand",{
    foundColor = {
      {42/255,96/255,46/255,1},
      {27/255,73/255,46/255,1}
    },
    replaceColor = {
      {234/255,173/255,47/255,1},
      {204/255,145/255,21/255,1}
    }
  })
  EnvManager:add("ice",{
    foundColor = {
      {42/255,96/255,46/255,1},
      {27/255,73/255,46/255,1}
    },
    replaceColor = {
      {178/255,220/255,239/255,1},
      {141/255,201/255,234/255,1}
    }
  })

end


function Game:Update(dt)

  mouseX, mouseY = screen:getMousePosition()

  currentLevel:update(dt)
end

function Game:Draw()
  currentLevel:draw()

end


