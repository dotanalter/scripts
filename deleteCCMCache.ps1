if(Test-Path -Path "C:\Windows\ccmcache"){
$UIResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
$Cache = $UIResourceMgr.GetCacheInfo()
$Cache.GetCacheElements() | where-object {[datetime]$_.LastReferenceTime -lt (get-date).adddays(-2)} |
foreach {
$Cache.DeleteCacheElement($_.CacheElementID)
}
}