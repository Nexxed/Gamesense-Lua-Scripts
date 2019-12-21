local function safeRequire(mod, link)
    local status, err, ret = pcall(require, mod)
    local retval = status == true and err or false

    if(retval == false) then
        client.log(string.format("[PriorityOnKey] %s doesn't exist. The script won't use any of its functions. (%s)", mod, link))
    end

    return retval
end

local notify = safeRequire("notify", "https://gamesense.pub/forums/viewtopic.php?id=8929")

-- playerlist stuff for flags
local rbot, rbot_key = ui.reference("RAGE", "Aimbot", "Enabled")
local playerlist = ui.reference("PLAYERS", "Players", "Player list")
local whitelisted = ui.reference("PLAYERS", "Adjustments", "Add to whitelist")
local disable_visuals = ui.reference("PLAYERS", "Adjustments", "Disable visuals")
local high_priority = ui.reference("PLAYERS", "Adjustments", "High priority")

local script = {
    enabled = ui.new_checkbox("RAGE", "Aimbot", "Prioritize target"),
    key = ui.new_hotkey("RAGE", "Aimbot", "Prioritize target key", true),
    notifications = ui.new_checkbox("RAGE", "Aimbot", "Prioritize notifications")
}

function can_draw_player(entindex)
    local loc = entity.get_local_player()
    local loc_team = entity.get_prop(loc, "m_iTeamNum")
    local loc_obstarget = entity.get_prop(loc, "m_hObserverTarget")
    local ply_team = entity.get_prop(entindex, "m_iTeamNum")
    local obs_team = entity.get_prop(loc_obstarget, "m_iTeamNum")

    return entity.is_alive(entindex) and loc_team ~= ply_team and ply_team ~= obs_team and loc_obstarget ~= entindex
end

function get_players()
    local players = {}

    local function get_distance(from, to, unit)
        local xDist, yDist, zDist = to[1] - from[1], to[2] - from[2], to[3] - from[3]

        local mult, divide = 0, 0
        if(unit ~= nil and unit == "feet") then
            mult = 2
            divide = 30.48
        end

        return math.sqrt( (xDist ^ 2) + (yDist ^ 2) + (zDist ^ 2) ) * mult / divide
    end


    for entindex = 1, globals.maxplayers() do
        local name = entity.get_player_name(entindex)
        if(name ~= "unknown" and can_draw_player(entindex)) then
            table.insert(players, entindex)
        end
    end

    if(entity.is_alive(entity.get_local_player())) then
        table.sort(players, function(a, b)
            local loc = { entity.get_prop(entity.get_local_player(), "m_vecAbsOrigin") }
            local dist_a = get_distance(loc, { entity.get_prop(a, "m_vecOrigin") }, "feet")
            local dist_b = get_distance(loc, { entity.get_prop(b, "m_vecOrigin") }, "feet")

            return dist_a < dist_b
        end)
    end

    return players
end

local priority = {}
client.set_event_callback("run_command", function(c)
    client.update_player_list()
    priority = {}

    ui.set_visible(script.notifications, ui.get(script.enabled))

    if not ui.is_menu_open() then
        for _, v in pairs(entity.get_players(true)) do
            ui.set(playerlist, v)
            priority[v] = ui.get(high_priority)
        end
    else
        local selected_player = ui.get(playerlist)
        if(selected_player ~= nil and selected_player ~= 0) then
            priority[selected_player] = ui.get(high_priority)
        end
    end
end)

local lastUpdate = 0
client.set_event_callback("paint", function()
    if(notify ~= false) then
        notify:listener()
    end

    if(ui.get(rbot) and ui.get(rbot_key) and ui.get(script.enabled)) then
        local players = get_players()

        for _,player in pairs(players) do
            local x1, y1, x2, y2, alpha = entity.get_bounding_box(player)
            if(alpha >= 1) then
                local screen_x, screen_y = client.screen_size()
                local xhair, yhair = screen_x / 2, screen_y / 2

                if(xhair >= x1 and xhair <= x2 and yhair >= y1 and yhair <= y2) then
                    local print_x = x1 + (x2 - x1) / 2
                    local print_y = y1 + (y2 - y1) / 2

                    if(ui.get(script.key) and lastUpdate < client.timestamp() - 500) then
                        ui.set(playerlist, player)
                        ui.set(high_priority, not priority[player])
                        lastUpdate = client.timestamp()

                        if(notify ~= false and ui.get(script.notifications) == true) then
                            notify.add(2, true, {
                                255, 255, 255,
                                string.format(
                                    "%s priority for player ",
                                    priority[player] == false and "Added" or "Removed"
                                )
                            }, {
                                128, 196, 12,
                                entity.get_player_name(player)
                            })
                        end
                    end
                end
            end
        end
    end
end)