require 'spec_helper'

describe 'nscd::passwd' do
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
  it { should create_class('nscd::passwd') }

  context 'base' do
    it { should compile.with_all_deps }
    it { should create_concat_fragment('nscd+conf.passwd').with({
        :content => /enable-cache\s+passwd\s+yes/
      })
    }
    it { should create_concat_fragment('nscd+conf.passwd').with({
        :content => /auto-propagate/
      })
    }
  end
end
