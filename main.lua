DEBUG = true

local HooECS = require('lib.HooECS')
HooECS.initialize({
	globals = true,
	debug = DEBUG,
})

Timer = require('lib.hump.timer')
vector = require('lib.hump.vector')
scrale = require('lib.scrale.scrale')

local gamera = require('lib.gamera.gamera')

-- Entities
local Player = require('src.entities.Player')
local Box = require('src.entities.Box')
local Level = require('src.entities.Level')

-- Systems
local CollisionSystem = require('src.systems.CollisionSystem')

local InputSystem = require('src.systems.InputSystem')

local PhysicsSystem = require('src.systems.PhysicsSystem')

local MovementSystem = require('src.systems.MovementSystem')
local StandSystem = require('src.systems.StandSystem')
local JumpSystem = require('src.systems.JumpSystem')
local DashSystem = require('src.systems.DashSystem')
local CrouchSystem = require('src.systems.CrouchSystem')
local SlideSystem = require('src.systems.SlideSystem')

local DeathSystem = require('src.systems.DeathSystem')

local HealthUISystem = require('src.systems.HealthUISystem')

local AnimationSystem = require('src.systems.AnimationSystem')
local LevelRenderingSystem = require('src.systems.LevelRenderingSystem')
local SpriteRenderingSystem = require('src.systems.SpriteRenderingSystem')
local AnimationRenderingSystem = require('src.systems.AnimationRenderingSystem')

local CameraSystem = require('src.systems.CameraSystem')

-- Debugging systems
local CameraDebugSystem = require('src.systems.CameraDebugSystem')
local HitboxRenderSystem = require('src.systems.HitboxRenderSystem')
local DebugTextSystem = require('src.systems.DebugTextSystem')

print(love.graphics.getHeight())

function love.load()
	scrale.init({
		fillHorizontally = false,
		fillVertically = false,
		scaleFilter = "nearest",
	})

	love.graphics.setLineStyle('rough')

	love.graphics.setNewFont('assets/fonts/gohufont-11.ttf', 11)

	camera = gamera.new(0, 0, 1024, 576)
	camera:setWindow(0, 0, 256, 144)

	engine = Engine()
	local level = Level('assets/levels/level_test.lua')

	engine:addEntity(level)
	engine:addEntity(Player(camera))
	engine:addEntity(Box())

	engine:addSystem(InputSystem())
	engine:addSystem(PhysicsSystem(level))

	engine:addSystem(MovementSystem())
	engine:addSystem(StandSystem())
	engine:addSystem(JumpSystem())
	engine:addSystem(DashSystem())
	engine:addSystem(CrouchSystem(level))
	engine:addSystem(SlideSystem())

	engine:addSystem(AnimationSystem())
	engine:addSystem(SpriteRenderingSystem(camera))
	engine:addSystem(AnimationRenderingSystem(camera))

	engine:addSystem(CollisionSystem(level))
	engine:addSystem(DeathSystem())

	engine:addSystem(LevelRenderingSystem(camera))
	engine:addSystem(HealthUISystem(camera))

	engine:addSystem(CameraSystem())

	if DEBUG then
		engine:addSystem(CameraDebugSystem(camera))
		engine:addSystem(HitboxRenderSystem(camera))
		engine:addSystem(DebugTextSystem(camera))
	end
end

function love.update(dt)
	require("lib.lovebird.lovebird").update()
	require('lib.lurker.lurker').update()
	engine:update(dt)
end

function love.draw()
	scrale.drawOnCanvas(true)

	engine:draw()

	scrale.draw()
end

function love.keypressed(k)
	if k == "p" then
		scrale.toggleFullscreen()
	end
end
