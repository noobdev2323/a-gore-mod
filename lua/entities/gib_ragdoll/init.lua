AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()		
	local ragdoll = ents.Create("prop_ragdoll")
	ragdoll:SetModel(self.ragdoll_model)
end

function ENT:Think()

end