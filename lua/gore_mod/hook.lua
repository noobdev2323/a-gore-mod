hook.Add( "noob_gore_gap", "Does something else", function(ragdoll,model,bone)
    if bone == "ValveBiped.Bip01_Head1" then
        bonemerge_prop(ragdoll,"models/noob_dev2323/gib/l4d/head_gore2.mdl")  
    end
end )

