-- ~/.config/nvim/init.lua

-- ~/.config/yazi/init.lua
function Linemode:size_and_mtime()
    -- local time = math.floor(self._file.cha.mtime or 0)
    -- if time == 0 then
    --     time = ""
    -- elseif os.date("%Y", time) == os.date("%Y") then
    --     time = os.date("%b %d %H:%M", time)
    -- else
    --     time = os.date("%b %d  %Y", time)
    -- end

    local size = self._file:size()
    -- 显示全部内容，size + mtime
    -- return string.format("%s %s", size and ya.readable_size(size) or "-", time)
    -- 只显示时间
    -- return string.format("%s", time)
    return string.format("%s", size and ya.readable_size(size) or "-")
end
