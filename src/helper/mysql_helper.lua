---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xiaoyueya.
--- DateTime: 2019/5/31 下午4:16
---

local mysql = require("resty.mysql");
local mysql_config = require("src.conf.mysql_conf").config(mysql_conf.defaultSource);

--- @class mysql_client
mysql_client = {};

--- 获取db
local function getdb()
    --- 实例化mysql类
    local db, err = mysql:new()
    if not db then
        ngx.say("failed to instantiate mysql: ", err)
        return nil
    end
    --- 设置链接超时时间
    db:set_timeout(mysql_config.timeout)
    --- 获取连接
    local ok, err, err_code, sqlstate = db:connect{
        host = mysql_config.host,
        port = mysql_config.port,
        database = mysql_config.database,
        user = mysql_config.username,
        password = mysql_config.password,
        charset = "utf8",
        max_packet_size = 1024 * 1024,
    }
    if not ok then
        ngx.say("failed to connect: ", err, ": ", err_code, " ", sqlstate)
        return nil
    end
    return db;
end

--- 关闭链接
local function close(db)

    --- Only call this method in the place you would have called the close method instead.
    --- Calling this method will immediately turn the current resty.mysql object into the closed state.
    --- Any subsequent operations other than connect() on the current objet will return the closed error.
    --- put it into the connection pool of size 50,
    --- with 10 seconds max idle timeout
    local ok, err = db:set_keepalive(mysql_config.maxIdleTimeout, mysql_config.poolSize)
    if not ok then
        ngx.log(ngx.ERR, "failed to set keepalive: ", err)
        ngx.exit(500)
    end

    --local ok, err = db:close()
    --if not ok then
    --    ngx.say("failed to close: ", err)
    --    return
    --end
end

--- 执行sql返回受影响行数
function mysql_client.execute(sql)
    --- 获取db
    local db = getdb();
    if not db then
        return 0;
    end

    --- 执行
    local query_count = 1;
    local res, err, errcode, sqlstate =  db:query(sql);
    if not res then
        ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
        query_count = 0;
    end
    close(db);
    return query_count;
end

--- 执行sql返回查询结果
function mysql_client.query(sql,limit)
    local db = getdb();
    if not db then
        return nil;
    end
    -- run a select query, expected about 10 rows in
    -- the result set:
    local res, err, errcode, sqlstate = db:query(sql, limit)
    close(db);
    if not res then
        ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
        return nil
    end
    return res;
end

return mysql_client;