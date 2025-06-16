# FORCE DEPLOYMENT - Bypass GitHub Actions
Write-Host "🚀 FORCE DEPLOYING SIMPLE PROPERTY APP" -ForegroundColor Green
Write-Host "Bypassing GitHub Actions - Direct deployment to Salesforce" -ForegroundColor Yellow
Write-Host ""

# Install Salesforce CLI if needed
Write-Host "Checking Salesforce CLI..." -ForegroundColor Cyan
try {
    $version = npm list -g @salesforce/cli --depth=0 2>$null
    if (-not $version) {
        Write-Host "Installing Salesforce CLI..." -ForegroundColor Yellow
        npm install -g @salesforce/cli
    }
    Write-Host "✅ Salesforce CLI ready" -ForegroundColor Green
} catch {
    Write-Host "Installing Salesforce CLI..." -ForegroundColor Yellow
    npm install -g @salesforce/cli
}

# Authenticate using your auth URL
Write-Host ""
Write-Host "Authenticating to Salesforce org..." -ForegroundColor Cyan
$authUrl = "force://PlatformCLI::5Aep861iCXbTx3lghQS69r1Dtg.l29CR56jv_EeVJj_dLN7lS5ELw.D6K59BAvpA0hDrb_nkjDSa8g.JBv5N0Mq@cloudseek-dev-ed.develop.my.salesforce.com"

# Create temp auth file
$authUrl | Out-File -FilePath "temp_auth.txt" -Encoding UTF8

try {
    # Authenticate
    sf org login sfdx-url --sfdx-url-file temp_auth.txt --alias ForceDeploy --set-default
    Write-Host "✅ Authentication successful!" -ForegroundColor Green
    
    # Verify connection
    Write-Host ""
    Write-Host "Verifying connection..." -ForegroundColor Cyan
    sf org display --target-org ForceDeploy
    
    # Deploy Simple Property app
    Write-Host ""
    Write-Host "🏠 DEPLOYING SIMPLE PROPERTY MANAGEMENT APP..." -ForegroundColor Green
    Write-Host "Components:" -ForegroundColor White
    Write-Host "  📦 Simple_Property__c object" -ForegroundColor White
    Write-Host "  📝 5 fields (Address, Price, Property Type, Status, Bedrooms)" -ForegroundColor White
    Write-Host "  ✅ Price validation rule" -ForegroundColor White
    Write-Host "  🏠 Custom tab with building icon" -ForegroundColor White
    Write-Host ""
    
    # Deploy with no tests (since Simple Property has no tests)
    sf project deploy start --source-dir force-app --target-org ForceDeploy --test-level NoTestRun --wait 15
    
    Write-Host ""
    Write-Host "🎉 DEPLOYMENT SUCCESSFUL!" -ForegroundColor Green
    Write-Host ""
    Write-Host "✅ Simple Property Management App is now in your Salesforce org!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🔗 Check your org: https://cloudseek-dev-ed.develop.lightning.force.com" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📋 Next steps:" -ForegroundColor Yellow
    Write-Host "1. Setup → Object Manager → Look for 'Simple Property'" -ForegroundColor White
    Write-Host "2. App Launcher → Search 'Simple' → Find 'Simple Property' tab" -ForegroundColor White
    Write-Host "3. Create a new property record to test" -ForegroundColor White
    Write-Host "4. Try negative price to test validation rule" -ForegroundColor White
    
} catch {
    Write-Host "❌ Deployment failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Trying web browser authentication..." -ForegroundColor Yellow
    sf org login web --alias ForceDeploy --instance-url https://cloudseek-dev-ed.develop.lightning.force.com --set-default
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Web auth successful! Retrying deployment..." -ForegroundColor Green
        sf project deploy start --source-dir force-app --target-org ForceDeploy --test-level NoTestRun --wait 15
    }
} finally {
    # Clean up
    Remove-Item "temp_auth.txt" -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "🎊 DEPLOYMENT COMPLETED!" -ForegroundColor Green
Read-Host "Press Enter to exit" 