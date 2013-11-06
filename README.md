# Tomcat 7 on RHEL 6 [![Build Status](https://secure.travis-ci.org/laurilehmijoki/tomcat7_rhel.png)]
(http://travis-ci.org/laurilehmijoki/tomcat7_rhel)

## Features

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
        jvm_envs => "-server -Xmx1024m -Xms128m -XX:MaxPermSize=256m -Dmy.java.opt=i_love_java -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=some.ip.address",
        tomcat_manager => true,
        tomcat_admin_user => "superuser",
        tomcat_admin_password => "secretpassword",
        smoke_test_path => "/health-check",
        jmx_registry_port => 10054,
        jmx_server_port => 10053
      }

      tomcat7_rhel::tomcat_application { "my-second-application":
        application_root => "/opt",
        tomcat_user => "webuser",
        tomcat_port => "8090",
        disable_access_log => true,
        jvm_envs => "-server -Xmx1024m -Xms128m -XX:MaxPermSize=256m -Dmy.java.opt=i_love_scala -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=some.ip.address"
      }
    }

## Custom configurations

### Adding extra configuration into the `<Engine>` tag of `server.xml`

You can include additional configuration in the `<Engine>` tag of you
`server.xml` by including a valid
[engine](http://tomcat.apache.org/tomcat-7.0-doc/config/engine.html) value in
the `server_xml_engine_config` parameter of `tomcat7_rhel::tomcat_application`.

For example, you can enable Tomcat 7 session replication with the help of the
`server_xml_engine_config` parameter. See the example below for more info.

### Enabling session replication

Take a look at [Tomcat 7 Clustering/Session Replication HOW-TO](http://tomcat.apache.org/tomcat-7.0-doc/cluster-howto.html).

Enable default clustering by passing `server_xml_engine_config` into `tomcat7_rhel::tomcat_application`:

    server_xml_engine_config => "<Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster"/>"

Full control over the clustering xml fragment can be done conveniently by using your own template:

	server_xml_engine_config => template("mymodule/my_tomcat_cluster_config.erb")

### Specifying allow/deny IPs for Tomcat Manager

Pass the params `tomcat_manager_allow_ip` and `tomcat_manager_deny_ip` to
`tomcat7_rhel::tomcat_application`.

## Deploy

### Without Tomcat Manager

    scp app.war webuser@superserver:~/app.war
    ssh webuser@superserver "rm -rf /opt/my-web-application/webapps/*"
    ssh webuser@superserver "cp ~/app.war /opt/my-web-application/webapps/ROOT.war"
    ssh webuser@superserver "sudo service my-web-application restart"

### With Tomcat Manager

    scp app.war webuser@superserver:/tmp/app.war
    ssh webuser@superserver "/opt/my-web-application/bin/deploy_with_tomcat_manager.sh /tmp/app.war"

Note that if you deploy with Manager, make sure your application shuts down correctly when Tomcat calls the
`ServletContextListener#contextDestroyed` method, otherwise you will eventually experience out-of-memory errors.

You can use the `check_memory_leaks.sh` to find memory leaks. It's under the
`bin` directory of your web application.

###  You can also use the parallel deployment feature of Tomcat (http://tomcat.apache.org/tomcat-7.0-doc/config/context.html#Parallel_deployment)

    scp app.war webuser@superserver:/tmp/app.war
    ssh webuser@superserver "/opt/my-web-application/bin/deploy_with_tomcat_manager.sh /tmp/app.war 1.2"

The above example starts a new version (1.2) of application in the same context path as the old one, without shutting down the old version,
meaning that new sessions (and requests) will go to the new instance, while existing sessions stay in the old version of application.
This results in zero downtime for your application.

You can list the running applications and their versions:

	ssh webuser@superserver "/opt/my-web-application/bin/list-applications.sh"

And undeploy an old version of the application:

	ssh webuser@superserver "/opt/my-web-application/bin/undeploy_with_tomcat_manager.sh 1.1"

### Run smoke test on the application

    ssh webuser@superserver "/opt/my-web-application/bin/run_smoke_test.sh"

### For Hiera users

From <https://github.com/laurilehmijoki/tomcat7_rhel/pull/22#issuecomment-23689505>:

I've added a class tomcat7_rhel::tomcat_instances, which allows users of hiera
to assign defined types through this class wrapper using for example the
following yaml (change to json for json users, obviously):

    tomcat7_rhel::tomcat_instances::instances:
        tomcat-datascience:
          application_root: /meltwater
          tomcat_user: www-data
          jvm_envs: "-server -Xmx128m -Xms128m -XX:MaxPermSize=256m"
          tomcat_manager: true
          tomcat_admin_user: superuser
          tomcat_admin_password: secretpassword
          tomcat_port: 8080
          tomcat_control_port: 9080

## Development

### Versioning

This project uses [Semantic Versioning](http://semver.org).

### Testing

We test this project with <http://rspec-puppet.com/>.

You can run the tests like this:

    bundle install # Installs the Ruby gems that we use for testing
    rake

## Links

This project in Puppet Forge:
<http://forge.puppetlabs.com/llehmijo/tomcat7_rhel>.

## A note about JPackage unstability

Sometimes the indices of the [JPackage Project](http://www.jpackage.org/)
become corrupted. When that happens, this Puppet module will fail to install
the Tomcat package.

For example, the indices might point to Tomcat 7.0.34, whereas the mirrors only
contain the version 7.0.39.

### Verifying that the indices do not work

1. Open <http://mirrors.dotsrc.org/jpackage/6.0/generic/free/RPMS/> and find
   `tomcat7`
2. Note the version of the tomcat7 RPM package
3. Open
   <http://mirrors.dotsrc.org/jpackage/6.0/generic/free/repodata/filelists.xml.gz>
   and check if the tomcat7 entry in the `filelists.xml` points to a
   **different** version that what's available (refer to steps 1 and 2 here)
4. If the versions do not match, this project does not work. Go do something
   else!
5. If the versions match, please notify lauri.lehmijoki@iki.fi
