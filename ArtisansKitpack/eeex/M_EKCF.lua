-- Artisan's Eldritch Knight: preserve inherited armour-casting exemptions on images.
-- Invoked only by the patched PROJIMAG / SIMULACR image-initialization spells.
function EKCLNFIX(invoke, sprite)
    if not sprite then return end
    local base=sprite.m_baseStats
    local kit=base.m_mageSpecUpperWord*65536+base.m_mageSpecialization
    local symbol=EEex_Resource_KitIDSToSymbol(kit)
    if symbol~='C0EK' and symbol~='C0EK_SORC' then return end
    local image=false
    local protected={}
    EEex_Utility_IterateCPtrList(sprite.m_timedEffectList,function(effect)
        if effect.m_effectId==237 and (effect.m_dWFlags==2 or effect.m_dWFlags==3) then
            image=true
        elseif effect.m_effectId==318 and effect.m_durationType==9
            and effect.m_effectAmount==0 and effect.m_dWFlags==0 then
            local resource=effect.m_res:get():upper()
            if resource=='C0ARCAS1' or resource=='C0ARCAS2' then protected[resource]=true end
        end
    end)
    if not image then return end
    local removed=0
    EEex_Utility_IterateCPtrList(sprite.m_equipedEffectList,function(effect)
        if effect.m_effectId==177 and effect.m_durationType==2
            and effect.m_effectAmount==0 and effect.m_dWFlags==2
            and effect.m_sourceType==2 and protected[effect.m_res:get():upper()]
            and effect.m_done==0 then
            -- Let the engine unlink/free the effect; never edit the CPtrList while iterating.
            effect.m_done=1
            removed=removed+1
        end
    end)
    if removed>0 then
        print('[EK clone fix] cleared '..removed..' inherited-exempt armour restriction(s) on image '..sprite.m_id)
    end
end
