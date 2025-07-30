util.AddNetworkString( "noob_gore_sigma_matrix" )
util.AddNetworkString( "noob_gore_benemerge" )
function GetClosestPhysBone(ent,pos)
	local closest_distance = -1
	local closest_bone = -1
	
	for i=0, ent:GetPhysicsObjectCount()-1 do
		local bone = ent:TranslatePhysBoneToBone(i)
		
		if bone then 
			local phys = ent:GetPhysicsObjectNum(i)
			
			if IsValid(phys) and pos then
				local distance = phys:GetPos():Distance(pos)
				
				if (distance < closest_distance || closest_distance == -1) then
					closest_distance = distance
					closest_bone = i
				end
			end
		end
	end
	return closest_bone
end
function colideBone(ragdoll,phys_bone)
	local colide = ragdoll:GetPhysicsObjectNum( phys_bone ) --get bone id
	colide:EnableCollisions(false)
	colide:SetMass(0)
	colide:Sleep()
	colide:SetMaterial("gmod_silent")
	colide:EnableGravity(false)
	colide:EnableMotion(false)
end
function gib_PhysBone(ragdoll,bone_name,damege_data)
    if ragdoll:LookupBone(bone_name) == nil or ragdoll:LookupBone(bone_name) == 0 then return end
    if !ragdoll.gib_bone then ragdoll.gib_bone = {} table.insert(gib_PhysBone_RAGDOLLS, ragdoll) end

    local bone_id = ragdoll:LookupBone(bone_name) --get bone id from bone name

    ragdoll:ManipulateBoneScale(bone_id,Vector(0,0,0)) --scale the bone
    local PhysBone = ragdoll:TranslateBoneToPhysBone(bone_id)
    local ObjectNum = ragdoll:GetPhysicsObjectNum(PhysBone)
			
    if ObjectNum:IsValid() then --check if the object is valid
        ragdoll:RemoveInternalConstraint(PhysBone)
        ragdoll.gib_bone[bone_id] = bone_id
        colideBone(ragdoll,PhysBone)
    end
    local children = ragdoll:GetChildBones(bone_id)
    for k, v in pairs(children) do --no more shit code
		local bone_parent_name = ragdoll:GetBoneName( v )
        gib_PhysBone(ragdoll,bone_parent_name)
    end
end
function noob_gore_TransferBones( ragdoll1, ragdoll2 ) -- Transfers the bones of one entity to a ragdoll's physics bones (modified version of some of RobotBoy655's code)
	if !IsValid( ragdoll1 ) or !IsValid( ragdoll2 ) then return end
	for i = 0, ragdoll2:GetPhysicsObjectCount() - 1 do
		local bone = ragdoll2:GetPhysicsObjectNum( i )
		if ( IsValid( bone ) ) then
			local pos, ang = ragdoll1:GetBonePosition( ragdoll2:TranslatePhysBoneToBone( i ) )
			if ( pos ) then bone:SetPos( pos ) end
			if ( ang ) then bone:SetAngles( ang ) end
		end
	end
end

function decap_ragdoll(ragdoll,bone_name)
    if ragdoll:LookupBone(bone_name) == nil or ragdoll:LookupBone(bone_name) == 0 then return end
    local bone_id = ragdoll:LookupBone(bone_name) --get bone id from bone name

	local ragdollGIB = ents.Create("prop_ragdoll")
    if IsValid(ragdollGIB) then
    	ragdollGIB:SetModel(ragdoll:GetModel())
    	ragdollGIB:SetPos(ragdoll:GetPos()) 
        ragdollGIB:SetSkin( ragdoll:GetSkin() )
    	ragdollGIB:Spawn()
		ragdollGIB:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		for i = 1, #ragdoll:GetBodyGroups() do
			ragdollGIB:SetBodygroup(i, ragdoll:GetBodygroup(i))
		end
		noob_gore_TransferBones( ragdoll, ragdollGIB )
		slice_gib(ragdollGIB,bone_name)
		sigma_scale(ragdollGIB)
		ragdollGIB:SetNoDraw(true )
		ragdollGIB:DrawShadow(false )
		net.Start( "noob_gore_benemerge" )
			net.WriteEntity(ragdoll)
			net.WriteInt(bone_id, 8 )
			net.WriteEntity(ragdollGIB)
		net.Broadcast()
	end
end 

/*
function decap_ragdoll(ragdoll,bone_name)
    if ragdoll:LookupBone(bone_name) == nil or ragdoll:LookupBone(bone_name) == 0 then return end
    local bone_id = ragdoll:LookupBone(bone_name) --get bone id from bone name
	net.Start( "noob_gore_sigma_matrix" )
		net.WriteEntity(ragdoll)
		net.WriteInt(bone_id, 8 )
	net.Broadcast()
end 
*/



