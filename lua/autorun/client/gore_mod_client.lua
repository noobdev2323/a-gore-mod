net.Receive( "noob_gore_sigma_matrix", function()
    local ent = net.ReadEntity()
    local sigma_table = net.ReadTable()
    local main_bone = net.ReadInt( 8 ) -- use the same number of bits that were written.
    if ( !IsValid( ent ) ) then return end

    for k, v in pairs(sigma_table) do
        if ent:GetBoneName(k) ~= "__INVALIDBONE__" then
            if sigma_table[v] ~= main_bone then
                local Pos = ent:GetBoneMatrix( main_bone ):GetTranslation()
                local BoneMatrix = ent:GetBoneMatrix(v)
                BoneMatrix:Scale( vector_origin ) --vector_origin = Vector( 0, 0, 0 )
                BoneMatrix:SetTranslation( Pos )
                ent:SetBoneMatrix( v, BoneMatrix )
            end
        end
	end
end )