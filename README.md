#Animated Camera Panel Plugin for GMod

This plugin for Garry's Mod introduces an animated camera panel. The `AnimatedCameraPanel` extends the `DModelPanel` and provides a way to animate the camera position, angles, and field of view (FOV) smoothly between two points over a specified duration.

# Features

- Create smooth camera animations between two points.
- Control the start and end positions, angles, and FOV.
- Define the duration of the animation.
- Queue multiple animations.

# Usage

## Adding the Plugin

Place `/animatedmodelpanel` in **Plugins** folder

## Creating an Animated Camera Panel

Here's an example of how to create an animated camera panel and define an animation:
```Lua
function ShowAnimatedCameraPanel()
    local frame = vgui.Create("DFrame")
    frame:SetSize(800, 600)
    frame:Center()
    frame:SetTitle("Animated Camera Panel")
    frame:MakePopup()

    local cameraPanel = vgui.Create("AnimatedCameraPanel", frame)
    cameraPanel:SetSize(600, 400)
    cameraPanel:Dock(FILL)
    cameraPanel:SetModel("models/props_c17/oildrum001.mdl")
    cameraPanel:AddAnimation(
        Vector(0, 0, 0),  -- startPos: Initial camera position
        Vector(0, 0, 150),    -- endPos: Final camera position
        Angle(0, 0, 0),       -- startAng: Initial camera angles
        Angle(0, 0, 0),     -- endAng: Final camera angles
        10,                   -- duration: Duration of the animation in seconds
        70,                   -- startFOV: Initial camera FOV
        90                    -- endFOV: Final camera FOV
    )
end

-- Concommand to show the animated camera panel
concommand.Add("show_animated_camera_panel", function(ply, cmd, args)
    ShowAnimatedCameraPanel()
end)
```
