# GitHub Authentication Fix Script
Write-Host "🔧 Fixing GitHub Authentication..." -ForegroundColor Cyan

# Your PAT
$PAT = "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"
$REPO_URL = "https://github.com/Salesforceworkflow/SalesforceDevWorkflow.git"

Write-Host "📋 Current Git Status:" -ForegroundColor Yellow
git status

Write-Host "🔗 Removing old remote..." -ForegroundColor Yellow
git remote remove origin 2>$null

Write-Host "➕ Adding new remote with PAT..." -ForegroundColor Yellow
$AUTH_URL = "https://$PAT@github.com/Salesforceworkflow/SalesforceDevWorkflow.git"
git remote add origin $AUTH_URL

Write-Host "🔍 Testing connection..." -ForegroundColor Yellow
git ls-remote origin

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Authentication SUCCESSFUL!" -ForegroundColor Green
    Write-Host "🚀 Pushing to GitHub..." -ForegroundColor Cyan
    git push -u origin main
} else {
    Write-Host "❌ Authentication FAILED!" -ForegroundColor Red
    Write-Host "💡 Possible issues:" -ForegroundColor Yellow
    Write-Host "   1. PAT expired or invalid" -ForegroundColor White
    Write-Host "   2. Missing permissions (needs: repo, workflow)" -ForegroundColor White
    Write-Host "   3. Repository name mismatch" -ForegroundColor White
}

Write-Host "🔍 PAT Info:" -ForegroundColor Cyan
Write-Host "   PAT: $($PAT.Substring(0,20))..." -ForegroundColor White
Write-Host "   Repository: $REPO_URL" -ForegroundColor White 