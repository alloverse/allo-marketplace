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
    local s = f:read("*a")
    f:close()
    return s
end

local app = App(client)

local apps = {}
local p = io.popen('find apps/* -maxdepth 0')
for appPath in p:lines() do
    print("App: "..appPath)
    local desc = {
        path=appPath,
        meta= json.decode(readfile(appPath.."/info.json")),
        icon= ui.Asset.File(appPath.."/icon.glb")
    }
    table.insert(apps, desc)
    app.assetManager:add(desc.icon)
end
p:close()


assets = {
    quit = ui.Asset.File("images/quit.png"),
}
app.assetManager:add(assets)

class.AppView(View)
function AppView:_init(bounds, desc)
    self:super(bounds)
    self.desc = desc
    self:makeIcon()

    self.brick = self:addSubview(ui.Cube(
        ui.Bounds{size=bounds.size:copy()}
        :insetEdges(0.05, 0.05, 0.05, 0.05, 0.00, 0.05)
        :move(0, 0, -0.05)
    ))
    self.brick.color = {0.9, 0.4, 0.3, 0.3}
    self.label = self:addSubview(
        ui.Label{
            bounds= ui.Bounds(0, 0, 0,   bounds.size.width, 0.05, 0.01)
                :move(0, -bounds.size.height/2 + 0.08, 0),
            text= self.desc.meta.display_name,
            color = {1, 1, 1, 1}
        }
    )
end

function AppView:makeIcon()
    self.icon = ui.Asset.View(self.desc.icon, 
        ui.Bounds{size=self.bounds.size:copy()}
            :move(0, 0, 0.05)
    )
    self.icon.color = {0.5, 0.2, 0.5, 1.0}
    self.icon:setGrabbable(true, {target_hand_transform= mat4.identity()})
    self.icon.onGrabStarted = function()
        self:makeIcon()
    end
    self.icon.onGrabEnded = function(oldIcon)
        local m_at = oldIcon.entity.components.transform:transformFromWorld()
        local v_at = m_at * vec3(0,0,-0.5)
        self:launchApp(v_at)
        oldIcon:removeFromSuperview()
    end
    self:addSubview(self.icon)
end

function AppView:launchApp(pos)
    local command = 'cd '..self.desc.path..'; ./allo/assist run '..arg[2]..' "'..tostring(pos)..'" &'
    print("Launching app "..command)
    os.execute(command)
end


local mainView = Frame(ui.Bounds(-3, 1.6, -2,   1.5, 0.8, 0.06), 0.03)
mainView.grabbable = true

local titleLabel = mainView:addSubview(ui.Label{
    bounds= ui.Bounds{size=ui.Size(1.5,0.10,0.01)}
        :move( mainView.bounds.size:getEdge("top", "center", "back") )
        :move( 0, 0.06, 0),
    text= "Alloverse Marketplace",
    halign= "left",
})

local grid = mainView:addSubview(
    ui.GridView(ui.Bounds{size=mainView.bounds.size:copy()})
)

local itemSize = mainView.bounds.size:copy()
itemSize.width = itemSize.width / 3
itemSize.height = itemSize.height / 2 
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
