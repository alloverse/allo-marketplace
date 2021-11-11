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
    local infojsonstr = readfile(appPath.."/info.json")
    if infojsonstr then
        local desc = {
            path=appPath,
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
    self:super(bounds, desc.meta.display_name, desc.icon)
    self.desc = desc
end

function AppView:onIconDropped(pos)
    local command = 'cd '..self.desc.path..'; ./allo/assist run '..arg[2]..' "'..tostring(pos)..'" &'
    print("Launching app "..command)
    os.execute(command)
end



local columnCount = 3
local rowCount = math.ceil(#apps/columnCount)
local mainView = Frame(
    ui.Bounds(0,0,0, 1.5, rowCount*0.4, 0.06)
        :rotate(3.14159/2, 0,1,0)
        :move(-3, 1.6, 0.5),
    0.03
)
mainView.grabbable = true

local titleLabel = mainView:addSubview(ui.Label{
    bounds= ui.Bounds{size=ui.Size(1.5,0.10,0.01)}
        :move( mainView.bounds.size:getEdge("top", "center", "back") )
        :move( 0, 0.06, 0),
    text= "Alloverse App Market",
    halign= "left",
})

local helpLabel = mainView:addSubview(ui.Label{
    bounds= ui.Bounds{size=ui.Size(1.5,0.06,0.01)}
        :move( mainView.bounds.size:getEdge("bottom", "center", "back") )
        :move( 0, -0.10, 0),
    text= "Grab an app (grip button or right mouse button) and drop it somewhere to start it.",
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
