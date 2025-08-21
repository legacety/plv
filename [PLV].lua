local vkeys = require("vkeys")
local ffi = require("ffi")
local samp = require("samp.events")

local active = false

ffi.cdef[[
    void keybd_event(uint8_t bVk, uint8_t bScan, uint32_t dwFlags, uintptr_t dwExtraInfo);
]]

local function pressKey(key)
    ffi.C.keybd_event(key, 0, 0, 0)
end

local function releaseKey(key)
    ffi.C.keybd_event(key, 0, 2, 0)
end

function samp.onShowDialog(id)
    if active and id == 3010 then
        sampSendDialogResponse(id, 1, 0, "")
        active = false
        sampAddChatMessage("[{B19CD9}PLV{FFFFFF}] {00FF00}Автоответ сработал, скрипт отключён.", -1)
    end
end

local function toggle()
    active = not active
    local stateText = active and "{00FF00}включён" or "{FF0000}выключен"
    sampAddChatMessage(string.format("[{B19CD9}PLV{FFFFFF}] Режим %s.", stateText), -1)
end

function main()
    repeat wait(0) until isSampAvailable()
    sampRegisterChatCommand("plv", toggle)

    while true do
        wait(0)
        if active then
            pressKey(vkeys.VK_MENU)
            wait(0)
            releaseKey(vkeys.VK_MENU)
        end
    end
end
