local HooECS = require('lib.HooECS')
HooECS.initialize({
	globals = true,
	debug = true,
})

local gamera = require('lib.gamera.gamera')

vector = require('lib.hump.vector')

scrale = require('lib.scrale.scrale')

-- Entities
local Player = require('src.entities.Player')
local Box = require('src.entities.Box')
local Level = require('src.entities.Level')

-- Systems
local AnimationSystem = require('src.systems.AnimationSystem')
local CollisionSystem = require('src.systems.CollisionSystem')

local InputSystem = require('src.systems.InputSystem')

local MovementSystem = require('src.systems.MovementSystem')
local StandSystem = require('src.systems.StandSystem')
local JumpSystem = require('src.systems.JumpSystem')
local CrouchSystem = require('src.systems.CrouchSystem')
local SlideSystem = require('src.systems.SlideSystem')

local DeathSystem = require('src.systems.DeathSystem')

local HealthUISystem = require('src.systems.HealthUISystem')

local LevelRenderingSystem = require('src.systems.LevelRenderingSystem')
local PhysicsSystem = require('src.systems.PhysicsSystem')
local SpriteRenderingSystem = require('src.systems.SpriteRenderingSystem')
local AnimationRenderingSystem = require('src.systems.AnimationRenderingSystem')

local CameraSystem = require('src.systems.CameraSystem')

-- Debugging systems
local CameraDebugSystem = require('src.systems.CameraDebugSystem')
local HitboxRenderSystem = require('src.systems.HitboxRenderSystem')
local DebugTextSystem = require('src.systems.DebugTextSystem')

debug = true

function love.load()
	scrale.init(512, 288, {
		fillHorizontally = false,
		fillVertically = false,
		scaleFilter = "nearest",
	})

	love.graphics.setLineStyle('rough')

	love.graphics.setNewFont('assets/fonts/gohufont-11.ttf', 11)

	camera = gamera.new(0, 0, 1024, 576)
	camera:setWindow(0, 0, 512, 288)

	engine = Engine()
	local level = Level('assets/levels/level_test.lua')

	engine:addEntity(level)
	engine:addEntity(Player(camera))
	engine:addEntity(Box())

	engine:addSystem(InputSystem())
	engine:addSystem(MovementSystem())
	engine:addSystem(StandSystem())
	engine:addSystem(JumpSystem())
	engine:addSystem(CrouchSystem(level))
	engine:addSystem(SlideSystem())
	engine:addSystem(AnimationSystem())
	engine:addSystem(SpriteRenderingSystem(camera))
	engine:addSystem(AnimationRenderingSystem(camera))
	engine:addSystem(PhysicsSystem(level))
	engine:addSystem(AnimationSystem())
	engine:addSystem(CollisionSystem(level))
	engine:addSystem(DeathSystem())
	engine:addSystem(LevelRenderingSystem(camera))
	engine:addSystem(HealthUISystem(camera))
	engine:addSystem(CameraSystem())

	if debug then
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
