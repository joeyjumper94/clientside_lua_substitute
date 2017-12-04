this addon adds two new console commands,
lua_run_substitute, which allows you to run lua on yourself like lua_run_cl
lua_openscript_substitute, which allows you to run custom scripts like lua_openscript_cl


and a convar to decide who can run these commands
sv_cslua_substitute_restriction
0=anyone who is not in the blacklist(banned,minge,noaccess,noscripts)
1=anyone who is not in the blacklist(banned,minge,noaccess,noscripts) or the level_1_blacklist(user,newbie) 
2=admins, anyone who is in the level 2 whitelist(donator,donor,mod,moderator,operator,t-mod,tmod,trialmod,trusted,vip)
3=admins, anyone who is in the level 3 whitelist(mod,moderator,operator,t-mod,tmod,trialmod)
4=admins and up
5=superadmins only
