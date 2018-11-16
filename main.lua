local sti = require ("sti")
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
            a:getUserData() == "Ground" and b:getUserData() == "Player" then
        if y < 0 then
            dunk_sound:play()
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

function create_key(x, y)
    local key = {}
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
    return player
end


function create_block(x, y)
    local block = {}
    block.body = love.physics.newBody(world, x, y, "dynamic")
    block.shape = love.physics.newRectangleShape(0, 0, 100, 50)
    block.fixture = love.physics.newFixture(block.body, block.shape, 0.5) -- A higher density gives it more mass.
    block.setUserData("Block")
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
    objects.ground = {}

    objects.joints = {}
    objects.blocks = {}

    map = sti("data/levels/level1.lua")
    for _, layer in ipairs(map.layers) do
        if layer.name == "ground" then
            ground_layer = layer
        elseif layer.name == "objects" then
            objects_layer = layer
        end
    end
    for _, obj in ipairs(ground_layer.objects) do
        print(_, obj.name, obj.x, obj.y, obj.width, obj.height, obj.layer.name)
        print("Creating ground")
        ground = {}
        ground.body = love.physics.newBody(
            world, obj.x + obj.width / 2, obj.y + obj.height/ 2)
        ground.shape = love.physics.newRectangleShape(obj.width,
                                                      obj.height)
        ground.fixture = love.physics.newFixture(ground.body, ground.shape)
        ground.fixture:setUserData("Ground")
        table.insert(objects.ground, ground)
    end

    for _, obj in ipairs(objects_layer.objects) do
        if obj.name == "player" then
            objects.player = create_player(obj.x, obj.y)
        end
        if obj.name == "key" then
            objects.key = create_key(obj.x, obj.y)
        end
    end
    ground_layer.visible = false
    objects_layer.visible = false

    love.graphics.setBackgroundColor(0.41, 0.53, 0.97)
    love.window.setMode(640, 480)

    key_sound = love.audio.newSource("data/snd/key.wav", "static")
    dunk_sound = love.audio.newSource("data/snd/dunk.wav", "static")
    dunk_sound:setVolume(0.15)
end

jumping = false
function love.update(dt)
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
        x = 120
        key_pressed = true
        objects.player.direction_right = true
    elseif love.keyboard.isDown("left") then
        x = -120
        key_pressed = true
        objects.player.direction_right = false
    end
    if love.keyboard.isDown("up") and not jumping then
        y = -100 * 60
        jumping = true
        key_pressed = true
    end
    if not love.keyboard.isDown("up") then
        jumping = false
    end
    if key_pressed then
        objects.player.body:applyLinearImpulse(x * dt, y * dt)
    end
end

function love.draw()
    camera = {}
    camera.x = objects.player.body:getX() - 320
    if camera.x < 0 then
        camera.x = 0
    end

    -- set the drawing color to green for the ground
    love.graphics.setColor(0.28, 0.63, 0.05)
    love.graphics.setColor(1, 1, 1)
    for _, layer in ipairs(map.layers) do
        if layer.name == "foreground" then
            foreground = layer
        end
        if layer.name == "background" then
            background = layer
        end
        if layer.name == "parallax" then
            parallax = layer
        end
    end

    foreground.visible = false
    background.visible = false
    map:draw()
    parallax.visible = false
    background.visible = true
    map:draw(-camera.x)
    foreground.visible = true
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
    
    love.graphics.setColor(0.40, 0.20, 0.20)
    for _, block in ipairs(objects.blocks) do
        love.graphics.polygon("fill", block.body:getWorldPoints(block.shape:getPoints()))
    end
    
    love.graphics.setColor(1, 1, 1)
    background.visible = false
    map:draw(-camera.x)
    background.visible = true
    parallax.visible = true

    if debug then
        love.graphics.print(text, 10, 10)
    end
end
