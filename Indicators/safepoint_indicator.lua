local ragebot_checkbox, ragebot_key = ui.reference("RAGE", "Aimbot", "Enabled")
local prefer_checkbox = ui.reference("RAGE", "Aimbot", "Prefer safe point")
local force_key = ui.reference("RAGE", "Aimbot", "Force safe point")

client.set_event_callback("paint", function()
    if(ui.get(ragebot_checkbox) == true and ui.get(ragebot_key)) then
        if(ui.get(force_key)) then
            renderer.indicator(124, 220, 3, 255, "SAFE")
        else
            if(ui.get(prefer_checkbox)) then
                renderer.indicator(255, 255, 0, 255, "SAFE")
            --[[else -- uncomment this if you want the indicator to show if prefer isn't enabled
                renderer.indicator(255, 0, 0, 255, "SAFE")]]
            end
        end
    end
end)