---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xiaoyueya.
--- DateTime: 2018/12/22 下午5:08
---
local metatb = {name="metatb",age=100};
local newtn = {age = 150};
setmetatable(newtn,{ __newindex = metatb,__index = metatb });
print(newtn.name)
print(newtn.age)
print(cjson.encode(newtn))

print("---------------")

print(metatb.name)
print(metatb.age)


print("---------------")

newtn.name = "newtn";
newtn.age = 512;
print(newtn.name)
print(newtn.age)
print(cjson.encode(newtn))


print("---------------")

local mtb = getmetatable(newtn)
print(mtb.name)
print(mtb.age)

print(metatb.name)
print(metatb.age)

print(cjson.encode(newtn))