CScoreboard = CScoreboard or {}
--Rank or steamid to let it snow on
CScoreboard.SnowSelection = {
	["owner"] = true,
	["developer"] = true,
	["STEAM_0:1:40778419"] = true
}
CScoreboard.RankOverides = {
	-- No reason to capitalize if there is no title the script
	-- Will do it itself
	--["developer"] = { Title="Random Title" }
}
print( "[CScoreboard] Loading Config" )