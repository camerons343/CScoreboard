if SERVER then
	util.AddNetworkString( "CScoreboardServerFunc" )
	net.Receive( "CScoreboardServerFunc", function( len, ply )
		local ButtonData = CScoreboard.Commands[ net.ReadDouble() ]
		local ply = net.ReadEntity()
		local target = net.ReadEntity()
		ButtonData.func( ply, target )
		RunConsoleCommand( "say", "test" )							
	end)
end