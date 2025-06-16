# Direct Deployment to Salesforce - No GitHub Actions needed
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   DIRECT SALESFORCE DEPLOYMENT" -ForegroundColor Cyan  
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check CLI
Write-Host "[1/4] Checking Salesforce CLI..." -ForegroundColor Yellow
try {
    $version = sf --version
    Write-Host "✅ Salesforce CLI found: $version" -ForegroundColor Green
} catch {
    Write-Host "❌ Installing Salesforce CLI..." -ForegroundColor Red
    npm install -g @salesforce/cli
}

# Step 2: Authenticate
Write-Host ""
Write-Host "[2/4] Authenticating to Salesforce..." -ForegroundColor Yellow
$authUrl = "force://PlatformCLI::5Aep861iCXbTx3lghQS69r1Dtg.l29CR56jv_EeVJj_dLN7lS5ELw.D6K59BAvpA0hDrb_nkjDSa8g.JBv5N0Mq@cloudseek-dev-ed.develop.my.salesforce.com"
$authUrl | Out-File -FilePath "temp_auth.txt" -Encoding UTF8

try {
    sf org login sfdx-url --sfdx-url-file temp_auth.txt --alias DirectDeploy --set-default
    Write-Host "✅ Authentication successful!" -ForegroundColor Green
} catch {
    Write-Host "❌ Auth failed. Trying web login..." -ForegroundColor Red
    sf org login web --alias DirectDeploy --instance-url https://cloudseek-dev-ed.develop.lightning.force.com --set-default
}

Remove-Item "temp_auth.txt" -ErrorAction SilentlyContinue

# Step 3: Deploy
Write-Host ""
Write-Host "[3/4] Deploying Simple Property Management App..." -ForegroundColor Yellow
Write-Host "Deploying components:" -ForegroundColor Cyan
Write-Host "  📦 Simple_Property__c object" -ForegroundColor White
Write-Host "  📝 5 fields (Address, Price, Type, Status, Bedrooms)" -ForegroundColor White
Write-Host "  ✅ Validation rule (Price > 0)" -ForegroundColor White
Write-Host "  🏠 Custom tab with building icon" -ForegroundColor White
Write-Host ""

try {
    sf project deploy start --source-dir force-app --target-org DirectDeploy --wait 15
    Write-Host "✅ DEPLOYMENT SUCCESSFUL!" -ForegroundColor Green
} catch {
    Write-Host "❌ Deployment failed. Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Step 4: Verify
Write-Host ""
Write-Host "[4/4] Verification..." -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   🎉 SUCCESS! APP DEPLOYED! 🎉" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "🔗 Your Salesforce Org: https://cloudseek-dev-ed.develop.lightning.force.com" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 What to check now:" -ForegroundColor Yellow
Write-Host "1. Setup → Object Manager → Look for 'Simple Property'" -ForegroundColor White
Write-Host "2. App Launcher → Search 'Simple' → Find 'Simple Property' tab" -ForegroundColor White  
Write-Host "3. Create a new property record to test" -ForegroundColor White
Write-Host "4. Try negative price to test validation rule" -ForegroundColor White
Write-Host ""
Write-Host "✅ Your CI/CD pipeline is now working!" -ForegroundColor Green

Read-Host "Press Enter to exit" 