local Input = Component.create('Input')

function Input:initialize()
	self.jump_count = 0
	self.jump_count_max = 2
	self.jump_canceled = false

	self.dash_count = 0
	self.dash_count_max = 1
	self.dash_canceled = false
	self.dash_cooldown = 1

	self.lock = false
end

return Input
