-- 1. Initialize storage state (persistent across code updates)
AuditLogs = AuditLogs or {}

-- 2. Core Logic: Mock Data Fetching
function fetchLatestDrugData()
    local mockID = "TX-" .. math.random(1000, 9999)
    local mockAmount = math.random(50000, 500000)
    
    local newEntry = {
        id = mockID,
        amount = mockAmount,
        status = "Pending_Audit",
        timestamp = "2026-01-05"
    }
    
    table.insert(AuditLogs, newEntry)
    return "Successfully fetched mock data! ID: " .. mockID .. " Amount: $" .. mockAmount
end

-- 3. Handler: Manual Audit Trigger (for Demo)
Handlers.add(
    "ManualAudit",
    Handlers.utils.hasMatchingTag("Action", "Audit"),
    function (msg)
        local result = fetchLatestDrugData()
        print(result)
        msg.reply({ Data = result })
    end
)

-- 4. Handler: Query Audit Logs
Handlers.add(
    "GetLogs",
    Handlers.utils.hasMatchingTag("Action", "GetLogs"),
    function (msg)
        print("--- Current Audit Log List ---")
        for i, log in ipairs(AuditLogs) do
            print(i .. ". [" .. log.id .. "] Amount: " .. log.amount .. " Status: " .. log.status)
        end
    end
)

print("OncoAudit v0.1 Core Logic Loaded")