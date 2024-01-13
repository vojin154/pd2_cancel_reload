local save_path = SavePath .. "cancel_reload.txt"
local settings = {
    primary_cancel = true,
    secondary_cancel = true
}

function Load()
    local file = io.open(save_path, "r")
    if file then
        settings = json.decode(file:read("*all"))
        file:close()
    end
end

function Save()
    local file = io.open(save_path, "w+")
    if file then
        file:write(json.encode(settings))
        file:close()
    end
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_cancel_reload", function(loc)
    loc:add_localized_strings( {
        ["cancel_reload_menu_title"] = "CANCEL RELOAD",

        ["cancel_reload_primary_title"] = "PRIMARY BUTTON",
        ["cancel_reload_primary_desc"] = "Cancel reloading using the PRIMARY BUTTON (LEFT MOUSE CLICK)",

        ["cancel_reload_secondary_title"] = "SECONDARY BUTTON",
        ["cancel_reload_secondary_desc"] = "Cancel reloading using the SECONDARY BUTTON (RIGHT MOUSE CLICK)",
    } )
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_cancel_reload", function(menu_manager, nodes)
    Load()

    local main_menu_id = "cancel_reload"

    MenuHelper:NewMenu(main_menu_id)

    MenuCallbackHandler.callback_primary_cancel_reload = function(self, item)
        settings.primary_cancel = (item:value() == "on" and true or false)
        Save()
    end

    MenuCallbackHandler.callback_secondary_cancel_reload = function(self, item)
        settings.secondary_cancel = (item:value() == "on" and true or false)
        Save()
    end

    MenuHelper:AddToggle({
        id = "primary_cancel_reload",
        title = "cancel_reload_primary_title",
        desc = "cancel_reload_primary_desc",
        callback = "callback_primary_cancel_reload",
        value = settings.primary_cancel,
        menu_id = main_menu_id,
        priority = 2
    })

    MenuHelper:AddToggle({
        id = "secondary_cancel_reload",
        title = "cancel_reload_secondary_title",
        desc = "cancel_reload_secondary_desc",
        callback = "callback_secondary_cancel_reload",
        value = settings.secondary_cancel,
        menu_id = main_menu_id,
        priority = 1
    })

    nodes[main_menu_id] = MenuHelper:BuildMenu(main_menu_id, {area_bg = "none"})
    MenuHelper:AddMenuItem(nodes["blt_options"], main_menu_id, "cancel_reload_menu_title", "")
end)

function MenuCallbackHandler.cancel_reload_status()
    return settings
end