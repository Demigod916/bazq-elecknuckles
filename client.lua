local isStunned = false
local stunStart = 0

local stunTime = 3500

AddEventHandler('gameEventTriggered', function (name, args)
    if name ~= "CEventNetworkEntityDamage" or args[1] ~= PlayerPedId() then return end

	local weapon = args[7]

    if weapon == joaat("WEAPON_ELECKNUCKLE") then

    	local attacker = args[2]
    	local isDead = args[6] == 1

        if isDead then return end

        stunStart = GetGameTimer()

        if isStunned then return end

        isStunned = true

        local coords = GetPedBoneCoords(attacker, 6286, 0, 0, 0)

        RequestNamedPtfxAsset("des_tv_smash")

        while not HasNamedPtfxAssetLoaded("des_tv_smash") do
            Citizen.Wait(0)
        end

        UseParticleFxAsset("des_tv_smash")

        StartNetworkedParticleFxNonLoopedAtCoord("ent_sht_electrical_box_sp", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false)

	RemoveNamedPtfxAsset("des_tv_smash")

        SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)


        while GetGameTimer() - stunStart < stunTime do
            SetPedToRagdoll(PlayerPedId(), 50, 50, 3, 0, 0, 0)
            Wait(50)
        end

        isStunned = false
    end
end)
