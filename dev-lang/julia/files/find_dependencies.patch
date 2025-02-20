#!/bin/bash

function extract_pkg_and_version() {
	pkg=$(grep "GIT_URL" $1$2 | sed -e 's|.*github.com/\(.*\).git|\1|' -e 's|/| |g')
	vers=$(grep "SHA1" $1$3 | sed -e 's|.*SHA1 = \(.*\)|\1|' | sed -e 's|.*SHA1=\(.*\)|\1|')
	echo "\"${pkg} ${vers}\""
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

extract_pkg_and_version_for_stdlib
echo
extract_pkg_and_version_for_deps
