-- 2026 Cancer Fund Monitor Core Process
-- Initialize the drug database
DrugDatabase = DrugDatabase or {
    { id = "1", name = "Tagrisso", category = "Lung Cancer", tw_price = 115500, us_price = 480000, status = "Stable" },
    { id = "2", name = "Enhertu", category = "Breast Cancer", tw_price = 100000, us_price = 210000, status = "Indexing" },
    { id = "3", name = "Lynparza", category = "Ovarian Cancer", tw_price = 275000, us_price = 350000, status = "Indexing" }
}

-- Handler to return the full price list
Handlers.add(
    "GetPrices",
    Handlers.utils.hasMatchingTag("Action", "GetPrices"),
    function (msg)
        print("Handling GetPrices request from: " .. msg.From)
        Handlers.utils.reply(JSON.encode(DrugDatabase))(msg)
    end
)

-- Handler for potential future AI Agent updates (Restricted to Founder)
Handlers.add(
    "UpdatePrice",
    Handlers.utils.hasMatchingTag("Action", "UpdatePrice"),
    function (msg)
        -- In a real scenario, we would check if msg.From is the Founder's address
        local newData = JSON.decode(msg.Data)
        -- Logic to update local table...
        print("Price Update Received for: " .. newData.name)
        msg.reply({ Data = "Update Logged on ao." })
    end
)