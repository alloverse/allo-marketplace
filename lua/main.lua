local vec3 = require("modules.vec3")
local mat4 = require("modules.mat4")
local json = require "allo.json"
local Frame = require("frame")

local client = Client(
    arg[2], 
    "allo-marketplace"
)

function readfile(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local s = f:read("*a")
    f:close()
    return s
end

local app = App(client)

local apps = {}
local p = io.popen('find apps/* -maxdepth 0')
for appPath in p:lines() do
    local shortname = string.gsub(appPath, "(.*/)(.*)", "%2")
    local infojsonstr = readfile(appPath.."/info.json")
    if infojsonstr then
        local desc = {
            shortname= shortname,
            path= appPath,
            meta= json.decode(infojsonstr),
            icon= ui.Asset.File(appPath.."/icon.glb")
        }
        print("Marketplace adding app '"..desc.meta.display_name.."' from "..appPath)
        table.insert(apps, desc)
        app.assetManager:add(desc.icon)
    else
        print("Marketplace skipping un-meta'd app "..appPath)
    end
end
p:close()


assets = {
    quit = ui.Asset.File("images/quit.png"),
}
app.assetManager:add(assets)

class.AppView(ui.ProxyIconView)
function AppView:_init(bounds, desc)
    local author = desc.meta.author or ""
    self:super(bounds, desc.meta.display_name, author, desc.icon)
    self.desc = desc
end

function AppView:onIconDropped(pos)
    print("Asking place to launch", self.desc.shortname)
    pos._m = nil -- so it becomes json-valid
    client:sendInteraction({
        receiver_entity_id = "place",
        body = {
            "launch_app",
            "alloapp:http://localhost:8000/"..self.desc.shortname,
            {
                initialLocation= pos
            }
        }
    }, function(resp, body)
        if body[2] ~= "ok" then
            print("Failed to launch", self.desc.shortname, ":", resp.body)
        else
            print("Successfully launched", self.desc.shortname)
        end
    end)

    return true
end



local columnCount = 4
local frameWidth = 2.0
local rowCount = math.ceil(#apps/columnCount)
local mainView = Frame(
    ui.Bounds(0,0,0, frameWidth, rowCount*0.4, 0.06)
        :rotate(3.14159/2, 0,1,0)
        :move(-3, 1.6, 0.5),
    0.03
)
mainView.grabbable = true
mainView:setColor(ui.Color.alloDarkPink())

local titleLabel = mainView:addSubview(ui.Label{
    bounds= ui.Bounds{size=ui.Size(frameWidth,0.10,0.01)}
        :move( mainView.bounds.size:getEdge("top", "center", "back") )
        :move( 0, 0.06, 0),
    text= "Alloverse App Market",
    halign= "left",
})

local helpLabel = mainView:addSubview(ui.Label{
    bounds= ui.Bounds{size=ui.Size(frameWidth,0.06,0.01)}
        :move( mainView.bounds.size:getEdge("bottom", "center", "back") )
        :move( 0, -0.10, 0),
    text= "Grab an app (grip button or right mouse button)\n and drop it somewhere to start it.",
    halign= "left",
    color={0.6, 0.6, 0.6, 1}
})

local grid = mainView:addSubview(
    ui.GridView(ui.Bounds{size=mainView.bounds.size:copy()}:insetEdges(0.06, 0.06, 0.06, 0.06, 0, 0))
)

local itemSize = grid.bounds.size:copy()
itemSize.width = itemSize.width / columnCount
itemSize.height = itemSize.height / rowCount

for _, desc in ipairs(apps) do
    local appView = grid:addSubview(
        AppView(ui.Bounds{size=itemSize:copy()}, desc)
    )
end
grid:layout()


local quitButton = mainView:addSubview(ui.Button(
    ui.Bounds{size=ui.Size(0.12,0.12,0.05)}
        :move( mainView.bounds.size:getEdge("top", "right", "front") )
))
quitButton:setDefaultTexture(assets.quit)
quitButton.onActivated = function()
    app:quit()
end

app.mainView = mainView

app:connect()
app:run()
