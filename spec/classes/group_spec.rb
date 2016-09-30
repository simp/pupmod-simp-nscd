require 'spec_helper'

describe 'nscd::group' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        it { is_expected.to create_class('nscd::group') }
        it { is_expected.to create_class('nscd') }

        context 'base' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to create_simpcat_fragment('nscd+conf.group').with({
              :content => /enable-cache\s+group\s+yes/
            })
          }
          it { is_expected.to create_simpcat_fragment('nscd+conf.group').with({
              :content => /auto-propagate/
            })
          }
        end
      end
    end
  end
end
