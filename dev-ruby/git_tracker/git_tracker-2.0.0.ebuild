# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_TASK_DOC=""

# Not all files present.
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Some simple tricks that make working with Pivotal Tracker even better... and easier... um, besier!"
HOMEPAGE="https://github.com/stevenharman/git_tracker"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE="doc"

ruby_add_rdepend ">=dev-ruby/rspec-3.5
		>=dev-ruby/pry-0.10
		>=dev-ruby/rake-12.0
		>=dev-ruby/activesupport-4.0"
