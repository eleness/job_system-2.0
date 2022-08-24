include("shared.lua")

ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Draw()
	
	self:DrawModel()
    

    hook.Add('HUDPaint','Job.DrawInfo',function()
        for k,v in pairs(ents.FindByClass('job_npc')) do
            if !(IsValid(v) && v:GetJobName()) then continue end
            if !(Job.CFG['showHeader']) then continue end
            local name = v:GetJobName()
    
            local pos = v:GetPos() + Vector(0,0,50)
            local d = math.floor(LocalPlayer():GetPos():Distance(pos)/100)
            if d > Job.CFG['maxDistance'] then continue end

            local pos = pos:ToScreen()
    
            local npc = Job.NPC[v:GetJobName()]

            surface.SetFont( 'ChatFont' )
            surface.SetTextColor(npc.headerColor[1], npc.headerColor[2], npc.headerColor[3], 1000/(d+4))
            surface.SetTextPos(pos.x,pos.y)
            surface.DrawText(npc.name)
        
            local x,y = surface.GetTextSize('npc.name')
    
            local d_score = string.format(d)

            if npc.showDistance then
                if d > 0 then
                    distanceText = Job.CFG['distance_text']..d_score..' m'
                else 
                    distanceText = ''
                end

                surface.SetFont('Default' )
                surface.SetTextColor(255,165,0, 1000/(d+5))
                surface.SetTextPos(pos.x,pos.y + y)
                surface.DrawText(distanceText)
            end
        end
    end)


end