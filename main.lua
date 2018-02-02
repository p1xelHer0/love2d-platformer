local HooECS = require('lib.HooECS')
HooECS.initialize({
	globals = true,
	debug = true,
})

local gamera = require('lib.gamera.gamera')

vector = require('lib.hump.vector')

local scrale = require('lib.scrale.scrale')

-- Entities
local Player = require('src.entities.Player')
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

local LevelRenderingSystem = require('src.systems.LevelRenderingSystem')
local PhysicsSystem = require('src.systems.PhysicsSystem')
local SpriteRenderingSystem = require('src.systems.SpriteRenderingSystem')

local CameraSystem = require('src.systems.CameraSystem')

-- Debugging systems
local HitboxRenderSystem = require('src.systems.HitboxRenderSystem')
local DebugTextSystem = require('src.systems.DebugTextSystem')

DEBUG = true

function love.load()
	scrale.init(256, 144, {
		fillHorizontally = false,
		fillVertically = false,
		scaleFilter = "nearest",
	})

	love.graphics.setLineStyle('rough')

	love.graphics.setNewFont('assets/fonts/gohufont-11.ttf', 11)

	camera = gamera.new(0, 0, 512, 144)
	camera:setWindow(0, 0, 256, 144)

	engine = Engine()
	local level = Level('assets/levels/level_test.lua')

	engine:addEntity(level)
	engine:addEntity(Player(camera))

	engine:addSystem(InputSystem())
	engine:addSystem(MovementSystem())
	engine:addSystem(StandSystem())
	engine:addSystem(JumpSystem())
	engine:addSystem(CrouchSystem(level))
	engine:addSystem(SlideSystem())
	engine:addSystem(SpriteRenderingSystem())
	if DEBUG then
		engine:addSystem(HitboxRenderSystem())
		engine:addSystem(DebugTextSystem())
	end
	engine:addSystem(PhysicsSystem(level))
	engine:addSystem(AnimationSystem())
	engine:addSystem(CollisionSystem(level))
	engine:addSystem(LevelRenderingSystem())
	engine:addSystem(CameraSystem())
end

function love.update(dt)
	require("lib.lovebird.lovebird").update()
	require('lib.lurker.lurker').update()
	engine:update(dt)
end

function love.draw()
	scrale.drawOnCanvas(true)

	camera:draw(
		function()
			engine:draw()
			scrale.draw()
		end
	)
end

function love.keypressed(k)
	if k == "p" then
		scrale.toggleFullscreen()
	end
end
