hook.Add( "noob_gore_gap", "do gib gap", function(ragdoll,model,bone)
    if bone == "ValveBiped.Bip01_Head1" then
        bonemerge_prop(ragdoll,"models/noob_dev2323/gib/l4d/head_gore2.mdl")  
    elseif bone == "ValveBiped.Bip01_L_Hand" then
        bonemerge_prop(ragdoll,"models/noob_dev2323/gib/l_arm.mdl")  
    elseif bone == "ValveBiped.Bip01_R_Hand" then
        bonemerge_prop(ragdoll,"models/noob_dev2323/gib/r_arm.mdl")  
    elseif bone == "ValveBiped.Bip01_R_Foot" then
        bonemerge_prop(ragdoll,"models/noob_dev2323/gib/r_foot.mdl")  
    elseif bone == "ValveBiped.Bip01_L_Foot" then
        bonemerge_prop(ragdoll,"models/noob_dev2323/gib/l_foot.mdl")  
    elseif bone == "ValveBiped.Bip01_L_UpperArm" then
        bonemerge_prop(ragdoll,"models/noob_dev2323/gib/upperarm_l.mdl")  
    elseif bone == "ValveBiped.Bip01_R_UpperArm" then
        bonemerge_prop(ragdoll,"models/noob_dev2323/gib/upperarm_r.mdl")  
    elseif bone == "ValveBiped.Bip01_R_Calf" then
        bonemerge_prop(ragdoll,"models/noob_dev2323/gib/r_leg_gap.mdl")  
    elseif bone == "ValveBiped.Bip01_L_Calf" then
        bonemerge_prop(ragdoll,"models/noob_dev2323/gib/l_leg_gap.mdl")  
    elseif bone == "ValveBiped.Bip01_L_Forearm" then
        bonemerge_prop(ragdoll,"models/noob_dev2323/gib/upperarm_l.mdl")  
    elseif bone == "ValveBiped.Bip01_R_Forearm" then
        bonemerge_prop(ragdoll,"models/noob_dev2323/gib/upperarm_r.mdl")  
    end
end )