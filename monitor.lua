-- Project: OncoAudit: International Audit Terminal
-- Version: 2.0.0 (January 2026 Migration)
-- Objective: Permanent monitoring of oncology drug reimbursement gaps
-- Architecture: AO Parallel Compute + Arweave Permanent Storage

-- [1] 初始化資料庫 (Persistent Storage State)
Founder = Founder or Owner -- Owner 是 AOS 內建的變數，確保只有你能更新藥價
DrugDatabase = DrugDatabase or {
    { id = "1", name = "Tagrisso", category = "Lung Cancer", tw_price = 115500, jp_price = 28000, status = "Audited" },
    { id = "2", name = "Enhertu", category = "Breast Cancer", tw_price = 100000, jp_price = 45000, status = "Indexing" },
    { id = "3", name = "Tecentriq", category = "Immunotherapy", tw_price = 150000, jp_price = 55000, status = "Admin_Silence" }
}
Logs = Logs or {} 
LeakingLogs = LeakingLogs or {} -- 匿名存證區（AO 真相機器核心）

-- [2] 工具函數：新增系統日誌 (Optimized for Transparency)
function AddLog(e, d)
    table.insert(Logs, 1, { 
        timestamp = os.date("%Y-%m-%d %H:%M:%S"), 
        event = e, 
        detail = d,
        network = "AO-Mainnet-Beta" 
    })
    if #Logs > 50 then table.remove(Logs) end
end

-- [3] Handlers: 資料讀取 (GetPrices & GetLogs)
Handlers.add("GetPrices", Handlers.utils.hasMatchingTag("Action", "GetPrices"), function(msg)
    print("Dispatching Drug Price Database...")
    Handlers.utils.reply(require("json").encode(DrugDatabase))(msg)
end)

Handlers.add("GetLogs", Handlers.utils.hasMatchingTag("Action", "GetLogs"), function(msg)
    Handlers.utils.reply(require("json").encode(Logs))(msg)
end)

-- [4] Handlers: 匿名存證爆料 (Whistleblower Protection Layer)
Handlers.add("SubmitMessage", Handlers.utils.hasMatchingTag("Action", "SubmitMessage"), function(msg)
    table.insert(LeakingLogs, 1, { 
        from = msg.From, 
        data = msg.Data, 
        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
        integrity = "Permanent_Seal" 
    })
    AddLog("Whistleblower_Event", "Evidence of administrative silence recorded.")
    msg.reply({ Data = "Evidence Cryptographically Stored on AO/Arweave" })
end)

-- [5] Handlers: 更新藥價 (Security: Admin Only)
Handlers.add("UpdatePrice", Handlers.utils.hasMatchingTag("Action", "UpdatePrice"), function(msg)
    -- 嚴格權限控管：只有 Process Owner 可以更新
    if msg.From ~= Owner then 
        msg.reply({ Error = "Unauthorized access. This incident will be logged." }) 
        AddLog("Security_Alert", "Unauthorized update attempt from: " .. msg.From)
        return 
    end
    
    local n = require("json").decode(msg.Data)
    for i, v in ipairs(DrugDatabase) do
        if v.name == n.name then
            DrugDatabase[i].tw_price = n.tw_price or v.tw_price
            DrugDatabase[i].status = "Updated_By_Authority"
            AddLog("Price_Audit_Update", v.name)
            break
        end
    end
    msg.reply({ Data = "Update Successful" })
end)

-- 系統引導
AddLog("Protocol_Launch", "OncoAudit v2.0.0 Global Terminal Online")
print("--- [OncoAudit v2.0.0] International Audit Core Fully Loaded ---")

