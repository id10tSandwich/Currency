local colorize = minetest.colorize
local storage = minetest.get_mod_storage()


minetest.register_privilege("money_god", {
    description = "Can give others money from nowhere :O",
    give_to_singleplayer = true
})  
--------------------------------------
--------------------------------------
--------------------------------------
-----[WIP] More settings comming------
local settings = {
    "money_name",
    "amount_join" 
}
function set_settings(name, setting, input)
    local data = load_money_settings()
    minetest.chat_send_player(name, colorize("#c3ee3e", "[Server] Setting "..setting.." was set to "..input))
    data[setting] = input
    save_money_settings(data)
end
-----[WIP] More settings comming------
-------------------------------------- 
--------------------------------------
--------------------------------------

--Save datas to modstorage
function save_player_money(data_money) 
    if type(data_money) == "table" then
        storage:set_string("money", minetest.serialize(data_money))
    end
    --not needed
    --data_money = {}
end
 
--Get general modstorage
function load_player_money()
    local data_money = storage:get_string("money")
    if data_money then
        data_money = minetest.deserialize(data_money)
        --extra check needed
        if type(data_money) ~= "table" then
            data_money = {} 
        end
    else 
        data_money = {}
    end
    return data_money
end
 

--Save settings to modstorage
function save_money_settings(data) 
    if type(data) == "table" then
        storage:set_string("settings", minetest.serialize(data))
    end
end
 
--Get settings from modstorage
function load_money_settings()
    local data = storage:get_string("settings")
    if data then
        data = minetest.deserialize(data)
        --extra check needed
        if type(data) ~= "table" then
            data = {}
        end
    else
        data = {} 
    end
    return data 
end

minetest.register_on_joinplayer(function(player)
    local data_money = load_player_money()
    local name = player and player:get_player_name()
    if data_money[name] == nil then
        local setting_data = load_money_settings()
        local money_name = setting_data["money_name"] or "$"
        local amount_join = setting_data["amount_join"] or 0
        data_money[name] = amount 
        minetest.chat_send_player(name, colorize("#c3ee3e", "[Server] Added "..amount_join..""..money_name.." to your bank"))
        save_player_money(data_money)
    end 
end)

function check_money_amount(name)
    local money_data = load_player_money()
    local settings_data = load_money_settings()
    local coin_name = settings_data["money_name"] or "$"
    local own_bank = money_data[name] or 0 
    minetest.chat_send_player(name, colorize("#c3ee3e", "[Server] Your currently having "..own_bank..""..coin_name))
end

function money_transection(name, player, money)
    local data = load_player_money()
    local setting_data = load_money_settings()
    local name2 = minetest.get_player_by_name(player)
    local own_bank = data[name] or 0
    local player_bank = data[player] or 0
    local coin_name = setting_data["money_name"] or "$"

    if name2 == nil then
        minetest.chat_send_player(name, colorize("#ff0000", "[Server] Error player needs to be online"))
        return
    end
    if name == player then
        minetest.chat_send_player(name, colorize("#ff0000", "[Server] Error you can't send your self money"))
        return
    end
        
    if type(tonumber(money)) ~= "number" or money == "nan" or money == "-nan" or money == "+nan" then
        minetest.chat_send_player(name, colorize("#00ffff", "[Server] This is not a number"))
        return  
    end 

    --Check if the user has enought money
    if tonumber(money) > tonumber(own_bank) then
        minetest.chat_send_player(name, colorize("#ff0000", "[Server] You don't have enought money to sent "..money.."$ you currently have "..own_bank.."$"))
        return
    end

    if tonumber(money) <= 0 then
        minetest.chat_send_player(name, colorize("ff0000", "[Server] Your need a minimum of 1"..coin_name.." to send someone money with /pay"))
        return
    end

    local own_new_amount = tonumber(own_bank - tonumber(money))
    local player_new_amount = tonumber(player_bank + tonumber(money)) 
    ----------
    minetest.chat_send_player(player, colorize("#c3ee3e", "[Server] You received "..money..""..coin_name.." from "..name))  
    minetest.chat_send_player(name, colorize("#c3ee3e", "[Server] You successfully send "..money..""..coin_name.." to "..player))
    ----------
    data[name] = own_new_amount
    data[player] = player_new_amount 
    save_player_money(data)
end  



--This function allows you to build a own way of getting money by mining or by killing monsters for example
function get_money(name, amount)
    local data = load_player_money()
    local setting_data = load_money_settings()
    local coin_name = setting_data["money_name"] or "$"
    if name == nil then 
        return
    end
    if amount == nil then
        return
    end
    if type(tonumber(amount)) ~= "number" or amount == "nan" then 
        return
    end  
    local current_bank = data[name]  
    if data[name] == nil then
        data[name] = 0
        current_bank = 0
        save_player_money(data)  
    end  
 
    data[name] = tonumber(current_bank + amount)
    save_player_money(data) 
end 

function give_money_admin(name, player, amount)
    local data = load_player_money()
    local setting_data = load_money_settings()
    local money_name = setting_data["money_name"] or "$" 
    local pname = minetest.get_player_by_name(player)
    if pname == nil then 
        minetest.chat_send_player(name, colorize("#ff0000", "[Server] Error player needs to be online"))
        return
    end 
    local player_current_bank = data[player] 
    if amount == nil or amount == "nan" then
        minetest.chat_send_player(name, colorize("#ff0000", "[Server] No amount given"))
        return
    end
    
    if type(tonumber(amount)) ~= "number" then
        minetest.chat_send_player(name, colorize("#ff0000", "[Server] This is not a number"))
        return
    end

    if player_current_bank == nil then
        data[amount] = 0
        player_current_bank = 0
        save_player_money(name)
    end

    data[player] = tonumber(player_current_bank + amount)
    minetest.chat_send_player(name, colorize("#c3ee3e", "[Server] You added "..amount.." "..money_name.." to "..player.."'s bank"))
    save_player_money(data)
end

function set_money(name, player, amount)
    local data = load_player_money() 
    local pname = minetest.get_player_by_name(player) 
    if pname == nil then
        minetest.chat_send_player(name, colorize("#ff0000", "[Server] Player needs to be online"))
        return 
    end  
    if type(tonumber(amount)) ~= "number" then
        minetest.chat_send_player(name, colorize("#ff0000", "[Server] This is not a number"))
        return 
    end
    data[player] = tonumber(amount)
    save_player_money(data)
end  
    

function make_settings(name, input, input2)
    local trigger = true
    for _, setting in pairs(settings) do
        if setting == input then 
            trigger = false
            break
        end 
    end 
    -----------------------------------
    -----------------------------------
    --Dumb way of doing things but whatever
    if trigger == false then
        if input == "amount_join" then
            if type(tonumber(input2)) ~= "number" or input2 == "nan" then
                minetest.chat_send_player(name, colorize("#ff0000", "[Server] "..input2.." is not a number"))
                return
            end 
        end 
        set_settings(name, input, input2) 
    end
    -----------------------------------
    -----------------------------------
end 
