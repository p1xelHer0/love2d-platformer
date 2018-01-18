local LevelRenderingSystem = class('LevelRenderingSystem', System)

function LevelRenderingSystem:initialize()
	System.initialize(self)
end

function LevelRenderingSystem:draw()
	for _, entity in pairs(self.targets) do
		-- Render the TileMap
		local tileMap = entity:get('TileMap').map
		tileMap:draw()
	end
end

function LevelRenderingSystem:requires()
	return {
		'TileMap',
	}
end

return LevelRenderingSystem
