--      ██╗   ██╗ ██████╗ ██╗     ██╗   ██╗███╗   ███╗███████╗
--      ██║   ██║██╔═══██╗██║     ██║   ██║████╗ ████║██╔════╝
--      ██║   ██║██║   ██║██║     ██║   ██║██╔████╔██║█████╗
--      ╚██╗ ██╔╝██║   ██║██║     ██║   ██║██║╚██╔╝██║██╔══╝
--       ╚████╔╝ ╚██████╔╝███████╗╚██████╔╝██║ ╚═╝ ██║███████╗
--        ╚═══╝   ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================


local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local offsetx = dpi(56)
local offsety = dpi(300)
local screen = awful.screen.focused()
local icon_dir = gears.filesystem.get_configuration_dir() .. "/icons/volume/" .. beautiful.name .. "/"


-- ===================================================================
-- Appearance & Functionality
-- ===================================================================


local volume_icon = wibox.widget {
   width = dpi(40),
   height = dpi(40),
   widget = wibox.widget.imagebox
}

-- create the volume_adjust component
local volume_adjust = wibox({
   screen = awful.screen.focused(),
   x = screen.geometry.width - offsetx,
   y = (screen.geometry.height / 2) - (offsety / 2),
   width = dpi(48),
   height = offsety,
   shape = gears.shape.rounded_rect,
   visible = false,
   ontop = true
})

local volume_bar = wibox.widget{
   widget = wibox.widget.progressbar,
   shape = gears.shape.rounded_bar,
   color = "#efefef",
   background_color = beautiful.bg_focus,
   max_value = 100,
   value = 0
}

volume_adjust:setup {
   layout = wibox.layout.align.vertical,
   {
      wibox.container.margin(
         volume_bar, dpi(14), dpi(20), dpi(20), dpi(20)
      ),
      forced_height = offsety * 0.75,
      direction = "east",
      layout = wibox.container.rotate
   },
   wibox.container.margin(
      volume_icon,
      dpi(4), dpi(4), dpi(4), dpi(4)
   )
}

-- create a 4 second timer to hide the volume adjust
-- component whenever the timer is started
local hide_volume_adjust = gears.timer {
   timeout = 4,
   autostart = true,
   callback = function()
      volume_adjust.visible = false
   end
}

-- show volume-adjust when "volume_change" signal is emitted
awesome.connect_signal("volume_change",
   function()
      -- set new volume value
      awful.spawn.easy_async_with_shell(
         "wpctl get-volume @DEFAULT_SINK@",
         function(stdout)
            local muted_pos = string.find(stdout, "MUTED")
            local volume_level = 0
            local is_on = true
            if muted_pos == nil then
              volume_level = tonumber(string.sub(stdout, 9))
            else
              is_on = false
              muted_pos, _ = muted_pos
              volume_level = tonumber(string.sub(stdout, 9, muted_pos - 3))
            end
            if volume_level == nil then
               volume_level = 0
            end
            volume_level = volume_level * 100

            if volume_level > 100 then
              volume_bar.background_color = "#900603"
              volume_level = volume_level - 100
            else
              volume_bar.background_color = beautiful.bg_focus
            end
            volume_bar.value = volume_level

            if is_on then
               volume_icon:set_image(icon_dir .. "volume.png")
            else
               volume_icon:set_image(icon_dir .. "volume-off.png")
            end
         end,
         false
      )

      -- make volume_adjust component visible
      if volume_adjust.visible then
         hide_volume_adjust:again()
      else
         volume_adjust.visible = true
         hide_volume_adjust:start()
      end
   end
)
