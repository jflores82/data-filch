pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--Data Filch
--by tibonev

-- debug -- REMEMBER TO DISABLE BEFORE RELEASE --
debug_side_en = false
debug_top_en = false

-------------------------------------------
-- ECHO DELETE BEFORE RELEASE 
--------------------------------------------
---------------------------debugging----------
-- echoes collection
echoes = {}

-- store a value to be printed
function echo(val)
  add(echoes,tostr(val))
end

-- print all echoes
-- ...opt: c (text color, default: latest)
-- ...opt: x,y (print coords)
function print_echoes(c, x, y)
	local cx, cy, cc = cursor()  --pen_x, pen_y, pen_color

	--set text position and color
	cursor(x or cx, y or cy, c or cc)
	for i=1,#echoes do
		print(tostr(echoes[i]))
	end

	--erase all echoes
	echoes = {}
end
-------------------------------------------------


-- Code Init --
function _init()
	init_vars()
	state_switch(currentstate)
end

function _draw()
	gamestate[currentstate]:draw()
end

function _update()
	gamestate[currentstate]:update()
end

function init_vars()
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
		rain = 0,
	}
	
	player_general = { 
		score = 0,
		lives = 3,
		music = 1,
		sfx = 1,
		d = 0,
		d_max = 4,
		d_cooldown = 0,
		d_cooldown_max = 30,
	}
	
	player_top = { 
		x = 96, 
		y = 152,
		flip = false,
		dir = 0,
		walk_ani = 0,  
		walk_max = 16,
		safe = true,
	}
	
	en_side = {}
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
	
	top_goals = { 
		safe_x = 96, 
		safe_y = 152, 
		made = false,
		comp = false,
		goal_x =  23,
		goal_y = 208,
	}
		
	pickups_top = {}
	blocks_top = {}
	
	game_states = { 
		intro = 0, 
		title_screen = 1, 
		side_play = 2, 
		side_death = 3,
		side_win = 4,
		top_play = 5, 
		top_death = 6,
		top_win = 7,
		gameover = 8,
		mainmenu = 9, 
		options = 10,
		tutorial = 11,
		credits = 12,
	}
	currentstate = 1
	currentlevel = 1
	
	levels = { 
		[1] = { 
			en_side_spd_min = 0.5,
			en_side_spd_max = 1,
			en_top_spd_max = 1,
			en_top_spd_delta = 0.1,
			en_top_shot_spd = 1,
			pickups = 5,
		},
		[2] = { 
			en_side_spd_min = 0.6,
			en_side_spd_max = 1.1,
			en_top_spd_max = 1.1,
			en_top_spd_delta = 0.1,
			en_top_shot_spd = 1,
			pickups = 5,
		},
		[3] = { 
			en_side_spd_min = 0.7,
			en_side_spd_max = 1.2,
			en_top_spd_max = 1.2,
			en_top_spd_delta = 0.2,
			en_top_shot_spd = 1.1,
			pickups = 5,
		},
		[4] = { 
			en_side_spd_min = 0.8,
			en_side_spd_max = 1.2,
			en_top_spd_max = 1.2,
			en_top_spd_delta = 0.3,
			en_top_shot_spd = 1.2,
			pickups = 6,
		},
		[5] = { 
			en_side_spd_min = 0.9,
			en_side_spd_max = 1.3,
			en_top_spd_max = 1.3,
			en_top_spd_delta = 0.4,
			en_top_shot_spd = 1.3,
			pickups = 6,
		},
		[6] = { 
			en_side_spd_min = 0.9,
			en_side_spd_max = 1.4,
			en_top_spd_max = 1.4,
			en_top_spd_delta = 0.5,
			en_top_shot_spd = 1.3,
			pickups = 6,
		},
		[7] = { 
			en_side_spd_min = 1.0,
			en_side_spd_max = 1.4,
			en_top_spd_max = 1.5,
			en_top_spd_delta = 0.5,
			en_top_shot_spd = 1.4,
			pickups = 7,
		},
		[8] = { 
			en_side_spd_min = 1.0,
			en_side_spd_max = 1.5,
			en_top_spd_max = 1.6,
			en_top_spd_delta = 0.6,
			en_top_shot_spd = 1.5,
			pickups = 8,
		},
		[9] = { 
			en_side_spd_min = 1.0,
			en_side_spd_max = 1.5,
			en_top_spd_max = 1.6,
			en_top_spd_delta = 0.7,
			en_top_shot_spd = 1.5,
			pickups = 10,
		},
		
	}
