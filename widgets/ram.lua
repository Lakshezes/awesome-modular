-- widgets/ram.lua — displays RAM usage by listening to the daemon.
local wibox = require("wibox")

local ram_widget = wibox.widget{ widget = wibox.widget.textbox, text = " RAM --" }

awesome.connect_signal("signal::ram", function(percent, used, total)
    ram_widget.text = string.format(" RAM %3d%%", percent)
end)

return ram_widget