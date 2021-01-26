-- ============================================================= --
-- EXTENDED DASHBOARD SCRIPT
-- ============================================================= --
-- USAGE IN ModDesc:
-- 	<extraSourceFiles>
--		<sourceFile filename="ExtendedDashboard.lua" />
--	</extraSourceFiles>
-- ============================================================= --
-- USAGE IN *.XML:
-- <dashboard ... extendedDashboard="true", valueFunc="totalAmount", valueObject="spec_wearable"/>
-- ============================================================= --
-- if type(valueFunc) == "number" then return valueFunc
-- if type(valueFunc) == "boolean" then return valueFunc
-- if type(valueFunc) == "function" then return valueFunc(valueObject)
-- if type(valueObject[valueFunc]) == "number" then return valueObject.valueFunc
-- if type(valueObject[valueFunc]) == "boolean" then return valueObject.valueFunc
-- if type(valueObject[valueFunc]) == "function" then return valueObject:valueFunc()
-- ============================================================= --

if getfenv(0).g_extendedDashboardInstalled then
	print("ExtendedDashboard is already loaded")
	return
else
	print("Loading ExtendedDashboard")
end
getfenv(0).g_extendedDashboardInstalled = true

ExtendedDashboard = {}

addModEventListener(ExtendedDashboard)

function ExtendedDashboard:vehicleLoad(superFunc, vehicleData, asyncCallbackFunction, asyncCallbackObject, asyncCallbackArguments)
	--print("vehicle load")
    return superFunc(self, vehicleData, asyncCallbackFunction, asyncCallbackObject, asyncCallbackArguments)
end

function ExtendedDashboard:loadDashboardFromXML(superFunc, xmlFile, key, dashboard, dashboardData)
	local result = superFunc(self, xmlFile, key, dashboard, dashboardData)

	if result then
		--print(" >> loadDashboardFromXML: "..tostring(key))
		
		local hasExtendedDashboard = getXMLString(xmlFile, key .. "#extendedDashboard")
		if hasExtendedDashboard then
			local valueFunc = getXMLString(xmlFile, key .. "#valueFunc")
			if self[tostring(valueFunc)] ~= nil then
				dashboard.valueFunc = self[tostring(valueFunc)]
			else
				dashboard.valueFunc = tostring(valueFunc)
			end

			local valueObject = getXMLString(xmlFile, key .. "#valueObject")
			if self[tostring(valueObject)] ~= nil then
				dashboard.valueObject = self[tostring(valueObject)]
			else
				dashboard.valueObject = tostring(valueObject)
			end
		end
	end	
	return result
end

function ExtendedDashboard:loadMap(name)
	Vehicle.load = Utils.overwrittenFunction(Vehicle.load, ExtendedDashboard.vehicleLoad)
	for name, data in pairs( g_vehicleTypeManager:getVehicleTypes() ) do
		local vehicleType = g_vehicleTypeManager:getVehicleTypeByName(tostring(name))
		if SpecializationUtil.hasSpecialization(Dashboard, data.specializations) then
			--print("OVERWRITTEN DASHBOARD FOR: "..tostring(tostring(name)))
			SpecializationUtil.registerOverwrittenFunction(vehicleType, "loadDashboardFromXML", ExtendedDashboard.loadDashboardFromXML)
		end
	end
end

-- function ExtendedDashboard:deleteMap()
-- end

-- function ExtendedDashboard:mouseEvent(posX, posY, isDown, isUp, button)
-- end

-- function ExtendedDashboard:keyEvent(unicode, sym, modifier, isDown)
-- end

-- function ExtendedDashboard:draw()
-- end

-- function ExtendedDashboard:update(dt)
	-- if not self.initialised then
		-- -- print("")
		-- -- for key,value in pairs(g_modIsLoaded) do
			-- -- print(string.format(">> %s , %s", tostring(key), tostring(value)))
		-- -- end
		-- -- if g_modIsLoaded['FS19_precisionFarming'] then
			-- -- --print("PrecisionFarming is loaded")
		-- -- end

		-- local i = 1
		-- for key,value in pairs(g_currentMission.vehicles) do
			-- --print(string.format(">> %s , %s", tostring(key), tostring(value)))
			-- --print(tostring(g_currentMission.vehicles[i]:getFullName()))
			-- if g_currentMission.vehicles[i].spec_dashboard ~= nil then
				-- -- for k,v in pairs(g_currentMission.vehicles[i].spec_dashboard) do
					-- -- print(string.format(">> %s , %s", tostring(k), tostring(v)))
				-- -- end
				-- --print("dashboards:")
				-- --DebugUtil.printTableRecursively(g_currentMission.vehicles[i].spec_dashboard.dashboards, "--", 0, 1)
				-- --print("criticalDashboards:")
				-- --DebugUtil.printTableRecursively(g_currentMission.vehicles[i].spec_dashboard.criticalDashboards, "--", 0, 1)
			-- end
			-- i = i + 1
		-- end

		-- self.initialised = true
	-- end
-- end