# Note
Using `esp_base.lua` is essential for using this script, even if you're a developer because your scripts will build on-top of the base and should already have the basic ESP features like Name, Flags, Health, Ammo.etc and they all are customizable.

# Documentation

## Dependancies
- [surface.ljbc](https://github.com/Aviarita/surface) by [**Aviarita**](https://github.com/Aviarita)

## esp.set_box_scale(scale)
##### `scale` is a number between `0` and `20`.

## esp.add_box(entindex, color, outline_color)
##### `entindex` is the entity index you're drawing for.
##### `color` is a table containing RGBA values of the box color: `{255, 255, 255, 255}`
##### `outline_color` is just like the color parameter, except for the box outline instead.

## esp.add_text(entindex, position, color, font, text[, flash])
##### `entindex` is the entity index you're drawing for.
##### `position` can be one of the following: `top`, `left`, `right`, `bottom`
##### `color` is a table containing RGBA values of the text color: `{255, 255, 255, 255}`
##### `font` is a font generated using the surface library.
##### `text` is the text to draw.
##### `text_flash` is a boolean for flashing text.

## esp.add_bar(entindex, position, color, outline_color, percentage[, text, text_color, text_font, text_flash])
##### `entindex` is the entity index you're drawing for.
##### `position` can be one of the following: `left`, `right`, `bottom` (there's no top yet)
##### `color` is a table containing RGBA values of the bar color: `{255, 255, 255, 255}`
##### `outline_color` is just like the color parameter, except for the bar outline instead.
##### `percentage` is a number between `0` and `100` indicating the progress of the bar.
##### `text` is the text to draw on the bar when the `percentage` parameter is less than `90`.
##### `text_color` is a table containing RGBA values of the bar text color: `{255, 255, 255, 255}`
##### `text_font` is a font generated using the surface library.
##### `text_flash` is a boolean for a flashing bar.

## esp.add_gradient_bar(entindex, position, color1, color2, outline_color, percentage[, text, text_color, text_font, text_flash])
##### `entindex` is the entity index you're drawing for.
##### `position` can be one of the following: `left`, `right`, `bottom` (there's no top yet)
##### `color1` is a table containing RGBA values of the first color of the bar's gradient: `{255, 255, 255, 255}`
##### `color2` is a table containing RGBA values of the second color of the bar's gradient: `{255, 255, 255, 255}`
##### `outline_color` is just like the color parameter, except for the bar outline instead.
##### `percentage` is a number between `0` and `100` indicating the progress of the bar.
##### `text` is the text to draw on the bar when the `percentage` parameter is less than `90`.
##### `text_color` is a table containing RGBA values of the bar text color: `{255, 255, 255, 255}`
##### `text_font` is a font generated using the surface library.
##### `text_flash` is a boolean for a flashing gradient bar.

# Example
### Adding two bars and some text at two specific directions:
```lua
local esp = require("esp") -- esp.ljbc
local surface = require("surface") -- surface.ljbc (https://github.com/Aviarita/surface)

-- create the font for our example
local testfont = renderer.create_font("Small Fonts", 8, 400, {0x010, 0x200})

-- this function gets called every frame
client.set_event_callback("paint", function()

    -- get and loop through each player in esp.get_players()
    -- this is recommended over the default entity.get_players() function
    for k,player in pairs(esp.get_players()) do

        -- add some text to the left of the player ESP
        -- all directions = left, right, top, bottom
        esp.add_text(player, "left", [180, 230, 30, 255], testfont, "gamesense", true)
        --        the player  dir           color           font     text        flash

        -- add a bar to the left of the player (this will still be before the text we placed above)
        esp.add_bar(player, "left", [180, 230, 30, 255], [0, 0, 0, 255], 50)
        --       the player  dir           color          outline color  %

        -- add a gradient bar to the left of the player (this will be placed after the bar we placed above)
        esp.add_gradient_bar(player, "left", [ [180, 230, 30, 255], [255, 0, 0, 255] ], [0, 0, 0, 255], 50)
        --                the player  dir       gradient color #1   gradient color #2    outline color  %

    end

end)
```
*Note: If you add text params to bars, they will only be shown if % is less than 90.*

*Weapons have not been tested but they **should** work, in theory.*