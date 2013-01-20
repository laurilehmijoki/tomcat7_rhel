# Tomcat 7 on RHEL 6
[![Build Status](https://secure.travis-ci.org/laurilehmijoki/tomcat7_rhel.png)]
(http://travis-ci.org/laurilehmijoki/tomcat7_rhel)

Features

* Deploy multiple Tomcat instances on same machine ("the base + home setup")
* Use Tomcat Manager for deployment
* Use JMX for monitoring the Tomcat instances
* Use a ready-made smoke test script to test whether your web application is up and running

## Install

    puppet module install llehmijo/tomcat7_rhel

## Example usage

### Configure Puppet

    # In site.pp
    node "superserver" {
      tomcat7_rhel::tomcat_application { "my-web-application":
        application_root => "/opt",
        tomcat_user => "webuser",
        tomcat_port => "8080",
        jvm_envs => "-Dmy.java.opt=i_love_java -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=some.ip.address",
        tomcat_manager => true,
        tomcat_admin_user => "superuser",
        tomcat_admin_password => "secretpassword",
        jmxRegistryPort => 10054,
        jmxServerPort => 10053
      }

      tomcat7_rhel::tomcat_application { "my-second-application":
        application_root => "/opt",
        tomcat_user => "webuser",
        tomcat_port => "8090",
        jvm_envs => "-Dmy.java.opt=i_love_scala -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=some.ip.address"
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
    
#####  You can also use parallel deployment feature of tomcat (http://tomcat.apache.org/tomcat-7.0-doc/config/context.html#Parallel_deployment)

    scp app.war webuser@superserver:/tmp/app.war
    ssh webuser@superserver "/opt/my-web-application/bin/deploy_with_tomcat_manager.sh /tmp/app.war 1.2"

This starts a new version (1.2) of application in same contextpath as old one, without shutting down the old version,
meaning that new sessions (and requests) will go to new instance, while existing sessions stay in old version of application.
This also results in zero downtime of your application.

You can list running applications and their versions:
	
	ssh webuser@superserver "/opt/my-web-application/bin/list-applications.sh"
	
And undeploy old version of application:

	ssh webuser@superserver "/opt/my-web-application/bin/undeploy_with_tomcat_manager.sh 1.1"
	
    
NOTE. if you deploy with Manager, make sure your application shuts down correctly when Tomcat calls the 
`ServletContextListener#contextDestroyed` method, otherwise you will experience OOMs and other strange phenomenoms.

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
