# Tomcat 7 on RHEL 6
[![Build Status](https://secure.travis-ci.org/laurilehmijoki/tomcat7_rhel.png)]
(http://travis-ci.org/laurilehmijoki/tomcat7_rhel)

Features

* Allow multiple Tomcat instances on same machine ("the base + home setup")

## Install

    puppet module install llehmijo/tomcat7_rhel

## Example usage

### Configure Puppet

    # In site.pp
    node "superserver" {
      tomcat7_rhel::tomcat-application { "my-web-application":
        application_root => "/opt",
        tomcat_user => "webuser",
        tomcat_port => "8080",
        jvm_envs => "-Dmy.java.opt=i_love_java",
        tomcat_manager => true,
        tomcat_admin_user => "superuser",
        tomcat_admin_password => "secretpassword"
      }

      tomcat7_rhel::tomcat-application { "my-second-application":
        application_root => "/opt",
        tomcat_user => "webuser",
        tomcat_port => "8090",
        jvm_envs => "-Dmy.java.opt=i_love_scala"
      }
    }

### Deploy

#### Without Tomcat Manager

    scp app.war webuser@superserver:~/app.war
    ssh webuser@superserver "rm -rf /opt/my-web-application/webapps/*"
    ssh webuser@superserver "cp ~/app.war /opt/my-web-application/webapps"
    ssh webuser@superserver "sudo service my-web-application restart"

#### With Tomcat Manager

    scp app.war webuser@superserver:/tmp/app.war
    ssh webuser@superserver "/opt/my-web-application/bin/deploy_with_tomcat_manager.sh /tmp/app.war"
    
Make sure your application shuts down its threads when Tomcat calls the 
`ServletContextListener#contextDestroyed` method.

### Run smoke test on the application

    ssh webuser@superserver "/opt/my-web-application/bin/run_smoke_test.sh"

## Known problems

* You need to `puppet apply` the configuration twice,
  because the Tomcat Manager declarations have insufficient dependencies.

  In addition, you also need to `sudo service my-web-application restart`, because of the
  Tomcat Manager installation problem.

* The Tomcat access logs are not rotated.

## Development

This project uses [Semantic Versioning](http://semver.org).

## Links

This project in Puppet Forge:
<http://forge.puppetlabs.com/llehmijo/tomcat7_rhel>.
