menu = {}

title = love.graphics.newImage("data/gfx/title.png")
blank = love.graphics.newImage("data/gfx/blank.png")
function menu:draw()
    love.graphics.draw(title, 0, 0, 0, 1.25, 1.25)
    love.graphics.setColor(0, 0, 0)
    love.graphics.setColor(1, 1, 1)
end

function menu:draw_ending(deaths, time)
    love.graphics.draw(blank, 0, 0, 0, 1, 1)
    love.graphics.setColor(0, 0, 0)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Deaths: "..deaths, 200, 260, 0, 3, 3)
    mins = math.floor(time / 60)
    if mins < 10 then
        min_pad = "0"
    else
        min_pad = ""
    end
    secs = math.floor(time % 60)
    if secs < 10 then
        sec_pad = "0"
    else
        sec_pad = ""
    end
    time_string = string.format("Time: %s%d:%s%d", min_pad, mins, sec_pad, secs)
 
    love.graphics.print(time_string, 200, 300, 0, 3, 3)
end


function menu:ending_update(dt)
    if love.keyboard.isDown("space") then
        return "menu"
    else
        return "ending"
    end
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
