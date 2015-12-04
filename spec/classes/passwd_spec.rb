require 'spec_helper'

describe 'nscd::passwd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        it { is_expected.to create_class('nscd') }
        it { is_expected.to create_class('nscd::passwd') }

        context 'base' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to create_concat_fragment('nscd+conf.passwd').with({
              :content => /enable-cache\s+passwd\s+yes/
            })
          }
          it { is_expected.to create_concat_fragment('nscd+conf.passwd').with({
              :content => /auto-propagate/
            })
          }
        end
      end
    end
  end
end
