local sti = require ("sti")
require ("menu")
state = "loading"
debug = false
text = ""
persisting = 0

function beginContact(a, b, coll)
    x,y = coll:getNormal()
    text = text.."\n"..a:getUserData().." colliding with "..b:getUserData().." with a vector normal of: "..x..", "..y
    if (a:getUserData() == "Player" and b:getUserData() == "Key") or
            (a:getUserData() == "Key" and b:getUserData() == "Player") then
        taken = "Key"
    elseif a:getUserData() == "Player" and b:getUserData() == "Ground" or
            a:getUserData() == "Player" and b:getUserData() == "Block" then
        print(y)
        if y > 0 then
            dunk_sound:play()
            objects.player.jumping = false
        end
    elseif a:getUserData() == "Block" and b:getUserData() == "Player" or
            a:getUserData() == "Ground" and b:getUserData() == "Player" then
        print(y)
        if y < 0 then
            dunk_sound:play()
            objects.player.jumping = false
        end
    end
end
 
 
function endContact(a, b, coll)
    persisting = 0    -- reset since they're no longer touching
    text = text.."\n"..a:getUserData().." uncolliding with "..b:getUserData()
end
 
function preSolve(a, b, coll)
    if persisting == 0 then    -- only say when they first start touching
        text = text.."\n"..a:getUserData().." touching "..b:getUserData()
    elseif persisting < 20 then    -- then just start counting
        text = text.." "..persisting
    end
    persisting = persisting + 1    -- keep track of how many updates they've been touching for
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
-- we won't do anything with this function
end

function create_key(x, y, name)
    local key = {}
    key.type = "key"
    key.name = name
    key.body = love.physics.newBody(world, x, y, "dynamic")
    key.body:setGravityScale(0.1)
    key.body:setLinearDamping(5)
    key.shape = love.physics.newRectangleShape(5, 10)
    -- Attach fixture to body and give it a density of 1.
    key.fixture = love.physics.newFixture(key.body, key.shape, 0.0001)
    key.fixture:setRestitution(0.5) --let the ball bounce
    key.fixture:setUserData("Key")
    key.gfx = love.graphics.newImage("data/gfx/key.png")
    return key
end


function create_player(x, y)
    local player = {}
    player.type = "Player"
    player.name = "Player"
    -- place the body in the center of the world and make it dynamic,
    -- so it can move around
    player.body = love.physics.newBody(world, x, y, "dynamic")
    player.body:setFixedRotation(true)
    -- the ball's shape has a radius of 20
    player.shape = love.physics.newRectangleShape(30, 35)
    -- Attach fixture to body and give it a density of 1.
    player.fixture = love.physics.newFixture(player.body, player.shape, 1.2)
    player.fixture:setRestitution(0.1) --let the ball bounce
    player.fixture:setUserData("Player")
    player.gfx = love.graphics.newImage("data/gfx/hero1.png")
    player.direction_right = true
    player.jumping = false

    return player
end


function create_block(x, y, w, h, name)
    local block = {}
    block.type = "Block"
    block.name = name
    block.body = love.physics.newBody(world, x, y, "dynamic")
    block.shape = love.physics.newRectangleShape(0, 0, w, h)
    block.fixture = love.physics.newFixture(block.body, block.shape, 0.2) -- A higher density gives it more mass.
    block.fixture:setUserData("Block")
    return block
end

function love.load()
    love.physics.setMeter(64) --the height of a meter our worlds will be 64px
    -- create a world for the bodies to exist in with horizontal gravity of 0
    --  and vertical gravity of 9.81
    world = love.physics.newWorld(0, 9.81*64, true) 
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    taken = "" -- Collectibles picked up in collision

    objects = {}
    camera = {0, 0}

    load_level("level1")
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

    level_path = "data/levels/" .. level_name .. ".lua"
    objects.ground = {}

    objects.joints = {}
    objects.blocks = {}

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
        ground.fixture:setFriction(0.8)
        ground.fixture:setUserData("Ground")
        table.insert(objects.ground, ground)
    end

    for _, obj in ipairs(objects_layer.objects) do
        if obj.type == "player" then
            objects.player = create_player(obj.x, obj.y)
        elseif obj.type == "key" then
            objects.key = create_key(obj.x, obj.y, obj.name)
        elseif obj.type == "block" then
            table.insert(objects.blocks,
                         create_block(obj.x, obj.y, obj.width, obj.height,
                                      obj.name))
        end
    end
    for _, obj in ipairs(objects_layer.objects) do
        print(obj.type)
        if obj.type == "rope" then
            print('CREATING ROPE')
            create_rope(obj)
        end
    end

    love.graphics.setBackgroundColor(0.41, 0.53, 0.97)
    love.window.setMode(640, 480)

    key_sound = love.audio.newSource("data/snd/key.wav", "static")
    dunk_sound = love.audio.newSource("data/snd/dunk.wav", "static")
    dunk_sound:setVolume(0.15)
