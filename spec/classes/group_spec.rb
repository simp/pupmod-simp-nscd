require 'spec_helper'

describe 'nscd::group' do
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
  it { should create_class('nscd::group') }

  context 'base' do
    it { should compile.with_all_deps }
    it { should create_concat_fragment('nscd+conf.group').with({
        :content => /enable-cache\s+group\s+yes/
      })
    }
    it { should create_concat_fragment('nscd+conf.group').with({
        :content => /auto-propagate/
      })
    }
  end
end
