Level = Object:extend()


function Level:new()
  self.currentRoom = nil
  self.startRoom = nil
  self.bossRoom = nil
  self.listRooms = {}
  self.nbRoom = 30
  self.map = false

  self.rooms = {
    {
      x = 0,
      y = 0,
      image = "assets/images/map",
      instance = nil
    }
  }

  self.currentRoom = self.rooms[1]
end

function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

function Level:generate()

  --init tab
  local turn = 0
  self.rooms = {}
  for y=0,9 do
    local ligne = {}
    for x = 0,9 do
      ligne[x] = nil
    end 
    self.rooms[y] = ligne
  end

  local roomX = love.math.random(0,9)
  local roomY = love.math.random(0,9)

  local newRoom = {
    x = roomX,
    y = roomY,
    finished = false,
    tileID = 0,
    up = ROOM_DOOR_NONE,
    down = ROOM_DOOR_NONE,
    left = ROOM_DOOR_NONE,
    right = ROOM_DOOR_NONE,
    image = "assets/images/map",
    boss = false,
    bosskey = false,
    visited = true
  }

  self.rooms[roomY][roomX] = newRoom
  self.startRoom = newRoom
  table.insert(self.listRooms,newRoom)

  local directions = {
    {x = 0, y = 1},
    {x = 0, y = -1},
    {x = -1, y = 0},
    {x = 1, y = 0},
  }

  local nb = 1
  local maxbossDistance = 0
  local rndDirection = directions[love.math.random(1,4)]
  while nb < self.nbRoom+1 do
    turn = turn +1
    if(turn % 100 == 0) then
      roomX = self.startRoom.x
      roomY = self.startRoom.y
    end


    local oldir = rndDirection
    rndDirection = directions[love.math.random(1,4)]
    while(oldir.x == -rndDirection.x or oldir.y == -rndDirection.y) do
      rndDirection = directions[love.math.random(1,4)]
    end
    local previousRoom = self.rooms[roomY][roomX]
    roomX = roomX+rndDirection.x
    roomY = roomY+rndDirection.y


    if(roomX < 0 or roomX>9 or roomY < 0 or roomY > 9) then
      roomX = roomX-rndDirection.x
      roomY = roomY-rndDirection.y
      
    else
       nextRoom = {}
      if(self.rooms[roomY][roomX] == nil) then
        
         nextRoom = {
          x = roomX,
          y = roomY,
          finished = false,
          tileID = love.math.random(0,2),
          up = ROOM_DOOR_NONE,
          down = ROOM_DOOR_NONE,
          left = ROOM_DOOR_NONE,
          right = ROOM_DOOR_NONE,
          image = "assets/images/map",
          boss = false,
          bosskey = false,
          visited = false
        }
        
        local dist = math.dist(roomX,roomY,self.startRoom.x,self.startRoom.y)

        if(dist > maxbossDistance) then
          maxbossDistance = dist
          self.bossRoom = nextRoom
        end

        nb = nb + 1
        self.rooms[roomY][roomX] = nextRoom
        table.insert(self.listRooms,nextRoom)
      else
        nextRoom = self.rooms[roomY][roomX] 
      end

      if(rndDirection.x == 1) then 
        nextRoom.left = ROOM_DOOR_CLOSE 
        previousRoom.right = ROOM_DOOR_CLOSE
      end
      if(rndDirection.x == -1) then 
        nextRoom.right = ROOM_DOOR_CLOSE 
        previousRoom.left = ROOM_DOOR_CLOSE
      end
      if(rndDirection.y == -1) then 
        nextRoom.down = ROOM_DOOR_CLOSE 
        previousRoom.up = ROOM_DOOR_CLOSE
      end
      if(rndDirection.y == 1) then 
        nextRoom.up = ROOM_DOOR_CLOSE 
        previousRoom.down = ROOM_DOOR_CLOSE
      end

    end

  end
  if(self.listRooms[10].boss == false) then
    self.listRooms[10].bosskey = true
  else
    self.listRooms[11].bosskey = true
  end
  self.bossRoom.boss = true
  self.currentRoom = self.startRoom
  self.currentRoom.finished = true

end

function Level:getCurrentRoom()
  return self.currentRoom
end

