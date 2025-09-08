-- Auto Buy Event Pack (100 clicks, 10 min cooldown)
eventBtn.MouseButton1Click:Connect(function()
    eventToggle = not eventToggle
    eventBtn.Text = eventToggle and "Auto Buy Event Pack ON" or "Auto Buy Event Pack"

    if eventToggle then
        task.spawn(function()
            while eventToggle do
                local beachFolder = workspace:WaitForChild("Beach Event", 5) -- wait up to 5 seconds
                if beachFolder then
                    local mainFolder = beachFolder:FindFirstChild("Main")
                    if mainFolder then
                        local subFolder = mainFolder:FindFirstChild("Main")
                        if subFolder then
                            local prompt = subFolder:FindFirstChildWhichIsA("ProximityPrompt")
                            if prompt then
                                for i = 1, 100 do
                                    pcall(function()
                                        prompt:InputHoldBegin()
                                        task.wait(0.05)
                                        prompt:InputHoldEnd()
                                    end)
                                end
                            else
                                warn("[EventPack] No ProximityPrompt found in subfolder.")
                            end
                        else
                            warn("[EventPack] Subfolder 'Main' not found.")
                        end
                    else
                        warn("[EventPack] Main folder not found.")
                    end
                else
                    warn("[EventPack] Beach Event folder not found in workspace.")
                end

                -- 10 min cooldown with progress bar
                local cooldown = 600
                local startTime = tick()
                repeat
                    local progress = math.clamp((tick()-startTime)/cooldown, 0, 1)
                    eventBar.Size = UDim2.new(progress,0,1,0)
                    RunService.RenderStepped:Wait()
                until tick()-startTime >= cooldown or not eventToggle

                eventBar.Size = UDim2.new(0,0,1,0)
            end
        end)
    end
end)
