push = require 'push'

Class = require 'class'

require 'Bird'

require 'Pipe'

require 'PipePair'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('images/background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('images/ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

local Bird = Bird()

local pipePairs = {} --changed from pipes, since we're doing 2 pipes

local spawnTimer = 0

--changes the pipe position by 20 pixels so that its not so random
local lastY = -PIPE_HEIGHT + math.random(80) + 20

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Flappy Bird Zero')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, 
    {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.keyboard.keysPressed = {} --taking in keypresses in an table format (is this good?)
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % VIRTUAL_WIDTH

    math.randomseed(os.time())
    secondsPerGap = math.random(2, 5)

    spawnTimer = spawnTimer + dt

    if spawnTimer > secondsPerGap then 
        local y = math.max(-PIPE_HEIGHT + 10,
            math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        lastY = y

        table.insert(pipePairs, PipePair(y))
        spawnTimer = 0
    end

    Bird:update(dt)

    for k, pair in pairs(pipePairs) do
        pair:update(dt)
    end

    for k, pair in pairs(pipePairs) do
        if pair.remove then
            table.remove(pipePairs, k)
        end
    end

    love.keyboard.keysPressed = {} --resets the table to have nothing in it
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)

    for k, pair in pairs(pipePairs) do
        pair:render()
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    Bird:render()

    push:finish()
end