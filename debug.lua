function debug_side()
	local camx = player_side.x - 64
	local camy = player_side.y - 64
	local debug_x = camx + 10
	local debug_y = camy + 10
		
	local x = (player_side.x - 1) / 8
	local y = (player_side.y + 5) / 8
	local a = tostr(tile_solid(x, y))
	x = (player_side.x + 8) / 8
	local b = tostr(tile_solid(x,y))
		
	print("pl.x ="..player_side.x, debug_x, debug_y, 7)
	print("pl.y ="..player_side.y, debug_x, debug_y + 8, 7)
	print("pl.jmp="..tostr(player_side.jump), debug_x, debug_y + (8*2), 7)
	print("pl.cr="..tostr(player_side.crouch), debug_x, debug_y + (8*3), 7)
	print("en.cnt="..tostr(count(en_side)), debug_x, debug_y  + (8*4), 8)
	print("left="..a, debug_x, debug_y + (8*5), 11)
	print("right="..b, debug_x, debug_y + (8*6), 11)
end

function debug_top()
	print("pl.x ="..player_top.x, 10,10 + 128,7)
	print("pl.y ="..player_top.y, 10,18 + 128,7)
	print("pl.walk_ani="..player_top.walk_ani, 10, 26 + 128, 7)
	print("pl.dir="..player_top.dir, 10, 34 + 128, 7)
	print("pickups="..#pickups_top, 10, 2, 7)
	print("en_spd="..en_top.spd, 10, 128+10, 7)
	print("en_ani="..en_top.ani, 10, 128+18, 7)
end
