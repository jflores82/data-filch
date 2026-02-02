function player_side_control()

	if (btn(0) and player_side.crouch == false) then -- go left --
		local x = (player_side.x - 1) / 8
		local y = (player_side.y + 5) / 8
		if(not tile_solid(x, y)) then
			player_side.flip = false
			player_side.x -= 1
			player_side.walk_ani += 1
			player_side_score()
		end
	end
	if (btn(1) and player_side.crouch == false) then -- go right --
		local x = (player_side.x + 8) / 8
		local y = (player_side.y + 5) / 8
		if(not tile_solid(x, y)) then
			player_side.flip = true
			player_side.x += 1
			player_side.walk_ani += 1
			player_general.score -= 1
			if(player_general.score <= 0) then player_general.score = 0 end
		end
	end
	if (not btn(0)) and (not btn(1)) then -- not walking --
		player_side.walk_ani = 0 
		
	end
	
	if(btn(3)) then -- crouch
		player_side.crouch = true
	else 
		player_side.crouch = false
	end
	
	if(btnp(4) and player_side.jump == false and player_side.crouch == false and player_side.gvt == 0) then -- jump
		player_side.jump = true
		sfx_play(01)
		player_side.jump_counter = 1
	end
	
	if(player_side.jump_counter <= (player_side.jump_max / 2) and player_side.jump == true) then
		if not player_side_collision(player_side.x, player_side.y, 2, 0) then
			player_side.y -= 1
			player_side.jump_counter += 1
		else
			player_side.jump_counter = ((player_side.jump_max / 2) + 1)
		end
	end
	
	if(player_side.jump_counter  > (player_side.jump_max / 2) and player_side.jump == true) then
		player_side.y += 1
		player_side.jump_counter += 1
	end
	
	if((player_side.jump_counter == player_side.jump_max) and player_side.jump == true) then
		--player_side.y -= 1
		player_side.jump = false
		player_side.jump_counter = 0
	end
	
	if(player_side.walk_ani == player_side.walk_max) then 
		player_side.walk_ani = 0 
	end
	
	if not btn(0) and not btn(1) then
		player_side.walk_ani = 0
	end
	
	if (not player_side_collision(player_side.x, player_side.y, 3, 0) and player_side.jump == false) then
		player_side.gvt = 1
	else
		player_side.gvt = 0
	end
	
	if(player_side.gvt == 1) then player_side.y += 1 end
	
	if(player_general.d_cooldown > 0) then player_general.d_cooldown += 1 end
	if(player_general.d_cooldown >= player_general.d_cooldown_max) then 
		player_general.d_cooldown = 0 
		player_general.d = 0
	end

end

function player_side_draw()
	-- player is walking
	if(player_side.walk_ani > 0 and player_side.walk_ani < 4) then
		playerspr = 1
		if(player_side.jump == false) then sfx_play(5) end
	else 
		playerspr = 0
	end
	
	-- player is idle
	if(player_side.walk_ani == 0) then playerspr = 0 end

	-- player is crouching
	if(player_side.crouch == true) then playerspr = 2 end
	
	-- player is jumping
	if(player_side.jump == true) then 
		player_side.jump_ani += 1
		if(player_side.jump_ani <= 3) then playerspr = 3 end
		if(player_side.jump_ani >3 and player_side.jump_ani <= 6) then playerspr = 4 end
		if(player_side.jump_ani >6 and player_side.jump_ani <= 9) then playerspr = 5 end
		if(player_side.jump_ani >9 and player_side.jump_ani <= 12) then playerspr = 4 end
		if(player_side.jump_ani > 12) then player_side.jump_ani = 0 end
	end
		
	-- draw the player
	spr(playerspr, player_side.x, player_side.y, 1, 1, player_side.flip)
end

function player_side_collision(plx, ply, dir, flag)
	--tilex = flr(plx / 8)
	--tiley = flr(ply / 8)
	local bottom = flr((player_side.y + player_side.gvt + 8) / 8)
	local l = flr((player_side.x / 8))
	local r = flr((player_side.x + 7) / 8)
	local top = flr((player_side.y - 1) / 8)	
	
	-- top collision
	if(dir == 2) then
		if((tile_solid(l, top)) or (tile_solid(r, top))) then
			return true
		end
	end
	
	--bottom collision
	if(dir == 3) then 
		if(tile_solid(l, bottom)) or (tile_solid(r, bottom)) then 
			player_side.jump = false
			player_side.gvt = 0 
			player_side.y = (bottom * 8) - 8
			return true 
		end
	end
	
	return false 
end

function player_side_score()
	for i = #en_side, 1, -1 do
		if((abs(en_side[i].x - player_side.x) < 16) and player_side.jump == false) then
			if(player_general.d_cooldown > 0) then 
				player_general.d += 1
				if(player_general.d >= player_general.d_max) then player_general.d = player_general.d_max end
				break
			end
			if(player_general.d_cooldown == 0) then player_general.d_cooldown = 1 end
		end
	end
	if(player_general.d * 1) > 0 then
		player_general.score += (1 * player_general.d)
	else 
		player_general.score += 1
	end
end

function player_side_death_draw(ani)
	if(ani >= 0 and ani < 4) then spr(7, player_side.x, player_side.y) end
	if(ani > 4  and ani <= 8) then spr(8, player_side.x, player_side.y) end
	if(ani > 8  and ani <= 12) then spr(9, player_side.x, player_side.y) end
	if(ani > 12 and ani <= 16) then spr(10, player_side.x, player_side.y) end
end