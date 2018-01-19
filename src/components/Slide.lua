local Slide = Component.create('Slide')

function Slide:initialize()
	self.slideing = false
	self.slide_modifier = 0.5

	self.slide_current_frame = false
end
