
hook.Add( "ScaleNPCDamage", "ScaleNPCDamageExample", function( npc, hitgroup, dmginfo )
    npc.dmg_pos = dmginfo:GetDamagePosition()
end)
hook.Add("CreateEntityRagdoll", "Replace_shit_Ragdoll", function(owner, ragdoll)
    local hitposition = owner.dmg_pos
    local hit = GetClosestPhysBone(ragdoll,hitposition)
    local bone = ragdoll:TranslatePhysBoneToBone(hit)
    local bone_name = ragdoll:GetBoneName( bone ) 	
    dismember_limb(ragdoll,bone_name,true)
end)

include( "gore_mod/function.lua" )
include( "gore_mod/hook.lua" )