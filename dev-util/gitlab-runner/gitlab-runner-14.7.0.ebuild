# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-build golang-vcs-snapshot readme.gentoo-r1 systemd tmpfiles

EGO_PN="gitlab.com/gitlab-org/gitlab-runner"

DESCRIPTION="GitLab Runner"
HOMEPAGE="https://gitlab.com/gitlab-org/gitlab-runner"
SRC_URI="https://gitlab.com/gitlab-org/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="docker"
RESTRICT="mirror"

RDEPEND="acct-user/gitlab-runner"

DOC_CONTENTS="Register the runner using\\n
\\t gitlab-runner register\\n
Configure the runner in /etc/gitlab-runner/config.toml"

src_unpack() {
	golang-vcs-snapshot_src_unpack
}

src_install() {
	einstalldocs

	exeinto /usr/libexec/gitlab-runner
	doexe gitlab-runner
	dosym ../libexec/gitlab-runner/gitlab-runner /usr/bin/gitlab-runner

	systemd_douserunit "${FILESDIR}"/gitlab-runner.service

	readme.gentoo_create_doc

	insopts -o gitlab-runner -g gitlab -m 0600
	insinto /etc/gitlab-runner

	diropts -o gitlab-runner -g gitlab -m 0700
	keepdir /etc/gitlab-runner /var/log/gitlab-runner
}

pkg_postinst() {
	readme.gentoo_print_elog
}
