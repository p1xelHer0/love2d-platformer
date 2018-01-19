local HooECS = require('lib.HooECS')
HooECS.initialize({
	globals = true,
	debug = true,
})

vector = require('lib.hump.vector')

local scrale = require('lib.scrale')

-- Entities
local Player = require('src.entities.Player')
local Level = require('src.entities.Level')

-- Systems
local AnimationSystem = require('src.systems.AnimationSystem')
local CollisionSystem = require('src.systems.CollisionSystem')
local HitboxRenderSystem = require('src.systems.HitboxRenderSystem')
local InputSystem = require('src.systems.InputSystem')
local LevelRenderingSystem = require('src.systems.LevelRenderingSystem')
local PlatformingSystem = require('src.systems.PlatformingSystem')
local SpriteRenderingSystem = require('src.systems.SpriteRenderingSystem')

DEBUG = true

function love.load()
	scrale.init(256, 144, {
		fillHorizontally = false,
		fillVertically = false,
		scaleFilter = "nearest",
	})

	engine = Engine()

	engine:addEntity(Player())
	engine:addSystem(InputSystem())

	local level = Level('assets/levels/level_test.lua')
	engine:addEntity(level)

	engine:addSystem(PlatformingSystem())
	engine:addSystem(SpriteRenderingSystem())
	if DEBUG then engine:addSystem(HitboxRenderSystem()) end
	engine:addSystem(CollisionSystem(level))

	engine:addSystem(AnimationSystem())
	engine:addSystem(LevelRenderingSystem())
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
