# Copyright 2017 Mias van Klei
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Frog is an integration of memory-based natural language processing
            (NLP) modules developed for Dutch. It includes a tokenizer,
            part-of-speech tagger, lemmatizer, morphological analyser, named
            entity recognition, shallow parser and dependency parser."
HOMEPAGE="http://julialang.org/utf8proc"
SRC_URI="https://github.com/LanguageMachines/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3.0"

SLOT="0"

S="${WORKDIR}/${P/_/-}"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""
DEPEND="dev-libs/libxml2
	dev-libs/icu
	sci-libs/libfolia
	sci-libs/ticcutils
	sci-libs/uctodata
	sci-libs/ucto
	sci-libs/timbl
	sci-libs/mbt
	sci-libs/frogdata
	virtual/pkgconfig"

src_prepare()
{
	# fixes build error and linking error
	eapply "${FILESDIR}"/missing-includes.patch

	eapply_user
	eautoreconf
}

src_configure() {
        econf --disable-static
}

src_install() {
        default
        find "${D}" -name '*.la' -delete || die
}
