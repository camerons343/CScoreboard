AddCSLuaFile()

CScoreboard = CScoreboard or {}

print( "[CScoreboard] Loading" )
AddCSLuaFile( "client/cl__library.lua" )
AddCSLuaFile( "client/cl_config.lua" )
AddCSLuaFile( "client/cl_commands.lua" )
AddCSLuaFile( "client/cl_cscoreboard.lua" )

resource.AddSingleFile( "materials/cscoreboard/adminbutton.png" )