function slice_gib(ragdoll,bone_name)
	local bone_id = ragdoll:LookupBone(bone_name) --get bone id from bone name

	if !ragdoll.slice_gib then ragdoll.slice_gib = {} table.insert(gib_PhysBone_RAGDOLLS, ragdoll) end
	if ragdoll.slice_gib[bone_id] == bone_id then
		return 
	end
	ragdoll.slice_gib[bone_id] = bone_id
	ragdoll.main_bone_sigma = bone_id
	sigma_children(ragdoll,bone_id)

	local PhysBone = ragdoll:TranslateBoneToPhysBone(bone_id)
	ragdoll:RemoveInternalConstraint(PhysBone) --remove ragdoll Constraint
	for i=0, ragdoll:GetPhysicsObjectCount() - 1 do -- "ragdoll" being a ragdoll entity
		local bone = ragdoll:TranslatePhysBoneToBone(i)
		if ragdoll.slice_gib[bone] ~= bone then
			ragdoll:RemoveInternalConstraint(i)
			colideBone(ragdoll,i)
		end
	end
end
function sigma_children(ragdoll,bone_id)
	local sigma = ragdoll:GetChildBones(bone_id)
    for k, v in pairs(sigma) do --no more shit code
		local PhysBone = ragdoll:TranslateBoneToPhysBone(v)
		local ObjectNum = ragdoll:GetPhysicsObjectNum(PhysBone)
				
		if ObjectNum:IsValid() then --check if the object is valid
			ragdoll.slice_gib[v] = v
			sigma_children(ragdoll,v)
		end
    end
end

function sigma_scale(ragdoll)
	local bone_name = ragdoll:GetBoneName(ragdoll.main_bone_sigma)

	for i = 0, ragdoll:GetBoneCount()-1 do
		if ragdoll.slice_gib[i] ~= i then
			ragdoll:ManipulateBoneScale(i,Vector(0,0,0)) --scale the bone	
		end
	end
end
gib_PhysBone_RAGDOLLS = {}

hook.Add("Think", "ForcePhysbonePositions_Think_sigma", function()
    for _,ragdoll in ipairs( gib_PhysBone_RAGDOLLS ) do
		if not ragdoll:IsValid() then
			table.RemoveByValue(gib_PhysBone_RAGDOLLS, ragdoll) --remove ragdoll on the table
		end
		if ragdoll.gib_bone then
			ForcePhysBonePos(ragdoll) 
		end
		if ragdoll.slice_gib then
			ForcePhysBonePos2(ragdoll) 
		end
	end
end)
function ForcePhysBonePos(ragdoll)
	for k, v in pairs(ragdoll.gib_bone) do
		local bone = ragdoll:TranslateBoneToPhysBone(k)
		local bone_parent = ragdoll:TranslateBoneToPhysBone(ragdoll:GetBoneParent(k ))
		local gibbed_physobj = ragdoll:GetPhysicsObjectNum(bone)
		local parent_physobj = ragdoll:GetPhysicsObjectNum(bone_parent)
		gibbed_physobj:SetPos( parent_physobj:GetPos() )
		gibbed_physobj:SetAngles( parent_physobj:GetAngles() )
	end
end
function ForcePhysBonePos2(ragdoll)
	for i=0, ragdoll:GetPhysicsObjectCount() - 1 do -- "ragdoll" being a ragdoll entity
		local boneid = ragdoll:TranslatePhysBoneToBone(i)
		if boneid then 
			local phys = ragdoll:GetPhysicsObjectNum(i)
			
			if IsValid(phys) and ragdoll.slice_gib[boneid] ~= boneid then
				local main_bone = ragdoll:TranslateBoneToPhysBone(ragdoll.main_bone_sigma)
		
				local gibbed_physobj = ragdoll:GetPhysicsObjectNum(i)
				local parent_physobj = ragdoll:GetPhysicsObjectNum(main_bone)
				gibbed_physobj:SetPos( parent_physobj:GetPos() )
				gibbed_physobj:SetAngles( parent_physobj:GetAngles() )
			end
		end
	end
end
function bonemerge_prop(ragdoll,model)
	local npc_model = ragdoll:GetModel()
	local attachments = ragdoll:GetAttachments()
	local Attachment = nil
    for _, att in pairs( attachments ) do 
		Attachment = att.name 	
	end
	if Attachment == nil then
		return
	end
	ragdoll.bonemerge_prop = ents.Create("prop_physics") 
	ragdoll.bonemerge_prop:SetModel(model)
	ragdoll.bonemerge_prop:SetLocalPos(ragdoll:GetPos())
	ragdoll.bonemerge_prop:SetParent(ragdoll)
	ragdoll.bonemerge_prop:Fire("SetParentAttachment",Attachment)
	ragdoll.bonemerge_prop:Spawn()
	ragdoll.bonemerge_prop:Activate()
	ragdoll.bonemerge_prop:SetSolid(SOLID_NONE)
	ragdoll.bonemerge_prop:AddEffects(EF_BONEMERGE)
end
concommand.Add( "ngm_debug_print_ragdoll_table", function( ply, cmd, args )
    PrintTable(gib_PhysBone_RAGDOLLS)
end )
function dismember_limb(ragdoll,bone_name,slice)
	gib_PhysBone(ragdoll,bone_name)
	hook.Call( "noob_gore_gap", nil,ragdoll,ragdoll:GetModel(),bone_name) --call this hook to make cap based on bone name
	if slice then
		decap_ragdoll(ragdoll,bone_name)
	end
end
