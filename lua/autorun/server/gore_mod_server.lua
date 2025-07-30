hook.Add("EntityTakeDamage", "pai_do_reabilitado",function(npc, dmginfo) --gib script
    if npc:IsNPC() then
        npc.dmg_pos = dmginfo:GetDamagePosition()
        npc.dmg_type = dmginfo:GetDamageType()
        npc.attacker = dmginfo:GetAttacker()
        npc.weapon_sigma = dmginfo:GetWeapon()   
    end
end)
hook.Add("CreateEntityRagdoll", "Replace_shit_Ragdoll", function(owner, ragdoll)
    local hitposition = owner.dmg_pos
    print(owner.dmg_type)

    local hit = GetClosestPhysBone(ragdoll,hitposition)
    local bone = ragdoll:TranslatePhysBoneToBone(hit)
    local bone_name = ragdoll:GetBoneName( bone ) 	
    dismember_limb(ragdoll,bone_name,true)
end)

include( "gore_mod/function.lua" )
include( "gore_mod/hook.lua" )