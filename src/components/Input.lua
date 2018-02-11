local Input = Component.create('Input')

function Input:initialize()
	self.jump_count = 0
	self.jump_count_max = 2
	self.jump_canceled = false

	self.lock = false
end

return Input
