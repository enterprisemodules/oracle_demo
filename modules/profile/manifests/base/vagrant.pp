# Contains all development specific stuff on vagrant boxes
class profile::base::vagrant {
  if $facts['kernel'] == 'Linux' {
    $required_packages = {
      'mlocate' => { ensure => 'present' },
      'unzip'   => { ensure => 'present' },
    }

    ensure_resources('package', $required_packages)

    exec { 'create swap file':
      command => '/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=8192',
      creates => '/var/swap.1',
    }

    -> exec { 'attach swap file':
      command => '/sbin/mkswap /var/swap.1 && /sbin/swapon /var/swap.1',
      unless  => '/sbin/swapon -s | grep /var/swap.1',
    }

    #add swap file entry to fstab
    -> exec { 'add swapfile entry to fstab':
      command => '/bin/echo >>/etc/fstab /var/swap.1 swap swap defaults 0 0',
      user    => root,
      unless  => "/bin/grep '^/var/swap.1' /etc/fstab 2>/dev/null",
    }
  } elsif $facts['kernel'] == 'Windows' {
    # For performance reasons in VirtualBox
    exec { 'disable windows defender':
      command  => 'Set-MpPreference -DisableArchiveScanning $true -DisableRealtimeMonitoring $true',
      provider => 'powershell',
      unless   => '$Preferences = Get-MpPreference; If ($Preferences.DisableArchiveScanning -eq $true -And $Preferences.DisableRealtimeMonitoring -eq $true) {exit 0} Else {exit 1}',
    }
  }
}
