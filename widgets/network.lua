-- widgets/network.lua — shows live download/upload speed.
local wibox = require("wibox")

local network_widget = wibox.widget{ widget = wibox.widget.textbox, text = " ↓-- ↑--" }

-- humans don't read raw bytes: 1234 -> "1KB/s", 5678901 -> "5.4MB/s"
local function humanize(bps)
    if bps >= 1024 * 1024 then return string.format("%.1fMB/s", bps / 1024 / 1024) end
    if bps >= 1024         then return string.format("%dKB/s",  math.floor(bps / 1024)) end
    return string.format("%dB/s", math.floor(bps))
end

awesome.connect_signal("signal::network", function(rx, tx)
    network_widget.text = string.format(" ↓%s ↑%s", humanize(rx), humanize(tx))
end)

return network_widget