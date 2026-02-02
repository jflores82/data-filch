function player_top_control()

	if (btn(0)) then -- go left --
		local move_l = true
		for i = 0, 7, 1 do
			local x = flr((player_top.x) / 8)
			local y = flr((player_top.y - 8 + i) / 8)
			if(tile_solid(x, y)) then
				move_l = false
				break
			end
		end
		if(move_l == true) then 	
			player_top.flip = false
			player_top.dir = 0
			player_top.x -= 1
		end
	end
	
	if (btn(1)) then -- go right --
		local move_r = true
		for i = 0, 7, 1 do
			local x = flr((player_top.x + 7) / 8)
			local y = flr((player_top.y - 8 + i) / 8)
			if(tile_solid(x, y)) then
				move_r = false
				break
			end
		end
		if(move_r == true) then 	
			player_top.flip = true
			player_top.dir = 1
			player_top.x += 1
		end
	end
	
	if (btn(2)) then -- go up --
		local move_u = true
		for i = 0, 7, 1 do
			local x = flr((player_top.x + i) / 8)
			local y = flr((player_top.y - 9) / 8)
			if(tile_solid(x, y)) then
				move_u = false
				break
			end
		end
		if(move_u == true) then 	
			player_top.dir = 2
			player_top.y -= 1
		end
	end
	
	if (btn(3)) then -- go down --
		local move_d = true
		for i = 0, 7, 1 do
			local x = flr((player_top.x + i) / 8)
			local y = flr((player_top.y) / 8)
			if(tile_solid(x, y)) then
				move_d = false
				break
			end
		end
		if(move_d == true) then 	
			player_top.dir = 3
			player_top.y += 1
		end
	end
	
	if(btn(0) or btn(1) or btn(2) or btn(3)) then player_top.walk_ani += 1 end
	
	if(player_top.walk_ani >= player_top.walk_max) then player_top.walk_ani = 0 end
end

function player_top_draw() 
	-- player is walking
	local playerspr
	
	if(player_top.dir == 0 or player_top.dir == 1) then
		if(player_top.walk_ani == 0) then playerspr = 0 end
		if(player_top.walk_ani > 0 and player_top.walk_ani < 3) then 
			playerspr = 1
			sfx_play(5)
		end
		if(player_top.walk_ani >= 3 and player_top.walk_ani < 8) then playerspr = 0 end
		if(player_top.walk_ani >= 8 and player_top.walk_ani < 12) then 
			playerspr = 1
			sfx_play(5)
		end
		if(player_top.walk_ani >= 12 and player_top.walk_ani < 16) then playerspr = 0 end
	end
	
	
	if(player_top.dir == 2) then 
		if(player_top.walk_ani == 0) then playerspr = 14 end
		if(player_top.walk_ani > 0 and player_top.walk_ani < 3) then 
			playerspr = 15 
			sfx_play(5)
		end
		if(player_top.walk_ani >= 3 and player_top.walk_ani < 8) then playerspr = 14 end
		if(player_top.walk_ani >= 8 and player_top.walk_ani < 12) then 
			playerspr = 19 
			sfx_play(5)
		end
		if(player_top.walk_ani >= 12 and player_top.walk_ani < 16) then playerspr = 14 end
	end
	
	if(player_top.dir == 3) then 
		if(player_top.walk_ani == 0) then playerspr = 12 end
		if(player_top.walk_ani > 0 and player_top.walk_ani < 3) then 
			playerspr = 13 
			sfx_play(5)
		end
		if(player_top.walk_ani >= 3 and player_top.walk_ani < 8) then playerspr = 12 end
		if(player_top.walk_ani >= 8 and player_top.walk_ani < 12) then 
			playerspr = 18 
			sfx_play(5)
		end
		if(player_top.walk_ani >= 12 and player_top.walk_ani < 16) then playerspr = 12 end
	end
		
	spr(playerspr, player_top.x, player_top.y, 1,1, player_top.flip)
end

function player_top_death_draw(ani)
	if(ani >= 0 and ani < 4) then spr(7, player_top.x, player_top.y) end
	if(ani > 4  and ani <= 8) then spr(8, player_top.x, player_top.y) end
	if(ani > 8  and ani <= 12) then spr(9, player_top.x, player_top.y) end
	if(ani > 12 and ani <= 16) then spr(10, player_top.x, player_top.y) end
end

function player_top_check_safe()
	if(top_goals.safe_x + 8 > player_top.x) and (top_goals.safe_x < player_top.x + 6) and (top_goals.safe_y + 8> player_top.y) and (top_goals.safe_y < player_top.y + 9) then 
		player_top.safe = true
	else
		player_top.safe = false
	end
end

function player_death_check()
	player_general.lives -= 1
	if(player_general.lives <= 0) then 
		state_switch(game_states.gameover)
	end
end