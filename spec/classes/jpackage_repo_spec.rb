require 'spec_helper'

describe 'tomcat7_rhel::jpackage_repo' do
  it {
    should contain_yumrepo('jpackage').
      with_baseurl('ftp://jpackage.hmdc.harvard.edu/JPackage/6.0/generic/free/')
  }
end
