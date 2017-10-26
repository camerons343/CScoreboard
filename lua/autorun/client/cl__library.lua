--//Button Creation Function	 
print( "[CScoreboard] Loading Library" )
CScoreboard = CScoreboard or {}
CScoreboard.Commands = CScoreboard.Commands or {}
function CScoreboard.AddCommand( data )
	table.insert( CScoreboard.Commands, data )
end
if CLIENT then

	--//Custom Fonts
	surface.CreateFont( "CScoreboard_12", {
		font = "Roboto Lt",
		size = 12,
		weight = 500,
		antialias = true,
		shadow = false,
		extended = true,
	} )	
	surface.CreateFont( "CScoreboard_18", {
		font = "Roboto Lt",
		size = 18,
		weight = 500,
		antialias = true,
		shadow = false,
		extended = true,
	} )	
	surface.CreateFont( "CScoreboard_20", {
		font = "Roboto Lt",
		size = 20,
		weight = 500,
		antialias = true,
		shadow = false,
		extended = true,
	} )
	--//Player Sorting Function
	function CScoreboard.SortPlayers()
		local PLAYERS = player.GetAll()
		table.sort( PLAYERS, function( a, b ) return evolve.ranks[ a:EV_GetRank() ].Immunity > evolve.ranks[ b:EV_GetRank() ].Immunity end )
		return PLAYERS
	end
	--//Format Time Function
	function CScoreboard.FormatTime( time )
		local ttime = time or 0
		local s = ttime % 60
		ttime = math.floor(ttime / 60)
		local m = ttime % 60
		ttime = math.floor(ttime / 60)
		local h = ttime % 24
		ttime = math.floor( ttime / 24 )
		local d = ttime % 7
		local w = math.floor(ttime / 7)
		local str = ""
		str = (w>0 and w.."w " or "")..(d>0 and d.."d " or "")
		  
		return string.format( str.."%02ih %02im %02is", h, m, s )
	end 
	--//PlayTime Function
	function CScoreboard.GetPlayTime( ply )
		if ulx and ply:GetNWInt( "TotalUTime", -1 ) ~= - 1 then
			return math.floor((ply:GetUTime() + CurTime() - ply:GetUTimeStart()))
		elseif evolve then
			return evolve:Time() - ply:GetNWInt( "EV_JoinTime" ) + ply:GetNWInt( "EV_PlayTime" )
		else
			return ply:GetNWInt( "Time_Fixed" ) + ( CurTime() - ply:GetNWInt( "Time_Join" ))
		end
	end
	--//GetRank Function
	function CScoreboard.GetRank( ply )
		if ulx then
			return ply:GetUserGroup()
		elseif evolve then
			return ply:EV_GetRank() 
		else
			return ply:GetUserGroup()
		end
	end
	--//RankColor Function
	function CScoreboard.GetRankColor( ply )
		if ulx then 
			return team.GetColor( ply:Team() )
		elseif evolve then
			return ColorAlpha( evolve.ranks[ ply:EV_GetRank() ].Color, 255 )
		else
			return team.GetColor( ply:Team() )
		end
	end
	--//Blur Function
	function CScoreboard.Blur( panel, layers, density, alpha )		
		local blur = Material( "pp/blurscreen" )
		local x, y = panel:LocalToScreen(0, 0)
	
		surface.SetDrawColor( 255, 255, 255, alpha )
		surface.SetMaterial( blur )
	
		for i = 1, 3 do
			blur:SetFloat( "$blur", ( i / layers ) * density )
			blur:Recompute()
	
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
		end
	end
	--//Popup Box Function
	function CScoreboard.PopupOptions( data )
		CScoreboard.OptionsBox = vgui.Create( "DFrame" )
		CScoreboard.OptionsBox:SetSize( 200, 150 )
		CScoreboard.OptionsBox:SetTitle( "" )
		CScoreboard.OptionsBox:MakePopup()
		CScoreboard.OptionsBox:SetDraggable( false )
		CScoreboard.OptionsBox:ShowCloseButton( false )
		CScoreboard.OptionsBox:SetBackgroundBlur( true )	
		CScoreboard.OptionsBox.Paint = function( self, w, h )
			CScoreboard.Blur( self, 10, 20, 255 )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
			draw.DrawText( data.title, "CScoreboard_20", w/2, 5, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )
		end	
		CScoreboard.OptionsClose = vgui.Create( "DButton", CScoreboard.OptionsBox )
		CScoreboard.OptionsClose:SetSize( 20, 20 )
		CScoreboard.OptionsClose:SetPos( 180, 0 )
		CScoreboard.OptionsClose:SetText( "X" )
		CScoreboard.OptionsClose.Paint = function( self, w, h )
			draw.RoundedBox( 1, 0, 0, w, h, Color( 255, 100, 100 ) )
		end
		CScoreboard.OptionsClose.DoClick = function()
			CScoreboard.OptionsBox:Remove()
		end
		CScoreboard.OptionsList = vgui.Create( "DListLayout", CScoreboard.OptionsBox )
		CScoreboard.OptionsList:SetSize( 180, 350 )
		CScoreboard.OptionsList:SetPos( 10, 30 )
		
		for opt, func in pairs( data.options ) do
			local OptionButton = CScoreboard.OptionsList:Add( "DButton" )
			OptionButton:SetSize( 180, 40 )
			OptionButton:SetText( opt )
			OptionButton.DoClick = function() 
				func()
				CScoreboard.OptionsBox:Remove()
			end
			OptionButton.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 150, 150, 150 ) )
				surface.SetDrawColor( 0, 0, 0 )
				surface.DrawOutlinedRect( 0, 0, w, h )
				self:SetFontInternal( "CScoreboard_18" )
				self:SetFGColor( 0, 0, 0, 255 )
				--draw.DrawText( opt, "CScoreboard_20", w/2, 8, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )
			end
		end
		CScoreboard.OptionsList:SizeToChildren( false, true )
		CScoreboard.OptionsList:InvalidateLayout( true )
		CScoreboard.OptionsBox:SizeToChildren( false, true )
		CScoreboard.OptionsBox:InvalidateLayout( true )
		CScoreboard.OptionsBox:Center()
	end
	--//Function to determin if we should draw snow
	function CScoreboard.ShouldDrawSnow( ply )
		if CScoreboard.SnowSelection[ CScoreboard.GetRank( ply ) ] or CScoreboard.SnowSelection[ ply:SteamID() ] then
			return true
		end
	end
	local snowMaterial = Material("icon16/bullet_blue.png")
	--//Crate SnowFlakes Function
	function CreateSnowFlakes( ply, w, h, cnt )
		CScoreboard.Flakes = CScoreboard.Flakes or {}
		CScoreboard.Flakes[ply:GetName()] = {}
		for i = 1, cnt do
			CScoreboard.Flakes[ply:GetName()][i] = {x = math.random(0, w), y = math.random(-50, 0), sign = math.Round(math.random(-1, 1)), counter = 0, speed = math.random(5, 40), size = math.random(2, 10)}
		end
	end
	--//Sets Admin Prefix
	function CScoreboard.GetAdminPrefix()
		if ulx then
			return "ulx"
		elseif evolve then
			return "ev"
		end
	end
	--//Privledge Checker
	function CScoreboard.HasPrivledge( ply, prv )
		if ulx then
		--TODO
			return 
		elseif evolve then
			return ply:EV_HasPrivilege( prv )
		else
			return ply:IsAdmin() or ply:IsSuperAdmin()
		end
	end
	--//Kick function
	function CScoreboard.Kick( ply, reason )
		if ulx or evolve then
			RunConsoleCommand( CScoreboard.GetAdminPrefix(), "kick", ply:GetName(), reason )
		else
		--TODO
		end
	end
	function CScoreboard.BoolToInt( bool )
		if bool then
			return 1
		else
			return 0
		end
	end
	function CScoreboard.ToggleMute( ply )
		if ulx  then
		elseif evolve then
			RunConsoleCommand( "ev", "mute", ply:GetName(), 1 - CScoreboard.BoolToInt( ply:GetNWBool( "Muted" )  ) )
		end
	end
	--//Paint SnowFlakes Function
	function PaintSnowFlakes( ply, w, h)
		local flakes = CScoreboard.Flakes[ply:GetName()] or {}
		surface.SetDrawColor(color_white)
		surface.SetMaterial(snowMaterial)
		if (#flakes > 0) then			
			for i = 1, #flakes do
				flakes[i].counter = flakes[i].counter +flakes[i].speed /500
				flakes[i].x = flakes[i].x +(flakes[i].sign *math.cos(flakes[i].counter) /20)
				flakes[i].y = flakes[i].y +math.sin(flakes[i].counter) /40 +flakes[i].speed /30
				
				if (flakes[i].y > h) then
					flakes[i].y = math.random(-50,0)
					flakes[i].x = math.random(0, w)
				end
			end
			
			for i = 1, #flakes do
				surface.DrawTexturedRect(flakes[i].x, flakes[i].y, flakes[i].size, flakes[i].size)
			end
		end
	end
	--//Admin Menu Function
	function CScoreboard.UpdateAdminMenu( ply )
		CScoreboard.AdminFrame:SetTitle( ply:GetName() )
		CScoreboard.AdminBoxAvatar:SetPlayer( ply, 128 )
		CScoreboard.AdminFrame.Paint = function( self, w, h )
			self:SetFontInternal( "CScoreboard_12" )
			CScoreboard.Blur( self, 10, 20, 255 )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
			draw.RoundedBox( 0, 0, 0, w, 20, Color( 100, 100, 100, 100 ) )
			draw.RoundedBox( 0, 40, 40, 120, 120, ColorAlpha( CScoreboard.GetRankColor( ply ), 100 ) )
			draw.RoundedBox( 0, 20, 160, w - 40, h - 180, Color( 150, 150, 150, 140 ) )
		end
		CScoreboard.AdminFrame.Think = function()
			if not ply:IsValid() or ply == nil then
				CScoreboard.AdminFrame:Remove()
			end
		end
	end
	function CScoreboard.OpenAdminMenu( ply )
		if CScoreboard.AdminFrame then
			CScoreboard.UpdateAdminMenu( ply )
		else
			CScoreboard.AdminFrame = vgui.Create( "DFrame" )
			CScoreboard.AdminFrame:SetSize( 0, 20 )
			CScoreboard.AdminFrame:SetPos( (ScrW()/2) + (ScrW()*0.375) - 100, (ScrH()/2)-10 )
			CScoreboard.AdminFrame:SetZPos( 3000 )
			CScoreboard.AdminFrame:ShowCloseButton( false )
			CScoreboard.AdminFrame:SetDraggable( false )
			
			CScoreboard.AdminClose = vgui.Create( "DButton", CScoreboard.AdminFrame )
			CScoreboard.AdminClose:SetSize( 20, 20 )
			CScoreboard.AdminClose:SetPos( 180, 0 )
			CScoreboard.AdminClose:SetText( "X" )
			CScoreboard.AdminClose.Paint = function( self, w, h )
				draw.RoundedBox( 1, 0, 0, w, h, Color( 255, 100, 100 ) )
			end
			CScoreboard.AdminClose.DoClick = function()
				CScoreboard.AdminFrame:SizeTo( 200, 20, 0.25, 0, -1, function()
					CScoreboard.AdminFrame:SizeTo( 0, 20, 0.25, 0, -1, function()
						CScoreboard.AdminFrame:Remove()
						CScoreboard.AdminFrame = nil
						if CScoreboard.Frame then
							CScoreboard.Frame:MoveTo( (ScrW()/2) - (ScrW()*0.375), (ScrH()/2) - (ScrH()*0.35 ), 0.1, 0, -1 )
						end
					end )
				end )
				CScoreboard.AdminFrame:MoveTo( (ScrW()/2) + (ScrW()*0.375) - 100, (ScrH()/2) - 10, 0.2, 0, - 1 )
			end
			CScoreboard.Frame:MoveTo( (ScrW()/2) - (ScrW()*0.375) - 100, (ScrH()/2) - (ScrH()*0.35 ), 0.1, 0, -1, function()
				CScoreboard.AdminFrame:SizeTo( 200, 20, 0.3, 0, -1, function()
					CScoreboard.AdminFrame:SizeTo( 200, 400, 0.3, 0, -1 )
					CScoreboard.AdminFrame:MoveTo( (ScrW()/2) + (ScrW()*0.375)-100, (ScrH()/2)-200, 0.2, 0, - 1 )
				end)
			end)
			CScoreboard.AdminBoxAvatar = vgui.Create( "AvatarImage", CScoreboard.AdminFrame )
			CScoreboard.AdminBoxAvatar:SetSize( 100, 100 )
			CScoreboard.AdminBoxAvatar:SetPos( 50, 50 )
			CScoreboard.AdminBoxAvatar:SetPlayer( ply, 128 )
			CScoreboard.AdminBoxAvatar.OnMousePressed = function()
				ply:ShowProfile()
			end
			CScoreboard.AdmCommmandScroll = vgui.Create( "DScrollPanel", CScoreboard.AdminFrame )
			CScoreboard.AdmCommmandScroll:SetSize( 160, 220 )
			CScoreboard.AdmCommmandScroll:SetPos( 20, 160 )
			CScoreboard.AdmCommmandScroll.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 100, 100 ) )
			end 
			CScoreboard.AdmCommandList = vgui.Create( "DListLayout", CScoreboard.AdmCommmandScroll )
			CScoreboard.AdmCommandList:SetSize( CScoreboard.AdmCommmandScroll:GetWide(), CScoreboard.AdmCommmandScroll:GetTall() )
			CScoreboard.AdmCommandList:SetPos( 0, 0 )
			CScoreboard.AdmCommandList.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 100, 100 ) )
			end 

			for i, v in pairs( CScoreboard.Commands ) do
				if v.admpanel == true then
					local Command = CScoreboard.AdmCommandList:Add( "DButton" )
					Command:SetText( v.name )
					Command:SetSize( CScoreboard.AdmCommandList:GetWide(), 20 )
					Command.Paint = function( self, w, h )
						self:SetFontInternal( "CScoreboard_12" )
						self:SetFGColor( 0, 0, 0, 255 )
						draw.RoundedBox( 0, 0, 0, w, h, v.color or Color( 120, 120, 120 ) )
						--draw.DrawText( v.name, "CScoreboard_12", w/2, 4, v.textColor or Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )			
						surface.SetDrawColor( 0, 0, 0, 255 )
						surface.DrawLine( -1, h-1, w, h-1 )
					end
					Command.DoClick = function()
						if v.type == "player" then
							v.func( ply )
						elseif v.type == "server" then
							net.Start( "CScoreboardServerFunc" )
								net.WriteDouble( i )
								net.WriteEntity( LocalPlayer() )
								net.WriteEntity( ply )
							net.SendToServer()
						end
					end
				end
			end
			CScoreboard.UpdateAdminMenu( ply )
		end
	end
end