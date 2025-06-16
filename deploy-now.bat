@echo off
echo ========================================
echo   SALESFORCE DEPLOYMENT SCRIPT
echo ========================================
echo.

echo [1/5] Checking Salesforce CLI...
sf version
if %errorlevel% neq 0 (
    echo Installing Salesforce CLI...
    npm install -g @salesforce/cli
)

echo.
echo [2/5] Creating temporary auth file...
echo force://PlatformCLI::5Aep861iCXbTx3lghQS69r1Dtg.l29CR56jv_EeVJj_dLN7lS5ELw.D6K59BAvpA0hDrb_nkjDSa8g.JBv5N0Mq@cloudseek-dev-ed.develop.my.salesforce.com > temp_auth.txt

echo.
echo [3/5] Authenticating to Salesforce org...
sf org login sfdx-url --sfdx-url-file temp_auth.txt --alias ProductionOrg --set-default
if %errorlevel% neq 0 (
    echo Authentication via URL failed. Trying web login...
    sf org login web --alias ProductionOrg --instance-url https://cloudseek-dev-ed.develop.lightning.force.com --set-default
)

echo.
echo [4/5] Deploying Simple Property app...
sf project deploy start --source-dir force-app --target-org ProductionOrg --wait 10

echo.
echo [5/5] Cleaning up...
del temp_auth.txt

echo.
echo ========================================
echo   DEPLOYMENT COMPLETED!
echo ========================================
echo Check your Salesforce org at:
echo https://cloudseek-dev-ed.develop.lightning.force.com
echo.
pause 