local HooECS = require('lib.HooECS')
HooECS.initialize({
	globals = true,
	debug = true,
})

-- local scrale = require('lib.scrale')

-- Entities
local Player = require('src.entities.Player')
local Level = require('src.entities.Level')

-- Systems
local CollisionSystem = require('src.systems.CollisionSystem')
local HitboxRenderSystem = require('src.systems.HitboxRenderSystem')
local InputSystem = require('src.systems.InputSystem')
local LevelRenderingSystem = require('src.systems.LevelRenderingSystem')
local PlatformingSystem = require('src.systems.PlatformingSystem')
local SpawnSystem = require('src.systems.SpawnSystem')
local SpriteRenderingSystem = require('src.systems.SpriteRenderingSystem')
local SpriteSystem = require('src.systems.SpriteSystem')

DEBUG = true

function love.load()
	love.graphics.setLineStyle('rough')
	love.graphics.setDefaultFilter('nearest', 'nearest')
	-- scrale.init(256, 144)

	engine = Engine()

	engine:addEntity(Player())
	engine:addSystem(InputSystem())

	local level = Level('assets/levels/level_test.lua')
	engine:addEntity(level)

	engine:addSystem(PlatformingSystem())
	engine:addSystem(SpriteSystem())
	engine:addSystem(SpawnSystem(level))
	engine:addSystem(CollisionSystem(level))

	engine:addSystem(SpriteRenderingSystem())
	engine:addSystem(LevelRenderingSystem())

	if DEBUG then
		engine:addSystem(HitboxRenderSystem())
	end

	-- SpawnSystem is only needed for the first frame as of now
	engine:stopSystem('SpawnSystem')
end

function love.update(dt)
	require("lib.lovebird.lovebird").update()
	require('lib.lurker.lurker').update()
	engine:update(dt)
end

function love.draw()
	-- scrale.drawOnCanvas(true)

	-- love.graphics.setDefaultFilter('nearest', 'nearest')
	engine:draw()

	-- scrale.draw()
end

function love.keypressed(k)
	if k == "p" then
		scrale.toggleFullscreen()
	end
end
