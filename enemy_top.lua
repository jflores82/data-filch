function en_top_draw() 
	if(en_top.ani > 0 and en_top.ani <= 4) then
		spr(20, en_top.x, en_top.y, 2, 2)
	else
		spr(22, en_top.x, en_top.y, 2, 2)
	end 
end

function en_top_control()
	en_top.bit *= -1 
	if(not player_top.safe == true and en_top.bit == 1) then
		
		en_top.move = false
		
		if(en_top.x < player_top.x + 8) then
			en_top.spd += levels[currentlevel].en_top_spd_delta
			en_top_calculate_shot(1)
			if(en_top.spd >= levels[currentlevel].en_top_spd_max) then en_top.spd = levels[currentlevel].en_top_spd_max end
		end
		
		if(en_top.x > player_top.x - 12) then
			en_top.spd -= levels[currentlevel].en_top_spd_delta
			en_top_calculate_shot(0)
			if(en_top.spd <= (levels[currentlevel].en_top_spd_max * -1)) then en_top.spd = (levels[currentlevel].en_top_spd_max * - 1) end
		end
		
		if(en_top.x <= 8) then 
			en_top.x = 9
			en_top.spd = 0
		end
		
		if(en_top.x >= 104) then
			en_top.x = 103
			en_top.spd = 0
		end
		
		if not (en_top.spd == 0) then 
			en_top.x += en_top.spd
			en_top.ani += 1
		end
		
		if(en_top.ani >= en_top.ani_max) then en_top.ani = 0 end
	end
end

function en_top_calculate_shot(en_dir)
	en_dir = en_dir or -1
	local x_offset = en_top.x - player_top.x
	if(x_offset <= 0) then
		x_offset *= -1
	end
	local y_offset = en_top.y - player_top.y
	
	if(en_dir == 1) and (player_top.dir == 0) and (x_offset > 5) and (x_offset < 40) then
		en_top_create_shot()
	end
	
	if(en_dir == 0) and (player_top.dir == 1) and (x_offset > 5) and (x_offset < 40) then
		en_top_create_shot()
	end
end

function en_top_create_shot()
	if(#en_top_shots < 3) and (en_top.shot_timer == 0) and (player_top.safe == false) then
		add(en_top_shots, {x = en_top.x + 6, y = en_top.y - 8})
		sfx_play(7)
		en_top.shot_timer = 1
	end
end

function en_top_shots_update()
	for i = #en_top_shots, 1, -1 do
		en_top_shots[i].y -= levels[currentlevel].en_top_shot_spd
		
		local en_x = en_top_shots[i].x
		local en_y = en_top_shots[i].y
		local pl_x = player_top.x
		local pl_y = player_top.y
		
		if(en_x + 8 > pl_x) and (en_x < pl_x + 6) and (en_y + 8> pl_y) and (en_y < pl_y + 9) and (player_top.safe == false) then 
			deli(en_top_shots, i)
			if (debug_top_en == false) then
				state_switch(game_states.top_death)
			end
			break
		end
		
		if(en_top_shots[i].y <= 136) then
			deli(en_top_shots, i)
		end
	end
	
	if(en_top.shot_timer > 0) then
		en_top.shot_timer +=1
	end
	if(en_top.shot_timer >= en_top.shot_delay) then
		en_top.shot_timer = 0
	end
	
end

function en_top_shots_draw()
	for i = #en_top_shots, 1, -1 do 
		spr(24, en_top_shots[i].x, en_top_shots[i].y)
	end
end
