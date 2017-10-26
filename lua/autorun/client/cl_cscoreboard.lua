CScoreboard = CScoreboard or {}
if CLIENT then
	
	print( "[CScoreboard] Loading Scoreboard" )
	function CScoreboard.show()
		--Create the scoreboard here, with an base like DPanel, you can use an DListView for the rows.
		CScoreboard.Frame = vgui.Create( "DFrame" )
		CScoreboard.Frame:SetSize( ScrW()*0.75, ScrH()*0.7 )
		CScoreboard.Frame:ShowCloseButton( false )
		CScoreboard.Frame:SetTitle( "" )
		CScoreboard.Frame:SetMouseInputEnabled( true )
		CScoreboard.Frame:SetMinWidth( 1080 )
		CScoreboard.Frame:SetMinHeight( 630 )
		CScoreboard.Frame:SetDraggable( false )
		if CScoreboard.AdminFrame then
			CScoreboard.AdminFrame:Show()
			CScoreboard.Frame:SetPos( (ScrW()/2) - (ScrW()*0.375) - 100, (ScrH()/2) - (ScrH()*0.35 ) )
		else
			CScoreboard.Frame:Center()
		end
		gui.EnableScreenClicker( true )
		CScoreboard.Frame.Paint = function( self, w, h )
			CScoreboard.Blur( self, 10, 20, 255 )
			draw.RoundedBox( 2, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
			draw.RoundedBox( 0, 0, 0, w, 25, Color( 80, 80, 80, 100 ) )
			draw.DrawText( GetHostName(), "CScoreboard_18", w/2, 4, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )
		end
		CScoreboard.CommandList = vgui.Create( "DListLayout", CScoreboard.Frame )
		CScoreboard.CommandList:SetSize( 200, CScoreboard.Frame:GetTall() - 300 )
		CScoreboard.CommandList:SetPos( 20, 45 )
		CScoreboard.CommandList.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
		end
		local CommandPanel = CScoreboard.CommandList:Add( "DPanel" )
		CommandPanel:SetSize( 180, 20 )
		CommandPanel:SetPos( 30, 45 )
		CommandPanel.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200 ) )	
			draw.DrawText( "Commands", "CScoreboard_18", w/2, 1, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )		
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawLine( -1, h-1, w, h-1 )
		end
		if CScoreboard.Commands then
			for i, v in pairs( CScoreboard.Commands ) do
				if v.admpanel == nil or v.admpanel == false then
					Command = CScoreboard.CommandList:Add( "DButton" )
					Command:SetText( v.name )
					Command:SetSize( CScoreboard.CommandList:GetWide(), 40 )
					Command.Paint = function( self, w, h )
						draw.RoundedBox( 0, 0, 0, w, h, v.color or Color( 120, 120, 120 ) )
						self:SetFontInternal( "CScoreboard_18" )
						self:SetFGColor( 0, 0, 0, 255 ) 
						--draw.DrawText( v.name, "CScoreboard_18", w/2, 13, v.textColor or Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )			
						surface.SetDrawColor( 0, 0, 0, 255 )
						surface.DrawLine( -1, h-1, w, h-1 )
					end
					Command.DoClick = function()
						if v.type == "player" or v.type == nil then
							v.func( LocalPlayer() )
						elseif v.type == "server" then
							net.Start( "CScoreboardServerFunc" )
								net.WriteDouble( i )
								net.WriteEntity( LocalPlayer() )
							net.SendToServer()
						end
					end
				end
			end
		end
		CScoreboard.ScrollPanel = vgui.Create( "DScrollPanel", CScoreboard.Frame )
		CScoreboard.ScrollPanel:SetSize( CScoreboard.Frame:GetWide() - 240, CScoreboard.Frame:GetTall() - 70 )
		CScoreboard.ScrollPanel:SetPos( 240, 45 )
		CScoreboard.ScrollPanel:GetVBar().Paint = function() end
		CScoreboard.ScrollPanel:GetVBar().btnUp.Paint = function() end
		CScoreboard.ScrollPanel:GetVBar().btnDown.Paint = function() end
		CScoreboard.ScrollPanel:GetVBar().btnGrip.Paint = function() end
		
		CScoreboard.List = vgui.Create( "DListLayout", CScoreboard.ScrollPanel )
		CScoreboard.List:SetSize( CScoreboard.Frame:GetWide() - 260, CScoreboard.Frame:GetTall() - 70 )
		local line = CScoreboard.List:Add( "DPanel" )
		line:SetSize( CScoreboard.List:GetWide(), 20 )
		line.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200 ) )
			draw.DrawText( "Name", "CScoreboard_18", 90, 1, Color( 0, 0, 0 ), TEXT_ALIGN_LEFT )
			draw.DrawText( "Rank", "CScoreboard_18", w*0.445, 1, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )
			draw.DrawText( "Play Time", "CScoreboard_18", w*0.624, 1, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )
			draw.DrawText( "Kills | Deaths", "CScoreboard_18", w*0.779, 1, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )
			draw.DrawText( "Ping", "CScoreboard_18", w*0.888, 1, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawLine( -1, h-1, w, h-1 )
		end
		for _, ply in pairs( CScoreboard.SortPlayers() ) do
			if ply:IsValid() then
				local line = CScoreboard.List:Add( "DPanel" )
				line:SetSize( CScoreboard.List:GetWide(), 40 )
				
				if CScoreboard.ShouldDrawSnow( ply ) then
					CreateSnowFlakes( ply, CScoreboard.List:GetWide(), CScoreboard.List:GetTall(), 50 )
				end
				line.Paint = function( self, w, h )
					
					if ply:IsValid() then
						local PanelColor = CScoreboard.GetRankColor( ply )
						local Rank = CScoreboard.GetRank( ply )
						if CScoreboard.RankOverides[ Rank ] != nil then
							Rank = CScoreboard.RankOverides[ Rank ].Title
						else
							Rank = string.upper( string.sub( Rank, 1, 1 ) )..string.sub( Rank, 2 ) or ""
						end
						draw.RoundedBox( 0, 0, 0, w, h, PanelColor )
						
						if CScoreboard.ShouldDrawSnow( ply ) then
							PaintSnowFlakes( ply, w, h )
						end
						draw.DrawText( ply:Name(), "CScoreboard_18", 40, 10, Color( 0, 0, 0 ), TEXT_ALIGN_LEFT )	
						draw.DrawText( Rank, "CScoreboard_18", w*0.445, 10, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )		
						draw.DrawText( CScoreboard.FormatTime( CScoreboard.GetPlayTime( ply ) ), "CScoreboard_18", w*0.624, 10, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )			
						draw.DrawText( ply:Frags().."|", "CScoreboard_18", w*0.772, 10, Color( 0, 0, 0 ), TEXT_ALIGN_RIGHT )
						draw.DrawText( ply:Deaths(), "CScoreboard_18", w*0.772, 10, Color( 0, 0, 0 ), TEXT_ALIGN_LEFT )
						draw.DrawText( ply:Ping().."ms", "CScoreboard_18", w*0.888, 10, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )
						surface.SetDrawColor( 0, 0, 0, 255 )

						surface.DrawLine( -1, h-1, w, h-1 )			
					else
						line:Remove()
					end
				end
				local InfoPanel = vgui.Create( "DPanel", line )
				InfoPanel:SetPos( 5, 40 )
				InfoPanel:SetSize( line:GetWide() - 10, 60 )
				InfoPanel.Paint = function( self, w, h )
					
					draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200, 200 ) )
					surface.SetDrawColor( Color( 0, 0, 0 ) )
					surface.DrawOutlinedRect( 0, 0, w, h )
					draw.DrawText( "Props: "..ply:GetCount( "props" ), "CScoreboard_12", 10, 5, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
					draw.DrawText( "Ragdolls: "..ply:GetCount( "ragdolls" ), "CScoreboard_12", 10, 17, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
					draw.DrawText( "SENTS: "..ply:GetCount( "sents" ), "CScoreboard_12", 10, 30, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
					draw.DrawText( "Vehicles: "..ply:GetCount( "vehicles" ), "CScoreboard_12", 10, 42, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
					
				end
				local Avatar = vgui.Create( "AvatarImage", line )
				Avatar:SetSize( 32, 32 )
				Avatar:SetPos( 4, 4 )
				Avatar:SetPlayer( ply, 64 )
				Avatar.OnMousePressed = function()
					ply:ShowProfile()
				end
				
				line.OnMousePressed = function( pnl, key )
					if key == 107 then
						if line:GetTall() == 40 then
							line:SizeTo( line:GetWide(), 105, 0.5, 0, -1 )
							InfoPanel:SizeTo( InfoPanel:GetWide(), 60, 0.5, 0, -1 )
						elseif line:GetTall() >= 100 then
							line:SizeTo( line:GetWide(), 40, 0.5, 0, -1 )
							InfoPanel:SizeTo( InfoPanel:GetWide(), 0, 0.48, 0, -1 )
						end
					elseif key == 108 then
						CScoreboard.RightClick()
					end
				end
				if CScoreboard.HasPrivledge( LocalPlayer(), "CSAdminMenu" ) then
					local AdminButton = vgui.Create( "DImageButton", InfoPanel )
					AdminButton:SetSize( 40, 40 )
					AdminButton:SetPos( InfoPanel:GetWide() - 50, 10 )
					AdminButton:SetImage( "cscoreboard/adminbutton.png" )
					AdminButton.DoClick = function()
						CScoreboard.OpenAdminMenu( ply )
					end
				end
				if ply != LocalPlayer() then
					local Mute = vgui.Create( "DImageButton", line )
					Mute:SetSize( 40, 40 )
					Mute:SetPos( line:GetWide() - 40, 0 )
					
					Mute:SetImage( "icon32/unmuted.png" )
					Mute.DoClick = function()
						
						ply:SetMuted( !ply:IsMuted() ) 
						local muted = ply:IsMuted()
						if muted then
							Mute:SetImage( "icon32/muted.png" )
						else
							Mute:SetImage( "icon32/unmuted.png" )
						end
					end
				end
			else
				line:Remove()
			end
		end
	end
	
	function CScoreboard.hide()
		CScoreboard.Frame:Hide()
		CScoreboard.Frame = nil
		if CScoreboard.AdminFrame then
			CScoreboard.AdminFrame:Hide()
		end
		gui.EnableScreenClicker( false )
	end
	hook.Add( "Initialize", "first", function()
		function GAMEMODE:ScoreboardShow()
			CScoreboard.show()
		end

		function GAMEMODE:ScoreboardHide()
			CScoreboard.hide()
		end
	end)
end