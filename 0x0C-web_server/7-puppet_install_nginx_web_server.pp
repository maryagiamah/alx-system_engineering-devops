#  Install and configure an Nginx server using Puppet

package {'nginx':
  ensure   => installed,
  provider => 'apt',
}

file {'/etc/nginx/sites-enabled/default':
  ensure  => link,
  path    => '/etc/nginx/sites-enabled/default',
  target  => '/etc/nginx/sites-available/default',
  require => Package['nginx'],
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
  subscribe => Augeas['301 Moved Permanently'],
}


augeas { '301 Moved Permanently':
  context => '/files/etc/nginx/sites-available/default',
  changes => [
    'ins location after server/location[last()]',
    'set server/location[last()]/#uri /redirect_me',
    'set server/location[last()]/return "301 https://youtu.be/B9LYL5OO7eQ?si=Z0UqqX7R97tM-7Gi"',
  ],
  require => Package['nginx'],
  notify  => Service['nginx']
}


file {'/var/www/html/index.html':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0766',
  content => 'Hello World!',
  require => Package['nginx'],
}