end

jumping = false
function love.update(dt)
    if state == "loading" then
        state = loading:update(dt)
    elseif state == "menu" then
        state = menu:update(dt)
    elseif state == "level" then
        state = level_update(dt)
    end
end


function level_update(dt)
    world:update(dt) --this puts the world into motion
    if string.len(text) > 768 then    -- cleanup when 'text' gets too long
        text = "" 
    end
    if taken == "Key" then
        joint = love.physics.newRopeJoint(objects.player.body,
                                          objects.key.body,
                                          objects.player.body:getX(),
                                          objects.player.body:getY() + 20,
                                          objects.key.body:getX(),
                                          objects.key.body:getY(),
                                          30, false)
        table.insert(objects.joints, joint)
        key_sound:play()
        taken = ""
    end

    key_pressed = False
    x = 0
    y = 0
    -- Keyboard inputs updates the force of the object
    if love.keyboard.isDown("right") then
        if not objects.player.jumping then
            x = 120
        else
            x = 30
        end
        key_pressed = true
        objects.player.direction_right = true
    elseif love.keyboard.isDown("left") then
        if not objects.player.jumping then
            x = -120
        else
            x = -30
        end
        key_pressed = true
        objects.player.direction_right = false
    end
    if love.keyboard.isDown("up") and not objects.player.jumping then
        y = -100 * 60
        objects.player.jumping = true
        key_pressed = true
    end
    if not love.keyboard.isDown("up") then
        jumping = false
    end
    if key_pressed then
        objects.player.body:applyLinearImpulse(x * dt, y * dt)
    end

    return "level"
end

function love.draw()
    if state == "loading" then
        loading:draw()
    elseif state == "menu" then
        menu:draw()
    elseif state == "level" then
        draw_level()
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
        map:draw(-camera.x)
        active.visible = false
    end
end


function draw_level()
    camera = {}
    camera.x = objects.player.body:getX() - 320
    if camera.x < 0 then
        camera.x = 0
    end

    -- set the drawing color to green for the ground
    love.graphics.setColor(0.28, 0.63, 0.05)
    love.graphics.setColor(1, 1, 1)

    draw_layer(map, "parallax")
    draw_layer(map, "background", camera)
    --love.graphics.polygon("fill", objects.player.body:getWorldPoints(objects.player.shape:getPoints()))
    if objects.player.direction_right then
        love.graphics.draw(objects.player.gfx, objects.player.body:getX() - 15 - camera.x,
                           objects.player.body:getY() - 15, 0, 0.25, 0.25)
    else
        love.graphics.draw(objects.player.gfx, objects.player.body:getX() + 15 - camera.x,
                           objects.player.body:getY() - 15, 0, -0.25, 0.25)
    end
    if objects.key then
        --love.graphics.polygon("fill", objects.key.body:getWorldPoints(objects.key.shape:getPoints()))
        love.graphics.draw(objects.key.gfx, objects.key.body:getX() - 10 - camera.x,
                       objects.key.body:getY() - 10, 0, 0.1, 0.1)
    end
    
    love.graphics.setColor(0.3, 0.3, 0.80)
    for _, block in ipairs(objects.blocks) do
        x1, y1, x2, y2, x3, y3, x4, y4 = block.body:getWorldPoints(block.shape:getPoints())
        love.graphics.polygon("fill", x1 - camera.x, y1, x2 - camera.x, y2, x3 - camera.x, y3, x4 - camera.x, y4)
    end
    
    love.graphics.setColor(1, 1, 1)
    draw_layer(map, "foreground", camera)

    if debug then
        love.graphics.print(text, 10, 10)
    end

    love.graphics.setColor(1,1,1,1)
    love.graphics.setLineWidth(3)
    love.graphics.setLineStyle("smooth")
    for _, j in ipairs(objects.joints) do
        x1, y1, x2, y2 = j:getAnchors()
        love.graphics.line(x1 - camera.x, y1, x2 - camera.x, y2)
    end
end
