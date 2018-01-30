local Jump = Component.create('Jump')

function Jump:initialize()
	self.count = 0
	self.count_max = 2
	self.force = -120
end

return Jump
