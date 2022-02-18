function love.load()
  target = {}
  target.radius = 35
  target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
  target.y = math.random(target.radius, love.graphics.getHeight()- target.radius)
  
  FPS = love.timer.getFPS()
  

  score = 0
  timer = 0
  gameState = 1

  gameFont = love.graphics.newFont("IndieFlower_Regular.ttf", 40)

  sprites = {}
  sprites.sky = love.graphics.newImage('sprites/erba.jpg')
  sprites.target = love.graphics.newImage('sprites/target.png')
  sprites.crosshairs = love.graphics.newImage('sprites/mirino.png')

  love.mouse.setVisible(false)

  sounds = {}
  sounds.blip = love.audio.newSource("sounds/Pistol.mp3", "stream")
  sounds.music = love.audio.newSource("sounds/BackgroundSong.mp3", "stream")
  PreGame = love.audio.newSource("sounds/PreGame.mp3", "stream")

  
  PreGame:setVolume(0.7)
  PreGame:setLooping(true)
  PreGame:play()
  
end

function love.update(dt)
    if timer > 0 then
        timer = timer - dt
    end

    if timer < 0 then
        timer = 0
        gameState = 1
    end
    
end

function love.draw()
    love.graphics.draw(sprites.sky, 0, 0)

    if gameState == 2 then
        love.graphics.circle("fill", target.x, target.y, target.radius)
        love.graphics.draw(sprites.target, target.x-35, target.y-35)
    end

    love.graphics.draw(sprites.crosshairs, love.mouse.getX()- 23, love.mouse.getY()-23)

    love.graphics.setColor(1, 0, 0, 0)
    love.graphics.setColor(1, 1, 1) --bianco
    love.graphics.setFont(gameFont)
    love.graphics.print("Score: "..score, 0, 0)
    love.graphics.print("Time: "..math.ceil(timer), 320, 0)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 650, 0)

    if gameState == 1 then
        love.graphics.printf("Click anywhere to begin!", 0, 250, love.graphics.getWidth(),"center")   
        PreGame:setVolume(0.7)
        PreGame:setLooping(true)
        PreGame:play()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and gameState == 2 then
        PreGame:stop()
        sounds.music:play()
        sounds.music:setVolume(0.1)
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)
        sounds.blip:play()
        sounds.blip:setVolume(0.1)
        if mouseToTarget < target.radius then
            score = score + 1
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight()- target.radius)
        end
    
    elseif button == 1 and gameState == 1 then
        gameState = 2
        timer = 60
        score = 0
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2-x1)^2 + (y2-y1)^2 )
end