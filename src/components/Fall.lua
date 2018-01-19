local Fall = Component.create('Fall')

function Fall:initialize()
	self.falling = false
	self.fall_speed = 120

	self.fall_current_frame = false
end
