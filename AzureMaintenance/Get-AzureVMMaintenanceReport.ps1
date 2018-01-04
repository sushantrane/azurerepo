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