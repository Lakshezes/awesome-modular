-- entry point, Awesome executes this file top-to-bottom 

local gears = require("gears") -- timers, tables and filesys utilities
local awful = require("awful") -- windowx, tage, keys 
local wibox = require("wibox") -- widgent containers
local beautiful = require("beautiful") -- theme engine

require("daemons")
local cpu_widget = require("widgets.cpu")
local ram_widget = require("widgets.ram")
local battery_widget = require("widgets.battery")


beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

local modkey = "Mod4" -- super
local terminal = "kitty"

-- layouts available on each tag 
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
}

-- 5 tags on the primary screen
awful.tag({ "1", "2", "3", "4", "5" }, screen.primary, awful.layout.layouts[1])

-- Global keybindings
globalkeys = gears.table.join(
    -- THE most important key: reload config, windows stay open
    awful.key({ modkey, "Shift" }, "r", awesome.restart),
    -- open a terminal
    awful.key({ modkey }, "Return", function() awful.spawn(terminal) end)
)
root.keys(globalkeys)

-- Rules = how new windows are treated. This one says: focus every new
-- window and place it without overlapping, fully on-screen.
awful.rules.rules = {
    { rule = {},
      properties = {
          focus = awful.client.focus.filter,
          raise = true,
          placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      } },
}

-- Build the status bar. Runs once per screen.
awful.screen.connect_for_each_screen(function(s)
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 26 })

    -- align.horizontal = [ left | center | right ]
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            cpu_widget,
            ram_widget,
            battery_widget,
            
        },
        {widget = wibox.widget.textbox}, -- placeholder
        wibox.widget.textclock(),        -- right: a live clock
    }
end)
