local sti = require ("sti")
require ("menu")
state = "menu" -- "loading"
debug = false
text = ""
persisting = 0
deaths = 0
end_tune = love.audio.newSource("data/snd/shoreline.ogg", "stream")


function beginContact(a, b, coll)
    x,y = coll:getNormal()
    print(a:getUserData().t, b:getUserData().t)
    text = text.."\n"..a:getUserData().t.." colliding with "..b:getUserData().t.." with a vector normal of: "..x..", "..y
    if (a:getUserData().t == "Player" and b:getUserData().t == "Key") or
            (a:getUserData().t == "Key" and b:getUserData().t == "Player") then
        if a:getUserData().t == "Key" then
            taken = a:getUserData()
        else
            taken = b:getUserData()
        end
    elseif a:getUserData().t == "Player" and b:getUserData().t == "Ground" or
            a:getUserData().t == "Player" and b:getUserData().t == "Door" or
            a:getUserData().t == "Player" and b:getUserData().t == "Block" then
        if y > 0 then
            dunk_sound:play()
            objects.player.jumping = false
        end
    elseif a:getUserData().t == "Block" and b:getUserData().t == "Player" or
            a:getUserData().t == "Door" and b:getUserData().t == "Player" or
            a:getUserData().t == "Ground" and b:getUserData().t == "Player" then
        if y < 0 then
            dunk_sound:play()
            objects.player.jumping = false
        end
    end
    if a:getUserData().t == "Door" and b:getUserData().t == "Player" or
            a:getUserData().t == "Player" and b:getUserData().t == "Door" then
        print('DOOR COLLISION')
        if a:getUserData().t == "Door" then
            check_door = a:getUserData().n
        else
            check_door = b:getUserData().n
        end
    end
end
 
 
function endContact(a, b, coll)
    persisting = 0    -- reset since they're no longer touching
    text = text.."\n"..a:getUserData().t.." uncolliding with "..b:getUserData().t
end
 
function preSolve(a, b, coll)
    if persisting == 0 then    -- only say when they first start touching
        text = text.."\n"..a:getUserData().t.." touching "..b:getUserData().t
    elseif persisting < 20 then    -- then just start counting
        text = text.." "..persisting
    end
    persisting = persisting + 1    -- keep track of how many updates they've been touching for
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
-- we won't do anything with this function
end

function create_key(x, y, name, heavy)
    local key = {}
    key.type = "key"
    key.name = name
    key.body = love.physics.newBody(world, x, y, "dynamic")
    key.body:setGravityScale(0.1)
    key.body:setLinearDamping(5)
    key.shape = love.physics.newRectangleShape(5, 10)
    -- Attach fixture to body and give it a density of 1.
    if heavy then
        key.body:setGravityScale(0.25)
        density = 0.3
    else
        density = 0.1
    end
    key.fixture = love.physics.newFixture(key.body, key.shape, density)
    key.fixture:setRestitution(0.5)
    data = {}
    data.t = "Key"
    data.n = name
    key.fixture:setUserData(data)
    key.gfx = love.graphics.newImage("data/gfx/key.png")
    return key
end


function create_player(x, y)
    local player = {}
    player.type = "Player"
    player.name = "Player"
    player.keys = 0

    width = 27
    height = 30
    player.height = height
    player.width = width 
    player.body = love.physics.newBody(world, x + width / 2, y + height / 2,
                                       "dynamic")
    player.body:setFixedRotation(true)
    -- the ball's shape has a radius of 20
    player.shape = love.physics.newRectangleShape(width, height)
    -- Attach fixture to body and give it a density of 1.
    player.fixture = love.physics.newFixture(player.body, player.shape, 1.2)
    player.fixture:setRestitution(0.1) --let the ball bounce
    data = {}
    data.t = "Player"
    data.n = "Player"
    player.fixture:setUserData(data)
    player.gfx = love.graphics.newImage("data/gfx/hero1.png")
    player.jump_gfx = love.graphics.newImage("data/gfx/hero4.png")
    player.direction_right = true
    player.jumping = false
    player.walking = false
    player.walk_animation = {}
    player.walk_animation.gfx = {}
    table.insert(player.walk_animation.gfx,
                 love.graphics.newImage("data/gfx/hero2.png"))
    table.insert(player.walk_animation.gfx,
                 love.graphics.newImage("data/gfx/hero3.png"))
    player.walk_animation.time = 0

    return player
end


