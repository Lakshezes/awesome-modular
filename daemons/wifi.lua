-- daemons/wifi.lua — Wi-Fi connection state + signal quality, broadcasts it.

local awful = require("awful")
local gears = require("gears")

local interface = "wlan0"

local function parse(out)
    -- the two lines we care about from `iw dev wlan0 link`:
    --     SSID: eduroam
    --     signal: -66 dBm
    -- when offline, the entire output is just:  Not connected.
    local ssid   = out:match("SSID:%s+(%S+)")
    local signal = out:match("signal:%s+(-?%d+)")  

    if not signal then
        awesome.emit_signal("signal::wifi", 0, "", false)   -- offline is data too
        return
    end

    -- dBm -> quality %: the standard heuristic maps -100 dBm -> 0%, -50 dBm -> 100%
    -- (linear in between). clamp() doesn't exist in Lua — this is the idiom:
    local quality = math.max(0, math.min(100, 2 * (tonumber(signal) + 100)))

    awesome.emit_signal("signal::wifi", quality, ssid or "?", true)
end

local function poll()
    awful.spawn.easy_async({ "iw", "dev", interface, "link" },
        function(stdout) parse(stdout) end)
end

poll()
gears.timer({ timeout = 5, autostart = true, callback = poll })