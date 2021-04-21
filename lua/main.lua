local frame = require("frame")

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
    table.insert(assets, ui.Asset.File("models/"..n..".glb"))
end
app.assetManager:add(assets)

class.AppView(View)
function AppView:_init(bounds, appName)
    self:super(bounds)
    local iconAsset = assets[appName]
    self.icon = self:addSubview(
        ui.Asset.View(iconAsset, ui.Bounds{size=bounds.size:copy()})
    )
    self.brick = self:addSubview(ui.Cube(
        ui.Bounds{size=bounds.size:copy()}
        :insetEdges(0.05, 0.05, 0.05, 0.05, 0.00, 0.05)
        :move()
    ))
    self.label = self:addSubview(
        ui.Label{
            bounds= ui.Bounds(0, 0, 0,   bounds.size.width, 0.05, 0.01)
                :move(0, -bounds.size.height/2 + 0.08, 0),
            text= appName
        }
    )
end

local mainView = Frame(ui.Bounds(0, 1.4, -2,   1.5, 0.8, 0.06), 0.03)
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
