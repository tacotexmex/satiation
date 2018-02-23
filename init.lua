
-- Vars
local modpath = minetest.get_modpath(minetest.get_current_modname()) .. "/"
local hudbars = minetest.get_modpath("hudbars") or false
local timer = 0
--local movement_speed_walk = tonumber(minetest.settings:get("movement_speed_walk")) or 4

dofile(modpath .. "hunger_monoid.lua")

-- Functions

-- Registrations
minetest.register_on_joinplayer(function(player)
	hb.init_hudbar(player, "satiation")
	if not tonumber(player:get_attribute("satiation")) then
		player:set_attribute("satiation", 20)
		player:set_attribute("metabolism", 0.05)
	end
	playereffects.apply_effect_type("regen", 999999999999999999999999999, player)
end)

minetest.register_on_respawnplayer(function(player)
	player:get_attribute("satiation", 20)
	player:get_attribute("metabolism", 0.05)
end)

if hudbars then
	hb.register_hudbar("satiation",
		0xFFFFFF,
		"satiation",
		{
			bar = "nyctophobia_bar.png",
			icon = "default_stone.png^[mask:farming_bread.png",
			bgicon = "farming_bread.png"
		},
		20, 20,
		false,
		"%s: %.1f/%.1f")
end

minetest.register_privilege("satiated", {
	description = "Immune to hunger",
	give_to_singleplayer = false,
})

minetest.register_on_priv_grant(function(name, granter, priv)
	if priv == "satiated" then
		local player = minetest.get_player_by_name(name)
		player:set_attribute("satiation", 20)
		if hudbars then hb.change_hudbar(player, "satiation", 20) end
	end
end)

playereffects.register_effect_type("regen", "Regeneration", "heart.png", {"health"},
	function(player)
		if not minetest.check_player_privs(player, "satiated") then
			local satiation = tonumber(player:get_attribute("satiation"))
			local metabolism = tonumber(player:get_attribute("metabolism"))
			satiation = satiation - metabolism
			player:set_attribute("satiation", satiation)
			hb.change_hudbar(player, "satiation", satiation)
		end
	end,
	nil, true, false, 1
)
