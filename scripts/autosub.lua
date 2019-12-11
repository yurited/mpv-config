-- default keybinding: b
-- add the following to your input.conf to change the default keybinding:
-- keyname script_binding auto_load_subs
local utils = require 'mp.utils'

function display_error()
  mp.msg.warn("Subtitle download failed: ")
  mp.osd_message("Subtitle download failed")
end

function load_sub_fn()
  path = mp.get_property("path")
  srt_path = string.gsub(path, "%.%w+$", ".en.srt")
  zh_srt_path = string.gsub(path, "%.%w+$", ".zh.srt")
  t = { args = { "subliminal", "download", "-f", "-l", "en", "-l", "zh", path } }

  mp.osd_message("Searching subtitle")
  res = utils.subprocess(t)
  if res.error == nil then
    -- add zh srt
    mp.commandv("sub_add", zh_srt_path)
    -- then add en srt
    if mp.commandv("sub_add", srt_path) then
      mp.msg.warn("Subtitle download succeeded")
      mp.osd_message("Subtitle '" .. srt_path .. "' download succeeded")
    else
      display_error()
    end
  else
    display_error()
  end
end

mp.add_key_binding("b", "auto_load_subs", load_sub_fn)
