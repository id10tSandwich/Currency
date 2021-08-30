minetest.register_chatcommand("money", { --Done
    description = "/money shows you your banks amount",
    privs = {interact=true},
    func = function(name, param)
        check_money_amount(name)
    end
})

minetest.register_chatcommand("pay", { --Done
    description = "/pay <name> <amount> pay someone money",
    privs = {interact=true},
    func = function(name, param) 
        local player = param:split(' ')[1]
        local money = param:split(' ')[2]
        if player == nil or money == nil then
            minetest.chat_send_player(name, "[Server] pls use it the right way /pay <name> <amount>")
            return
        end
        money_transection(name, player, money)
    end
})
 
minetest.register_chatcommand("add_money", { --Done
    description = "/add_money <name> <amounth> adds someone money",
    privs = {money_god=true},
    func = function(name, param)
        local player = param:split(' ')[1]
        local amount = param:split(' ')[2]
        if player == nil or amount == nil then
            minetest.chat_send_player(name, "[Server] pls use it the right way /add_money <name> <amount>")
            return
        end
        give_money_admin(name, player, amount)
    end
})

minetest.register_chatcommand("set_money", { --Done
    description = "/set_money <name> <amount> set's someones money amount",
    privs = {money_god=true},
    func = function(name, param)
        local player = param:split(' ')[1]
        local amount = param:split(' ')[2] 
        if player == nil or amount == nil then
            minetest.chat_send_player(name, "[Server] pls use it the right way /set_money <name> <amount>")
            return
        end
        set_money(name, player, amount)
    end
}) 

minetest.register_chatcommand("setting", { --Done
    description = "/setting <setting> <new setting> allows you to change settings",
    privs = {server=true},
    func = function(name, param)
        local setting = param:split(' ')[1]
        local input = param:split(' ')[2]
        if setting == nil or input == nil then
            minetest.chat_send_player(name, "[Server] pls use it the right way /setting <setting> <new setting>")
            return
        end    
        make_settings(name, setting, input)
    end 
})
  