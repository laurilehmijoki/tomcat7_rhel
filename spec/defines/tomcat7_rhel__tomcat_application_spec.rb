require 'spec_helper'

describe 'tomcat7_rhel::tomcat_application with minimal parameters' do
  let(:title) { 'my-web-app' }
  let(:params) {{
    :application_root => '/opt',
    :tomcat_user      => 'uzer',
    :tomcat_port      => 8080,
    :jvm_envs         => '-Di_love_java=true',
  }}

  it {
    should include_class('tomcat7_rhel')
  }
end
