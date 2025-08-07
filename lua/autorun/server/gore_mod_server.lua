hook.Add("EntityTakeDamage", "pai_do_reabilitado",function(npc, dmginfo) --gib script
    if npc:IsNPC() then
        npc.dmg_pos = dmginfo:GetDamagePosition()
        npc.dmg_type = dmginfo:GetDamageType()
        npc.dmg_force = dmginfo:GetDamageForce()
    end
end)
hook.Add("CreateEntityRagdoll", "Replace_shit_Ragdoll", function(owner, ragdoll)
    if owner.is_madness_combat_npc == true then return end
    local dmg_data = {
        dmg_type = owner.dmg_type,
        dmg_pos = owner.dmg_pos,
        dmg_force = owner.dmg_force
    }
    local hit = GetClosestPhysBone(ragdoll,dmg_data.dmg_pos)
    local bone = ragdoll:TranslatePhysBoneToBone(hit)
    local bone_name = ragdoll:GetBoneName( bone ) 	
    dismember_limb(ragdoll,bone_name,dmg_data,true)
end)

include( "gore_mod/function.lua" )
include( "gore_mod/hook.lua" )