class tomcat7_rhel::jpackage_repo {
  yumrepo { "jpackage":
    descr => "JPackage project",
    # If the mirror below fails, try another mirror (http://www.jpackage.org/mirroring.php)
    baseurl => "ftp://jpackage.hmdc.harvard.edu/JPackage/6.0/generic/free/",
    enabled => 1,
    gpgcheck => 1,
    gpgkey => "http://www.jpackage.org/jpackage.asc",
  }
}
