# Tomcat 7 on RHEL 6

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
    }

### Deploy

    scp app.war webuser@superserver:~/app.war
    ssh webuser@superserver "rm -rf /opt/my-web-application/webapps/*"
    ssh webuser@superserver "cp ~/app.war /opt/my-web-application/webapps"

## Development

This project uses [Semantic Versioning](http://semver.org).

## Links

This project in Puppet Forge:
<http://forge.puppetlabs.com/llehmijo/tomcat7_rhel>.
