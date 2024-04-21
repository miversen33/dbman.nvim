---@class DbmanResult
---@field name string The "key" that this result is associated with
---@field value any The "value" that is associated with this result
---@field type? string The "type" of this value. Useful if the type is something odd (like JSON). Not likely respected though, probably will not be used and may be removed, we will see

---@class DbmanProvider
---@field name string The name of the provider. Make this the same name as the database you support. EG "SQLite" or "Redis"
---@field version string The version that your provider is currently. Follow Semvar standards for versioning. We will use this for bug reporting
---@field repo_link string The link to your code base for the provider. This is required for all 3rd party providers so we can properly direct bugs
---@field schema? string If set, this should be the filename schema you want us to watch for. As an example, this can be used to hook open events for 'sqlite://'. In this case, the schema is 'sqlite'. NOTE, there can only be one provider per schema. If there is a conflict, the most recently loaded (read race condition) provider will be used and the unloaded one will be logged.

---@class DbmanConnectionInfo
---@field host string The string representation of the hostname(or socket)
---@field port? integer The port to connect to. Optional depending on the provider
---@field username? string The username to connect with. Optional depending on the provider
---@field password? string The password to connect with. Optional depending on the provider
---@field _db_type string The type of database being connected to. SQLite, Postgresql, Mongodb, Redis, etc.
---@field _status string The current status of the connection. Will be one of the following "CONNECTED", "DISCONNECTED"

---@class DbmanConnectionMeta
---@field databases fun(cb: fun(results: string[], err?: string)): nio.tasks.Task This will attempt to fetch a list of available databases on this connection.
---@field schemas fun(cb: fun(results: string[], err?: string), database: string): nio.tasks.Task This will attempt to fetch a list of schemas available on the connection. Note, not all databases support schemas. In such a case, this function will provide an empty list to the callback immediately.
---@field tables fun(cb: fun(results: string[], err?: string), database: string, schema?: string): nio.tasks.Task This will attempt to fetch the tables of the provided database. If the provider supports/requires schemas, you can provide that as the third argument
---@field views fun(cb: fun(results: string[], err?: string), database: string, schema?: string): nio.tasks.Task This will attempt to fetch any views that are associated with the database provided.
---@field indexes fun(cb: fun(results: DbmanResult[], err?: string), table: string, database?: string, schema?: string): nio.tasks.Task This will attempt to fetch any indexes that are associated with the table. Note, some databases do not have a concept of indexes. These providers will simply return an empty table immediately
---@field foreign_keys fun(cb: fun(results: DbmanResult[], err?: string), table: string, database?: string, schema?: string): nio.tasks.Task This will attempt to fetch any foreign keys that are associated with the database. Note, some databases do not have a concept of foreign keys. These providers will simply return an empty table immediately

---@class DbmanConnection
---@field _conn_info DbmanConnectionInfo
---@field _provider DbmanProvider
---@field meta DbmanConnectionMeta
---@field is_connected fun(): boolean This will return a true/false to indicate if we are connected or not
---@field connect fun(cb: fun(success?: boolean)): nio.tasks.Task This will attempt to connect to the database. A `true` should be returned only if the connection was successful
---@field disconnect fun(cb: fun(status: string), force?: boolean): nio.tasks.Task This will attempt to disconnect the database. A string may be returned that will indicate any output on disconnection
---@field query fun(cb: fun(results: DbmanResult[], err?: string), query: string, ...): nio.tasks.Task Executes the provided query. Varargs can be provided if the database supports placeholders

