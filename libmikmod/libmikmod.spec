%define version 3.3.11.1
%define release 1

Summary:    sound library for module files
Name:       libmikmod
Version:    %{version}
Release:    %{release}
License:    LGPL
Group:      System Environment/Libraries
URL:        http://mikmod.sourceforge.net/
#Source:    http://mikmod.sourceforge.net/files/%{name}-%{version}.tar.gz
Source:     http://download.sourceforge.net/mikmod/%{name}-%{version}.tar.gz
BuildRoot:  %{_tmppath}/%{name}-%{version}-root

%description
A portable sound library for Unix and other systems, capable of playing
samples as well as module files, on a wide range of sound devices.

%package    devel
Summary:    Libraries and include files to develop libmikmod applications
Group:      Development/Libraries
Requires:   %{name} = %{version}

%description devel
Install the libmikmod-devel package if you want to develop applications
that will use the libmikmod library.

%prep
%setup -q -n %{name}-%{version}

%build
%configure
make

%install
[ "$RPM_BUILD_ROOT" != "/" ] && [ -d $RPM_BUILD_ROOT ] && rm -rf $RPM_BUILD_ROOT
%makeinstall
rm -f $RPM_BUILD_ROOT/%{_infodir}/dir

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && [ -d $RPM_BUILD_ROOT ] && rm -rf $RPM_BUILD_ROOT

%post   -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%post devel
if [ "$1" = "1" ]; then # first install
  if [ -x /sbin/install-info ]; then
    for infofile in %{_infodir}/mikmod.info*; do
      /sbin/install-info $infofile %{_infodir}/dir
    done
  fi
fi

%preun devel
if [ "$1" = "0" ]; then # last uninstall
  if [ -x /sbin/install-info ]; then
    for infofile in %{_infodir}/mikmod.info*; do
      /sbin/install-info --delete $infofile %{_infodir}/dir
    done
  fi
fi

%ifos darwin
%define __defattr %defattr(-,root,wheel)
%define __soext   dylib
%else
%define __defattr %defattr(-,root,root)
%define __soext   so
%endif

%files
%{__defattr}
%doc AUTHORS COPYING.LESSER COPYING.LIB INSTALL NEWS README TODO
%ifnos darwin
%{_libdir}/libmikmod.%{__soext}.*
%else
%{_libdir}/libmikmod.*.%{__soext}
%endif

%files devel
%{__defattr}
%doc docs/mikmod.html
%{_bindir}/libmikmod-config
%{_mandir}/man?/*
%{_includedir}/mikmod.h
%{_libdir}/libmikmod.a
%{_libdir}/libmikmod.la
%{_libdir}/libmikmod.%{__soext}
%{_libdir}/pkgconfig/libmikmod.pc
%{_infodir}/mikmod.info*
%{_datadir}/aclocal/*
