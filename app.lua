local stardust = require "stardust"
local router = require "stardust.router"
local cjson = require "cjson"
local http = require "resty.http"

local _M = {}

local encode = cjson.encode
local decode = cjson.decode

local function json(res, data)
    res.status = 200
    res.headers["Content-Type"] = "application/json"
    res.body = encode(data)
end

local app = stardust.new()
local r = router.new()
app:use(r)

app:use(stardust.sender)

local cache = ngx.shared.cache

r:get("^/ami/(%a+)/(.+)$",
      function(req, res)
          local c = http.new()
          local region = req.params[2]
          local channel = req.params[1]
          local val = cache:get(channel)
          if val == nil then
              local url = "http://" .. channel .. ".release.core-os.net/amd64-usr/current/coreos_production_ami_all.json"
              local rc, err = c:request_uri(url)
              if not rc then
                  ngx.log(ngx.ERR, "http failure: ", err)
                  return err
              end
              if rc.status ~= 200 then
                  ngx.log(ngx.ERR, "http failure: ", rs.status)
                  return
              end
              val = rc.body
              cache:set(channel, val, 3600)
          end

          -- we could cache the channel+region and avoid this, but is fine for now
          data, err = decode(val)
          if err ~= nil then
               ngx.log(ngx.ERR, "json failure: ", err)
               return err
          end

          for  _, v in ipairs(data.amis) do
              if v.name == region then
                  return json(res, v)
              end
          end
            res.status = 404
      end
)


function _M.run(ngx)
    return app:run(ngx)
end

return _M
