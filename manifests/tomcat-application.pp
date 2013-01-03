define tomcat7-rhel::tomcat-application(
  $application_name = $title,
  $application_root,
  $tomcat_user,
  $tomcat_port,
  $jvm_envs) {
  include tomcat7-rhel

  $application_dir = "$application_root/$application_name"
  $tomcat_log = "$application_dir/logs/catalina.out"
  $catalina_home = "/usr/share/tomcat7"

  file { [
    "$application_dir/conf","$application_dir/temp","$application_dir/work",
    "$application_dir/logs","$application_dir/webapps"]:
    ensure => directory,
    owner => $tomcat_user,
    group => $tomcat_user
  }

  file { "$application_dir":
    ensure => directory
  }

  service { "$application_name":
    ensure => running,
    hasstatus => true
  }

  file { "/etc/init.d/$application_name":
    ensure => link,
    target => "/etc/init.d/tomcat7",
  }

  file { "$application_dir/conf/web.xml":
    ensure => link,
    target => "$catalina_home/conf/web.xml",
  }

  file { "/etc/sysconfig/$application_name":
    content => template("tomcat7-rhel/etc/sysconfig/tomcat7.erb")
  }

  file { "$application_dir/conf/server.xml":
    content => template("tomcat7-rhel/server.xml.erb")
  }

  file { "/etc/logrotate.d/$application_name":
    content => template("tomcat7-rhel/etc/logrotate.d/tomcat7.erb")
  }
}
