-- 2026 Cancer Fund Monitor Core Process v1.2
-- 包含：藥價資料庫、權限控管、系統日誌、匿名爆料存證

-- [1] 初始化資料庫
Founder = Founder or Owner 
DrugDatabase = DrugDatabase or {
    { id = "1", name = "Tagrisso", category = "Lung Cancer", tw_price = 115500, us_price = 480000, status = "Stable" },
    { id = "2", name = "Enhertu", category = "Breast Cancer", tw_price = 100000, us_price = 210000, status = "Indexing" },
    { id = "3", name = "Lynparza", category = "Ovarian Cancer", tw_price = 275000, us_price = 350000, status = "Indexing" }
}
Logs = Logs or {} 
LeakingLogs = LeakingLogs or {} 

-- [2] 工具函數：新增系統日誌
function AddLog(e, d)
    table.insert(Logs, 1, { timestamp = os.date("%Y-%m-%d %H:%M:%S"), event = e, detail = d })
    if #Logs > 20 then table.remove(Logs) end
end

-- [3] Handlers: 資料讀取 (GetPrices & GetLogs)
Handlers.add("GetPrices", Handlers.utils.hasMatchingTag("Action", "GetPrices"), function(msg)
    Handlers.utils.reply(require("json").encode(DrugDatabase))(msg)
end)

Handlers.add("GetLogs", Handlers.utils.hasMatchingTag("Action", "GetLogs"), function(msg)
    Handlers.utils.reply(require("json").encode(Logs))(msg)
end)

-- [4] Handlers: 匿名存證爆料 (SubmitMessage)
Handlers.add("SubmitMessage", Handlers.utils.hasMatchingTag("Action", "SubmitMessage"), function(msg)
    table.insert(LeakingLogs, 1, { from = msg.From, data = msg.Data, timestamp = os.date("%Y-%m-%d %H:%M:%S") })
    AddLog("New Leak", "收到一筆匿名金流爆料")
    msg.reply({ Data = "Evidence Stored on AO" })
end)

-- [5] Handlers: 更新藥價 (限創始人)
Handlers.add("UpdatePrice", Handlers.utils.hasMatchingTag("Action", "UpdatePrice"), function(msg)
    if msg.From ~= Founder then msg.reply({ Error = "Unauthorized" }) return end
    local n = require("json").decode(msg.Data)
    for i, v in ipairs(DrugDatabase) do
        if v.name == n.name then
            DrugDatabase[i].tw_price = n.tw_price or v.tw_price
            DrugDatabase[i].status = "Updated"
            AddLog("Price Update", v.name)
            break
        end
    end
    msg.reply({ Data = "OK" })
end)

-- 初始化日誌
AddLog("System Boot", "癌症監測站核心程序啟動成功")
print("--- AO 監測站核心 v1.2 已完全裝載 ---")
