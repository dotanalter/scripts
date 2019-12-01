#####Parent folder part#####
$user = "xxx"
$folder = "path\$user"
if(!(Test-Path -Path $folder))
{
New-Item  -Path $folder -ItemType Directory
}
else
{
$DirectoryInfo = Get-ChildItem $folder | Measure-Object
if($DirectoryInfo.Count -ne 0)
{
Rename-Item -NewName "Old$user" -Path $folder
New-Item  -Path $folder -ItemType Directory
}
}
#create admin and user access rule objects
$userPrem = "DomainName\$user" , "Modify" , "ContainerInherit,ObjectInherit" , "None" , "Allow"

$userACE = New-Object System.Security.AccessControl.FileSystemAccessRule -ArgumentList $userPrem
#create ACL object of manage folder
$folderACL = New-Object System.Security.AccessControl.DirectorySecurity
$folderACL.AddAccessRule($userACE)
Set-Acl -Path $folder -AclObject $folderACL #set the ACL on the folder



