Bird = Class{}

local GRAVITY = 20

function Bird:init()
    self.image = love.graphics.newImage('images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

function Bird:collides(pipe)
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 < pipe.y + PIPE_HEIGHT then 
            return true
        end
    end

    return false
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt --applying gravity to velocity

    if love.keyboard.wasPressed('space') then --jumping
        self.dy = -5
    end

    self.y = self.y + self.dy --applying current velocity to Y position
end    

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

--dt has been confusing me for a while, so before i forget, i'll put it here right now.
--dt is a way for fps to be kept constant no matter what PC you're running on.
--typically, PC's with higher specs are going to run way smoother than a potato one.
--to give potato-ers a chance at playing a game (myself included), dt takes in the typical speed of something
--and multiplies it to give it a constant value.
--so no matter what PC you have, the game will run at a constant fps rate.