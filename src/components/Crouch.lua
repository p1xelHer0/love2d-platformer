local Crouch = Component.create('Crouch')

function Crouch:initialize()
	self.modifier = 0.5
	self.height = 0.5
	self.cancelable = false
end

return Crouch
