local function fsm(event, entity)
	local jump = entity:get('Jump')
	local crouch = entity:get('Crouch')
	local fall = entity:get('Fall')
	local slide = entity:get('Slide')
	local stand = entity:get('Stand')

	if event == 'move' then
	elseif event == 'jump' then
		jump.jumping =			true

		slide.sliding =			false
		stand.standing =		false

	elseif event == 'land' then
		stand.standing =		true

		fall.falling =			false
		jump.jumping =			false
		slide.sliding =			false

	elseif event == 'slide' then
		slide.sliding =			true

		fall.falling =			false
		jump.jumping =			false

	elseif event == 'fall' then
		fall.falling =			true

		slide.sliding =			false

	elseif event == 'crouch' then
		crouch.crouching =	true

		stand.standing =		false
	end
end

return fsm
