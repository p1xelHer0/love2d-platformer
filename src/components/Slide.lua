local Slide = Component.create('Slide')

function Slide:initialize()
	self.sliding = false
	self.slide_modifier = 0.7

	self.slide_start_frame = false
end
