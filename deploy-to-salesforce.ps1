# PowerShell script to deploy Simple Property app to Salesforce
Write-Host "Starting deployment to Salesforce..." -ForegroundColor Green

# Check if Salesforce CLI is installed
try {
    $sfVersion = sf version 2>$null
    Write-Host "Salesforce CLI is installed: $sfVersion" -ForegroundColor Green
} catch {
    Write-Host "Installing Salesforce CLI..." -ForegroundColor Yellow
    npm install -g @salesforce/cli
}

# Create auth file
$authUrl = "force://PlatformCLI::5Aep861iCXbTx3lghQS69r1Dtg.l29CR56jv_EeVJj_dLN7lS5ELw.D6K59BAvpA0hDrb_nkjDSa8g.JBv5N0Mq@cloudseek-dev-ed.develop.my.salesforce.com"
$authUrl | Out-File -FilePath "temp-auth.txt" -Encoding ASCII

# Authenticate to Salesforce
Write-Host "Authenticating to Salesforce org..." -ForegroundColor Yellow
try {
    sf org login sfdx-url --sfdx-url-file temp-auth.txt --alias ProductionOrg --set-default
    Write-Host "Authentication successful!" -ForegroundColor Green
} catch {
    Write-Host "Authentication failed. Trying web login..." -ForegroundColor Yellow
    sf org login web --alias ProductionOrg --instance-url https://cloudseek-dev-ed.develop.lightning.force.com --set-default
}

# Clean up auth file
Remove-Item "temp-auth.txt" -ErrorAction SilentlyContinue

# Deploy the metadata
Write-Host "Deploying Simple Property app to Salesforce..." -ForegroundColor Yellow
try {
    sf project deploy start --source-dir force-app --target-org ProductionOrg --wait 10
    Write-Host "Deployment successful! Check your Salesforce org." -ForegroundColor Green
} catch {
    Write-Host "Deployment failed. Error details:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

Write-Host "Deployment script completed!" -ForegroundColor Green 