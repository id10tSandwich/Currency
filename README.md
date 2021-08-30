# Currency
## Made by xXNicoXx
### Minetest mod
Minetest currency mod (api good write for modders and codders) [WIP] Release 1.0.0

# EXAMPLE OF HOW TO USE THIS API
***Use ````get_money(name, amount)```` to add money to someones acc***
````lua
--Example 1
minetest.register_chatcommand("get_coin", {
    description = "Gives you randomly 100 coins that you can see with /money",
    privs = {server=true},
    func = function(name, param)
        get_money(name, 100)
    end
})

--Example 2
minetest.register_chatcommand("get_coin", {
    description = "Gives you randomly 100 coins that you can see with /money",
    privs = {server=true},
    func = function(name, param)
        local amount = 100
        get_money(name, amount)
    end
})

--Both gonna do the same it dosn't matter if it's a chatmod or a block you mine or monster you kill :)
````