end

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

function en_side_update()
	
	local camx = player_side.x - 64
	local camy = player_side.y - 64
		
		
	if(count(en_side) < 2) then
		if(flr(rnd(20)) == 10) then
			add(en_side, {x = camx + 1, y = player_side.y + 2, type = 1, spd = levels[currentlevel].en_side_spd_max, anim = 0})
		end
		if(flr(rnd(20)) == 5) then 
			add(en_side, {x = camx + 1, y = player_side.y - 4, type = 2, spd = levels[currentlevel].en_side_spd_min, anim = 0})
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

--
-- TOP DOWN
--
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
		pickups_top = {}
		blocks_top = {}
		blocks_top_generate()
		pickups_top_generate()
	end
end

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
		if(player_top.walk_ani > 0 and player_top.walk_ani < 3) then playerspr = 1 end
		if(player_top.walk_ani >= 3 and player_top.walk_ani < 8) then playerspr = 0 end
		if(player_top.walk_ani >= 8 and player_top.walk_ani < 12) then playerspr = 1 end
		if(player_top.walk_ani >= 12 and player_top.walk_ani < 16) then playerspr = 0 end
	end
	
	
	if(player_top.dir == 2) then 
		if(player_top.walk_ani == 0) then playerspr = 14 end
		if(player_top.walk_ani > 0 and player_top.walk_ani < 3) then playerspr = 15 end
		if(player_top.walk_ani >= 3 and player_top.walk_ani < 8) then playerspr = 14 end
		if(player_top.walk_ani >= 8 and player_top.walk_ani < 12) then playerspr = 19 end
		if(player_top.walk_ani >= 12 and player_top.walk_ani < 16) then playerspr = 14 end
	end
	
	if(player_top.dir == 3) then 
		if(player_top.walk_ani == 0) then playerspr = 12 end
		if(player_top.walk_ani > 0 and player_top.walk_ani < 3) then playerspr = 13 end
		if(player_top.walk_ani >= 3 and player_top.walk_ani < 8) then playerspr = 12 end
		if(player_top.walk_ani >= 8 and player_top.walk_ani < 12) then playerspr = 18 end
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
		
	for i = 1, 10, 1 do
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
		if(top_goals.goal_x + 8 > player_top.x) and (top_goals.goal_x < player_top.x + 6) and (top_goals.goal_y + 8> player_top.y) and (top_goals.goal_y < player_top.y + 9) then 
			madespr = 28
			top_goals.comp = true
		end
		spr(madespr, top_goals.goal_x, top_goals.goal_y)
	end
end

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

------------------------------
-- HUD -----------------------
------------------------------
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
	

------------------------------
-- General / Misc Functions --
------------------------------
function tile_solid(tx,ty, flag)
	flag = flag or 0
	local t = mget(tx, ty)
	return fget(t, flag)
