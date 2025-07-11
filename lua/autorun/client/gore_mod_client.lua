net.Receive( "noob_gore_sigma_matrix", function()
    local ent = net.ReadEntity()
    local sigma_table = net.ReadTable()
    local main_bone = net.ReadInt( 8 ) -- use the same number of bits that were written.
    if ( !IsValid( ent ) ) then return end

    for i=0, ent:GetBoneCount() - 1 do -- "ragdoll" being a ragdoll entity
		if sigma_table[i] ~= main_bone then

			
    
            local BoneMatrix = ent:GetBoneMatrix(i)
                BoneMatrix:Scale( vector_origin ) --vector_origin = Vector( 0, 0, 0 )
            ent:SetBoneMatrix( i, BoneMatrix )
		end
	end
end )