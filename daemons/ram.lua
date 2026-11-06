-- collects RAM usage, broadcasts it 

local awful = require("awful")
local gears = require("gears")

local function parse(out)
    local total = out:match("MemTotal:%s+(%d+)")
    local avail = out:match("MemAvailable:%s+(%d+)")

    if not (total and avail) then return end
    total, avail = tonumber(total), tonumber(avail)

    local used = total - avail 

    awesome.emit_signal("signal::ram",
        math.floor(used / total * 100 + 0.5), -- percent
        math.floor(used/1024),
        math.floor(total / 1024))
    
end


local function  poll()
    awful.spawn.easy_async({ "cat", "/proc/meminfo"}, function(stdout) parse(stdout) end)
end

poll()
gears.timer({ timeout = 3, autostart = true, callback = poll})


