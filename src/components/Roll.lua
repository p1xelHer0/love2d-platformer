local Roll = Component.create('Roll')

function Roll:initialize()
	self.rolling = false
	self.roll_modifier = 1.2

	self.roll_current_frame = false
end

return Roll
