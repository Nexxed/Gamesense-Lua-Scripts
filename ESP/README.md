# [Example](esp_example.lua) Rules
If you plan on using the example as a base, **don't sell or compile it** if you release it, it's here for educational purposes (hence the comments!)
# Documentation

## ESP.SetBoxScale(scale)
### `scale` is a number between `0` and `20`.

## ESP.AddBox(entindex, color, outline_color)
### `entindex` is the entity index you're drawing for.
### `color` is a table containing RGBA values of the box color: `{255, 255, 255, 255}`
### `outline_color` is just like the color parameter, except for the box outline instead.

## ESP.AddText(entindex, position, color, font, text)
### `entindex` is the entity index you're drawing for.
### `position` can be one of the following: `top`, `left`, `right`, `bottom`
### `color` is a table containing RGBA values of the text color: `{255, 255, 255, 255}`
### `font` is a font generated using the surface library.
### `text` is the text to draw.

## ESP.AddBar(entindex, position, color, outline_color, percentage, text, text_color, text_font)
### `entindex` is the entity index you're drawing for.
### `position` can be one of the following: `left`, `right`, `bottom` (there's no top yet)
### `color` is a table containing RGBA values of the bar color: `{255, 255, 255, 255}`
### `outline_color` is just like the color parameter, except for the bar outline instead.
### `percentage` is a number between `0` and `100` indicating the progress of the bar.
### `text` is the text to draw on the bar when the `percentage` parameter is less than `90`.
### `text_color` is a table containing RGBA values of the bar text color: `{255, 255, 255, 255}`
### `text_font` is a font generated using the surface library.

## ESP.AddGradientBar(entindex, position, color1, color2, outline_color, percentage, text, text_color, text_font)
### `entindex` is the entity index you're drawing for.
### `position` can be one of the following: `left`, `right`, `bottom` (there's no top yet)
### `color1` is a table containing RGBA values of the first color of the bar's gradient: `{255, 255, 255, 255}`
### `color2` is a table containing RGBA values of the second color of the bar's gradient: `{255, 255, 255, 255}`
### `outline_color` is just like the color parameter, except for the bar outline instead.
### `percentage` is a number between `0` and `100` indicating the progress of the bar.
### `text` is the text to draw on the bar when the `percentage` parameter is less than `90`.
### `text_color` is a table containing RGBA values of the bar text color: `{255, 255, 255, 255}`
### `text_font` is a font generated using the surface library.