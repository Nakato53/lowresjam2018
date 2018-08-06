require 'managers/loader'
-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')
shader = nil
local myShaderText = ""

gameSpeed = 1

function love.load()
  love.graphics.setDefaultFilter( "nearest", "nearest", 1 )
  love.window.setTitle("MonJeu")
  love.window.setMode(64*8, 64*8, {resizable=false, vsync=false})
  Terebi.initializeLoveDefaults()
  screen = Terebi.newScreen(64, 64, 8)
    :setBackgroundColor(0, 0, 0)

    myShaderText = love.filesystem.read("assets/shaders/pixel.txt" );
    shader = love.graphics.newShader(myShaderText)

    game = Game()
end

function love.keypressed(key)
  if key == 'f' then
    screen:toggleFullscreen()
  end
end

function love.update(dt)
  InputsManager:update()

  dt = dt * gameSpeed
  game:Update(dt)
end

local function drawFn()

  game:Draw()

  
end

function love.draw()
  screen:draw(drawFn) -- Additional arguments will be passed to drawFn.

  love.graphics.setColor(1,1,1,1)
end