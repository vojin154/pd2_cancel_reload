function PlayerStandard:cancel_reload()
    if self:_is_reloading() then --i mean the interupt action function already kinds of checks it but better be safe than sorry ig
        local weapon = self._equipped_unit:base()
        if weapon:clip_not_empty() then --so you dont completely stop the auto reload when trying to shoot forcing you to reload manually
            self:_interupt_action_reload()
            self._ext_camera:play_redirect(self:get_animation("idle")) --cancel the reload animation
        end
    end
end

Hooks:PostHook(PlayerStandard, "_check_action_primary_attack", "_check_action_primary_attack_cancel_reload", function(self, t, input, params)
    if (not input) or (not MenuCallbackHandler.cancel_reload_status().primary_cancel) then --check if input exists and cancelling reload when shooting is allowed
        return
    end

    local primary_btn = input.btn_primary_attack_state or input.btn_primary_attack_release --check for input

    if primary_btn then --just to make sure it doesnt run every frame even tho no button is pressed
        self:cancel_reload()
    end
end)


Hooks:PreHook(PlayerStandard, "_start_action_steelsight", "_start_action_steelsight_cancel_reload", function(self, t, gadget_state)
    if MenuCallbackHandler.cancel_reload_status().secondary_cancel then --check if cancelling reload when aiming is allowed
        self:cancel_reload()
    end
end)
