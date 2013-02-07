class tomcat7_rhel::tomcat7_manager_package {
  package { "tomcat7-admin-webapps":
    ensure => installed,
    require => [Package['tomcat7'], Yumrepo['jpackage']]
  }
}
