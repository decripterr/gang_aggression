local gangPeds = {
    `g_m_y_ballasout_01`,
    `g_m_y_famca_01`,
    `g_m_y_mexgoon_01`,
    `g_m_y_lost_01`,
    `g_m_y_azteca_01`
}

local detectionRadius = 25.0
local triggerDistance = 10.0

function isGangPed(ped)
    local model = GetEntityModel(ped)
    for _, gangModel in pairs(gangPeds) do
        if model == gangModel then return true end
    end
    return false
end

function isPlayerThreatening(ped)
    local player = PlayerPedId()
    local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId())
    if aiming and targetPed == ped then
        return true
    end
    if IsPedArmed(player, 4) and GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(ped), true) < triggerDistance then
        return true
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local peds = GetGamePool('CPed')

        for _, ped in ipairs(peds) do
            if DoesEntityExist(ped) and not IsPedAPlayer(ped) and isGangPed(ped) then
                local dist = #(playerCoords - GetEntityCoords(ped))
                if dist < detectionRadius and isPlayerThreatening(ped) then
                    TaskCombatPed(ped, PlayerPedId(), 0, 16)
                end
            end
        end
    end
end)
