class tomcat7_rhel {
  include tomcat7_rhel::jpackage-repo

  package { "java-1.7.0-openjdk":
    ensure => installed
  }

  package { "tomcat7":
    ensure => installed,
    require => [Package['java-1.7.0-openjdk'], Yumrepo['jpackage']]
  }
}
