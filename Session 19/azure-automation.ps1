Get-AzWebApp | Where-Object  {$_.Name -like "*Capgem-webapp-1*"}    

$StartTime1 = Get-Date "13:00:00"
New-AzAutomationSchedule -AutomationAccountName "CapgemAutomationAccount" -Name "On/Off-Schedule" -StartTime $StartTime1  -HourInterval 1 -ResourceGroupName "build-agents-templates"

$StartTime2 = Get-Date "13:30:00"
New-AzAutomationSchedule -AutomationAccountName "CapgemAutomationAccount" -Name "On/Off-Schedule" -StartTime $StartTime2  -HourInterval 1 -ResourceGroupName "build-agents-templates"