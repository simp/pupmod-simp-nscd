require 'spec_helper'

describe 'nscd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        it { is_expected.to create_class('nscd') }

        context 'base' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to create_class('openldap::pam') }
          it { is_expected.to create_class('nscd::passwd') }
          it { is_expected.to create_class('nscd::group') }
          it { is_expected.to create_class('nscd::services') }
          it { is_expected.not_to create_class('nscd::hosts') }
          it { is_expected.to create_simpcat_fragment('nscd+conf.global').with({ :content => /paranoia\s+no/ }) }
        end

        context 'enable_hosts' do
          let(:params) {{ :enable_caches => ['passwd','group','services','hosts' ] }}
          it { is_expected.to create_class('nscd::hosts') }
        end

      end
    end
  end
end
