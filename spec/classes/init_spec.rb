require 'spec_helper'

describe 'nscd' do
  let(:facts) {{
    :fqdn => 'test.host.net',
    :hardwaremodel => 'x86_64',
    :operatingsystem => 'RedHat',
    :lsbmajdistrelease => '7',
    :apache_version => '2.4',
    :grub_version => '0.9',
    :uid_min => '500'
  }}

  it { should create_class('nscd') }

  context 'base' do
    it { should compile.with_all_deps }
    it { should create_class('openldap::pam') }
    it { should create_class('nscd::passwd') }
    it { should create_class('nscd::group') }
    it { should create_class('nscd::services') }
    it { should_not create_class('nscd::hosts') }
    it { should create_concat_fragment('nscd+conf.global').with({ :content => /paranoia\s+no/ }) }
  end

  context 'enable_hosts' do
    let(:params) {{ :enable_caches => ['passwd','group','services','hosts' ] }}
    it { should create_class('nscd::hosts') }
  end

end
