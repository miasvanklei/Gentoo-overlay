# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module readme.gentoo-r1 systemd tmpfiles

MY_PV=$(ver_rs 3 -)
MY_P="${PN}-v${MY_PV}"
REVISION="54944146"
BRANCH="13-10-stable"
NS="gitlab.com/gitlab-org/gitlab-runner/common"

DESCRIPTION="GitLab Runner"
HOMEPAGE="https://gitlab.com/gitlab-org/gitlab-runner"
SRC_URI="https://gitlab.com/gitlab-org/${PN}/-/archive/v${MY_PV}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="docker"
RESTRICT="mirror"

RDEPEND="acct-user/gitlab-runner"

S="${WORKDIR}/${MY_P}"

DOCS=( {CHANGELOG,README}.md )

DOC_CONTENTS="Register the runner using\\n
\\t gitlab-runner register\\n
Configure the runner in /etc/gitlab-runner/config.toml"

src_compile() {
	LDFLAGS="-X ${NS}.NAME=${PN} -X ${NS}.VERSION=${PV}
		-X ${NS}.REVISION=${REVISION} -X ${NS}.BUILT=$(date -u +%Y-%m-%dT%H:%M:%S%z)
		-X ${NS}.BRANCH=${BRANCH}"

	GOFLAGS="-v -x -mod=vendor" \
		go build -ldflags "${LDFLAGS}" || die "go build failed"
}

src_test() {
	GOFLAGS="-v -x -mod=vendor" \
		go test -work || die "test failed"
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
	doins config.toml.example

	diropts -o gitlab-runner -g gitlab -m 0700
	keepdir /etc/gitlab-runner /var/log/gitlab-runner
}

pkg_postinst() {
	readme.gentoo_print_elog
}
