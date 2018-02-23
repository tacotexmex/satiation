-- Standard effect monoids, to provide canonicity.

local function mult(x, y) return x * y end

local function mult_fold(elems)
	local tot = 1

	for _, v in pairs(elems) do
		tot = tot * v
	end

	return tot
end

local function v_mult(v1, v2)
	local res = {}

	for k, v in pairs(v1) do
		res[k] = v * v2[k]
	end

	return res
end

local function v_mult_fold(identity)
	return function(elems)
		local tot = identity

		for _, v in pairs(elems) do
			tot = v_mult(tot, v)
		end

		return tot
	end
end

-- Satiation monoid. Effect values are satiation multipliers.
satiation = {}
local monoid = player_monoids.make_monoid
satiation.metabolism_monoid = monoid({
	combine = mult,
	fold = mult_fold,
	identity = 1,
	apply = function(multiplier, player)
		local metabolism = tonumber(player:get_attribute("metabolism"))
		metabolism = multiplier
		minetest.chat_send_all(metabolism)
		player:set_attribute("metabolism",metabolism)
	end,
})
