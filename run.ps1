# 🔐 GitHub Token (embedded for unattended execution)
$token = "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"

function Invoke-PrivateScript {
    param (
        [string]$token,
        [string]$owner = "ammon-vargas",
        [string]$repo = "automation",
        [string]$path
    )

    $headers = @{
        Authorization = "Bearer $token"
        Accept = "application/vnd.github.object"
        "X-GitHub-Api-Version" = "2022-11-28"
    }

    $url = "https://api.github.com/repos/$owner/$repo/contents/$path"

    try {
        Write-Host "`n🌐 Fetching '$path' from '$owner/$repo'..." -ForegroundColor Cyan
        $response = Invoke-RestMethod -Uri $url -Headers $headers
        $script = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($response.content))
        Write-Host "✅ Script fetched. Executing..." -ForegroundColor Green
        Invoke-Expression $script
    } catch {
        Write-Host "❌ Failed to fetch or execute '$path'" -ForegroundColor Red
        Write-Host "Details: $_" -ForegroundColor DarkGray
    }
}

function Show-InstallMenu {
    param (
        [string]$token,
        [string]$owner = "ammon-vargas",
        [string]$repo = "automation"
    )

    Write-Host "`n🛠️ Validator-Grade Install Menu" -ForegroundColor Cyan
    Write-Host "1. 🧩 Post-Install Setup"
    Write-Host "2. 🔐 Install Tailscale"
    Write-Host "3. 🧪 BIOS Check"
    Write-Host "4. 🚪 Exit`n"

    $choice = Read-Host "Select an option (1-4)"

    switch ($choice) {
        '1' { Invoke-PrivateScript -token $token -owner $owner -repo $repo -path "post-install.ps1" }
        '2' { Invoke-PrivateScript -token $token -owner $owner -repo $repo -path "install-tailscale.ps1" }
        '3' { Invoke-PrivateScript -token $token -owner $owner -repo $repo -path "bios-check.ps1" }
        '4' { Write-Host "👋 Exiting..." -ForegroundColor Yellow }
        default { Write-Host "⚠️ Invalid selection. Try again." -ForegroundColor Red }
    }
}

# 🚀 Launch the menu
Show-InstallMenu -token $token
