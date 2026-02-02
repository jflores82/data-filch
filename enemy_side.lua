function en_side_update()
	
	local camx = player_side.x - 64
	local camy = player_side.y - 64
	
	local en_y = 104   -- top part of level = player.y = 64 / bottom part of level = player.y = 104
	
	if(player_side.x > 192) then
		en_y = 64
	end
		
	if(count(en_side) < 2) then
		if(flr(rnd(20)) == 10) then
			add(en_side, {x = camx + 1, y = en_y + 1, type = 1, spd = levels[currentlevel].en_side_spd_max, anim = 0})
		end
		if(flr(rnd(20)) == 5) then 
			add(en_side, {x = camx + 1, y = en_y - 6, type = 2, spd = levels[currentlevel].en_side_spd_min, anim = 0})
		end
	end
	
	for i = #en_side, 1, -1 do
		en_side[i].x += en_side[i].spd -- movement
		en_side[i].anim += 1  -- animation
		
		if(en_side[i].anim > 6) then en_side[i].anim = 0 end
		
		if (en_side[i].x > camx + 128) or (en_side[i].y > camy + 128) then
			deli(en_side, i)
		end
	end
	
	if(en_side_collision() == true) then
		if(debug_side_en == false) then
			state_switch(game_states.side_death)
		end
	end
end

function en_side_draw()
	local enspr = 16
	
	for i = #en_side, 1, -1 do
		if(en_side[i].anim > 3 and en_side[i].anim < 7) then 
			enspr = 17 
		end
		spr(enspr, en_side[i].x, en_side[i].y) -- draw the enemy spr
	end
end

function en_side_collision()
	local en_x
	local en_y
	local pl_x = player_side.x
	local pl_y = player_side.y
	for i = #en_side, 1, -1 do
		en_x = en_side[i].x
		en_y = en_side[i].y
		
		if(player_side.crouch == true) then pl_y = player_side.y + 5 end
				
		if(en_x + 8 > pl_x) and (en_x < pl_x + 6) and (en_y + 8> pl_y) and (en_y < pl_y + 9) then 
			deli(en_side, i)
			return true
		end
	end
	return false
end