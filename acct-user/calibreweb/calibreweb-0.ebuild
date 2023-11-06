# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for the system-wide app-text/calibreweb server"
ACCT_USER_ID=500
ACCT_USER_HOME=/var/lib/calibreweb
ACCT_USER_HOME_PERMS=0770
ACCT_USER_GROUPS=( calibreweb )

acct-user_add_deps
