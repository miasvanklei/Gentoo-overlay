EAPI=6

inherit git-r3

DESCRIPTION="Actions gestures on your touchpad using libinput"
HOMEPAGE="https://github.com/bulletmark/libinput-gestures"
SRC_URI=""
EGIT_REPO_URI="https://github.com/bulletmark/libinput-gestures.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RDEPEND="
    >=dev-lang/python-3
    >=dev-libs/libinput-1
    x11-misc/xdotool
    x11-misc/wmctrl
"
DEPEND="${RDEPEND}"
