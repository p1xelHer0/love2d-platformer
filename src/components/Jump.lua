local Jump = Component.create('Jump')

function Jump:initialize()
	self.count = 0
	self.count_max = 2

	self.time = 0
	self.time_min = 0.05
	self.time_max = 0.2

	self.cancelable = false

	self.force = -120

	self.wall = false
end

return Jump
