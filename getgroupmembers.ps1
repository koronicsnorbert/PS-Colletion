$vpnlista = Get-ADGroup -Filter "name -like '#FILTER#'" | ForEach-Object {
    $group = $_.Name
    $users = $_ | Get-ADGroupMember -Recursive | 
                  Where-Object { $_.objectClass -eq 'user' } |    # filter users only
                  Get-ADUser -Properties Company,Name,LastLogonDate,Enabled
    foreach ($user in $users) {
        [PsCustomObject]@{
            'Company'        = $user.Company
            'Name'           = $user.Name
            'Engedélyezve'   = $user.Enabled
            'LastLogonDate'  = $user.LastLogonDate
            'Group'          = $group
        }
    }
} | Sort-Object Company, SamAccountName, Group

# output on screen
#$vpnlista | Format-Table -AutoSize

# or write to CSV file
$vpnlista | Export-Csv -Path 'vpnlista.csv' -NoTypeInformation -Encoding UTF8
