local isStunned = false
local stunStart = 0

local stunTime = 3500

local function electricParticles(ped)
    local coords = GetPedBoneCoords(ped, 6286, 0, 0, 0)

    RequestNamedPtfxAsset("des_tv_smash")

    while not HasNamedPtfxAssetLoaded("des_tv_smash") do
        Wait(0)
    end

    UseParticleFxAsset("des_tv_smash")

    StartNetworkedParticleFxNonLoopedAtCoord(
        "ent_sht_electrical_box_sp",
        coords.x,
        coords.y,
        coords.z,
        0.0,
        0.0,
        0.0,
        1.0,
        false,
        false,
        false
    )

    RemoveNamedPtfxAsset("des_tv_smash")
end

AddEventHandler("gameEventTriggered", function(name, args)
        local weapon = args[7]

        if name ~= "CEventNetworkEntityDamage" or weapon ~= joaat("WEAPON_ELECKNUCKLE") then
            return
        end

        local victim = args[1]
        local attacker = args[2]
        local isDead = args[6] == 1
        local isPed = IsEntityAPed(victim)

        if isDead then
            return
        end

        if victim == PlayerPedId() then
            electricParticles(attacker)

            stunStart = GetGameTimer()

            if isStunned then
                return
            end

            isStunned = true

            SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)

            while GetGameTimer() - stunStart < stunTime do
                SetPedToRagdoll(PlayerPedId(), 50, 50, 3, 0, 0, 0)
                Wait(50)
            end

            isStunned = false
        elseif isPed and attacker == PlayerPedId() then
            electricParticles(attacker)

            if IsPedRagdoll(victim) then
                return
            end

            local stunStartLocal = GetGameTimer()

            SetPedToRagdoll(victim, 1000, 1000, 0, 0, 0, 0)

            while GetGameTimer() - stunStartLocal < stunTime do
                SetPedToRagdoll(victim, 50, 50, 3, 0, 0, 0)
                Wait(50)
            end
        end
    end
)
