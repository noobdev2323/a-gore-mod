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
	colide:SetMass(0.1)
end
function gib_PhysBone(ragdoll,bone_name)
    if ragdoll:LookupBone(bone_name) == nil then return end
    if !ragdoll.gib_bone then ragdoll.gib_bone = {} table.insert(gib_PhysBone_RAGDOLLS, ragdoll) end

    local bone_id = ragdoll:LookupBone(bone_name)
    hook.Call( "noob_gore_gap", nil,ragdoll,model,bone_name)
	if GetConVar("debug_mode"):GetBool() then
		for i, ply in ipairs( player.GetAll() ) do ply:ChatPrint( bone_name.." gibbed" ) end
	end

    ragdoll:ManipulateBoneScale(bone_id,Vector(0,0,0))
    local bone = ragdoll:TranslateBoneToPhysBone(bone_id)
    local phys_bone = ragdoll:GetPhysicsObjectNum(bone)
			
    if phys_bone:IsValid() then
        ragdoll:RemoveInternalConstraint(bone)
        ragdoll.gib_bone[bone_id] = bone_id
        colideBone(ragdoll,bone)
    end
    local children = ragdoll:GetChildBones(bone_id)
    for k, v in pairs(children) do --no more shit code
		local bone_parent_name = ragdoll:GetBoneName( v )
        gib_PhysBone(ragdoll,bone_parent_name)
    end
end
function gib_PhysBone2(ragdoll,bone_name)
    print("aids")
    if ragdoll:LookupBone(bone_name) == nil then return end
    if !ragdoll.gib_bone2 then ragdoll.gib_bone2 = {} table.insert(gib_PhysBone_RAGDOLLS2, ragdoll) end

    local bone_id = ragdoll:LookupBone(bone_name)
    local children = ragdoll:GetBoneParent(bone_id)
    ragdoll:ManipulateBoneScale(bone_id,Vector(0,0,0))
    local bone = ragdoll:TranslateBoneToPhysBone(bone_id)
    local phys_bone = ragdoll:GetPhysicsObjectNum(bone)
                
    if phys_bone:IsValid() then
        ragdoll:RemoveInternalConstraint(bone)
        ragdoll.gib_bone2[bone_id] = bone_id
        colideBone(ragdoll,bone)
    end
    if bone_id != 0 then
        local bone_parent_name = ragdoll:GetBoneName( children )
        gib_PhysBone2(ragdoll,bone_parent_name)
    else
        local children = ragdoll:GetChildBones(bone_id)
        for k, v in pairs(children) do --no more shit code
            local bone_parent_name = ragdoll:GetBoneName( v )
            gib_PhysBone2(ragdoll,bone_parent_name)
        end
    end
end
gib_PhysBone_RAGDOLLS = {}
gib_PhysBone_RAGDOLLS2 = {}
hook.Add("Think", "ForcePhysbonePositions_Think_sigma", function()

    for _,ragdoll in ipairs( gib_PhysBone_RAGDOLLS2 ) do
		if ragdoll.gib_bone2 then
			ForcePhysBonePos2(ragdoll) 
		end
	end
end)
function ForcePhysBonePos(ragdoll)
	for k, v in pairs(ragdoll.gib_bone) do
		local bone = ragdoll:TranslateBoneToPhysBone(k)
		local bone_parent = ragdoll:TranslateBoneToPhysBone(ragdoll:GetBoneParent(k ))
		local children = ragdoll:GetBoneParent(k)

		for k, v in pairs(children) do
			local shit = ragdoll:TranslateBoneToPhysBone(v)
			local shit2 = ragdoll:GetPhysicsObjectNum(shit)
	
			shit2:SetPos( parent_physobj:GetPos() )
			shit2:SetAngles( parent_physobj:GetAngles()-Angle(0,0,180) )
		end
	end
end
function ForcePhysBonePos2(ragdoll)
	for k, v in pairs(ragdoll.gib_bone2) do
		local bone = ragdoll:TranslateBoneToPhysBone(k)
        local bone_parent = ragdoll:TranslateBoneToPhysBone(ragdoll:GetBoneParent(k ))


		local parent = ragdoll:GetChildBones(k)
		local gibbed_physobj = ragdoll:GetPhysicsObjectNum(bone)
		local parent_physobj = ragdoll:GetPhysicsObjectNum(bone_parent)
        if parent_physobj == nil then
            local children = ragdoll:GetChildBones(k)
            for k, v in pairs(children) do --no more shit code
                local bone_parent_name = ragdoll:GetBoneName( v )
                gib_PhysBone2(ragdoll,bone_parent_name)
            end
        else
            parent_physobj:SetPos( gibbed_physobj:GetPos() )
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