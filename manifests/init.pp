class tomcat7_rhel ( $manage_java = true ){
  include tomcat7_rhel::jpackage_repo

  if $manage_java {
    package { 'java-1.7.0-openjdk':
      ensure => latest,
    }
    package { 'java-1.7.0-openjdk-devel':
      ensure  => latest,
      require => Package['java-1.7.0-openjdk'],
    }
    package { 'tomcat7':
      ensure  => installed,
      require => [Package['java-1.7.0-openjdk'], Yumrepo['jpackage']],
    }
  } else {
    package { 'tomcat7':
      ensure => installed,
    }
  }

}
