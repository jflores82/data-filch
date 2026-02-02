function sfx_play(sfxi)
	sfxi = sfxi or -1
	if(player_general.sfx == 1) then
		sfx(sfxi)
	end
	
	-- SFX List: 
	-- 0 : Player Die
	-- 1 : Player jump
	-- 2 : Interface cursor move
	-- 3 : Interface confirm
	-- 4 : Interface deny
	-- 5 : Player Steps
	-- 6 : Side Complete
	-- 7 : Top Enemy Fire
	-- 8 : Top Pickup
	-- 9 : Top Complete
	
end

function music_play(musici)
	musici = musici or 20
	music(-1)
	if(player_general.music == 1) then 
		music(musici)
	end
	
	-- Music List: 
	-- 00 : Title Screen
	-- 04 : Game Over 
	-- 05 : Side View
	
end
