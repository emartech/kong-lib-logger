local Logger = require 'logger'
local ngx = require 'fake_ngx'

describe('Logger', function()

    before_each(function()
        ngx.ctx = {}
        ngx.clearLoggedMessages()
    end)

    describe('#logNotice', function()

        it('should log notice', function()
            local logger = Logger.getInstance(ngx)
            logger:logNotice({ foo = 'bar' })
            local logged = ngx.getLoggedMessages()[1]

            assert.are.same(ngx.NOTICE, logged.severity)
            assert.are.same('bar', logged['data']['foo'])
            assert.are.same('notice', logged['data']['severity'])
            assert.are.same(ngx.var.request_id, logged['data']['transaction_id'])
            assert.are.same(1, logged['data']['log_counter'])
            assert.string_match('logger_spec.lua:%d+$', logged['data']['caller_file_path'])
        end)

        it('should not mutate input data', function()
            local data = { foo = 'bar' }
            Logger.getInstance(ngx):logNotice(data)
            assert.are.same({ foo = 'bar' }, data)
        end)

        it('should increment log_counter when called multiple times', function()
            Logger.getInstance(ngx):logNotice({ foo = 'bar' })
            Logger.getInstance(ngx):logNotice({ foo = 'bar' })

            local loggedMessages = ngx.getLoggedMessages()
            assert.are.same(1, loggedMessages[1]['data']['log_counter'])
            assert.are.same(2, loggedMessages[2]['data']['log_counter'])
        end)

    end)

    describe('#logError', function()

        it('should log error', function()
            local logger = Logger.getInstance(ngx)
            logger:logError({ foo = 'bar' })
            local logged = ngx.getLoggedMessages()[1]

            assert.are.same(ngx.ERR, logged.severity)
            assert.are.same('bar', logged['data']['error']['foo'])
            assert.are.same('error', logged['data']['severity'])
            assert.are.same(ngx.var.request_id, logged['data']['transaction_id'])
            assert.are.same(1, logged['data']['log_counter'])
            assert.string_match('logger_spec.lua:%d+$', logged['data']['caller_file_path'])
        end)

        it('should not mutate input data', function()
            local data = { foo = 'bar' }
            Logger.getInstance(ngx):logError(data)
            assert.are.same({ foo = 'bar' }, data)
        end)

    end)

    describe('.getInstance', function()

        it('should return with the same instance for every call', function()
            local logger1 = Logger.getInstance(ngx)
            local logger2 = Logger.getInstance(ngx)

            assert.are.equal(logger1, logger2)
        end)

        it('should return different instance after context is cleared', function()
            local logger1 = Logger.getInstance(ngx)
            ngx.ctx = {}
            local logger2 = Logger.getInstance(ngx)

            assert.are_not.equal(logger1, logger2)
        end)

        it('should raise error when ngx not passed to the construstor', function()
            assert.has.error(function() Logger.getInstance() end, 'Nginx is required to construct a logger')
        end)

    end)

    describe('#new', function()

        it('should return unique instance for every call', function()
            Logger.getInstance(ngx)
            local logger1 = Logger()
            local logger2 = Logger()

            assert.are_not.equal(logger1, logger2)
        end)

    end)

    describe('#addContext', function()

        it('should extend log messages with context', function()
            Logger.getInstance(ngx):addContext({ foo1 = 'bar1' })

            Logger.getInstance(ngx):logNotice({ foo2 = 'bar2' })

            local loggedMessage = ngx.getLoggedMessages()[1]
            assert.are.same({ foo1 = 'bar1' }, loggedMessage['data']['context'])
        end)

        it('should extend the previous context', function()
            Logger.getInstance(ngx):addContext({ foo1 = 'bar1', foo2 = 'original' })
            Logger.getInstance(ngx):addContext({ foo2 = 'updated', foo3 = 'bar3' })

            Logger.getInstance(ngx):logNotice({ lorem = 'ipsum' })

            local loggedMessage = ngx.getLoggedMessages()[1]
            local expectedContext = { foo1 = 'bar1', foo2 = 'updated', foo3 = 'bar3' }
            assert.are.same(expectedContext, loggedMessage['data']['context'])
        end)

    end)

    describe('#logWarning', function()

        it('should log warning', function()
            local logger = Logger.getInstance(ngx)
            logger:logWarning({ foo = 'bar' })
            local logged = ngx.getLoggedMessages()[1]

            assert.are.same(ngx.WARN, logged.severity)
            assert.are.same('bar', logged['data']['foo'])
            assert.are.same('warning', logged['data']['severity'])
            assert.are.same(ngx.var.request_id, logged['data']['transaction_id'])
            assert.are.same(1, logged['data']['log_counter'])
            assert.string_match('logger_spec.lua:%d+$', logged['data']['caller_file_path'])
        end)

        it('should not mutate input data', function()
            local data = { foo = 'bar' }
            Logger.getInstance(ngx):logWarning(data)
            assert.are.same({ foo = 'bar' }, data)
        end)

    end)

end)
