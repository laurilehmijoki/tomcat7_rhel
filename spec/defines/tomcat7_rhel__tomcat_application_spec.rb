require 'spec_helper'

describe 'tomcat7_rhel::tomcat_application' do
  context 'tomcat_manager = true' do
    let(:title) { 'my-app-with-tomcat-manager' }

    let(:params) {{
      :application_root => '/opt',
      :tomcat_user      => 'uzer',
      :tomcat_port      => 8123,
      :tomcat_manager   => true,
      :jvm_envs         => '-Di_love_tomcat=true'
    }}

    it { should include_class('tomcat7_rhel::tomcat7_manager_package') }

    it { should contain_package('tomcat7-admin-webapps') }

    it {
      should contain_file('/opt/my-app-with-tomcat-manager/conf/tomcat-users.xml').
        with_content(/.*username="tomcat".*/m).
        with_content(/.*password="s3cr3t".*/m)
    }

    it {
      should contain_file(
        '/opt/my-app-with-tomcat-manager/conf/Catalina/localhost/manager.xml').
        with_content(/.*Context path="\/manager".*/m)
    }

    it {
      should contain_file(
        '/opt/my-app-with-tomcat-manager/bin/deploy_with_tomcat_manager.sh').
        with_content(/.*curl --fail -4 -s -u tomcat:s3cr3t "http:\/\/localhost:8123\/manager\/text\/deploy\?path=\/&tag=my-app-with-tomcat-manager.*/m)
    }

    it {
      should contain_file(
        '/opt/my-app-with-tomcat-manager/bin/check_memory_leaks.sh').
        with_content(/.*curl --fail -4 -u tomcat:s3cr3t "http:\/\/localhost:8123\/manager\/text\/findleaks\?statusLine=true*/m)
    }

    it {
      should contain_file(
        '/opt/my-app-with-tomcat-manager/bin/list-applications.sh').
        with_content(/.*curl --fail -4 -u tomcat:s3cr3t "http:\/\/localhost:8123\/manager\/text\/list".*/m)
    }

    it {
      should contain_file(
        '/opt/my-app-with-tomcat-manager/bin/undeploy_with_tomcat_manager.sh').
        with_content(/.*curl --fail -4 -s -u tomcat:s3cr3t "http:\/\/localhost:8123\/manager\/text\/undeploy\?path=.*&tag=my-app-with-tomcat-manager".*/m)
    }
  end

  context 'JMX support with default ports' do
    let(:title) { 'my-web-app' }

    let(:params) {{
      :application_root => '/opt',
      :tomcat_user      => 'uzer',
      :tomcat_port      => 8123,
      :jvm_envs         => '-Di_love_java=true'
    }}

    it('enables the Tomcat JMX server') {
      should contain_file('/opt/my-web-app/conf/server.xml').
        with_content(/.*<Listener className="org.apache.catalina.mbeans.JmxRemoteLifecycleListener" rmiRegistryPortPlatform="10052" rmiServerPortPlatform="10051" \/>.*/m)
    }
  end

  context 'customising JMX' do
    let(:title) { 'my-web-app' }

    let(:params) {{
      :application_root => '/opt',
      :tomcat_user      => 'uzer',
      :tomcat_port      => 8123,
      :jvm_envs         => '-Di_love_java=true',
      :jmx_registry_port  => 9999,
      :jmx_server_port    => 8888
    }}

    it('allows the user to define JMX ports') {
      should contain_file('/opt/my-web-app/conf/server.xml').
        with_content(/.*<Listener className="org.apache.catalina.mbeans.JmxRemoteLifecycleListener" rmiRegistryPortPlatform="9999" rmiServerPortPlatform="8888" \/>.*/m)
    }
  end

  context 'Custom Tomcat control port' do
    let(:title) { 'my-web-app' }

    let(:params) {{
      :application_root => '/opt',
      :tomcat_user      => 'uzer',
      :tomcat_port      => 8123,
      :tomcat_control_port      => 9000,
      :jvm_envs         => '-Di_love_java=true'
    }}

    it {
      should contain_file('/opt/my-web-app/conf/server.xml').
      with_content(/.*<Server port="9000".*/m)
    }
  end

  context 'minimal configuration' do
    let(:title) { 'my-web-app' }

    let(:params) {{
      :application_root => '/opt',
      :tomcat_user      => 'uzer',
      :tomcat_port      => 8123,
      :jvm_envs         => '-Di_love_java=true'
    }}

    it { should include_class('tomcat7_rhel') }

    it { should_not contain_package('tomcat7-admin-webapps') }

    context 'server.xml ports' do
      it {
        should contain_file('/opt/my-web-app/conf/server.xml').
          with_content(/.*<Connector port="8123".*/m)
      }

      it {
        should contain_file('/opt/my-web-app/conf/server.xml').
          with_content(/.*<Server port="9123".*/m)
      }
    end

    it {
      should contain_file('/etc/init.d/my-web-app').with({
        'ensure' => 'link',
        'target' => '/etc/init.d/tomcat7'
      })
    }

    it {
      should contain_file('/opt/my-web-app/conf/web.xml').with({
        'ensure' => 'link',
        'target' => '/usr/share/tomcat7/conf/web.xml'
      })
    }

    it {
      should contain_service('my-web-app').with({
        'ensure' => 'running',
        'enable' => 'true'
      })
    }

    it {
      should contain_file('/etc/sysconfig/my-web-app').
        with_content(/.*JVM_OPTS="-Di_love_java=true".*/m)
    }

    it {
      should contain_file('/etc/sysconfig/my-web-app').
        with_content(/.*CATALINA_BASE="\/opt\/my-web-app".*/m)
    }

    it {
      should contain_file('/etc/logrotate.d/my-web-app').
        with_content(/\/opt\/my-web-app\/logs\/catalina.out \{.*/m).
        with_content(/\/opt\/my-web-app\/logs\/\*access_log\*.txt \{.*/m)
    }

    it {
      should contain_file('/opt/my-web-app/bin/run_smoke_test.sh').
        with_content(/.*curl -L.*localhost:8123.*/m)
    }
  end
end
