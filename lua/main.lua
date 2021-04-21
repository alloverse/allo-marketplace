local vec3 = require("modules.vec3")
local mat4 = require("modules.mat4")
local Frame = require("frame")

local client = Client(
    arg[2], 
    "allo-marketplace"
)

local appNames = {"clock", "drawing-board", "fileviewer", "house", "jukebox"}


local app = App(client)
assets = {
    quit = ui.Asset.File("images/quit.png"),
}
for _, n in ipairs(appNames) do 
    assets[n] = ui.Asset.File("models/"..n..".glb")
end
app.assetManager:add(assets)

class.AppView(View)
function AppView:_init(bounds, appName)
    self:super(bounds)
    local iconAsset = assets[appName]
    self.icon = self:addSubview(
        ui.Asset.View(iconAsset, 
            ui.Bounds{size=bounds.size:copy()}
                :move(0, 0, 0.05)
        )
    )
    self.icon.transform = mat4.scale(mat4.identity(), mat4.identity(), vec3(0.25, 0.25, 0.25))
    self.icon.color = {0.5, 0.2, 0.5, 1.0}
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
            text= appName,
            color = {1, 1, 1, 1}
        }
    )
end

local mainView = Frame(ui.Bounds(0, 1.6, -2,   1.5, 0.8, 0.06), 0.03)
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
for _, name in ipairs(appNames) do
    local appView = grid:addSubview(
        AppView(ui.Bounds{size=itemSize:copy()}, name)
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
