local M = {}

local lib = require("dbman.lib")
local logger = require("dbman.logger")
local config = require("dbman.config")

function M.setup(opts)
    local merged_config = config.merge(opts)
    logger.init(merged_config.log)
end

return M
