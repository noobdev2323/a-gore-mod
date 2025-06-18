net.Receive( "gore_mode_do_bone_shit", function( len, ply )
    local ragdoll = net.ReadEntity()
    if IsValid(ragdoll) then
        ragdoll.main_penis = ragdoll:LookupBone( "ValveBiped.Bip01_Head1" )
    end
end )
hook.Add("PrePlayerDraw", "sigma_bone_move", function(ply, flags)
    for _, ragdoll in ipairs(ents.GetAll()) do
        if IsValid(ragdoll) and ragdoll:IsRagdoll() and ragdoll.main_penis then
            for i = 0, ragdoll:GetBoneCount()-1 do
                print(ragdoll)
                if ragdoll.main_penis ~= i then
                    local matrix = ragdoll:GetBoneMatrix(ragdoll.main_penis)
                    local pos = matrix:GetTranslation()
                    local ang = matrix:GetAngles()
                        
                    ragdoll:SetBonePosition( i, pos , ang )
                end
            end
        end
    end
end)