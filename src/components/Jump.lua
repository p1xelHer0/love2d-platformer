local Jump = Component.create('Jump')

function Jump:initialize()
	self.jumping = false
	self.jump_count = 0
	self.jump_count_max = 2
	self.jump_force = -120

	self.jump_current_frame = false
end
