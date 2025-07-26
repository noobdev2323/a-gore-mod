
hook.Add( "ScaleNPCDamage", "ScaleNPCDamageExample", function( npc, hitgroup, dmginfo )
    npc.dmg_pos = dmginfo:GetDamagePosition()
    npc.dmg_type = dmginfo:GetDamageType()
    npc.attacker = dmginfo:GetAttacker()
    npc.weapon_sigma = dmginfo:GetWeapon()

end)
hook.Add("CreateEntityRagdoll", "Replace_shit_Ragdoll", function(owner, ragdoll)
    local hitposition = owner.dmg_pos
    print(owner.dmg_type)
    if hitposition == nil and owner.attacker:GetWeapon( "weapon_lscs" ) then
        local pos = owner.attacker:GetBonePosition(owner.attacker:LookupBone("ValveBiped.Bip01_R_Hand"))
        hitposition = pos
    end
    local hit = GetClosestPhysBone(ragdoll,hitposition)
    local bone = ragdoll:TranslatePhysBoneToBone(hit)
    local bone_name = ragdoll:GetBoneName( bone ) 	
    dismember_limb(ragdoll,bone_name,true)
end)

include( "gore_mod/function.lua" )
include( "gore_mod/hook.lua" )