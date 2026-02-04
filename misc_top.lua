function top_reset(new) 
	new = new or 0
	
	player_top = { 
		x = 96, 
		y = 144,
		flip = false,
		dir = 0,
		walk_ani = 0,  
		walk_max = 16,
		safe = true,
	}
	
	top_goals = { 
		safe_x = 96, 
		safe_y = 144, 
		made = false,
		comp = false,
		goal_x = 23,
		goal_y = 208,
	}
	
	en_top = { 
		x = 8,
		y = 240,
		ani = 0,
		ani_max = 8, 
		move = false, 
		spd = 0,
		bit = 1,
		shot_delay = 30,
		shot_timer = 0,
	}
	en_top_shots = {}
	
	if(new == 1) then 
		for b in all(blocks_top) do
			mset(b.x, b.y, 114)
		end
		
		pickups_top = {}
		blocks_top = {}
		blocks_top_generate()
		pickups_top_generate()
	end
end

function top_clean()
	for b in all(blocks_top) do
		mset(b.x, b.y, 114)
	end
end

function pickups_top_generate()
	local tx_min = 1
	local tx_max = 14
	local ty_min = 18
	local ty_max = 28
	local new_x = flr(rnd(tx_max - tx_min + 1)) + tx_min
	local new_y = flr(rnd(ty_max - ty_min + 1)) + ty_min
		
	for i = 1, levels[currentlevel].pickups, 1 do
		local valid = false
		
		repeat
			new_x = flr(rnd(tx_max - tx_min + 1)) + tx_min
			new_y = flr(rnd(ty_max - ty_min + 1)) + ty_min
		
			if not tile_solid(new_x, new_y) then
				if not ((new_x > 96) and (new_x < 104) and (new_y > 144) and (new_y < 152)) then
					if not ( (new_x > 23) and (new_x < 32) and (new_y > 288) and (new_y < 296) ) then
						valid = true
					end
				end
			end
		until valid
	
		if valid == true then
			add(pickups_top, { x = new_x*8, y = (new_y*8)+8, spr = 32, tx = new_x, ty = new_y})
		end
	end
end

function pickups_top_draw() 
	for i = #pickups_top, 1, -1 do
		spr(pickups_top[i].spr, pickups_top[i].x, pickups_top[i].y)
		
		-- Debug: draw collision corners
        if(debug_top == true) then
			pset(pickups_top[i].x, pickups_top[i].y, 8)        -- top-left (red)
			pset(pickups_top[i].x+7, pickups_top[i].y, 11)     -- top-right (orange)
			pset(pickups_top[i].x, pickups_top[i].y+7, 12)     -- bottom-left (green)
			pset(pickups_top[i].x+7, pickups_top[i].y+7, 14)   -- bottom-right (yellow)
		end
	end
end

function pickups_top_collision()
	for i = #pickups_top, 1, -1 do
		pl_x = player_top.x
		pl_y = player_top.y
		en_x = pickups_top[i].x
		en_y = pickups_top[i].y
		
		if(en_x + 8 > pl_x) and (en_x < pl_x + 6) and (en_y + 8> pl_y) and (en_y < pl_y + 9) then 
			deli(pickups_top, i)
			player_general.score += 10
			sfx_play(8)
		end
	end
end

function blocks_top_generate()
	local tx_min = 1
	local tx_max = 14
	local ty_min = 18
	local ty_max = 28
	local new_x = flr(rnd(tx_max - tx_min + 1)) + tx_min
	local new_y = flr(rnd(ty_max - ty_min + 1)) + ty_min
	
	for i = 1, levels[currentlevel].blocks_top, 1 do
		local valid = false
		
		repeat
			new_x = flr(rnd(tx_max - tx_min + 1)) + tx_min
			new_y = flr(rnd(ty_max - ty_min + 1)) + ty_min
		
			if not tile_solid(new_x, new_y) then
				if not ((new_x > 96) and (new_x < 104) and (new_y > 144) and (new_y < 152)) then
					if not ( (new_x > 23) and (new_x < 32) and (new_y > 288) and (new_y < 296) ) then
						valid = true
					end
				end
			end
		until valid
	
		if valid == true then
			mset(new_x, new_y, 96)
			add(blocks_top, { x = new_x, y = new_y })
		end
	end
end

function goals_draw() 
	-- 25 = empty safe
	-- 26 == player + safe
	-- 27 == empty goal
	-- 28 == player + goal
	local goalspr = 25
	local madespr = 27
		
	if(player_top.safe == true) then goalspr = 26 end
	spr(goalspr, top_goals.safe_x, top_goals.safe_y)
	
	if(top_goals.made == true) then
		--if(top_goals.goal_x + 8 > player_top.x) and (top_goals.goal_x < player_top.x + 6) and (top_goals.goal_y + 8> player_top.y) and (top_goals.goal_y < player_top.y + 9) then 
		if(top_goals.goal_x + 8 > player_top.x + 3) and (top_goals.goal_x < player_top.x + 5) and (top_goals.goal_y + 8 > player_top.y) and (top_goals.goal_y < player_top.y + 8) then
 			madespr = 28
			top_goals.comp = true
		end
		spr(madespr, top_goals.goal_x, top_goals.goal_y)
	end
end

function top_hud_draw()
	-- Lives --
	print("l:", 1, 128, 7)
	for i = 1, player_general.lives, 1 do
		print(chr(137), 2 + (i * 8), 128, 7)
	end
	
	-- Score --
	print ("s:"..player_general.score, 64, 128, 7)
	
	-- Danger Move -- 
	print ("d:"..player_general.d, 110, 128, 7)
end
