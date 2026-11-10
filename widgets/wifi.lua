-- widgets/wifi.lua — displays Wi-Fi state by listening to the daemon.
local wibox = require("wibox")

local wifi_widget = wibox.widget{ widget = wibox.widget.textbox, text = " WIFI --" }

awesome.connect_signal("signal::wifi", function(quality, ssid, connected)
    if not connected then
        wifi_widget.text = " WIFI off"   -- offline is a display state too
        return                           -- early return: we're done, skip the rest
    end
    wifi_widget.text = string.format(" WIFI %d%%", quality)
end)

return wifi_widget