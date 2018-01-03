local vector = require "vector"

local anim8 = require('lib.anim8.anim8')

local dtotal = 0
local platform = {}
local player = {
	moveDirection = 0,
	moveSpeed = 10,
	lookDirection = vector(0, 0),
	hitbox = vector(30, 30),
	sprite = {
		animations = {

		}
	}
}

local gravity = {
	x = 0,
	y = 30
}

local DIRECTION = {
	RIGHT = {},
	LEFT = {},
	UP = {},
	DOWN = {}
}

function love.conf(t)
	t.window.width = 1024
	t.window.height = 768
end

function love.load()
	platform.width = love.graphics.getWidth()
	platform.height = love.graphics.getHeight()
	platform.x = 0
	platform.y = platform.height / 2
end

function love.update(dt)
	dtotal = dtotal + dt

	player.moveDirection = 0

	applyForces(dtotal, player)

	if love.keyboard.isDown('d') then
		turn(DIRECTION.RIGHT, player)
	end
	if love.keyboard.isDown('a') then
		turn(DIRECTION.LEFT, player)
	end
	if love.keyboard.isDown('s') then
		turn(DIRECTION.DOWN, player)
	elseif love.keyboard.isDown('w') then
		turn(DIRECTION.UP, player)
	end

	moveCharacter(player)
end

function turnCharacter(direction, character)
	if direction == DIRECTION.RIGHT then
		character.moveDirection = character.moveDirection + 1
	elseif direction == DIRECTION.LEFT then
		character.moveDirection = character.moveDirection - 1
	end
end

function turnCharacterSprite(direction, character)
	character.lookDirection.x = character.moveDirection
	if direction == DIRECTION.LEFT then
		lookDirection.y = 0
	elseif direction == DIRECTION.RIGHT then
		lookDirection.y = 0
	elseif direction == DIRECTION.DOWN then
		lookDirection.y = 1
	elseif direction == DIRECTION.UP then
		lookDirection.y = -1
	end
end

function turn(direction, character)
	turnCharacter(direction, character)
	turnCharacterSprite(direction, character)
end

function moveCharacter(character)
	character.x = character.x + character.moveDirection * character.moveSpeed
end

function applyForces(dt, character)
	character.y = character.y + gravity.y * dt / 10
end

function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and
				 x2 < x1 + w1 and
				 y1 < y2 + h2 and
				 y2 < y1 + h1
end

function love.draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)

	love.graphics.setColor(0, 190, 123)
	love.graphics.rectangle('fill', player.x, player.y, player.hitbox.width, player.hitbox.height)
end
