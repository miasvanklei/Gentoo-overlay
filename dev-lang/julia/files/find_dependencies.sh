#!/bin/bash

function extract_pkg_and_version() {
	pkg=$(grep "GIT_URL" $1$2 | sed -e 's|.*github.com/\(.*\).git|\1|' -e 's|/| |g')
	vers=$(grep "SHA1" $1$3 | sed -e 's|.*SHA1 = \(.*\)|\1|' | sed -e 's|.*SHA1=\(.*\)|\1|')
	echo -e "\t\"${pkg} ${vers}\""
}

function extract_pkg_and_version_for_stdlib() {
	for i in stdlib/*.version; do
		extract_pkg_and_version "$i" "" ""
	done
}

function extract_pkg_and_version_for_deps() {
	extract_pkg_and_version "deps/JuliaSyntax.version" "" ""
	for i in deps/{ittapi,libwhich,libuv,blastrampoline}; do
		extract_pkg_and_version "$i" ".mk" ".version"
	done
}

echo "STDLIBS=("
echo -e "\t# repo    package name    hash"
extract_pkg_and_version_for_stdlib
echo ")"
echo
echo "# correct versions for deps are in deps/{package_name}.version"
echo "BUNDLED_DEPS=("
extract_pkg_and_version_for_deps
echo ")"
