define tomcat7_rhel::tomcat-application(
  $application_name = $title,
  $application_root,
  $tomcat_user,
  $tomcat_port,
  $jvm_envs) {
  include tomcat7_rhel

  $application_dir = "$application_root/$application_name"
  $tomcat_log = "$application_dir/logs/catalina.out"
  $catalina_home = "/usr/share/tomcat7"

  File {
    before => Service["$application_name"]
  }

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
    hasstatus => true,
    require => Package['tomcat7']
  }

  file { "/etc/init.d/$application_name":
    ensure => link,
    target => "/etc/init.d/tomcat7",
    require => Package['tomcat7']
  }

  file { "$application_dir/conf/web.xml":
    ensure => link,
    target => "$catalina_home/conf/web.xml",
  }

  file { "/etc/sysconfig/$application_name":
    content => template("tomcat7_rhel/etc/sysconfig/tomcat7.erb")
  }

  file { "$application_dir/conf/server.xml":
    content => template("tomcat7_rhel/server.xml.erb")
  }

  file { "/etc/logrotate.d/$application_name":
    content => template("tomcat7_rhel/etc/logrotate.d/tomcat7.erb")
  }
}
