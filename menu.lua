menu = {}

function menu:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("> Press any key to begin <", 100, 200)
end

function menu:update(dt)
    if love.keyboard.isDown("space") then
        return "level"
    else
        return "menu"
    end
end

local offset = 0
loading = {}

function loading:draw()
    love.graphics.setColor(0.4, 0.4, 0.7)
    love.graphics.rectangle("fill", 0, 0, 640, 480)
    love.graphics.setColor(0, 0, 0.8)
    y = 0
    print("-------------")
    while y < 480 do
        pos = (y + offset) % 480
        diff = math.random(5)
        print(pos)
        love.graphics.rectangle("fill", 0, pos, 640, 30 + diff)
        y = y + 60
    end
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, 640, 60)
    love.graphics.rectangle("fill", 420, 0, 640, 60)
end


local time = 0
function loading:update(dt)
    offset = (offset + (dt * 100))

    time = time + dt

    if time >= 3 then
        time = 0
        return "menu"
    else
        return "loading"
    end
end
