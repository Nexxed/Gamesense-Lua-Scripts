-- this example is for V2, not V1
-- you'll need to disable the original visuals before using this otherwise they'll overlap

-- we require the ESP v2 lib (named esp.ljbc in the CS:GO directory)
local ESP = require("esp")

-- surface lib is required: https://github.com/Aviarita/surface
local surface = require("surface")

-- for our flags
local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

-- this is where we define our fonts using the surface library
local fonts = {
    ["name"] = renderer.create_font("Verdana", 14, 500, {0x010, 0x080}),
    ["clantag"] = renderer.create_font("Verdana", 12, 400, {0x010, 0x080}),
    ["side_text"] = renderer.create_font("Small Fonts", 8, 400, {0x010, 0x200}),
    ["bar_text"] = renderer.create_font("Small Fonts", 8, 400, {0x010, 0x200})
}

-- all of our custom references for all the options this script contains
-- you can add more of course
local refs = {
    ["scale"] = ui.new_slider("VISUALS", "Player ESP", "Custom scale", 0, 20, 0, true),
    ["box"] = ui.new_checkbox("VISUALS", "Player ESP", "Bounding box"),
    ["box_color"] = ui.new_color_picker("VISUALS", "Player ESP", "Name color", 255, 255, 255, 255),
    ["name"] = ui.new_checkbox("VISUALS", "Player ESP", "Name"),
    ["name_color"] = ui.new_color_picker("VISUALS", "Player ESP", "Name color", 255, 255, 255, 255),
    ["name_truncate"] = ui.new_slider("VISUALS", "Player ESP", "Name truncation", 5, 20, 10, true),
    ["clantag"] = ui.new_checkbox("VISUALS", "Player ESP", "Clantag"),
    ["clantag_color"] = ui.new_color_picker("VISUALS", "Player ESP", "Clantag color", 255, 255, 255, 255),
    ["weapon"] = ui.new_checkbox("VISUALS", "Player ESP", "Weapon text"),
    ["weapon_color"] = ui.new_color_picker("VISUALS", "Player ESP", "Weapon text color", 255, 255, 255, 255),
    ["health"] = ui.new_checkbox("VISUALS", "Player ESP", "Health bar"),
    ["health_color"] = ui.new_color_picker("VISUALS", "Player ESP", "Health bar color", 180, 230, 30, 255),
    ["location"] = ui.new_checkbox("VISUALS", "Player ESP", "Location"),
    ["location_color"] = ui.new_color_picker("VISUALS", "Player ESP", "Location color", 255, 255, 255, 255),
    ["flags"] = ui.new_multiselect("VISUALS", "Player ESP", "Flags", "Lethal"), -- feel free to add more flags, this is merely a placeholder
    ["flags_color"] = ui.new_color_picker("VISUALS", "Player ESP", "Flags color", 180, 230, 30, 255)
}

-- comment this out if you want to change when to cap the player name based on length
ui.set_visible(refs.name_truncate, false)

-- comment this out if you want to adjust the size/scale of the visuals
ui.set_visible(refs.scale, false)

-- this anonymous callback function will be called every frame
client.set_event_callback("paint", function()
    -- we set the ESP scale to the one given by the slider reference
    ESP.SetBoxScale(ui.get(refs.scale))

    -- loop through each player
    for k, player in pairs(entity.get_all("CCSPlayer")) do
        local a, b, c, d, alpha = entity.get_bounding_box(player)

        -- we dont want to confuse the player with dormant results, especially if they're not fading
        -- fade on dormant can be implemented though, just uncomment this and handle the alphas accordingly!
        if(alpha > 0) then
            -- local stuff
            local local_player = entity.get_local_player()
            local local_weapon = entity.get_player_weapon(local_player)
            local local_weapon_ammo = {total = entity.get_prop(local_weapon, "m_iClip2") or -1}

            local player_resource = entity.get_player_resource()                    -- this is required for the players clantag
            local player_name = entity.get_player_name(player)                      -- this is for the players name
            local player_weapon = entity.get_player_weapon(player)                  -- this is for the players weapon
            local clantag = entity.get_prop(player_resource, "m_szClan", player)    -- this is for the players clantag
            local health = entity.get_prop(player, "m_iHealth")                     -- this is for the players health
            local last_place = entity.get_prop(player, "m_szLastPlaceName")         -- this is for the players location

            -- truncate the name and append three dots to indicate it has been truncated
            if(#player_name > ui.get(refs.name_truncate)) then
                player_name = string.format("%s...", player_name:sub(1, ui.get(refs.name_truncate)))
            end

            -- add a bounding box to the player
            if(ui.get(refs.box)) then
                ESP.AddBox(player, {ui.get(refs.box_color)}, {0, 0, 0, 150})
            end

            -- add the players name to the top
            if(ui.get(refs.name)) then
                ESP.AddText(player, "top", {ui.get(refs.name_color)}, fonts.name, string.upper(player_name))
            end

            -- add the players clantag above their name (if enabled, otherwise it'll just be drawn above the bounding box)
            if(ui.get(refs.clantag) and clantag ~= nil and #clantag > 1) then
                ESP.AddText(player, "top", {ui.get(refs.clantag_color)}, fonts.clantag, clantag:match("^%s*(.-)%s*$"))
            end

            -- add weapon text using class names (ghetto way)
            if(ui.get(refs.weapon) and player_weapon ~= nil) then
                ESP.AddText(player, "bottom", {ui.get(refs.weapon_color)}, fonts.side_text, entity.get_classname(player_weapon):gsub("CWeapon", ""):gsub("CC4", "C4"):upper())
            end

            -- add the players last known location
            if(ui.get(refs.location) and last_place ~= nil and #last_place > 1) then
                ESP.AddText(player, "right", {ui.get(refs.location_color)}, fonts.side_text, string.upper(last_place))
            end

            -- basically a check to see if they're alive, I was lazy though
            if(health ~= nil) then

                -- add the players health bar to the left side of the bounding box
                if(ui.get(refs.health)) then
                    ESP.AddGradientBar(player, "left", {0, 0, 0, 255}, {ui.get(refs.health_color)}, {0, 0, 0, 150}, health, health, {255, 255, 255, 255}, fonts.bar_text)
                end

                -- lethal flag - it'll show when you're holding either of the three weapons and the player is a one-hit (weapon damage dependant)
                if(has_value(ui.get(refs.flags), "Lethal") and local_weapon ~= nil) then
                    local_weapon = entity.get_classname(local_weapon) -- get the class of the current weapon

                    -- check if the current weapon is one of three and if so, check if health is a lethal amount (if the target is visible of course)
                    if((local_weapon == "CWeaponSCAR20" or local_weapon == "CWeaponG3SG1" or local_weapon == "CWeaponSSG08") and health < 80) then
                        ESP.AddText(player, "right", {ui.get(refs.flags_color)}, fonts.side_text, "LETHAL")
                    end
                end
            end
        end
    end
end)