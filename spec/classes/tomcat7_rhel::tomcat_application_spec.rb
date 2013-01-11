require 'spec_helper'

describe 'tomcat7_rhel' do
  let(:title) { 'foo' }

  it { should include_class('tomcat7_rhel::jpackage-repo') }

  it {
    should contain_package('tomcat7').with({
      'ensure'  => 'installed'
    })
  }

  it { should contain_package("java-1.7.0-openjdk") }

  it { should contain_package("java-1.7.0-openjdk-devel") }
end