function Level:getCurrentRoomInstance()
  if (self.currentRoom.instance == nil) then
    
    self.currentRoom.instance = Room(self.currentRoom.x,self.currentRoom.y,self.currentRoom.image,self.currentRoom.tileID, self.currentRoom.finished, {up=self.currentRoom.up,down=self.currentRoom.down,left=self.currentRoom.left,right=self.currentRoom.right} )
  end
  return self.currentRoom.instance
end

function Level:update(dt)
  self:getCurrentRoomInstance()

  if(self:getCurrentRoomInstance().state == "active") then

    if(self.currentRoom.instance.infade) then
      self:getCurrentRoomInstance():Fade(dt)
    else
      player:update(dt)
      if(player.x <= 2 or player.y <= 2 or player.x >= 62 or player.y >= 62) then

        
        self:getCurrentRoomInstance().state = "exit"
        self:getCurrentRoomInstance().infade = true
        self:getCurrentRoomInstance().fadestep = 1
        

      end


      self:getCurrentRoomInstance():update(dt)
    end

  end

  if(self:getCurrentRoomInstance().state == "exit") then
    if(self.currentRoom.instance.infade) then
      self:getCurrentRoomInstance():Fade(dt)
      
      if(self.currentRoom.instance.fade >= 1) then
        if(player.x <= 2) then
          self:getCurrentRoomInstance().exitDirection = {x=-1,y=0}
          player.x = 57
        end
        if(player.x >= 62) then
          self:getCurrentRoomInstance().exitDirection = {x=1,y=0}
          player.x = 7
        end
        if(player.y <= 2) then
          self:getCurrentRoomInstance().exitDirection = {x=0,y=-1}
          player.y = 56
        end
        if(player.y >= 62) then
          self:getCurrentRoomInstance().exitDirection = {x=0,y=1}
          player.y = 7
        end
        print("change room")
        print(self.currentRoom.instance.x .. "-" ..self.currentRoom.instance.y)
        local exitDir = self:getCurrentRoomInstance().exitDirection
        self.currentRoom.finished = true
        self.currentRoom.instance = nil
        self.currentRoom = self.rooms[self.currentRoom.y+exitDir.y][self.currentRoom.x+exitDir.x]
        print(self.currentRoom.x .. "-".. self.currentRoom.y..self.currentRoom.image)
        self.currentRoom.visited = true
  
        
      end
    end
  end
  

end

function Level:draw()

  self:getCurrentRoomInstance():draw()
  if(self.map) then self:drawMap() end

  if(self.currentRoom.instance.infade) then
    love.graphics.setColor(0,0,0,self.currentRoom.instance.fade)
    love.graphics.rectangle("fill", 0,0,64,64 )
  end
end



function Level:drawMap()
  
  love.graphics.setColor(0,0,0,0.8)
  love.graphics.rectangle("fill", 0,0,64,64 )




  love.graphics.setColor(1,1,1,1)

  for y=0,9 do
    for x = 0,9 do

      if(self.rooms[y][x] ~= nil) then
        local myRoom = self.rooms[y][x]
        if(myRoom.visited) then
          love.graphics.setColor(0,0,0.5,1)
          if(y == self.startRoom.y and x == self.startRoom.x) then
            love.graphics.setColor(0,0.5,0,1)
          end
          if(y == self.bossRoom.y and x == self.bossRoom.x) then
            love.graphics.setColor(0.5,0.5,0,1)
          end

          if(myRoom.bosskey) then
            love.graphics.setColor(0.5,0.5,0.5,1)
          end
          love.graphics.rectangle("fill", x*5+x+2,y*5+y+2,5,5)


          if(y == self.currentRoom.y and x == self.currentRoom.x) then
            love.graphics.setColor(1,1,1,0.3)
            love.graphics.rectangle("fill", x*5+x+3,y*5+y+3,3,3)
          end

          if(myRoom.down > 0) then
            love.graphics.setColor(1,1,1,1)
            love.graphics.points(x*5+x+2+2,y*5+y+6+2)
          end
          if(myRoom.up > 0) then
            love.graphics.setColor(1,1,1,1)
            love.graphics.points(x*5+x+2+2,y*5+y+2)
          end
          if(myRoom.left > 0) then
            love.graphics.setColor(1,1,1,1)
            love.graphics.points(x*5+x+2-1,y*5+y+2+3)
          end
          if(myRoom.right > 0) then
            love.graphics.setColor(1,1,1,1)
            love.graphics.points(x*5+x+2+5,y*5+y+2+3)
          end
        end
      end
    end 
  end

  love.graphics.setColor(1,1,1,1)
end