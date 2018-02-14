local DeathSystem = class('DeathSystem', System)

function DeathSystem:initialize(level)
	System.initialize(self)
end

function DeathSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local current = entity:get('Health').health
		if current <= 0 then
			print('u r ded m8')
		end
	end
end

function DeathSystem:onAddEntity(entity)
end

function DeathSystem:onRemoveEntity(entity)
end

function DeathSystem:requires(entity)
	return {
		'Health',
	}
end

return DeathSystem
