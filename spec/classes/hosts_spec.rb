require 'spec_helper'

describe 'nscd::hosts' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        it { is_expected.to create_class('nscd') }
        it { is_expected.to create_class('nscd::hosts') }

        context 'base' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to create_concat_fragment('nscd+conf.hosts').with({
              :content => /enable-cache\s+hosts\s+yes/
            })
          }
          it { is_expected.to create_concat_fragment('nscd+conf.hosts').without({
              :content => /auto-propagate/
            })
          }
        end
      end
    end
  end
end
