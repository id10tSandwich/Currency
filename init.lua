dofile(minetest.get_modpath("currency").."/api.lua")
dofile(minetest.get_modpath("currency").."/commands.lua")

 
minetest.register_chatcommand("get_coin", {
    func = function(name, param)
        get_money(name, 100)
    end
})  