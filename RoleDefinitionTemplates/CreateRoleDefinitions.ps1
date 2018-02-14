$templatesFilePath = "{location to the role definition templates}"
$subscriptionId = "{subscriptionId}"
Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionId $subscriptionId
$templates = Get-ChildItem $templatesFilePath -Filter *.json
foreach ($template in $templates)
{
    try
    {
        New-AzureRmRoleDefinition -InputFile "$templatesFilePath\$($template.Name)"
    }

    catch
    {
        $ErrorMessage = $_.Exception.Message
        Write-Host "Unable to create Role Definition for $($template.Name) with Error: $ErrorMessage" -ForegroundColor Red
    }
}