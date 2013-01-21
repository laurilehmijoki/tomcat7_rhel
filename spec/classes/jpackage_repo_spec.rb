require 'spec_helper'

describe 'tomcat7_rhel::jpackage_repo' do
  it {
    should contain_yumrepo('jpackage').
      with_baseurl('http://mirrors.dotsrc.org/jpackage/6.0/generic/free/')
  }
end
