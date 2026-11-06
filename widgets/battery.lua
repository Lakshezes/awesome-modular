-- widgets/battery.lua — displays battery state by listening to the daemon.
local wibox = require("wibox")

local battery_widget = wibox.widget{ widget = wibox.widget.textbox, text = " BAT --" }

awesome.connect_signal("signal::battery", function(capacity, status)
    local bolt = (status == "Charging") and "+" or ""
    battery_widget.text = string.format(" BAT %d%%%s", capacity, bolt)
end)

return battery_widget