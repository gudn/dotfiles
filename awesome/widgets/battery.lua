--      ██████╗  █████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗
--      ██╔══██╗██╔══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝
--      ██████╔╝███████║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝
--      ██╔══██╗██╔══██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝
--      ██████╔╝██║  ██║   ██║      ██║   ███████╗██║  ██║   ██║
--      ╚═════╝ ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝

-------------------------------------------------
-- Battery Widget for Awesome Window Manager
-- Shows the battery status using the ACPI tool
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/battery-widget

-- @author Pavel Makhov
-- @copyright 2017 Pavel Makhov
-------------------------------------------------


-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local naughty = require("naughty")
local clickable_container = require("widgets.clickable-container")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi

local PATH_TO_ICONS = os.getenv("HOME") .. "/.config/awesome/icons/battery/"


-- ===================================================================
-- Widget Creation
-- ===================================================================


local widget = wibox.widget {
   {
      id = "icon",
      widget = wibox.widget.imagebox,
      resize = true
   },
   {
      id = "percentage",
      widget = wibox.widget.textbox,
      resize = true
   },
   layout = wibox.layout.fixed.horizontal
}

local widget_button = clickable_container(wibox.container.margin(widget, dpi(7), dpi(7), dpi(7), dpi(7)))
widget_button:buttons(
   gears.table.join(
      awful.button({}, 1, nil,
         function()
            awful.spawn(apps.power_manager)
         end
      )
   )
)

local function show_battery_warning()
   naughty.notify {
      icon = PATH_TO_ICONS .. "battery-alert.svg",
      icon_size = dpi(48),
      text = "Huston, we have a problem",
      title = "Battery is dying",
      timeout = 5,
      hover_timeout = 0.5,
      position = "top_right",
      bg = "#d32f2f",
      fg = "#EEE9EF",
      width = 248
   }
end

local last_battery_check = os.time()

watch("bash -c \"acpi | awk 'match($0, /Battery [0-9]+: ([a-zA-Z ]+), +([0-9]+)%/, arr) { printf \\\"%s:%s\\\", arr[1], arr[2] }'\"", 1,
   function(_, stdout)
      local space, _ = string.find(stdout, ":", 1, true)
      local status = string.sub(stdout, 1, space - 1)
      local charge = tonumber(string.sub(stdout, space + 1, -2))

      if charge == nil then
          charge = 0
      end

      if (charge >= 0 and charge < 15) then
         if status ~= "Charging" and os.difftime(os.time(), last_battery_check) > 300 then
            -- if 5 minutes have elapsed since the last warning
            last_battery_check = os.time()

            show_battery_warning()
         end
      end


      local battery_icon_name = "battery"

      if status == "Charging" then
         battery_icon_name = battery_icon_name .. "-charging"
      end

      local rounded_charge = math.floor(charge / 10) * 10
      if (rounded_charge == 0) then
         battery_icon_name = battery_icon_name .. "-outline"
      elseif (rounded_charge ~= 100) then
         battery_icon_name = battery_icon_name .. "-" .. rounded_charge
      end

      widget.icon:set_image(PATH_TO_ICONS .. battery_icon_name .. ".svg")
      widget.percentage:set_markup_silently(tostring(charge) .. "%")
      collectgarbage("collect")
   end,
   widget
)

return widget_button
