function side_reset()
	player_side = { 
		x = 500,
		y = 63,
		flip = false,
		crouch = false,
		jump = false,
		jump_counter = 0, 
		jump_max = 30, 
		jump_ani = 0, 
		walk_ani = 0,
		walk_max = 8,
		gvt = 0,
		rain = 0
	}
	
	player_general.d = 0
	player_general.d_cooldown = 0
	en_side = {}
end

function side_rain_draw()
	player_side.rain += 1
	if(player_side.rain >= 10) then player_side.rain = 0 end
	
	local flip = false 
	
	if(currentlevel % 2 == 0) then flip = true end
	
	local rainspr = 72
		
	for x = (player_side.x - 64), (player_side.x + 64), 8 do
		for y = 0, 115, 8 do
			if(player_side.rain > 5) then rainspr = 73 end
			spr(rainspr, x, y,1,1, flip)
		end
	end
end

function side_hud_draw()
	-- Lives --
	print("l:", (player_side.x - 63), 122, 7)
	for i = 1, player_general.lives, 1 do
		print(chr(137), (player_side.x - 62) + (i * 8), 122, 7)
	end
	
	-- Score -- 
	print ("s:"..player_general.score, player_side.x, 122, 7)

	-- Danger Move --
	print ("d:"..player_general.d, player_side.x + 30, 122, 7)
end