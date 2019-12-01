function Get-ScreenShot {
  Add-Type -AssemblyName System.Windows.Forms
  $fileName = '{0}.jpg' -f (Get-Date).ToString('yyyyMMdd_HHmmss')
  $ScreenshotPath = "path"
  $path = Join-Path $ScreenshotPath $fileName 
  $b = New-Object System.Drawing.Bitmap([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width, [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height)
  $g = [System.Drawing.Graphics]::FromImage($b)
  $g.CopyFromScreen((New-Object System.Drawing.Point(0,0)), (New-Object System.Drawing.Point(0,0)), $b.Size)
  $g.Dispose()
  $myEncoder = [System.Drawing.Imaging.Encoder]::Quality
  $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1) 
  $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter($myEncoder, 20) 
  $myImageCodecInfo = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders()|where {$_.MimeType -eq 'image/jpeg'}
  $b.Save($path,$myImageCodecInfo, $($encoderParams))
}

Get-ScreenShot