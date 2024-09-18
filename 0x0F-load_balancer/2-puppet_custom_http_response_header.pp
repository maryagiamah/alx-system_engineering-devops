#  Install and configure an Nginx server using Puppet

exec {'update':
  command  => 'apt-get update',
  provider => 'shell',
}

package {'nginx':
  ensure   => installed,
  provider => 'apt',
  require  => Exec['update'],
}

file {'/etc/nginx/sites-available/default':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  path    => '/etc/nginx/sites-available/default',
  mode    => '0766',
  require => Package['nginx'],
}

service {'nginx':
  ensure    => running,
  subscribe => Augeas['add_header'],
}

augeas { 'add_header':
  context => '/files/etc/nginx/sites-available/default',
  changes => [
    'ins add_header after server/server_name',
    'set server/add_header "X-Served-By $hostname always"',
  ],
  require => Package['nginx'],
  notify  => Service['nginx'],
}