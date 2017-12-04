AddCSLuaFile()
local blacklist={--if someone's usergoup is in here, they will not be able to use this bypasser at all
	["banned"]=true,
	["minge"]=true,
	["noaccess"]=true,
	["noscripts"]=true
}
local level_1_blacklist={--if someone's usergroup is in here, they will not be able to use this bypasser if sv_cslua_bypasser_restriction is set to 1 or higher
	["newbie"]=true,
	["user"]=true,
}
local level_2_whitelist={--if someone's usergroup is in here, they will be able to use this bypasser if sv_cslua_bypasser_restriction is set to 2 or lower
	["donator"]=true,
	["donor"]=true,
	["trusted"]=true,
	["vip"]=true,
}
local level_3_whitelist={--if someone's usergroup is in here, they will be able to use this bypasser if sv_cslua_bypasser_restriction is set to 3 or lower
	["mod"]=true,
	["moderator"]=true,
	["operator"]=true,
	["t-mod"]=true,
	["tmod"]=true,
	["trialmod"]=true,
}
local restriction_level=CreateConVar("sv_cslua_substitute_restriction","1",FCVAR_ARCHIVE,FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE,[[decide who can use lua_openscript_substitute and lua_run_substitute
0=anyone who is not in the blacklist(banned,minge,noaccess,noscripts)
1=anyone who is not in the blacklist(banned,minge,noaccess,noscripts) or the level_1_blacklist(user,newbie) 
2=admins, anyone who is in the level 3 whitelist(mod,moderator,operator,t-mod,tmod,trialmod), anyone in the level 2 whitelist(donator,donor,trusted,vip)
3=admins, anyone who is in the level 3 whitelist(mod,moderator,operator,t-mod,tmod,trialmod)
4=admins and up
5=superadmins only]]):GetInt()

if SERVER then
	hook.Add("InitPostEntity","FuckQAC",function()
		timer.Simple(1,function()--inspired by FuckQAC from darkrp
			for k,v in pairs({"Debug1","Debug2","checksaum","gcontrol_vars","control_vars","QUACK_QUACK_MOTHER_FUCKER"}) do
				net.Receivers[v] = fn.Id
			end
		end)
	end)
	return--no need for the server to read anything after here
end

local files={}
timer.Simple(10,function()
	local filesL1, foldersL1 = file.Find("*", "LUA")
	for key, fileL1 in ipairs(filesL1) do
		table.insert(files," "..fileL1)
	end
	for key, folderL1 in ipairs(foldersL1) do
		local filesL2,foldersL2=file.Find(folderL1.."/*", "LUA")
		for key, fileL2 in ipairs(filesL2) do
			table.insert(files," "..folderL1.."/"..fileL2)
		end
		for key, folderL2 in ipairs(foldersL2) do
			local filesL3,foldersL3=file.Find(folderL1.."/"..folderL2.."/*", "LUA")
			for key, fileL3 in ipairs(filesL3) do
				table.insert(files," "..folderL1.."/"..folderL2.."/"..fileL3)
			end
			for key, folderL3 in ipairs(foldersL3) do
				local filesL4,foldersL4=file.Find(folderL1.."/"..folderL2.."/"..folderL3.."/*", "LUA")
				for key, fileL4 in ipairs(filesL4) do
					table.insert(files," "..folderL1.."/"..folderL2.."/"..folderL3.."/"..fileL4)
				end
			end
		end
	end
end)
concommand.Add("lua_openscript_substitute",function(ply,cmd,args)--if have the perms this will function identically to lua_openscript_cl when sv_allowcslua is set to 1
	if ply and ply:IsValid() and ply:IsPlayer() then--nilchecking
		if args and args[1] and args[1]!="" and false then--are they using invalid arguements?
			print('Executes a Lua script relative to the /lua/ folder, if you have the perms to.\nexamples:\nlua_openscript_substitute autorun/client/falcoutilities.lua')
		else
			local group=string.lower(ply:GetUserGroup())
			if blacklist[group] then
				ply:PrintMessage(HUD_PRINTTALK,"people with the usergroup of "..ply:GetUserGroup().." are not allowed to use that command")
			elseif restriction_level==1 and !ply:IsAdmin() and level_1_blacklist[group] then
				ply:PrintMessage(HUD_PRINTTALK,"people with the usergroup of "..ply:GetUserGroup().." are not allowed to use that command")
			elseif restriction_level==2 and !ply:IsAdmin() and !level_3_whitelist[group] and !level_2_whitelist[group] then
				ply:PrintMessage(HUD_PRINTTALK,"people with the usergroup of "..ply:GetUserGroup().." are not allowed to use that command")
			elseif restriction_level==3 and !ply:IsAdmin() and !level_3_whitelist[group] then
				ply:PrintMessage(HUD_PRINTTALK,"people with the usergroup of "..ply:GetUserGroup().." are not allowed to use that command")
			elseif restriction_level==4 and !ply:IsAdmin() then
				ply:PrintMessage(HUD_PRINTTALK,"only admins and up are allowed to use that command")
			elseif restriction_level>=5 and !ply:IsSuperAdmin() then
				ply:PrintMessage(HUD_PRINTTALK,"only superadmins are allowed to use that command")
			else
				include(args[1])
			end
		end
	end
end,
function(cmd,typed)--autocomplete
	local tbl={}
	for k,v in pairs(files) do
		if string.StartWith(v,tostring(typed)) then
			table.insert(tbl,cmd..v)
		end
	end
	return tbl
end,'Executes a Lua script relative to the /lua/ folder, if you have the perms to.\nexamples:\nlua_openscript_substitute autorun/client/falcoutilities.lua')

