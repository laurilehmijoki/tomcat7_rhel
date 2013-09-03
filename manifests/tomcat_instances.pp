class tomcat7_rhel::tomcat_instances (
  $instances = {}
) {
  create_resources('tomcat7_rhel::tomcat_application', $instances)
}

