CScoreboard = CScoreboard or {}
print( "[CScoreboard] Loading Commands" )
CScoreboard.Commands = {} --This is called to prevent buttons duplicating
-- To create a button you must pass the function a table of arguments
-- arguments are the following listed below
-- type="player|server"						Decides wether its an server|player function ( Default "player" )
-- name="Suicide"							The buttons name to display
-- admpanel=false							Decides if it should be shown in the admin panel instead
-- color=Color( 0, 0, 255 )					The desired color of the button ( Default Color( 120, 120, 120 ) )
-- textColor=Color( 0, 0, 0 )				The desired color for your text( Default( Color( 255, 255, 255 ) )
-- func=function( ply ) <code here> end		The code to run when the button is pressed
-- Options box usage is simple
-- CScoreboard.PopupOptions( {				The function for the options menu
--		title = "Are you sure?",			The title for the menu
--		options = {							This is the table that stores our options data
--			["Yes"] = function()				Yes is what will be displayed on the button
--				RunConsoleCommand( "retry" )What to run when the button is pressed
--			end,							All entries must be seperated with a comma
--			["No"] = function()					No matter what clicking a button closes
--			end								the box so leaving this blank is just like a close button
--		}
--	} )
CScoreboard.AddCommand( { type="player", name="Suicide", color=Color( 100, 100, 255 ), func=function( ply )
	RunConsoleCommand( "kill" )
end } )
CScoreboard.AddCommand( { type="player", name="StopSound", color=Color( 200, 200, 100 ), func=function( ply )
	RunConsoleCommand( "stopsound" )
end } )
CScoreboard.AddCommand( { type="player", name="Toggle Buildmode", color=Color( 100, 200, 255 ), func=function( ply )
	RunConsoleCommand( "say", "!build" )
end } )
CScoreboard.AddCommand( { type="player", name="Reconnect", color=Color( 255, 100, 100 ), func=function( ply )
	CScoreboard.PopupOptions( {
		title = "Are you sure?",
		options = {
			["Yes"] = function()
				RunConsoleCommand( "retry" )
			end,
			["No"] = function()
			end
		}
	} )
end } )

CScoreboard.AddCommand( { type="player", name="Kick", admpanel=true, color=Color( 155, 155, 155 ), func=function( ply )
	CScoreboard.PopupOptions( {
		title = "Kick Reason",
		options = {
			["Spam"] = function()
				CScoreboard.Kick( ply, "Spam" )
			end,
			["Minge"] = function()
				CScoreboard.Kick( ply, "Minge" )
			end,
			["Goto Bed"] = function()
				CScoreboard.Kick( ply, "Goto Bed" )
			end,
			["This server isnt for you"] = function()
				CScoreboard.Kick( ply, "Wrong server buddy" )
			end
			
		}
	} )
end } )
CScoreboard.AddCommand( { type="player", name="Toggle Mute", admpanel=true, color=Color( 155, 155, 155 ), func=function( ply )
	CScoreboard.ToggleMute( ply )
end } )

CScoreboard.AddCommand( { type="player", name="Goto", admpanel=true, color=Color( 155, 155, 155 ), func=function( ply )
	RunConsoleCommand( "ev", "goto", ply:Nick() )
end } )

CScoreboard.AddCommand( { type="server", name="Toggle Buildmode", admpanel=true, color=Color( 155, 155, 155 ), func=function( _, ply )
	ply:SetNWBool( "CBuildmode", !GetNWBool( "CBuildmode" ) )
end } )

