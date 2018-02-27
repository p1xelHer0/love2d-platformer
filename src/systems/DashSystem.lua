local DashSystem = class('DashSystem', System)

function DashSystem:initialize()
	System.initialize(self)
end

function DashSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local airborne = entity:get('Airborne')
		local dash = entity:get('Dash')
		local direction = entity:get('Direction').value
		local input = entity:get('Input')
		local velocity = entity:get('Body').velocity

		if input then
			input.lock = true
		end

		-- Prevent from falling while dashing
		if airborne then
			velocity.y = 0
		end

		-- Apply dash force
		velocity.x = dash.force * direction

		dash.timer_move_end:update(dt)
		dash.timer_dash_end:update(dt)
	end
end

function DashSystem:onAddEntity(entity)
	local dash = entity:get('Dash')
	local movement = entity:get('Movement')

	if movement then
		entity:remove('Movement')
	end

	dash.timer_move_end = Timer.new()
	dash.timer_move_end:after(
		 dash.time_max,
		function()
			dash.force = 0
		end
	)

	dash.timer_dash_end = Timer.new()
	dash.timer_dash_end:after(
		dash.cooldown,
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
