net.Receive("gore_mode_do_bone_shit", function()
    local ragdoll = net.ReadEntity()
    local bones_sigma_table = net.ReadTable()
    local main_sigma_bone = net.ReadString()
    if IsValid(ragdoll) then
        ragdoll.bone_gib_aids_shit = bones_table
        ragdoll.main_penis = main_bone
    end
end)
hook.Add("PrePlayerDraw", "HeadsUp", function(ply, flags)
    for _, ragdoll in ipairs(ents.GetAll()) do
        if IsValid(ragdoll) and ragdoll:IsRagdoll() and ragdoll.bone_gib_aids_shit then
            for i = 0, ragdoll:GetBoneCount()-1 do
                if ragdoll.bone_gib_aids_shit[i] ~= i then
                    local matrix = ragdoll:GetBoneMatrix(ragdoll.main_penis)
                    local pos = matrix:GetTranslation()
                    local ang = matrix:GetAngles()
                        
                    ragdoll:SetBonePosition( i, pos , ang )
                end
            end
        end
    end
end)