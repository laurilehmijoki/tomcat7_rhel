# Tomcat 7 on RHEL 6

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
        jvm_envs => "-Dmy.java.opt=i_love_java"
      }
    }

### Deploy

    scp app.war webuser@superserver:~/app.war
    ssh webuser@superserver "rm -rf /opt/my-web-application/webapps/*"
    ssh webuser@superserver "cp ~/app.war /opt/my-web-application/webapps"
