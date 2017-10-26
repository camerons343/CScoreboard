function ulx.cscoreboard( calling_ply )
	local cscoreboard = ulx.command( "CScoreboard", "ulx cscoreboard", ulx.cscoreboard, { "!cscoreboard" } )
	cscoreboard:defaultAccess( ULib.ACCESS_ADMIN )
	cscoreboard:help( "Allows access to CScoreboard admin menu" )  
end