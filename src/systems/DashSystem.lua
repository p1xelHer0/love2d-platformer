local DashSystem = class('DashSystem', System)

function DashSystem:initialize()
	System.initialize(self)
end

function DashSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local dash = entity:get('Dash')
		local direction = entity:get('Direction').value
		local input = entity:get('Input')
		local velocity = entity:get('Body').velocity

		if input then
			input.lock = true
		end

		-- Apply force on entity velocity to dash
		velocity.x = dash.force * direction

		-- Prevent from falling while dashing
		velocity.y = 0

		dash.timer:update(dt)
	end
end

function DashSystem:onAddEntity(entity)
	local dash = entity:get('Dash')

	dash.timer = Timer.new()

	--  Setup timers
	dash.timer:after(
		dash.time_max,
		function()
			entity:remove('Dash')
		end
	)
end

function DashSystem:onRemoveEntity(entity)
	local input = entity:get('Input')
	local velocity = entity:get('Body').velocity

	velocity.x = 0
	if input then
		input.lock = false
	end
end

function DashSystem.requires()
	return {
		'Body',
		'Direction',
		'Dash',
	}
end

return DashSystem
