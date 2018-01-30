local Crouch = Component.create('Crouch')

function Crouch:initialize()
	self.modifier = 0.5
	self.can_stand = false
end

return Crouch
