local config = {}

---@class DbmanLogConfig
---@field level string Filter level for logging. Valid levels are "TRACE2", "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "CRITICAL". NOTE, _not_ case sensitive
---@field location string The location to store the log file at. Useful if you are trying to reproduce a log and ship it to me

---@class DbmanConfig
---@field log DbmanLogConfig
local current_config = {}

---@type DbmanConfig
local default_configuration = {
    ---@type DbmanLogConfig
    log = {
        level = "TRACE",
        location = vim.fn.stdpath('log') .. '/dbman.log' -- This is identical to what is in logger defaults
    }
}

--- Merges an input configuration with preset defaults. Input configuration _will_ override
--- any defaults that are set.
---
--- Returns the merged configuration
--- @param in_config table
--- @return DbmanConfig
function config.merge(in_config)
    current_config = vim.tbl_deep_extend("keep", in_config or {}, default_configuration)
    return current_config
end

function config.get_current_config()
    return current_config
end

return config
