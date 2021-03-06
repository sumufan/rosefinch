---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xiaoyueya.
--- DateTime: 2018/12/22 下午5:56
---
---@class redis_service
redis_service = {}

local redis_conf = require("src.conf.redis_conf");

--评估师权限
redis_service.prefix_user_authority = "inspector:auth:";


---@public set
---@param key string
---@param value string
---@return boolean
function redis_service.set(key,value)
    local redis_factory = require('src.helper.redis_factory')(redis_conf.get_conf())
    local ok, redis_a = redis_factory:get_instance(redis_conf.default)
    if not ok then
        return false;
    end
    local ok = redis_a:set(key, value)
    if not ok then
        return false;
    end
    return true;
end

---@public get
---@param key string
---@return string
function redis_service.get(key)
    local redis_factory = require('src.helper.redis_factory')(redis_conf.get_conf())
    local ok, client = redis_factory:get_instance(redis_conf.default);
    if not ok then
        return nil;
    end
    local value,err = client:get(key);
    if err ~= nil then
        return nil;
    end
    return value;
end

---@public expire_at
---@param key string
---@param unix_time number
---@return nil
function redis_service.expire_at(key,unix_time)
    local redis_factory = require('src.helper.redis_factory')(redis_conf.get_conf())
    local ok, client = redis_factory:get_instance(redis_conf.default);
    if not ok then
        return;
    end
    client:expireat(key,unix_time);
end

---@public destruct
---@return nil
function redis_service.destruct()
    local redis_factory = require('src.helper.redis_factory')(redis_conf.get_conf())
    --批量操作完成之后调用
    redis_factory:destruct();
end



return redis_service;