local tu = require "texutil"

function data()
return {
	texture = tu.makeMaterialIndexTexture("res/textures/terrain/material/construction/industry/era_a/coal_mine_1.tga", "CLAMP_TO_EDGE", "CLAMP_TO_EDGE"),
		
		
	texSize = { 180, 180 },
	materialIndexMap = {
		[1] = "dirt.lua",
		[2] = "grass_gravel.lua",
		[3] = "rock.lua",
		[4] = "scree.lua",
		[5] = "shared/coal.lua",
	},
	priority = 20,
}
end
