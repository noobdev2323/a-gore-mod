function GetClosestPhysBone(ent,pos)
	local closest_distance = -1
	local closest_bone = -1
	
	for i=0, ent:GetPhysicsObjectCount()-1 do
		local bone = ent:TranslatePhysBoneToBone(i)
		
		if bone then 
			local phys = ent:GetPhysicsObjectNum(i)
			
			if IsValid(phys) then
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
	colide:SetMass(0.01)
end
function gib_PhysBone(ragdoll,bone_name,damege_data)
    if ragdoll:LookupBone(bone_name) == nil then return end
    if !ragdoll.gib_bone then ragdoll.gib_bone = {} table.insert(gib_PhysBone_RAGDOLLS, ragdoll) end

    local bone_id = ragdoll:LookupBone(bone_name) --get bone id from bone name
    hook.Call( "noob_gore_gap", nil,ragdoll,model,bone_name) --call this hook to make cap based on bone name

    ragdoll:ManipulateBoneScale(bone_id,Vector(0,0,0)) --scale the bone
    local PhysBone = ragdoll:TranslateBoneToPhysBone(bone_id)
    local ObjectNum = ragdoll:GetPhysicsObjectNum(PhysBone)
			
    if ObjectNum:IsValid() then
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
gib_PhysBone_RAGDOLLS = {}
hook.Add("Think", "ForcePhysbonePositions_Think_sigma", function()
    for _,ragdoll in ipairs( gib_PhysBone_RAGDOLLS ) do
		if ragdoll.gib_bone then
			ForcePhysBonePos(ragdoll) 
		end
	end
end)
function ForcePhysBonePos(ragdoll)
	for k, v in pairs(ragdoll.gib_bone) do
		local bone = ragdoll:TranslateBoneToPhysBone(k)
		local bone_parent = ragdoll:TranslateBoneToPhysBone(ragdoll:GetBoneParent(k ))
		local children = ragdoll:GetChildBones(k)
		local gibbed_physobj = ragdoll:GetPhysicsObjectNum(bone)
		local parent_physobj = ragdoll:GetPhysicsObjectNum(bone_parent)
		gibbed_physobj:SetPos( parent_physobj:GetPos() )
		gibbed_physobj:SetAngles( parent_physobj:GetAngles() )
		for k, v in pairs(children) do
			local shit = ragdoll:TranslateBoneToPhysBone(v)
			local shit2 = ragdoll:GetPhysicsObjectNum(shit)
	
			shit2:SetPos( parent_physobj:GetPos() )
			shit2:SetAngles(parent_physobj:GetAngles())
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
	ragdoll.bonemerge_prop:SetOwner(ragdoll)
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