net.Receive( "noob_gore_sigma_matrix", function()
    local ent = net.ReadEntity()
    local sigma_table = net.ReadTable()
    local main_bone = net.ReadInt( 8 ) -- use the same number of bits that were written.

    ent:AddCallback("BuildBonePositions",GibCallback)

end )
function GibCallback(myself, boneCount)
    for i = 0, boneCount - 1 do
        if i ~= myself:LookupBone("ValveBiped.Bip01_Head1") then
            local mat = myself:GetBoneMatrix( i )
            if ( !mat ) then continue end
            local Pos = myself:GetBoneMatrix( myself:LookupBone("ValveBiped.Bip01_Head1") ):GetTranslation()
    
            mat:Scale( vector_origin ) //vector_origin = Vector( 0, 0, 0 )
            mat:SetTranslation( Pos )
            myself:SetBoneMatrix( i, mat )
        end
    end
end
local csRag = FindMetaTable( "CSEnt" )
-- csRag:SetPos() doesn't work for C_ClientRagdoll entities.
function csRag:SetRagdollPos(pos)
	
	for i = 0, self:GetPhysicsObjectCount() - 1 do 
		-- Get the physics object (PhysBone)
		local phys = self:GetPhysicsObjectNum(i)
		-- Get the position of the physics object relative to the ragdoll's position
		local localPos = self:WorldToLocal( phys:GetPos() )
		-- Set the physics object's location to the new position using the relative position to it's previous position
		phys:SetPos( pos + localPos )
		
	end
	
end
concommand.Add( "player_csragdoll", function( ply )
	local ragdoll = ClientsideRagdoll( ply:GetModel() )		-- Create a ragdoll using the player's model
	ragdoll:SetNoDraw( false )
	ragdoll:DrawShadow( true )
	ragdoll:SetRagdollPos( ply:GetPos() )		-- Set the position of the ragdoll to the player's position
    ragdoll:SetupBones()
    ragdoll:AddCallback("BuildBonePositions",GibCallback)
end )