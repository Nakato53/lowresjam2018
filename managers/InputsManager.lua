local baton = require 'libs/baton'

return baton.new {
  controls = {
    left = {'key:left','key:a','key:q', 'axis:leftx-', 'button:dpleft'},
    right = {'key:right','key:d', 'axis:leftx+', 'button:dpright'},
    up = {'key:up','key:w','key:z', 'axis:lefty-', 'button:dpup'},
    down = {'key:down','key:s', 'axis:lefty+', 'button:dpdown'},
    jump = {'key:x', 'button:b'},
    leftClick = {'mouse:1'},
    rightClick = {'mouse:2','key:c'},
    showmap = {'key:tab'},
    nextenv = {'key:e'},
    prevenv = {'key:r'},
  },
  pairs = {
    move = {'left', 'right', 'up', 'down'}
  },
  joystick = love.joystick.getJoysticks()[1],
}
