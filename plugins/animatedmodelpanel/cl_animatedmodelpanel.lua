DEFINE_BASECLASS("DModelPanel")

local PANEL = {}

function PANEL:Init()
     self.animations = {} -- Animation queue
     self.currentAnimation = nil -- Current animation
     self.cameraFOV = 70 -- Default FOV
end

function PANEL:AddAnimation(startPos, endPos, startAngles, endAngles, duration, startFOV, endFOV)
     local animation = {
         startPos = startPos,
         endPos = endPos,
         startAngles = startAngles,
         endAngles = endAngles,
         duration = duration,
         startTime = SysTime(),
         endTime = SysTime() + duration, -- Added to define endTime
         startFOV = startFOV or self:GetFOV(), -- if startFOV is not given, use the current FOV
         endFOV = endFOV or self:GetFOV(), -- if endFOV is not provided, use the current FOV
     }

     table.insert(self.animations, animation)
end

function PANEL:Think()
     if not self.animations or #self.animations == 0 then return end -- Make sure there are animations to process

     local animation = self.animations[1] -- We take the first animation from the queue
     local t = (SysTime() - animation.startTime) / animation.duration -- Calculate the animation progress (from 0 to 1)

     if t < 1 then
         -- We interpolate the camera's position, angle and FOV based on the t-factor
         local newPos = LerpVector(t, animation.startPos, animation.endPos)
         local newAng = LerpAngle(t, animation.startAngles, animation.endAngles)
         local newFOV = Lerp(t, animation.startFOV, animation.endFOV)
        
         -- Set the new position, angle and FOV of the camera
         self:SetCamPos(newPos)
         self:SetLookAt(newPos + newAng:Forward() * 100) -- Adjusted to point the camera at the model
         self:SetFOV(newFOV)
     else
         -- If the animation is finished, we set the final position, angle and FOV of the camera
         self:SetCamPos(animation.endPos)
         self:SetLookAt(animation.endPos + animation.endAngles:Forward() * 100) -- Adjusted to point the camera at the model
         self:SetFOV(animation.endFOV)
        
         -- We remove the completed animation from the animation list
         table.remove(self.animations, 1)
     end
end

vgui.Register("AnimatedCameraPanel", PANEL, "DModelPanel")

-- Function to display an animated camera panel
function ShowAnimatedCameraPanel()
     local frame = vgui.Create("DFrame")
     frame:SetSize(800, 600)
     frame:Center()
     frame:SetTitle("Animated Camera Panel")
     frame:MakePopup()

     local cameraPanel = vgui.Create("AnimatedCameraPanel", frame)
     cameraPanel:SetSize(600, 400)
     cameraPanel:Dock(FILL) -- Adjusted to fit the panel to the frame
     cameraPanel:SetModel("models/props_c17/oildrum001.mdl")
     cameraPanel:AddAnimation(
         Vector(0, -20, 0), -- startPos: The starting position of the camera
         Vector(0, -20, 150), -- endPos: End position of the camera
         Angle(90, 90, 0), -- startAng: The starting angle at which the camera is looking
         Angle(90, 90, 0), -- endAng: The final angle at which the camera is looking
         10, -- duration: Animation duration in seconds
         100, -- startFOV: The initial FOV of the camera
         100 -- endFOV: End FOV of the camera
     )
end

-- Concommand to display an animated camera panel
concommand.Add("show_animated_camera_panel", function(ply, cmd, args)
     ShowAnimatedCameraPanel()
end)