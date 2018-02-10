local Crouch = Component.create('Crouch')

function Crouch:initialize()
	self.modifier = 0.5
	self.cancelable = false
	self.time = 0
end

return Crouch
