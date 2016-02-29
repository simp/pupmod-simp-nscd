#
# == Class: nscd
#
# Set up nscd.
#
# NSCD is quite useful for reducing network usage due to global nameservice
# lookups.
#
# This module is incompatible with SSSD!
#
# See nscd.conf(5) for any parameters not defined below.
#
# == Parameters
#
# [*use_ldap*]
# Type: Boolean
# Default: true
#   If true, ensure that nscd restarts if the system ldap configuration is
#   changed.
#
# [*enable_caches*]
# Type: Array
# Default: ['passwd','group','services']
#   Which services to cache by default.
#   Valid values are 'passwd', 'group', 'services', and 'hosts'.
#   Once included, the relevant variables can be manipulated via hiera under
#   the nscd::<service_name> classes.
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
#
class nscd (
  $use_ldap = hiera('use_ldap',true),
  $logfile = '',
  $threads = '5',
  $max_threads = '',
  $server_user = 'nscd',
  $stat_user = '',
  $debug_level = '0',
  $reload_count = '5',
  $paranoia = 'no',
  $restart_interval = '1200',
  $enable_caches = ['passwd','group','services']
){

  validate_bool($use_ldap)
  if !empty($logfile) { validate_absolute_path($logfile) }
  validate_integer($threads)
  if !empty($max_threads) { validate_integer($max_threads) }
  validate_string($server_user)
  if !empty($stat_user) { validate_string($stat_user) }
  validate_integer($debug_level)
  validate_integer($reload_count)
  validate_array_member($paranoia,['yes','no'])
  validate_integer($restart_interval)
  validate_array_member($enable_caches,['passwd','group','services','hosts'])

  if $use_ldap {
    include '::openldap::pam'
  }

  if 'passwd' in $enable_caches {
    include '::nscd::passwd'
  }
  if 'group' in $enable_caches {
    include '::nscd::group'
  }
  if 'hosts' in $enable_caches {
    include '::nscd::hosts'
  }
  if 'services' in $enable_caches {
    include '::nscd::services'
  }

  concat_build { 'nscd':
    order   => ['conf.*'],
    target  => '/etc/nscd.conf',
    require => Package['nscd']
  }

  concat_fragment { 'nscd+conf.global':
    content => template('nscd/nscd.global.erb')
  }

  if ( $::operatingsystem in ['RedHat','CentOS'] ) and ( $::operatingsystemmajrelease > '6' ) {
    $l_service_command = '/usr/sbin/service'
  }
  else {
    $l_service_command = '/sbin/service'
  }

  $nscd_start_command = "/usr/bin/test -e /var/run/nscd/nscd.pid && ! ${l_service_command} nscd status && /bin/rm -f /var/run/nscd/nscd.pid; ${l_service_command} nscd restart && ${l_service_command} nscd reload"

  file { '/etc/nscd.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    require => [
      Concat_build['nscd'],
      Package['nscd']
    ],
    audit   => 'content'
  }

  group { 'nscd':
    ensure    => 'present',
    allowdupe => false,
    gid       => '28'
  }

  package { 'nscd':
    ensure => 'latest'
  }

  $_subscribe = $use_ldap ? {
    true    => [
                  File[$::openldap::pam::ldap_conf],
                  File['/etc/nscd.conf']
    ],
    default => File['/etc/nscd.conf']
  }

  service { 'nscd':
    ensure    => 'running',
    enable    => true,
    start     => $nscd_start_command,
    restart   => $nscd_start_command,
    status    => '/bin/ps -C nscd > /dev/null',
    subscribe => $_subscribe
  }

  user { 'nscd':
    ensure     => 'present',
    allowdupe  => false,
    comment    => 'Name Service Cache Daemon',
    uid        => '28',
    gid        => '28',
    home       => '/',
    membership => 'inclusive',
    shell      => '/sbin/nologin'
  }
}
