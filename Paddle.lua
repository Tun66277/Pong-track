Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dy = 0
end


function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    elseif self.dy > 0 then
        self.y = math.min(virtual_height -20, self.y + self.dy * dt)
    end
end

function Paddle:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Paddle:up(ball)
    if ball.y > self.y - 15 then
        return true
    else
        return false
    end
end
function Paddle:down(ball)
    if ball.y < self.y + 15 then
        return true
    else
        return false
    end
end