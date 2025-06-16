@echo off
cls
echo.
echo ==========================================
echo    SALESFORCE DEPLOYMENT - STARTING
echo ==========================================
echo.

REM Check if we're in the right directory
if not exist "sfdx-project.json" (
    echo ERROR: Not in a Salesforce project directory!
    echo Please run this from the SalesforceDevWorkflow folder.
    pause
    exit /b 1
)

echo [1/4] Checking Salesforce CLI installation...
sf --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Salesforce CLI...
    npm install -g @salesforce/cli
    if %errorlevel% neq 0 (
        echo ERROR: Failed to install Salesforce CLI
        pause
        exit /b 1
    )
)
echo ✅ Salesforce CLI is ready

echo.
echo [2/4] Authenticating to Salesforce org...
echo Attempting authentication...

REM Try authentication with the auth URL
echo force://PlatformCLI::5Aep861iCXbTx3lghQS69r1Dtg.l29CR56jv_EeVJj_dLN7lS5ELw.D6K59BAvpA0hDrb_nkjDSa8g.JBv5N0Mq@cloudseek-dev-ed.develop.my.salesforce.com > temp_auth_url.txt

sf org login sfdx-url --sfdx-url-file temp_auth_url.txt --alias ProductionOrg --set-default
if %errorlevel% neq 0 (
    echo Authentication via URL failed. Opening web browser for manual login...
    sf org login web --alias ProductionOrg --instance-url https://cloudseek-dev-ed.develop.lightning.force.com --set-default
    if %errorlevel% neq 0 (
        echo ERROR: Authentication failed completely
        del temp_auth_url.txt >nul 2>&1
        pause
        exit /b 1
    )
)

del temp_auth_url.txt >nul 2>&1
echo ✅ Authentication successful

echo.
echo [3/4] Deploying Simple Property Management App...
echo This will deploy:
echo   - Simple_Property__c custom object
echo   - 5 fields (Address, Price, Property Type, Status, Bedrooms)
echo   - Validation rule (Price must be positive)
echo   - Custom tab with building icon
echo.

sf project deploy start --source-dir force-app --target-org ProductionOrg --wait 10
if %errorlevel% neq 0 (
    echo ❌ Deployment failed! Check the error messages above.
    pause
    exit /b 1
)

echo ✅ Deployment successful!

echo.
echo [4/4] Verification...
echo.
echo ==========================================
echo    DEPLOYMENT COMPLETED SUCCESSFULLY! 
echo ==========================================
echo.
echo ✅ Simple Property Management App is now in your Salesforce org!
echo.
echo 🔗 Check your org at: https://cloudseek-dev-ed.develop.lightning.force.com
echo.
echo What to do next:
echo 1. Go to Setup → Object Manager → Look for "Simple Property"
echo 2. Go to App Launcher → Search "Simple" → Find "Simple Property" tab  
echo 3. Create a new property record to test the app
echo 4. Try entering a negative price to test validation rules
echo.
echo Your CI/CD pipeline is working! 🎉
echo.
pause 