function create_block(x, y, w, h, name, no_rotate)
    local block = {}
    block.type = "Block"
    block.name = name
    block.body = love.physics.newBody(world, x + w / 2, y + h / 2, "dynamic")
    block.shape = love.physics.newRectangleShape(0, 0, w, h)
    block.fixture = love.physics.newFixture(block.body, block.shape, 0.2) -- A higher density gives it more mass.
    data = {}
    data.t = "Block"
    data.name = name
    block.fixture:setUserData(data)
    block.body:setLinearDamping(0.5)
    if no_rotate then
        block.body:setFixedRotation(true)
    end
    return block
end

function create_door(x, y, w, h, name)
    local block = {}
    block.type = "Door"
    block.name = name
    block.body = love.physics.newBody(world, x + w / 2, y + h / 2, "static")
    block.shape = love.physics.newRectangleShape(0, 0, w, h)
    block.fixture = love.physics.newFixture(block.body, block.shape, 0.2) -- A higher density gives it more mass.
    data = {}
    data.t = "Door"
    data.n = block.name
    block.fixture:setUserData(data)
    block.body:setLinearDamping(0.5)
    if no_rotate then
        block.body:setFixedRotation(true)
    end
    return block
end

function love.load()
    love.physics.setMeter(64) --the height of a meter our worlds will be 64px
    -- create a world for the bodies to exist in with horizontal gravity of 0
    --  and vertical gravity of 9.81
    taken = {} -- Collectibles picked up in collision
    deaths = 0
end

function create_rope(rope)
    local obj1
    local obj2
    for _, obj in ipairs(objects.blocks) do
        if obj.name == rope.properties.obj1 then
            obj1 = obj
        elseif obj.name == rope.properties.obj2 then
            obj2 = obj
        end
    end
    length = rope.properties.length
    offset = rope.properties.offset
    for _, obj in ipairs(objects.ground) do
        if obj.name == rope.properties.obj1 then
            obj1 = obj
        elseif obj.name == rope.properties.obj2 then
            obj2 = obj
        end
    end
    print(rope.name, obj1.name, obj2.name)
    print(rope.height)
    print(rope.x, obj2.body:getX(), offset)
    joint = love.physics.newRopeJoint(obj1.body,
                                      obj2.body,
                                      rope.x,
                                      rope.y,
                                      obj2.body:getX() + offset,
                                      obj2.body:getY(),
                                      length, true)
    table.insert(objects.joints, joint)
end


function load_level(level_name)
    objects = {}
    objects.invisible = {}
    objects.blocks = {}
    objects.joints = {}
    check_door = nil
    camera = {0, 0}
    current_level = level_name

    if world then
        world:destroy()
    end

    world = love.physics.newWorld(0, 9.81*64, true)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    level_path = "data/levels/" .. level_name .. ".lua"
    objects.ground = {}
    objects.joints = {}
    objects.blocks = {}
    objects.keys = {}

    map = sti(level_path)
    for _, layer in ipairs(map.layers) do
        layer.visible = false
        if layer.name == "ground" then
            ground_layer = layer
        elseif layer.name == "objects" then
            objects_layer = layer
        end
    end
    for _, obj in ipairs(ground_layer.objects) do
        ground = {}
        ground.name = obj.name
        ground.type = "Ground"
        ground.body = love.physics.newBody(
            world, obj.x + obj.width / 2, obj.y + obj.height/ 2)
        ground.shape = love.physics.newRectangleShape(obj.width,
                                                      obj.height)
        ground.fixture = love.physics.newFixture(ground.body, ground.shape)
        ground.fixture:setFriction(0.6)
        data = {}
        data.t = "Ground"
        data.n = "Ground"
        ground.fixture:setUserData(data)
        table.insert(objects.ground, ground)
    end

    for _, obj in ipairs(objects_layer.objects) do
        if obj.type == "player" then
            objects.player = create_player(obj.x, obj.y)
        elseif obj.type == "key" then
            table.insert(objects.keys, create_key(obj.x, obj.y, obj.name,
                                                  obj.properties.heavy))
        elseif obj.type == "door" then
            table.insert(objects.blocks,
                         create_door(obj.x, obj.y, obj.width, obj.height,
                                      obj.name))
        elseif obj.type == "block" then
            table.insert(objects.blocks,
                         create_block(obj.x, obj.y, obj.width, obj.height,
                                      obj.name, obj.properties.no_rotate))
        elseif obj.type == "exit" then
            objects.exit = obj
        elseif obj.type == "end" then
            objects.ending = obj
        end
    end
    for _, obj in ipairs(objects_layer.objects) do
        print(obj.type)
        if obj.type == "rope" then
            create_rope(obj)
        end
    end

    love.graphics.setBackgroundColor(0.41, 0.53, 0.97)
    love.window.setMode(640, 480)

    key_sound = love.audio.newSource("data/snd/key.wav", "static")
    dunk_sound = love.audio.newSource("data/snd/dunk.wav", "static")
    dunk_sound:setVolume(0.15)
    jump_sound = love.audio.newSource("data/snd/jump.wav", "static")
    jump_sound:setVolume(0.25)
    door_sound = love.audio.newSource("data/snd/door.wav", "static")
