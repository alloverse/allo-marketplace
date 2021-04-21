local class = require('pl.class')
local tablex = require('pl.tablex')
local pretty = require('pl.pretty')
local vec3 = require("modules.vec3")
local mat4 = require("modules.mat4")

class.Frame(View)

function Frame:_init(bounds, thickness)
    self:super(bounds)
    local cubeBounds = Bounds{size= bounds.size:copy()}
    self.top    = self:addSubview(ui.Cube(cubeBounds:copy()))
    self.left   = self:addSubview(ui.Cube(cubeBounds:copy()))
    self.right  = self:addSubview(ui.Cube(cubeBounds:copy()))
    self.bottom = self:addSubview(ui.Cube(cubeBounds:copy()))
    self.thickness = thickness
    self:layout()
end

function Frame:layout()
    local w2 = self.bounds.size.width / 2
    local h2 = self.bounds.size.height / 2
    local d2 = self.bounds.size.depth / 2
    local t2 = self.thickness/2

    self.top.bounds.size.height = self.thickness
    self.top.bounds:move(0, -h2 + t2, 0)

    self.bottom.bounds.size.height = self.thickness
    self.bottom.bounds:move(0, h2 - t2, 0)

    self.left.bounds.size.width = self.thickness
    self.left.bounds:move(-w2 + t2, 0, 0)

    self.right.bounds.size.width = self.thickness
    self.right.bounds:move(w2 - t2, 0, 0)
end

return Frame
