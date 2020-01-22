# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 golang-base golang-vcs-snapshot multilib linux-info systemd

DESCRIPTION="Service and tools for management of snap packages"
HOMEPAGE="http://snapcraft.io/"
SRC_URI="https://github.com/snapcore/${PN}/releases/download/${PV}/${PN}_${PV}.vendor.tar.xz -> ${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="primaryuri"

MY_S="${S}/src/github.com/snapcore/${PN}"
PKG_LINGUAS="am bs ca cs da de el en_GB es fi fr gl hr ia id it ja lt ms nb oc pt_BR pt ru sv tr ug zh_CN"

CONFIG_CHECK="	CGROUPS \
		CGROUP_DEVICE \
		CGROUP_FREEZER \
		NAMESPACES \
		SQUASHFS \
		SQUASHFS_ZLIB \
		SQUASHFS_LZO \
		SQUASHFS_XZ \
		BLK_DEV_LOOP \
		SECCOMP \
		SECCOMP_FILTER \
		SECURITY_APPARMOR"

export GOPATH="${S}/${PN}"

EGO_PN="github.com/snapcore/${PN}"

PATCHES=(
	"${FILESDIR}"/add-musl-path.patch
	"${FILESDIR}"/missing-includes.patch
	"${FILESDIR}"/remove-xfs.patch
	"${FILESDIR}"/use-getenv.patch
)

RDEPEND="sys-libs/libseccomp[static-libs]
	sys-libs/libcap
	sys-apps/apparmor
	sec-policy/apparmor-profiles
	dev-libs/glib
	sys-fs/squashfs-tools:*"
DEPEND="${RDEPEND}
	>=dev-lang/go-1.9
	dev-python/docutils
	sys-devel/gettext"

src_configure() {
	debug-print-function $FUNCNAME "$@"

	cd "${MY_S}/cmd/"
	cat <<EOF > "${MY_S}/cmd/version_generated.go"
package cmd
func init() {
        Version = "${PV}"
}
EOF
	echo "${PV}" > "${MY_S}/cmd/VERSION"
	echo "VERSION=${PV}" > "${MY_S}/data/info"

	test -f configure.ac	# Sanity check, are we in the right directory?
	rm -f config.status
	autoreconf -i -f	# Regenerate the build system
	econf --enable-maintainer-mode --disable-silent-rules --enable-apparmor
}

src_compile() {
	debug-print-function $FUNCNAME "$@"

	C="${MY_S}/cmd/"
	emake -C "${MY_S}/data/"
	emake -C "${C}"

	# Generate snapd-apparmor systemd unit
	emake -C "${MY_S}/data/systemd"

	export GOPATH="${S}/"
	VX="-v -x" # or "-v -x" for verbosity
	for I in snapctl snap-failure snap-exec snap snapd snap-seccomp snap-update-ns; do
		einfo "go building: ${I}"
		go install $VX -ldflags '-s -w -linkmode external -extldflags -static'  "github.com/snapcore/${PN}/cmd/${I}" || die
	done
	"${S}/bin/snap" help --man > "${C}/snap/snap.1"
	rst2man.py "${C}/snap-confine/"snap-confine.{rst,1}
	rst2man.py "${C}/snap-discard-ns/"snap-discard-ns.{rst,5}

	for I in ${PKG_LINGUAS};do
		einfo "mo building: ${I}"
		msgfmt -v --output-file="${MY_S}/po/${I}.mo" "${MY_S}/po/${I}.po"
	done

	# Generate apparmor profile
	sed -e "s,[@]LIBEXECDIR[@],/usr/$(get_libdir)/snapd,g" \
		-e 's,[@]SNAP_MOUNT_DIR[@],/snap,' \
		"${C}/snap-confine/snap-confine.apparmor.in" \
		> "${C}/snap-confine/usr.$(get_libdir).snapd.snap-confine.real"
}

src_install() {
	debug-print-function $FUNCNAME "$@"

	C="${MY_S}/cmd"
	DS="${MY_S}/data/systemd"

	doman \
		"${C}/snap-confine/snap-confine.1" \
		"${C}/snap/snap.1" \
		"${C}/snap-discard-ns/snap-discard-ns.5"

	systemd_dounit \
		"${DS}/snapd.service" \
		"${DS}/snapd.socket" \
		"${DS}/snapd.apparmor.service"

	cd "${MY_S}"
	dodir  \
		"/etc/profile.d" \
		"/usr/$(get_libdir)/snapd" \
		"/usr/share/dbus-1/services" \
		"/usr/share/polkit-1/actions" \
		"/var/lib/snapd"

	exeinto "/usr/$(get_libdir)/${PN}"
	doexe "${C}"/decode-mount-opts/decode-mount-opts
	doexe "${C}"/snap-discard-ns/snap-discard-ns
	doexe "${S}/bin"/snap
	doexe "${S}/bin"/snapd
	doexe "${S}/bin"/snapctl
	doexe "${S}/bin"/snap-exec
	doexe "${S}/bin"/snap-failure
	doexe "${S}/bin"/snap-update-ns
	doexe "${S}/bin"/snap-seccomp ### missing libseccomp
	doexe "${MY_S}/cmd/snapd-apparmor/snapd-apparmor"
	doexe \
			data/completion/etelpmoc.sh \
			data/completion/complete.sh
	doexe "${C}"/snap-confine/snap-device-helper
	exeopts -m 6755
	doexe "${C}"/snap-confine/snap-confine
	dosym "/usr/$(get_libdir)/${PN}/snap" /usr/bin/snap
	dosym "/usr/$(get_libdir)/snapd/snapctl" /usr/bin/snapctl

	insinto "/usr/share/selinux/targeted/include/snapd/"
	doins \
			data/selinux/snappy.if \
			data/selinux/snappy.te \
			data/selinux/snappy.fc

	insinto "/usr/share/dbus-1/services/"
	doins data/dbus/io.snapcraft.Launcher.service
	insinto "/usr/share/polkit-1/actions/"
	doins data/polkit/io.snapcraft.snapd.policy

	insinto "/usr/$(get_libdir)/snapd/"
	doins "${MY_S}/data/info"
	insinto "/etc/profile.d/"
	doins data/env/snapd.sh
	insinto "/etc/apparmor.d"
	doins "${C}/snap-confine/usr.$(get_libdir).snapd.snap-confine.real"

	dodoc	"${MY_S}/packaging/ubuntu-14.04"/copyright \
		"${MY_S}/packaging/ubuntu-16.04"/changelog

	dobashcomp data/completion/snap

	domo "${MY_S}/po"/*.mo

}