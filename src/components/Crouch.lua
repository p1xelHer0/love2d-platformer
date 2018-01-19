local Crouch = Component.create('Crouch')

function Crouch:initialize()
	self.crouching = false
	self.crouch_modifier = 0.5

	self.crouch_current_frame = false
end
