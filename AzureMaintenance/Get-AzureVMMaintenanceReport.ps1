<#
.EULA
This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.  
THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, 
EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  
We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, 
provided that You agree: 
(i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
(ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; 
and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys’ fees, 
that arise or result from the use or distribution of the Sample Code.
#>

$csvPath = "C:\Temp\AzureVMMaintenance.csv"
$AzureVMs = @()
Login-AzureRmAccount
$subs = Get-AzureRmSubscription
foreach($sub in $subs)
{
    Select-AzureRmSubscription -SubscriptionObject $sub
    $vms = Get-AzureRmVM -Status
    foreach($vm in $vms)
    {
         $vminfo = New-Object -TypeName psobject
         $vminfo | Add-Member -Type NoteProperty -Name SubscriptionName -Value $sub.Name
         $vminfo | Add-Member -Type NoteProperty -Name SubscriptionId -Value $sub.Id
         $vminfo | Add-Member -Type NoteProperty -Name VMName -Value $vm.Name
         $vminfo | Add-Member -Type NoteProperty -Name ResourceGroupName -Value $vm.ResourceGroupName
         $vminfo | Add-Member -Type NoteProperty -Name Location -Value $vm.Location
         $vminfo | Add-Member -Type NoteProperty -Name VMSize -Value $vm.HardwareProfile.VmSize
         $vminfo | Add-Member -Type NoteProperty -Name IsCustomerInitiatedMaintenanceAllowed -Value $vm.MaintenanceRedeployStatus.IsCustomerInitiatedMaintenanceAllowed
         $vminfo | Add-Member -Type NoteProperty -Name LastOperationResultCode -Value $vm.MaintenanceRedeployStatus.LastOperationResultCode
         $vminfo | Add-Member -Type NoteProperty -Name LastOperationMessage -Value $vm.MaintenanceRedeployStatus.LastOperationMessage
         $vminfo | Add-Member -Type NoteProperty -Name MaintenanceWindowEndTime -Value $vm.MaintenanceRedeployStatus.MaintenanceWindowEndTime
         $vminfo | Add-Member -Type NoteProperty -Name MaintenanceWindowStartTime -Value $vm.MaintenanceRedeployStatus.MaintenanceWindowStartTime
         $vminfo | Add-Member -Type NoteProperty -Name PreMaintenanceWindowEndTime -Value $vm.MaintenanceRedeployStatus.PreMaintenanceWindowEndTime
         $vminfo | Add-Member -Type NoteProperty -Name PreMaintenanceWindowStartTime -Value $vm.MaintenanceRedeployStatus.PreMaintenanceWindowStartTime
         $vminfo | Add-Member -Type NoteProperty -Name ApplicationName -Value $vm.Tags.applicationname
         $vminfo | Add-Member -Type NoteProperty -Name Environment -Value $vm.Tags.environmentinfo

         $AzureVMs += $vminfo
    }

}

$AzureVMs | Export-Csv -Path $csvPath -NoTypeInformation