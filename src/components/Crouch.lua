local Crouch = Component.create('Crouch')

function Crouch:initialize()
	self.crouching = false
	self.crouch_modifier = 0.5

	self.crouch_start_frame = false
	self.crouch_stop_frame = false
end
