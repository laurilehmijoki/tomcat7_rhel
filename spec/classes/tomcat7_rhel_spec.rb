require 'spec_helper'

describe 'tomcat7_rhel' do
  shared_examples 'default packages' do
    it {
      should contain_package('tomcat7').with({
        'ensure'  => 'installed'
      })
    }

    it { should include_class('tomcat7_rhel::jpackage_repo') }
  end

  describe '$manage_java = [default]' do
    let(:title) { 'foo' }

    include_examples 'default packages'

    it { should contain_package("java-1.7.0-openjdk") }

    it { should contain_package("java-1.7.0-openjdk-devel") }
  end

  describe '$manage_java = false' do
    let(:title) { 'foo' }

    let(:params) {{
      :manage_java => false
    }}

    include_examples 'default packages'

    it { should_not contain_package("java-1.7.0-openjdk") }

    it { should_not contain_package("java-1.7.0-openjdk-devel") }
  end
end
