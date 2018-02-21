local CrouchSystem = class('CrouchSystem', System)

function CrouchSystem:initialize(level)
	System.initialize(self)
	self.bumpWorld = level:get('BumpWorld').world
end

function CrouchSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local airborne = entity:get('Airborne')
		local hitbox = entity:get('Body').hitbox
		local crouch = entity:get('Crouch')
		local movement = entity:get('Movement')
		local position = entity:get('Position').coordinates

		-- Query the world to see if we can stand
		-- Query a rectangle that represents a non-crouching entity
		-- If there is no collision we're good to go!
		local _, length = self.bumpWorld:queryRect(
			position.x,
			position.y - self.initial_height * crouch.height,
			hitbox.w,
			self.initial_height
		)

		if length > 1 then
			crouch.cancelable = false
		else
			crouch.cancelable = true
		end

		-- We cant crouch when airborne
		-- But we need to check if we actually can uncrouch!
		if airborne then
			if crouch.cancelable then entity:remove('Crouch') end
		end

		if movement then
			entity:remove('Movement')
		end
	end
end

function CrouchSystem:onAddEntity(entity)
	local crouch = entity:get('Crouch')
	local hitbox = entity:get('Body').hitbox
	local position = entity:get('Position').coordinates

	-- Store the inital height
	self.initial_height = hitbox.h

	-- Crouching decreases the hitbox
	hitbox.h = hitbox.h * crouch.height
	-- We need to take the hitbox change in consideration
	position.y = position.y + hitbox.h
end

function CrouchSystem:onRemoveEntity(entity)
	local hitbox = entity:get('Body').hitbox
	local position = entity:get('Position').coordinates

	-- We need to take the hitbox change in consideration
	position.y = position.y - hitbox.h
	-- Uncrouching (standing) sets the hitbox to the initial height
	hitbox.h = self.initial_height
end

function CrouchSystem.requires()
	return {
		'Body',
		'Crouch',
		'Position',
	}
end

return CrouchSystem
