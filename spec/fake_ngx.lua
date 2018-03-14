local cjson = require "cjson"

local loggedMessages = {}

local ngx = {
    ERR = 4,
    WARN = 5,
    NOTICE = 6,


    log = function(severity, data)
        table.insert(loggedMessages, {
            severity = severity,
            data = cjson.decode(data)
        })
    end,


    getLoggedMessages = function()
        return loggedMessages
    end,


    clearLoggedMessages = function()
        loggedMessages = {}
    end,

    var = {
        request_id = 'random_request_id',
        dns_server = 'test.dns.ser.ver'
    },

    ctx = {},

    sleep = function() end

}

return ngx