end

function love.update(dt)
    if state == "loading" then
        state = loading:update(dt)
    elseif state == "menu" then
        state = menu:update(dt)
        if state == "level" then
            load_level("tutorial")
            start_time = love.timer.getTime()
            deaths = 0
        end
    elseif state == "level" then
        state = level_update(dt)
    elseif state == "ending" then
        state = menu:ending_update(dt)
    end
end


function check_exit(player, exit)
    x, y = player.body:getWorldCenter()
    if exit == nil then
        return false
    end

    if x > exit.x and x < exit.x + exit.width and
            y > exit.y and y < exit.y + exit.height then
        return true
    else
        return false
    end
end

function check_end(player, ending)
    x, y = player.body:getWorldCenter()
    if ending == nil then
        return false
    end

    if x > ending.x and x < ending.x + ending.width and
            y > ending.y and y < ending.y + ending.height then
        return true
    else
        return false
    end
end


function check_fallen(player, height)
    x, y = player.body:getWorldCenter()
    if y > height + 64 then
        return true
    else
        return false
    end
end


function open_door(door)
    to_remove = {}
    for i, b in ipairs(objects.blocks) do
        print(door, b.name, b.type)
        if b.type == "Door" and b.name == door then
            objects.player.keys = objects.player.keys - 1
            b.fixture:destroy()
            b.body:destroy()
            table.remove(objects.blocks, i)
            door_sound:play()
            break
        end
    end
end

function check_ground(fixture)
    if fixture:getUserData().t ~= "Player" then
        on_ground = true
        return false
    end
    return true
end

function level_update(dt)
    x_vel, y_vel = objects.player.body:getLinearVelocity()

    -- Check if player is on ground
    feet_x, feet_y = objects.player.body:getWorldCenter()
    feet_x = feet_x - objects.player.width / 2
    feet_y = feet_y + objects.player.height / 2 + 1
    on_ground = false
    world:queryBoundingBox(feet_x, feet_y,
                           feet_x + objects.player.width, feet_y + 3,
                           check_ground)
    if not on_ground then
        objects.player.jumping = true
    end
    on_ground = false


    world:update(dt) --this puts the world into motion
    if string.len(text) > 768 then    -- cleanup when 'text' gets too long
        text = "" 
    end
    if taken.t == "Key" then
        objects.player.keys = objects.player.keys + 1
        for _, key in ipairs(objects.keys) do
            if key.name == taken.n then
                key.body:setGravityScale(0.1)
                joint = love.physics.newRopeJoint(objects.player.body,
                                                  key.body,
                                                  objects.player.body:getX(),
                                                  objects.player.body:getY() + 20,
                                                  key.body:getX(),
                                                  key.body:getY(),
                                                  30, false)
                table.insert(objects.invisible, joint)
                break
            end
        end
        key_sound:play()
        taken = {}
    end

    if check_door and objects.player.keys > 0 then
        open_door(check_door)
    end
    check_door = nil

    objects.player.walking = false
    key_pressed = false
    x = 0
    y = 0
    -- Keyboard inputs updates the force of the object
    if love.keyboard.isDown("right") then
        objects.player.walking = true
        if not objects.player.jumping then
            x = 110
        else
            x = 35
        end
        key_pressed = true
        objects.player.direction_right = true
    elseif love.keyboard.isDown("left") then
        if not objects.player.jumping then
            x = -110
        else
            x = -35
        end
        key_pressed = true
        objects.player.walking = true
        objects.player.direction_right = false
    end
    if love.keyboard.isDown("up") and not objects.player.jumping then
        y = -90
        objects.player.jumping = true
        key_pressed = true
        jump_sound:play()
    end
    if love.keyboard.isDown("r") then
        deaths = deaths + 1
        load_level(current_level)
    end

    animate_player(objects.player.walking, dt)


    if key_pressed then
        objects.player.body:applyForce(x, 0)
        objects.player.body:applyLinearImpulse(0, y)
    end

    if check_exit(objects.player, objects.exit) then
        load_level(objects.exit.name)
    end
    if check_fallen(objects.player, map.height * 32) then
        deaths = deaths + 1
        load_level(current_level)
    end
    if check_end(objects.player, objects.ending) then
        end_tune:play()
        end_time = love.timer.getTime()
        return "ending"
    end
    return "level"
