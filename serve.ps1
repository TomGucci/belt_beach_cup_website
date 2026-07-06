# BELT Beach Cup - mini server statico per provare il sito in locale.
# Avviato da avvia-sito.bat. Chiudi la finestra per fermarlo.
$porta = 8765
$cartella = $PSScriptRoot

$tipi = @{
  '.html'='text/html; charset=utf-8'; '.js'='text/javascript; charset=utf-8'
  '.css'='text/css; charset=utf-8';   '.json'='application/json'
  '.webmanifest'='application/manifest+json'
  '.png'='image/png'; '.jpg'='image/jpeg'; '.jpeg'='image/jpeg'
  '.svg'='image/svg+xml'; '.ico'='image/x-icon'; '.pdf'='application/pdf'
}

$server = New-Object System.Net.HttpListener
$server.Prefixes.Add("http://localhost:$porta/")
try { $server.Start() } catch {
  Write-Host "Porta $porta occupata? Chiudi altre finestre del server e riprova." -ForegroundColor Red
  exit 1
}
Write-Host ""
Write-Host "  Sito avviato su http://localhost:$porta" -ForegroundColor Green
Write-Host "  Lascia aperta questa finestra; chiudila per fermare il server." -ForegroundColor Yellow
Write-Host ""
Start-Process "http://localhost:$porta/"

while ($server.IsListening) {
  $ctx = $server.GetContext()
  $percorso = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath.TrimStart('/'))
  if ([string]::IsNullOrWhiteSpace($percorso)) { $percorso = 'index.html' }
  $file = Join-Path $cartella $percorso
  if ((Test-Path $file -PathType Leaf) -and (Resolve-Path $file).Path.StartsWith($cartella)) {
    $bytes = [IO.File]::ReadAllBytes($file)
    $est = [IO.Path]::GetExtension($file).ToLower()
    $ctx.Response.ContentType = if ($tipi[$est]) { $tipi[$est] } else { 'application/octet-stream' }
    $ctx.Response.Headers.Add('Cache-Control','no-cache')
    $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  } else {
    $ctx.Response.StatusCode = 404
  }
  $ctx.Response.Close()
}
