require 'spec_helper'

describe 'nscd::services' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        it { is_expected.to create_class('nscd') }
        it { is_expected.to create_class('nscd::services') }

        context 'base' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to create_simpcat_fragment('nscd+conf.services').with({
              :content => /enable-cache\s+services\s+yes/
            })
          }
          it { is_expected.to create_simpcat_fragment('nscd+conf.services').without({
              :content => /auto-propagate/
            })
          }
        end
      end
    end
  end
end
