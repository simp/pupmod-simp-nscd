Summary: NSCD Puppet Module
Name: pupmod-nscd
Version: 5.0.0
Release: 5
License: Apache License, Version 2.0
Group: Applications/System
Source: %{name}-%{version}-%{release}.tar.gz
Buildroot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Requires: pupmod-common >= 4.1.0-6
Requires: pupmod-simplib >= 1.0.0-0
Requires: pupmod-simpcat >= 4.0.0-0
Requires: pupmod-openldap >= 4.1.0-3
Requires: puppet >= 3.3.0
Buildarch: noarch
Requires: simp-bootstrap >= 4.2.0
Obsoletes: pupmod-nscd-test

Prefix: /etc/puppet/environments/simp/modules

%description
This Puppet module provides the capability to configure NSCD on your system.

%prep
%setup -q

%build

%install
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/nscd

dirs='files lib manifests templates'
for dir in $dirs; do
  test -d $dir && cp -r $dir %{buildroot}/%{prefix}/nscd
done

mkdir -p %{buildroot}/usr/share/simp/tests/modules/nscd

%clean
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/nscd

%files
%defattr(0640,root,puppet,0750)
%{prefix}/nscd

%post
#!/bin/sh

if [ -d %{prefix}/nscd/plugins ]; then
  /bin/mv %{prefix}/nscd/plugins %{prefix}/nscd/plugins.bak
fi

%postun
# Post uninstall stuff

%changelog
* Mon Nov 09 2015 Chris Tessmer <chris.tessmer@onypoint.com> - 5.0.0-5
- migration to simplib and simpcat (lib/ only)

* Thu Feb 19 2015 Trevor Vaughan <tvaughan@onyxpoint.com> - 5.0.0-4
- Migrated to the new 'simp' environment.

* Fri Jan 16 2015 Trevor Vaughan <tvaughan@onyxpoint.com> - 5.0.0-3
- Changed puppet-server requirement to puppet

* Wed Jul 02 2014 Nick Markowski <nmarkowski@keywcorp.com> - 5.0.0-2
- Modified the service command in the service start/restart clause
  to be compatible with RHEL 7 AND 6.

* Sun Jun 22 2014 Kendall Moore <kmoore@keywcorp.com> - 5.0.0-1
- Removed MD5 file checksums for FIPS compliance.

* Fri Jun 20 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 5.0.0-1
- Modified the nscd start command to use the call to /usr/sbin/service
  instead of the init script directly so that it works in RHEL7 and
  below.

* Tue Mar 25 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 5.0.0-0
- Updated to work well with hiera and Puppet 3
- Removed the nscd::conf define and split out each of the services into their
  own classes for easier manipulation via Hiera.
- Incorporated the nscd::global define into the main nscd class.
- Added a variable to the main nscd class to allow for the automatic creation
  of the usually cached services.
- Added spec tests.

* Mon Oct 07 2013 Kendall Moore <kmoore@keywcorp.com> 4.0.0-5
- Updated all erb templates to properly scope variables.

* Mon Jan 07 2013 Maintenance
4.0.0-4
- Created a Cucumber test which toggles the nscd switch to true and ensures
  that the nscd service is running and the sssd service is stopped.

* Wed Apr 11 2012 Maintenance
4.0.0-3
- Moved mit-tests to /usr/share/simp...
- Updated pp files to better meet Puppet's recommended style guide.

* Fri Mar 02 2012 Maintenance
4.0.0-2
- Improved test stubs.

* Wed Dec 14 2011 Maintenance
4.0.0-1
- Updated the spec file to not require a separate file list.
- Removed prod_nscd from here since it more accurately belongs in the openldap
  module.

* Fri Oct 28 2011 Maintenance
4.0.0-0
- Updated to use the selective variable for the location of the PAM LDAP
  library.

* Mon Oct 10 2011 Maintenance
2.0.0-2
- Add an exec to be sure that nscd has not lost its mind.
- Updated to put quotes around everything that need it in a comparison
  statement so that puppet > 2.5 doesn't explode with an undef error.

* Fri Feb 11 2011 Maintenance - 2.0.0-1
- Forward port of nscd fix for cleaning up orphan pid files prior to restarting
  nscd.
- Updated to use concat_build and concat_fragment types.

* Tue Jan 11 2011 Maintenance
2.0.0-0
- Refactored for SIMP-2.0.0-alpha release

* Tue Jan 11 2011 Maintenance - 1-2
- Remove any existing pid file from /var/run/nscd prior to starting. This
  ensures that a crashed process does not interfere with running a new process.

* Tue Oct 26 2010 Maintenance - 1-1
- Converting all spec files to check for directories prior to copy.

* Fri May 21 2010 Maintenance
1.0-0
- Code refactor and Doc update.

* Wed Jan 06 2010 Maintenance
0.1-11
- Paranoia is now 'off' by default.

* Tue Nov 24 2009 Maintenance
0.1-10
- Changed the service statement to properly restart the nscd service.
