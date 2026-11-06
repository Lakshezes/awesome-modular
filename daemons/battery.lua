-- daemons/battery.lua — collects battery capacity + charging state, broadcasts it.

local awful = require("awful")
local gears = require("gears")

local function parse(out)
    -- `cat` of both files prints two lines:
    --    87
    --    Charging
    local values = {}
    for word in out:gmatch("[^%s]+") do
        values[#values + 1] = word
    end

    -- first word = capacity (a STRING like "87"), rest = status.
    -- "rest", because the kernel can report "Not charging" — TWO words.
    -- table.concat joins words 2..end back into one string.
    local capacity = tonumber(values[1])
    local status   = table.concat(values, " ", 2)

    if not (capacity and status ~= "") then return end   -- never crash the WM

    awesome.emit_signal("signal::battery", capacity, status)
end

local function poll()
    awful.spawn.easy_async(
        { "cat",
          "/sys/class/power_supply/BAT0/capacity",
          "/sys/class/power_supply/BAT0/status" },
        function(stdout) parse(stdout) end)
end

poll()
gears.timer({ timeout = 30, autostart = true, callback = poll })