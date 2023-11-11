# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..12} )
inherit distutils-r1 pypi systemd

DESCRIPTION="Simple integration of Flask and WTForms"
HOMEPAGE="https://pypi.org/project/calibreweb/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+metadata +kobi"

RDEPEND="
	acct-user/calibreweb
	acct-group/calibreweb
	dev-python/APScheduler[${PYTHON_USEDEP}]
	dev-python/Babel[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-babel[${PYTHON_USEDEP}]
	dev-python/flask-limiter[${PYTHON_USEDEP}]
	dev-python/flask-login[${PYTHON_USEDEP}]
	dev-python/flask-principal[${PYTHON_USEDEP}]
	dev-python/flask-wtf[${PYTHON_USEDEP}]
	dev-python/pycountry[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pypdf[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	<dev-python/sqlalchemy-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/tornado-6.3[${PYTHON_USEDEP}] <dev-python/tornado-6.4[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
	dev-python/wand[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	metadata? (
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/faust-cchardet[${PYTHON_USEDEP}]
		dev-python/html2text[${PYTHON_USEDEP}]
		dev-python/markdown2[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
	)
	kobi? (
		dev-python/jsonschema[${PYTHON_USEDEP}]
)
"

src_install()
{
	default

	systemd_dounit ${FILESDIR}/${PN}.service
}
