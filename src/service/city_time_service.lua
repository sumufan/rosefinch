---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xiaoyueya.
--- DateTime: 2019/5/31 下午4:59
---

local client = require("src.helper.mysql_helper")

cityTime = { VERSION = 1.0 };

--- 获取分发的url
function cityTime.getTimeFromCIty(city)
    local sql = "select city,`current_time` from t_city_time where city = '"..city.."' order by id asc ";
    return client.query(sql,1);
end

--- 获取转发的子请求的IP
function cityTime.getUrl()
    local sql = "select url from t_distribution_url where id = 1";
    return client.query(sql,1);
end

return cityTime;