end

function animate_player(walking, dt)
    --print(dt)
    if walking then
        objects.player.walk_animation.time = objects.player.walk_animation.time + dt
    else
        objects.player.walk_animation.time = 0
    end
    if objects.player.walk_animation.time < 0.5 then
        objects.player.walk_animation.frame = 1
    elseif objects.player.walk_animation.time <= 1 then
        objects.player.walk_animation.frame = 2
    else
        objects.player.walk_animation.time = 0
    end
end

 
function love.draw()
    if state == "loading" then
        loading:draw()
    elseif state == "menu" then
        menu:draw()
        deaths = 0
    elseif state == "level" then
        draw_level()
    elseif state == "ending" then
        menu:draw_ending(deaths, math.floor(end_time - start_time))
    
    end
end


function draw_layer(map, layer, camera)
    if camera == nil then
        camera = {}
        camera.x = 0
        camera.y = 0
    end
    -- find and enable drawing
    for _, l in ipairs(map.layers) do
        if l.name == layer then
            active = l
            active.visible = true
            break
        end
    end
    if active then
        map:draw(-camera.x, -camera.y)
        active.visible = false
    end
end


function draw_level()
    camera = {}
    camera.x = objects.player.body:getX() - 320
    camera.y = objects.player.body:getY() - 240
    if camera.x < 0 then
        camera.x = 0
    elseif camera.x > map.width * 32  - 640 then
        camera.x = map.width * 32 - 640
    end

    if camera.y > map.height * 32 - 480 then
        camera.y = map.height * 32 - 480
    end
    if camera.y < 0 then
        camera.y = 0
    end

    -- set the drawing color to green for the ground
    love.graphics.setColor(0.28, 0.63, 0.05)
    love.graphics.setColor(1, 1, 1)

    draw_layer(map, "parallax")
    draw_layer(map, "background", camera)
    --love.graphics.polygon("fill", objects.player.body:getWorldPoints(objects.player.shape:getPoints()))
    if objects.player.jumping then
        player_gfx = objects.player.jump_gfx
    elseif objects.player.walking then
        frame = objects.player.walk_animation.frame
        player_gfx = objects.player.walk_animation.gfx[frame]
    else
        player_gfx = objects.player.gfx
    end
    if objects.player.direction_right then
        love.graphics.draw(player_gfx,
             objects.player.body:getX() - objects.player.width / 2 - camera.x,
             objects.player.body:getY() - objects.player.height / 2 - camera.y,
             0, 0.22, 0.22)
    else
        love.graphics.draw(player_gfx,
             objects.player.body:getX() + objects.player.width / 2 - camera.x,
             objects.player.body:getY() - objects.player.height / 2 - camera.y,
             0, -0.22, 0.22)
    end
    for _, key in ipairs(objects.keys) do
        --love.graphics.polygon("fill", objects.key.body:getWorldPoints(objects.key.shape:getPoints()))
        love.graphics.draw(
            key.gfx, key.body:getX() - 10 - camera.x,
            key.body:getY() - camera.y - 15, 0, 0.1, 0.1)
    end
    
    love.graphics.setColor(0.3, 0.3, 0.80)
    for _, block in ipairs(objects.blocks) do
        if block.type == "Block" then
            love.graphics.setColor(0.3, 0.3, 0.80)
        else
            love.graphics.setColor(0.8, 0.3, 0.3)
        end
        x1, y1, x2, y2, x3, y3, x4, y4 = block.body:getWorldPoints(block.shape:getPoints())
        love.graphics.polygon("fill", x1 - camera.x, y1 - camera.y,
                              x2 - camera.x, y2 - camera.y,
                              x3 - camera.x, y3 - camera.y,
                              x4 - camera.x, y4 - camera.y)
    end
    
    love.graphics.setColor(1, 1, 1)
    draw_layer(map, "foreground", camera)

    if debug then
        love.graphics.print(text, 10, 10)
    end

    -- Draw ropes
    love.graphics.setColor(1,1,1,1)
    love.graphics.setLineWidth(3)
    love.graphics.setLineStyle("smooth")
    for _, j in ipairs(objects.joints) do
        x1, y1, x2, y2 = j:getAnchors()
        love.graphics.line(x1 - camera.x, y1 - camera.y,
                           x2 - camera.x, y2 - camera.y)
    end
end
