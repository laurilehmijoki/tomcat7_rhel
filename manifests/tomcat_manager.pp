define tomcat7_rhel::tomcat_manager(
                                    $tomcat_admin_user,
                                    $tomcat_admin_password,
                                    $tomcat_user,
                                    $application_dir,
                                    $application_name,
                                    $tomcat_port) {
  package { "tomcat7-admin-webapps":
    ensure => installed,
    require => [Package['tomcat7'], Yumrepo['jpackage']]
  }

  File {
    before => Package["tomcat7-admin-webapps"]
  }

  file { "$application_dir/bin":
    ensure => directory
  }

  file { "$application_dir/conf/Catalina/localhost/manager.xml":
    content => template("tomcat7_rhel/manager.xml.erb"),
    notify  => Service["$application_name"]
  }

  file { "$application_dir/conf/tomcat-users.xml":
    content => template("tomcat7_rhel/tomcat-users.xml.erb"),
    notify  => Service["$application_name"]
  }

  file { "$application_dir/bin/deploy_with_tomcat_manager.sh":
    content => template("tomcat7_rhel/deploy_with_tomcat_manager.sh.erb"),
    owner   => "$tomcat_user",
    group   => "$tomcat_user",
    mode    => 0740,
    require => File["$application_dir/bin"]
  }
  
  file { "$application_dir/bin/list-applications.sh":
    content => template("tomcat7_rhel/list-applications.sh.erb"),
    owner   => "$tomcat_user",
    group   => "$tomcat_user",
    mode    => 0740,
    require => File["$application_dir/bin"]
  }
  
  file { "$application_dir/bin/undeploy_with_tomcat_manager.sh":
    content => template("tomcat7_rhel/undeploy_with_tomcat_manager.sh.erb"),
    owner   => "$tomcat_user",
    group   => "$tomcat_user",
    mode    => 0740,
    require => File["$application_dir/bin"]
  }
  
  
}
