local LevelRenderingSystem = class('LevelRenderingSystem', System)

function LevelRenderingSystem:initialize(camera)
	System.initialize(self)
	self.camera = camera
end

function LevelRenderingSystem:draw()
	for _, entity in pairs(self.targets) do
		-- Render the TileMap
		local tileMap = entity:get('TileMap').map
		tileMap:draw(0, 0, 1, 1)
	end
end

function LevelRenderingSystem:requires()
	return {
		'TileMap',
	}
end

return LevelRenderingSystem
