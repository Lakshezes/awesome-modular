-- displays CPU usage by listening to the daemon's broadcast

local wibox = require("wibox")

local cpu_widget = wibox.widget{
    widget = wibox.widget.textbox,
    text = " CPU --",
}

awesome.connect_signal("signal::cpu", function (usage)
    cpu_widget.text = string.format(" CPU %3d%%", usage)    
end)

return cpu_widget