end

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
		
	--print("pl.x ="..player_top.x, 10,10 + 128,7)
	--print("pl.y ="..player_top.y, 10,18 + 128,7)
	--print("pl.walk_ani="..player_top.walk_ani, 10, 26 + 128, 7)
	--print("pl.dir="..player_top.dir, 10, 34 + 128, 7)
	--print("tile.x="..tilex, 10, 42 + 128, 7)
	--print("tile.y="..tiley, 10, 50 + 128, 7)
	--print("tile.col="..col, 10, 58+128, 7)
	--print("pickups="..#pickups_top, 10, 2, 7)
	--offsety = 10
	--for i = #pickups_top, 1, -1 do
	--	local tx = flr(pickups_top[i].x / 8)
	--	local ty = flr(pickups_top[i].y / 8) 
	--	print(i..":x="..pickups_top[i].x..":y="..pickups_top[i].y..":tx="..pickups_top[i].tx..":ty="..pickups_top[i].ty, 10, 128 + offsety, 7)
	--	offsety += 8
	--end
	--print("en_spd="..en_top.spd, 10, 128+10, 7)
	--print("en_ani="..en_top.ani, 10, 128+18, 7)
	
	
	
end

-------------------------
-- State Machine --------
-------------------------
function state_switch(newstate)
	currentstate = newstate 
	gamestate[currentstate]:enter()
end

-- state machine
gamestate = { 

	[1] = { -- title screen
		enter = function(self)
			self.i = 0
		end,
		
		update = function(self)
			self.i += 1 
			if(self.i >= 20) then self.i = 0 end
			
			if(btnp(4)) then
				state_switch(game_states.mainmenu)
			end
		end,
		
		draw = function(self) 
			cls()
			print("data filch", 44, 36, 11)
			print("(c) 2026 tibonev", 32, 120, 2)
			if(self.i > 10) then
				print("press 🅾️ / z", 40, 64, 6) 
			end
		end,
	},
	
	[2] = { -- sidescroll play
	
		enter = function(self)
			
		end,
	
		update = function(self)
			player_side_control()
			en_side_update()
			
			if(player_side.x < 8 and player_side.y > 100 and player_side.y < 110) then
				state_switch(game_states.side_win)
			end
		end,
		
		draw = function(self)
			cls()
			map()
			camera(player_side.x - 64, 0)
			player_side_draw()
			en_side_draw()
			side_rain_draw()
			side_hud_draw()
			
			if(debug_side_en == true) then 
				debug_side() 
			end
		end,
	},
	
	[3] = { --sidecroll death
			
		enter = function(self)
			self.pl = 0
		end,
	
		update = function(self)
			self.pl += 1
			if(self.pl > 50) then
				player_death_check()
				if(player_general.lives > 0) then 
					side_reset()
					state_switch(game_states.side_play)
				end
			end
		end,
	
		draw = function(self)
			cls()
			map()
			camera(player_side.x - 64, 0)
			player_side_death_draw(self.pl)
			en_side_draw()
			
			if(debug_side_en == true) then 
				debug_side() 
			end
		end
	},
	
	[4] = { --sidescroll complete 
		enter = function(self)
			self.i = 0
		end,
		
		update = function(self)
			self.i += 1
			if(self.i > 60) then
				top_reset(1)
				state_switch(game_states.top_play)
			end
		end, 
		
		draw = function(self)
			cls()
			map()
			camera(player_side.x - 64, 0)
			
			if(self.i >= 0 and self.i < 4) then spr(80, 0, 104) end
			if(self.i > 5 and self.i <= 8) then spr(81, 0, 104) end
			if(self.i > 8 and self.i <= 12) then spr(82, 0, 104) end
			if(self.i > 12 and self.i <= 16) then spr(83, 0, 104) end
			if(self.i > 16 and self.i <= 20) then spr(84, 0, 104) end
			if(self.i > 20 and self.i <= 24) then spr(85, 0, 104) end
			if(self.i > 24 and self.i <= 28) then spr(86, 0, 104) end
			if(self.i > 28 and self.i <= 32) then spr(87, 0, 104) end
			
		end
	}, 
	
	[5] = { --topdown play
		enter = function(self)
			
		end,
		
		update = function(self)
			player_top_control()
			pickups_top_collision()
			
			player_top_check_safe()
			
			en_top_control()
			en_top_shots_update()
			
			if(#pickups_top <= 0) then
				top_goals.made = true
			end
			
			if(top_goals.comp == true) then
				state_switch(game_states.top_win)
			end
		end,
		
		draw = function(self)
			cls()
			camera(0, 128)
			map(0, 15, 0, 128, 16, 16)
			pickups_top_draw()
			if(player_top.safe == false) then player_top_draw() end
			goals_draw()
			
			en_top_draw()
			en_top_shots_draw()
			
			top_hud_draw()
			
			print_echoes(7, 10, 150)
			if(debug_top_en == true) then
				--rect(8, 136, 119, 248, 12)  -- Your target area
				debug_top() 
			end
		end
	},
	
	[6] = { -- top death
		enter = function(self) 
			self.pl = 0
		end, 
		
		update = function(self) 
			self.pl += 1
			if(self.pl > 50) then
				player_death_check()
				top_reset()
				state_switch(game_states.top_play)
			end
		end, 
		
		draw = function(self) 
			cls()
			camera(0, 128)
			map(0, 15, 0, 128, 16, 16)
			pickups_top_draw()
			en_top_draw()
			en_top_shots_draw()
			player_top_death_draw(self.pl)
		end, 
	},
	
	[7] = { -- top complete
		enter = function(self)
			blocks_top = {}
			self.i = 0
		end, 
		
		update = function(self) 
			self.i += 1
			if(self.i >= 60) then
				if(currentlevel < 9) then currentlevel += 1 end
				side_reset()
				state_switch(game_states.side_play) 
			end
		end, 
		
		draw = function(self)
			cls()
			camera(0, 128)
			map(0, 15, 0, 128, 16, 16)
			pickups_top_draw()
			goals_draw()
		end,
	},
	[8] = { -- gameover 
		enter = function(self)
		
		end,
		
		update = function(self)
			if(btn(4)) then
				init_vars()
				state_switch(game_states.title_screen)
			end
		end,
		
		draw = function(self)
			cls()
			camera()
			print("game over yeah!", 35, 30, 7)
			print("press 🅾️ / z", 35, 100, 7)
			print("final score:"..player_general.score, 35, 50, 10)
		end,
	},
	[9] = { -- main menu 
		enter = function(self)
			self.i = 0 
		end,
		
		update = function(self)
			if(btnp(3)) and (self.i < 2) then 
				self.i += 1
			end
			if(btnp(2)) and (self. i > 0) then
				self.i -= 1
			end
			
			if(btnp(4)) then
				if(self.i == 0) then state_switch(game_states.side_play) end
				if(self.i == 1) then state_switch(game_states.options) end
				if(self.i == 2) then state_switch(game_states.tutorial) end
			end
		end,
				
		draw = function(self)
			local y = 50
			local ychr = y + (self.i * 8)
			cls()
			print("start game", 46, y, 7)
			print("options", 46, y + 8, 7) 
			print("instructions", 46, y+16, 7)
			
			print(chr(23), 38, ychr, 10)
		end,
	},
	[10] = { -- options
		enter = function(self)
			self.i = 0
			self.imax = 4
		end,
		
		update = function(self) 
			if(btnp(3)) and (self.i < (self.imax -1)) then 
				self.i += 1
			end
			if(btnp(2)) and (self. i > 0) then
				self.i -= 1
			end
			
			if(btnp(4)) then
				if(self.i == 2) then state_switch(game_states.credits) end
				if(self.i == 3) then state_switch(game_states.mainmenu) end
			end
			
			if(btnp(0)) then
				if(self.i == 0) then player_general.music = 0 end
				if(self.i == 1) then player_general.sfx = 0 end
			end
			
			if(btnp(1)) then
				if(self.i == 0) then player_general.music = 1 end
				if(self.i == 1) then player_general.sfx = 1 end
			end
		end,
		
		draw = function(self)
			local y = 50
			local ychr = y + (self.i * 8)
			
			cls()
			print("options", 54, 20, 11)
			
			print("music", 42, y, 7)
			print("sfx", 42, y+8, 7)
			print("credits", 42, y+16, 7)
			print("exit", 42, y+24, 7)
			
			print(chr(23), 35, ychr, 12)
			
			if(player_general.music == 1) then 
				print("on", 70, y, 11)
			else 
				print("off", 70, y, 10)
			end
			
			if(player_general.sfx == 1) then
				print("on", 70, y+8, 11)
			else	
				print("off", 70, y+8, 10)
			end
			
		end,
	},
	[11] = { -- instructions 
		enter = function(self)
			self.i = 0
			self.j = 0
		end,
		
		update = function(self)
			self.j += 1 
			if(self.j > 20) then self.j = 0 end
			
			if(btnp(4)) then self.i += 1 end
			if(self.i >= 3) then 
				state_switch(game_states.mainmenu)
			end
			
			if(btnp(5)) then state_switch(game_states.mainmenu) end
		end, 
		
		draw = function(self)
			cls()
			local y = 10
			if(self.i == 0) then 
				print("instructions", 25,y,8)
				print("the game is divided in 2 parts:", 0, y + (8*2), 7)
				print("sidescroll and top down sections", 0, y + (8*3), 7) 
				print("each part has unique controls", 0, y + (8*5), 7)
				print("and scoring systems.", 0, y + (8*6), 7)
				print(chr(142), 120, 120, 11)
			end
			
			if(self.i == 1) then
				print("controls system:", 25, y, 8)
				print("sidescroll:", 1, y + (8*2), 11)
				print(chr(139).." and "..chr(145)..":", 1, y + (8*3), 7)
				print("walk", 42, y + (8*3), 11)
				print(chr(131)..":",1 , y + (8*4), 7)
				print("crouch", 15, y + (8*4), 11)
				print(chr(142)..":", 1, y + (8*5), 7)
				print("jump", 15, y + (8*5), 11)
				
				print("topdown:", 1, y + (8*7), 11)
				print(chr(148).." "..chr(131).." "..chr(139).." "..chr(145)..":", 1, y + (8*8), 7)
				print("move", 50, y + (8*8), 11)
				spr(25, 1, y + (8*9))
				print(": safe capsule", 10, y + (8*9), 7)
				print(chr(142), 120, 120, 11)
			end
			
			if(self.i == 2) then
				print("scoring system:", 25, y, 8)
				print("sidescroll:", 1, y + (8*2), 11)
				print("gain points by walking right", 1, y + (8*3), 7)
				print("lose points by walking left", 1, y + (8*4), 7)
				print("near misses for multipliers", 1, y + (8*5), 7)
				print("indicated by the d value", 1, y + (8*6), 7)
			
				print("topdown:", 1, y + (8*8), 11)
				spr(32, 1, y + (8*9))
				print(": collect for points", 10, y + (8*9), 7)
				
				if(self.j > 10) then print("extra live every 30000 points", 1, y+(8*12), 10) end
				print(chr(142), 120, 120, 11)
			end
		end,
	},
	[12] = { 
		enter = function(self)
			self.i = 0
		end,
		
		update = function(self)
			if(btnp(4) or btnp(5)) then state_switch(game_states.options) end
			
			self.i += 1
			if(self.i >= 20) then self.i = 0 end
			
		end, 
		
		draw = function(self)
			local y = 10
			cls()
			print("credits", 25, y, 13)
			print("game created by", 1, y + (8*2), 7) 
			print("tibonev", 65, y + (8*2), 2)
			print("date: january 2026", 1, y + (8*3), 7)
			print("no ai of any kind was used", 1, y + (8*4), 7)
			print("visit:", 1, y + (8*6), 7)
			print("classicgames.com.br", 40, y + (8*6), 13)
			
			if(self.i > 10) then
				print("keep art and games human!", 15, y + (8*10), 8)
			end
			
			print("press any key", 35, y + (8*13), 11)
			
		end,
	}
}
-------------------------
-- DATA -----------------
-------------------------
__gfx__
00044000000440000000000000000000000000000000000000000000000000000000000000000e00000000000000000000044000000440000004400000044000
000f4000000f4000000000000004400000000000000000000000000000000000000000e0808000080800008008000000000ff000000ff0000004400000044000
000ff000000ff00000044000000f400000000000000cc000000000000000000000008000000000000000000e00000000000ff000000ff0000004400000044000
0005500000055000000f4000000ff000044f6c000006500000c5ff40000e8000008000000000000e000000000000000000655600006556000065560000655600
0005600000056600000ff0000005600004ff5c00000ff00000c6f4400008e00000000e0000e0000e000000000000000000655600000550000065560000055000
00056000000cc00000056000000cc000000000000004f000000000000000000000080000000008000000000000000000000550000005c000000550000005c000
000cc00000c00c0000065000000000000000000000044000000000000000000000000000800000000080000000000e00000cc000000cc000000cc000000cc000
000cc000000000c0000cc000000000000000000000000000000000000000000000000000000000000000800000000000000cc000000c0000000cc000000c0000
0900000000090000000440000004400000000031130000000000003113000000000aa00000666600006666000066660000666600000000000000000000000000
9690090000960900000ff000000440000000003113000000000000311300000000aaaa0006000560060445600600056006044560000000000000000000000000
0969989009609690000ff000000440000800003113000090090000311300008000aaaa0006005060060f506006005060060f5060000000000000000000000000
0955559009555590006556000065560003330031130033300333003113003330009779000c0500c00c05f0c00b0500b00b05f0b0000000000000000000000000
0969965909600b59000550000005500003b3031111303b3003b3031111303b30009aa9000c5005c00c5dd5c00b5005b00b5dd5b0000000000000000000000000
9690099000969990000c5000000c500003bb3bbbbbb3bb3003bb3bbbbbb3bb30009aa9000c0050c00c6d56c00b0050b00b6d56b0000000000000000000000000
0900000000090000000cc000000cc00003bbbb5555bbbb3003bbbb5555bbbb3000a99a00060500600605c060060500600605c060000000000000000000000000
00000000000000000000c0000000c000003b33555533b300003b33555533b3000090090006500060065cc06006500060065cc060000000000000000000000000
00000000000000000000000000000000000033333333000000003333333300000000000000000000000000000000000000000000000000000000000000000000
01111110000000000000000000000000001111111111110000111111111111000000000000000000000000000000000000000000000000000000000000000000
01cccc10000000000000000000000000013551111115531001355111111553100000000000000000000000000000000000000000000000000000000000000000
01c77c10000000000000000000000000115665155156651111566515515665110000000000000000000000000000000000000000000000000000000000000000
01cccc10000000000000000000000000115665155156651111566515515665110000000000000000000000000000000000000000000000000000000000000000
01cd5d10000000000000000000000000013551111115531001355111111553100000000000000000000000000000000000000000000000000000000000000000
001ddd10000000000000000000000000001111111111110000111111111111000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000001010100101010000010101101010000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
666666666666666655555555555555550000000000000000000000d0000000000000000000000000000550000000000000555500000000000000000000000000
66666666666666565666666556666665000000000000000000000d00000000000000000000000000000550000005550095566559000000000000000000000000
6666666666666566566666500566666500000080080000000000d000000000000000006000000000000550000056650009566590000000000000000000000000
666666666556666656666500005666658000080880800008000d00000000000000000c0000000000000550000056779090966909000000000000000000000000
66666666666566665dddd500005dddd508808000000808800000000000d0000000000000000000000005500005667a0909066090000000000000000000000000
66666666666666665ddddd5005ddddd50008000000008000000000000d000000000000000000000000055000005670a090055009000000000000000000000000
55555555555555555dddddd55dddddd5000000000000000000000000d0000000000000000c000000000550000005690a00055000000000000000000000000000
55555555555555555555555555555555000000000000000000000000000000000000000060000000000550000005500000055000000000000000000000000000
5444451154444511544445115444451154444511544445115444451154444511544445115444451165555555555555565d0770d55d0770d55d0770d555555555
d0000d116d00d6116dddd611600006116000061160000611600006116000061160000611600006115dddddddddddddd5dd7007d55d7007dd5d7007d5dddddddd
d0000d116d00d6116dddd6116dddd6116000061160000611600006116000061160000611600006115d700700007007d5dd7007d55d7007dd5d7007d507700770
d0000d116d00d6116dddd6116dddd6116dddd61160000611600006116000061160000611600006115d077077770770d5770770d55d0770775d0770d570077007
d0000d116d00d6116dddd6116dddd6116dddd6116dddd611600006116000061160000611600006115d077077770770d5770770d55d0770775d0770d570077007
d0000d116d00d6116dddd6116dddd6116dddd6116dddd6116dddd6116000061160000611600006115d700700007007d5007007d55d7007005d7007d507700770
d0000d116d00d6116dddd6116dddd6116dddd6116dddd6116dddd6116dddd61160000611600006115d7007dddd7007d5ddddddd55ddddddd5d7007d5dddddddd
5000051150000511500005115dddd5115dddd5115dddd5115dddd5115dddd5115dddd511500005115d0770d55d0770d555555556655555555d0770d555555555
88888888000000001111111111111111111111110008800011111111000880001111111100000000000000000000000000000000000000000000000000000000
44448444000000001111111111111111111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000000
44448444000000001111111115511551155115511551155119911551155115511111111100000000000000000000000000000000000000000000000000000000
88888888000000001111111115511551155115511551155119911551155115511818118800000000000000000000000000000000000000000000000000000000
88888888000000001111111111111111111111111111111111111111111111111811818100000000000000000000000000000000000000000000000000000000
48844444000000001111111115511551155119911551155115511991199115511111111100000000000000000000000000000000000000000000000000000000
48844444000000001111111115511551155119911551155115511991199115511111111100000000000000000000000000000000000000000000000000000000
48844444000000001111111111111111111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000000
555555555555555555555555d555555dd555555d00000000000000000004400000044000000bbb00000bb00000b00bb000000000000000000000000000000000
555555555dd55dd55d555d55d500000dd000005d000000000000000000044000000440000bb330b000bb3b00bb3bb30b00000000000000000000000000000000
5555555555d555555d555d55d050000dd000050d00000000000000000004400000044000b3b33b3b0b3b3bb0b03bb30b00000000000000000000000000000000
555555555555555555555555d005000dd000500d0000000000000000000440000004400000bbb00bb3b33b3b00b34b0000000000000000000000000000000000
555555555555d5555555d555d000500dd005000d000000000000000000044000000440000b044000bb33b33b00b440b000000000000000000000000000000000
5555555555555d5555555555d000050dd050000d00000000000000000055550000044000b0044000b33b4b3b0b04400b00000000000000000000000000000000
555555555d5555555d5555d5d000005dd500000d00000000000000000055550000044000000440000b0440bb0004400b00000000000000000000000000000000
555555555555555555555555d555555dd555555d00000000000000000055550000044000000440000004400b0004400000000000000000000000000000000000
ffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101020200000000000000000000000000000000000000000101010101010101000000000000000000000000000000010000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007070707072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff
61610000000000000000000000006567676565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070717070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff
61610000656500000000000000006363636363610000000000000000000067656500000000000000000000000000000000000000000000000000000000000000000070707072700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff
61616100636600000000000000006364636363000000000000000000000063666300000000000000004c0000000000000000004c000000000000000000000000000072707071700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff
61616161636300000000000000006363636363000000000000004c000000636363004b0000000000004a0000000000000000004a000000000000000000004b00000070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff
61616161636300000000000000006363636463000000006500004a000000636363004a0000000000004a00006700007a0000004a790000650000007b00004a00000071707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff
61616161666300000000000000006364636363610064666300004a007900636363004a7b00636463634a0063636300780000004a780063636300007800004a00686570707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff
67616100636300006700000000006363636364610063636300004a007777636463004a7700636363644a0066636400770000004a770064636300007700004a00636370717070720000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff
6363000063640063630000007f7f6363636363000063636300404140404140404040404040404041404040404041404040404040404040404040404040414040404070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff
636300006463006363000000004b6363646363000064636340617374616161616161616173746161617374616161747374616161616161616173746161616173746170727070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff
63634c006363006463006500004a64636363637a00636340740073747f0063636300656773746363637374636363747374670000670063636373740000000073746170707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff
68624a0063637a63666263667b4a6363636363780063407374007374647f64636300636373746366637374646363747374636363630063666373746700000073746170707072700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff
50624a006363776363626363774a6363636463770040417374637374630063636300636373746363637374636363747374636366630063636373746300000073746170707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff
4041404040404040404040404040404041404040407072707070707070707070727070707070707070707072707070707070707070707270707070707070707270707070707070ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5a5f5f5f5f5f5f5f5f5f5f5f5f5f5f5b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5e72707070707070707070707070705e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5e70707070707070707070707071705e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5e70707070727070727070707070705e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5e70707070707070707071707070705e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5e70707070707070707070707070705e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5e70707170707070707070727070705e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5e70707070707270707070707070705e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5e70707070707070707070707070705e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5e70707270707070707170707070705e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5e70707070707070707070707170705e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5e70707070707170707070707070705e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5e70707070707070707270707070705e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5e70717070707070707070707170705e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5e70707070727070707070707070705e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6161616161616161616161616161616100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
