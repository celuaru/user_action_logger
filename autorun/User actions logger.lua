--[[
		Cheat Engine 6.8.3 Cheat Engine Extensions
		
		"User actions logger 1.0 Beta"

Author: MasterGH
	Donations: paypal, mastergh.developer@gmail.com
	https://www.paypal.com/xclick/business=mastergh.developer%40gmail.com&no_note=1&tax=0&lc=US

	Site: https://gamehacklab.ru/
	Youtube channel: https://www.youtube.com/gamehacklabru
	VK: https://vk.com/gamehacklab
	
How to install:
	Put files in main directory to chate engine	
	
	Version: Beta 1.0 (22.018.2019)
		+ Add output base information about user actions 
		+ Add GHL panel

	Files:
		autorun->User actions logger.lua
		autorun->GHLLogo.lua		
		autorun->forms->GHLLogo.frm
]]--


function FindComponentByName(componentName) 
  local mainFormCE = getMainForm() 
  local maxComponents = mainFormCE.ComponentCount 
  for i=0,maxComponents-1 do 
    local comp = mainFormCE.getComponent(i) 
    if (comp.Name == componentName) then 
       return comp 
    end 
  end 
end 

function GetTimeLine() 
  local currentTime = os.date("%c"):gsub('/','.') 
  return currentTime 
end 

scanvalue = FindComponentByName("scanvalue") 
processLabel = FindComponentByName('ProcessLabel') 
foundcountlabel = FindComponentByName('foundcountlabel') 
scanType = getMainForm().ScanType 
varType = getMainForm().VarType 

countSession = 0 
countNextScan = 0 
isStartSeeson = false 

stringSaveScanType = '' 

-- Таймер ожидающий результата сканирования выводит строку 
if logTimer == nil then 
   logTimer = createTimer() 
   logTimer.Interval = 150 
   logTimer.Enabled = false 
end 

function OnTimerFirstScan() 
   if btnNextScan.Enabled then 
    
      if stringSaveScanType == "Unknown initial value" then 
         print(GetTimeLine()..'   First scan. Scan type "'..stringSaveScanType..'". Value type "'..varType.Items[varType.getItemIndex()]..'". Found '..foundcountlabel.Caption) 
      else 
         print(GetTimeLine()..'   First scan. Scan type "'..stringSaveScanType..'". Value '..scanvalue.Text..'. Value type "'..varType.Items[varType.getItemIndex()]..'". Found '..foundcountlabel.Caption) 
      end 
    
     logTimer.Enabled = false 
   end 
end 

function OnTimerNextScan() 
   if btnNextScan.Enabled then 
     print(GetTimeLine().."   Next scan"..countNextScan..'. Scan type "'..stringSaveScanType..'". Value '..scanvalue.Text..'. Found '..foundcountlabel.Caption) 
     logTimer.Enabled = false 
   end 
end 

btnNewScan = FindComponentByName("btnNewScan") 
oldOnClick_btnNewScan = btnNewScan.OnClick 
function newOnClick_btnNewScan()  
  if not isStartSeeson then 
    countSession = countSession + 1 
    print("Start session "..countSession..'. Process: '..processLabel.Caption) 
    isStartSeeson = true 
  else 
    print("End session "..countSession) 
   countNextScan = 0 
    isStartSeeson = false 
  end 
  stringSaveScanType =  scanType.Items[scanType.getItemIndex()] 
  btnNewScan.OnClick = oldOnClick_btnNewScan 
  btnNewScan.doClick() 
  btnNewScan.OnClick = newOnClick_btnNewScan 
  logTimer.OnTimer = OnTimerFirstScan  
  logTimer.Enabled = true 
end 
btnNewScan.OnClick = newOnClick_btnNewScan 

btnNextScan = FindComponentByName("btnNextScan") 
oldOnClick_btnNextScan = btnNextScan.OnClick 
function newOnClick_btnNextScan()  
  countNextScan = countNextScan + 1  
  stringSaveScanType =  scanType.Items[scanType.getItemIndex()] 
  btnNextScan.OnClick = oldOnClick_btnNextScan 
  btnNextScan.doClick() 
  btnNextScan.OnClick = newOnClick_btnNextScan 
  logTimer.OnTimer = OnTimerNextScan 
  logTimer.Enabled = true 
end 
btnNextScan.OnClick = newOnClick_btnNextScan 


btnUndoScan = FindComponentByName("UndoScan") 
oldOnClick_btnUndoScan = btnUndoScan.OnClick 
function newOnClick_btnUndoScan() 
  print(GetTimeLine().."   Undo Scan") 
  btnUndoScan.OnClick = oldOnClick_btnUndoScan 
  btnUndoScan.doClick() 
  btnUndoScan.OnClick = newOnClick_btnUndoScan 
end 
btnUndoScan.OnClick = newOnClick_btnUndoScan 