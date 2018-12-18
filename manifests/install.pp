# Class rabbitmq::install
# Ensures that rabbitmq-server exists
class rabbitmq::install {

  $package_ensure        = $rabbitmq::package_ensure
  $package_erlang_ensure = $rabbitmq::package_erlang_ensure
  $package_name          = $rabbitmq::package_name
  $package_erlang_name   = $rabbitmq::package_erlang_name
  $rabbitmq_group        = $rabbitmq::rabbitmq_group

  package { $package_erlang_name:
    ensure => $package_erlang_ensure,
  }

  -> package { $package_name:
    ensure => $package_ensure,
    notify => Class['rabbitmq::service'],
  }

  if $rabbitmq::environment_variables['MNESIA_BASE'] {
    file { $rabbitmq::environment_variables['MNESIA_BASE']:
      ensure  => 'directory',
      owner   => 'root',
      group   => $rabbitmq_group,
      mode    => '0775',
      require => Package[$package_name],
    }
  }
}
