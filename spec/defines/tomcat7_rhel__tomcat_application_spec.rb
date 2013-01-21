require 'spec_helper'

describe 'tomcat7_rhel::tomcat_application' do
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

    it {
      should contain_file('/opt/my-web-app/conf/server.xml').
        with_content(/.*port="8123".*/m)
    }

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
        'ensure' => 'running'
      })
    }

    it {
      should contain_file('/etc/sysconfig/my-web-app').
        with_content(/.*JVM_OPTS="-server -Xmx1024m -Xms128m -XX:MaxPermSize=256m -Di_love_java=true".*/m)
    }

    it {
      should contain_file('/etc/sysconfig/my-web-app').
        with_content(/.*CATALINA_BASE="\/opt\/my-web-app".*/m)
    }

    it {
      should contain_file('/etc/logrotate.d/my-web-app').
        with_content(
          /\/opt\/my-web-app\/logs\/catalina.out {/m)
    }

    it {
      should contain_file('/opt/my-web-app/bin/run_smoke_test.sh').
        with_content(/.*curl -L.*localhost:8123.*/m)
    }
  end
end
