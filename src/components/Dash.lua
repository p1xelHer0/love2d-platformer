local Dash = Component.create('Dash')

function Dash:initialize()
	self.timer = nil
	self.time_max = 0.1
	self.force = 400
end

return Dash
