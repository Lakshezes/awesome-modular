-- Measures download spee don wlan0, broadcasts it 

local awful = require("awful")
local gears = require("gears")


local interface = "wlan0"
local interval = 1

local prev_rx, prev_tx, initialized = 0,0, false

local function parse(out)
    local values= {}
    for number in out:gmatch("%d+") do
        values[#values + 1] = tonumber(number)
    end

    local rx, tx = values[1], values[2] -- rx: total bytes received 
    if not (rx and tx) then return end -- tx: total bytes transmitted 


    if not initialized then
        prev_rx, prev_tx, initialized = rx, tx, true
        return
    end

    local d_rx = math.max(rx - prev_rx, 0)
    local d_tx = math.max(tx - prev_tx, 0)
    prev_rx,prev_tx = rx,tx

    awesome.emit_signal("signal::network", d_rx/interval, d_tx/interval)
end

local function poll()
    awful.spawn.easy_async(
        { "cat",
          ("/sys/class/net/%s/statistics/rx_bytes"):format(interface),
          ("/sys/class/net/%s/statistics/tx_bytes"):format(interface) },
        function(stdout) parse(stdout) end)
end

poll()
gears.timer({timeout = interval, autostart = true, callback = poll})

