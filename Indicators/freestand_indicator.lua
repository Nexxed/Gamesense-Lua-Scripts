local ragebot_checkbox, ragebot_key = ui.reference("RAGE", "Aimbot", "Enabled")
local freestand_multi, freestand_key = ui.reference("aa", "anti-aimbot angles", "Freestanding")

client.set_event_callback("paint", function()
    if(ui.get(ragebot_checkbox) == true and ui.get(ragebot_key)) then
        if(ui.get(freestand_key)) then
            renderer.indicator(124, 220, 3, 255, "FS")
        --[[else -- uncomment this if you want the indicator to show even if freestanding isn't enabled
            renderer.indicator(255, 0, 0, 255, "FS")]]
        end
    end
end)