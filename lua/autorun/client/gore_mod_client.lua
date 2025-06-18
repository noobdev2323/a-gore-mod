/*
net.Receive( "gore_mode_do_bone_shit", function( len, ply )
    local ragdoll = net.ReadEntity()
    if IsValid(ragdoll) then
        ragdoll.main_penis = ragdoll:LookupBone( "ValveBiped.Bip01_Head1" )
    end
end )
hook.Add("OnEntityCreated", "sigma_bone_move", function(ent)
    if IsValid(ragdoll) and ragdoll:IsRagdoll() then
        local bone = ragdoll:LookupBone( "ValveBiped.Bip01_Head1" )
	
        if not bone then 
            return
        end
        ragdoll:ManipulateBonePosition(bone, Vector pos, boolean networking = true )
    end
end)
*/
