local logger = require("dbman.logger")
local lib = {}

---@class Dependency
---@field short_name string The name that is required in lua space
---@field long_name string The name that is usually referenced in a plugin manager such as lazy
---@field url string The url that the plugin can be found at
---@field required? boolean If provided (and true) indicates that the dependency is critical. If a dependency that is required is missing, we will die

---Creates a dependency and returns it
---@param short_name string
---@param long_name string
---@param url string
---@param required? boolean|nil
---@return Dependency
local function make_dep(short_name, long_name, url, required)
    return {
        short_name = short_name,
        long_name = long_name,
        url = url,
        required = required or false
    }
end

---@type Dependency[]
local deps = {
    make_dep("neo-tree", "nvim-neo-tree/neo-tree.nvim", "https://github.com/nvim-neo-tree/neo-tree.nvim"),
    make_dep("nio", "nvim-neotest/nvim-nio", "https://github.com/nvim-neotest/nvim-nio", true),
    -- Do we need?
    -- make_dep("plenary", "nvim-lua/plenary.nvim", "https://github.com/nvim-lua/plenary.nvim", true)
}

--- Checks to see if all critical dependencies are available. If there is a missing dependency, we will yell.
--- If there is a missing critical dependency, we will die
---@return boolean
function lib.check_deps()
    local has_deps = true
    for _, dep in ipairs(deps) do
        local exists, err = pcall(require, dep[1])
        logger.trace2(string.format("Checking if %s exists", dep.long_name), err)
        if not exists then
            local log_level = dep.required and logger.critical or logger.warn
            log_level(string.format('Dependency "%s" not found! Please install "%s". Checkout %s for details', dep.long_name, dep.url))
            has_deps = false
        end
    end
    if not has_deps then
        logger.critical("Unable to setup dbman, missing critical dependencies!")
    end
    return has_deps
end

return lib
