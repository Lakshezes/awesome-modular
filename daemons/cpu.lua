-- collects CPU usage, broadcasts it 
-- widgets never read themselves; they subscribe to "signal::cpu"

local awful = require("awful")
local gears = require("gears")

local previous_total, previous_idle = 0,0

local function parse(out)
    local first_line = out and out:match("^cpu%s+([%d%s]+)")
    if not first_line then return end -- must not crash WM

    local i, total, idle = 0,0,0
    for number in first_line:gmatch("%d+") do
        i = i + 1
        number = tonumber(number)
        total = total + number
        if i == 4 or i ==5 then idle = idle + number end
    end

    local d_total = total - previous_total -- time passed since last poll 
    local d_idle = idle - previous_idle
    previous_total, previous_idle = total,idle 

    if d_total > 0 then
        awesome.emit_signal("signal::cpu", math.floor((1 - d_idle / d_total) * 100 + 0.5))
    end
end

local function poll()
    -- easy_async = run the command WITHOUT blocking the UI;
    -- when it finishes, call parse() with whatever it printed
    awful.spawn.easy_async({ "cat", "/proc/stat" }, function(stdout)
        parse(stdout)
    end)
end

-- Poll once immediately, then every 2 seconds forever
poll()
gears.timer({timeout = 2, autostart = true, callback = poll})

