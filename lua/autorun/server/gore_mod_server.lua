
hook.Add( "ScaleNPCDamage", "ScaleNPCDamageExample", function( npc, hitgroup, dmginfo )
    npc.dmg_pos = dmginfo:GetDamagePosition()
end)
hook.Add("CreateEntityRagdoll", "Replace_shit_Ragdoll", function(owner, ragdoll)
    local hitposition = owner.dmg_pos
    local hit = GetClosestPhysBone(ragdoll,hitposition)
    local bone = ragdoll:TranslatePhysBoneToBone(hit)
    local bone_name = ragdoll:GetBoneName( bone ) 	
    gib_PhysBone(ragdoll,bone_name)
    hook.Call( "noob_gore_gap", nil,ragdoll,ragdoll:GetModel(),bone_name) --call this hook to make cap based on bone name
    decap_ragdoll(ragdoll,bone_name)
end)

include( "gore_mod/function.lua" )
include( "gore_mod/hook.lua" )