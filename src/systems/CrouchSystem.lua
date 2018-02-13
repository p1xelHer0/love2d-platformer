local CrouchSystem = class('CrouchSystem', System)

function CrouchSystem:initialize(level)
	System.initialize(self)
	self.bumpWorld = level:get('BumpWorld').world
end

function CrouchSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local body = entity:get('Body')
		local crouch = entity:get('Crouch')
		local position = entity:get('Position').coordinates
		local airborne = entity:get('Airborne')

		-- We cant crouch when airborne
		if airborne then
			entity:remove('Crouch')
		end

		local velocity = body.velocity
		local hitbox = body.hitbox

		crouch.time = crouch.time + dt

		-- Query the world to see if we can stand
		local _, length = self.bumpWorld:queryRect(
			position.x, position.y - 7, hitbox.w, hitbox.h + 7
		)

		-- TODO This might need improvment...
		if length > 1 then
			crouch.cancelable = false
		else
			crouch.cancelable = true
		end

		-- Apply velocity modifier
		velocity.x = velocity.x * crouch.modifier
	end
end

function CrouchSystem:onAddEntity(entity)
	local hitbox = entity:get('Body').hitbox
	local position = entity:get('Position').coordinates

	-- TODO more general solution
	-- Crouching decreases the hitbox
	hitbox.h = hitbox.h - 7
	-- We need to take the hitbox change in consideration
	position.y = position.y + 7
end

function CrouchSystem:onRemoveEntity(entity)
	local hitbox = entity:get('Body').hitbox
	local position = entity:get('Position').coordinates

	-- TODO more general solution
	-- Uncrouching (standing) increases the hitbox (back to normal)
	hitbox.h = hitbox.h + 7
	-- We need to take the hitbox change in consideration
	position.y = position.y - 7
end

function CrouchSystem:requires(entity)
	return {
		'Body',
		'Crouch',
		'Position',
	}
end

return CrouchSystem