concommand.Add("lua_run_substitute",function(ply,cmd,args)
	if ply and ply:IsValid() and ply:IsPlayer() then--nilchecking
		if args and args[1] and args[1]!="" then--are they using invalid arguements?
			local group=string.lower(ply:GetUserGroup())
			if blacklist[group] then
				ply:PrintMessage(HUD_PRINTTALK,"people with the usergroup of "..ply:GetUserGroup().." are not allowed to use that command")
			elseif restriction_level==1 and !ply:IsAdmin() and level_1_blacklist[group] then
				ply:PrintMessage(HUD_PRINTTALK,"people with the usergroup of "..ply:GetUserGroup().." are not allowed to use that command")
			elseif restriction_level==2 and !ply:IsAdmin() and !level_3_whitelist[group] and !level_2_whitelist[group] then-- group:find("donat") and !group:find("donor") and !group:find("vip") and !group:find("trusted") then
				ply:PrintMessage(HUD_PRINTTALK,"people with the usergroup of "..ply:GetUserGroup().." are not allowed to use that command")
			elseif restriction_level==3 and !ply:IsAdmin() and !level_3_whitelist[group] then
				ply:PrintMessage(HUD_PRINTTALK,"people with the usergroup of "..ply:GetUserGroup().." are not allowed to use that command")
			elseif restriction_level==4 and !ply:IsAdmin() then
				ply:PrintMessage(HUD_PRINTTALK,"only admins and up are allowed to use that command")
			elseif restriction_level==5 and !ply:IsSuperAdmin() then
				ply:PrintMessage(HUD_PRINTTALK,"only superadmins are allowed to use that command")
			else
				RunString(table.concat(args," "))
			end
		else
			print('run lua on yourself, if you have the perms to do so\nexamples:\nlua_run_substitute print("hello world")\nlua_run_substitute print("my name is"..LocalPlayer():Nick()..".")')
		end
	end
end,
function()
end,'run lua on yourself, if you have the perms to do so\nexamples:\nlua_run_substitute print("hello world")\nlua_run_substitute print("my name is"..LocalPlayer():Nick()..".")')

hook.Add("PlayerInitialSpawn","autorun/client",function(ply)
	if ply and ply:IsValid() and ply:IsPlayer() then--nilchecking
		local group=string.lower(ply:GetUserGroup())
		if blacklist[group] then
		elseif restriction_level==1 and !ply:IsAdmin() and level_1_blacklist[group] then
		elseif restriction_level==2 and !ply:IsAdmin() and !level_3_whitelist[group] and !level_2_whitelist[group] then
		elseif restriction_level==3 and !ply:IsAdmin() and !level_3_whitelist[group] then
		elseif restriction_level==4 and !ply:IsAdmin() then
		elseif restriction_level>=5 and !ply:IsSuperAdmin() then
		else
			for k,v in pairs(files) do
				if string.StartWith(v," autorun/client") then
					include(v)
				end
			end
		end
	end
end)