-- Project: OncoAudit: International Audit Terminal
-- Version: 2.0.0 (January 2026 Migration)
-- Objective: Permanent monitoring of oncology drug reimbursement gaps
-- Architecture: AOS (Arweave Object) Parallel Processing
-- Target: Benchmarking 7.6x Efficiency Gaps in Global Healthcare

-- [1] Initialize Database with Real-World Evidence (Persistent State)
Founder = Founder or Owner 
DrugDatabase = DrugDatabase or {
    { 
        id = "1", name = "Tagrisso", category = "Lung Cancer", 
        tw_wait_days = 1225, status = "Audited", 
        source = "https://tmcdfplatform.org.tw/" 
    },
    { 
        id = "2", name = "Enhertu", category = "Breast Cancer", 
        tw_wait_days = 458, status = "Audited", 
        source = "https://tmcdfplatform.org.tw/" 
    },
    { 
        id = "3", name = "Tecentriq", category = "Immunotherapy", 
        tw_wait_days = 2875, status = "Admin_Silence", 
        source = "https://tmcdfplatform.org.tw/" 
    },
    { 
        id = "4", name = "Japan_MHLW_Dataset", 
        status = "Link_Rot_Detected", 
        note = "Original source (404) lost on legacy web. Metadata preserved via OncoAudit on AO." 
    }
}
Logs = Logs or {} 
LeakingLogs = LeakingLogs or {} 

-- [2] Helper: System Logging
function AddLog(e, d)
    table.insert(Logs, 1, { 
        timestamp = os.date("%Y-%m-%d %H:%M:%S"), 
        event = e, 
        detail = d 
    })
    if #Logs > 50 then table.remove(Logs) end
end

-- [3] Handlers: Data Retrieval
Handlers.add("GetPrices", Handlers.utils.hasMatchingTag("Action", "GetPrices"), function(msg)
    print("Dispatching Audit Records...")
    Handlers.utils.reply(require("json").encode(DrugDatabase))(msg)
end)

Handlers.add("GetLogs", Handlers.utils.hasMatchingTag("Action", "GetLogs"), function(msg)
    Handlers.utils.reply(require("json").encode(Logs))(msg)
end)

-- [4] Handlers: Anonymous Evidence Submission (v4.0 Physical Evidence Prototype)
-- Designed for regions without digital data - allowing upload of document hashes.
Handlers.add("SubmitMessage", Handlers.utils.hasMatchingTag("Action", "SubmitMessage"), function(msg)
    table.insert(LeakingLogs, 1, { 
        from = msg.From, 
        data = msg.Data, -- Expected: IPFS/Arweave Hash of physical document scan
        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
        method = "Citizen_Audit_Submission" 
    })
    AddLog("Manual_Evidence_Stored", "Citizen submitted physical document hash for verification.")
    msg.reply({ Data = "Evidence Cryptographically Sealed on AO." })
end)

-- [5] Handlers: Update Price (Admin Only)
Handlers.add("UpdatePrice", Handlers.utils.hasMatchingTag("Action", "UpdatePrice"), function(msg)
    if msg.From ~= Owner then 
        msg.reply({ Error = "Unauthorized" }) 
        return 
    end
    local n = require("json").decode(msg.Data)
    for i, v in ipairs(DrugDatabase) do
        if v.name == n.name then
            DrugDatabase[i].tw_wait_days = n.tw_wait_days or v.tw_wait_days
            DrugDatabase[i].status = "Updated_By_Authority"
            AddLog("Audit_Update", v.name)
            break
        end
    end
    msg.reply({ Data = "Update Successful" })
end)

AddLog("Protocol_Launch", "OncoAudit v2.0.0 Global Terminal Online")
print("--- [OncoAudit v2.0.0] Ready for Arweave Pathfinder Audit ---")
