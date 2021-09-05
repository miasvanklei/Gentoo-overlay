# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

EGO_SUM=(
"cdr.dev/slog v1.3.0"
"cdr.dev/slog v1.3.0/go.mod"
"cloud.google.com/go v0.26.0/go.mod"
"cloud.google.com/go v0.34.0/go.mod"
"cloud.google.com/go v0.38.0/go.mod"
"cloud.google.com/go v0.44.1/go.mod"
"cloud.google.com/go v0.44.2/go.mod"
"cloud.google.com/go v0.45.1/go.mod"
"cloud.google.com/go v0.46.3/go.mod"
"cloud.google.com/go v0.49.0"
"cloud.google.com/go v0.49.0/go.mod"
"cloud.google.com/go/bigquery v1.0.1/go.mod"
"cloud.google.com/go/datastore v1.0.0/go.mod"
"cloud.google.com/go/pubsub v1.0.1/go.mod"
"cloud.google.com/go/storage v1.0.0/go.mod"
"dmitri.shuralyov.com/gpu/mtl v0.0.0-20190408044501-666a987793e9/go.mod"
"github.com/BurntSushi/toml v0.3.1/go.mod"
"github.com/BurntSushi/xgb v0.0.0-20160522181843-27f122750802/go.mod"
"github.com/GeertJohan/go.incremental v1.0.0/go.mod"
"github.com/GeertJohan/go.rice v1.0.0/go.mod"
"github.com/akavel/rsrc v0.8.0/go.mod"
"github.com/alecthomas/assert v0.0.0-20170929043011-405dbfeb8e38"
"github.com/alecthomas/assert v0.0.0-20170929043011-405dbfeb8e38/go.mod"
"github.com/alecthomas/chroma v0.7.0"
"github.com/alecthomas/chroma v0.7.0/go.mod"
"github.com/alecthomas/colour v0.0.0-20160524082231-60882d9e2721"
"github.com/alecthomas/colour v0.0.0-20160524082231-60882d9e2721/go.mod"
"github.com/alecthomas/kong v0.1.17-0.20190424132513-439c674f7ae0/go.mod"
"github.com/alecthomas/kong v0.2.1-0.20190708041108-0548c6b1afae/go.mod"
"github.com/alecthomas/kong-hcl v0.1.8-0.20190615233001-b21fea9723c8/go.mod"
"github.com/alecthomas/repr v0.0.0-20180818092828-117648cd9897"
"github.com/alecthomas/repr v0.0.0-20180818092828-117648cd9897/go.mod"
"github.com/census-instrumentation/opencensus-proto v0.2.1/go.mod"
"github.com/client9/misspell v0.3.4/go.mod"
"github.com/daaku/go.zipexe v1.0.0/go.mod"
"github.com/danwakefield/fnmatch v0.0.0-20160403171240-cbb64ac3d964"
"github.com/danwakefield/fnmatch v0.0.0-20160403171240-cbb64ac3d964/go.mod"
"github.com/davecgh/go-spew v1.1.0/go.mod"
"github.com/davecgh/go-spew v1.1.1"
"github.com/davecgh/go-spew v1.1.1/go.mod"
"github.com/dlclark/regexp2 v1.1.6/go.mod"
"github.com/dlclark/regexp2 v1.2.0"
"github.com/dlclark/regexp2 v1.2.0/go.mod"
"github.com/envoyproxy/go-control-plane v0.9.0/go.mod"
"github.com/envoyproxy/protoc-gen-validate v0.1.0/go.mod"
"github.com/fatih/color v1.7.0"
"github.com/fatih/color v1.7.0/go.mod"
"github.com/gin-contrib/sse v0.1.0"
"github.com/gin-contrib/sse v0.1.0/go.mod"
"github.com/gin-gonic/gin v1.6.3"
"github.com/gin-gonic/gin v1.6.3/go.mod"
"github.com/go-gl/glfw v0.0.0-20190409004039-e6da0acd62b1/go.mod"
"github.com/go-playground/assert/v2 v2.0.1"
"github.com/go-playground/assert/v2 v2.0.1/go.mod"
"github.com/go-playground/locales v0.13.0"
"github.com/go-playground/locales v0.13.0/go.mod"
"github.com/go-playground/universal-translator v0.17.0"
"github.com/go-playground/universal-translator v0.17.0/go.mod"
"github.com/go-playground/validator/v10 v10.2.0"
"github.com/go-playground/validator/v10 v10.2.0/go.mod"
"github.com/gobwas/httphead v0.0.0-20180130184737-2c6c146eadee"
"github.com/gobwas/httphead v0.0.0-20180130184737-2c6c146eadee/go.mod"
"github.com/gobwas/pool v0.2.0"
"github.com/gobwas/pool v0.2.0/go.mod"
"github.com/gobwas/ws v1.0.2"
"github.com/gobwas/ws v1.0.2/go.mod"
"github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b"
"github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b/go.mod"
"github.com/golang/groupcache v0.0.0-20190702054246-869f871628b6/go.mod"
"github.com/golang/groupcache v0.0.0-20191027212112-611e8accdfc9"
"github.com/golang/groupcache v0.0.0-20191027212112-611e8accdfc9/go.mod"
"github.com/golang/mock v1.1.1/go.mod"
"github.com/golang/mock v1.2.0/go.mod"
"github.com/golang/mock v1.3.1/go.mod"
"github.com/golang/protobuf v1.2.0/go.mod"
"github.com/golang/protobuf v1.3.1/go.mod"
"github.com/golang/protobuf v1.3.2/go.mod"
"github.com/golang/protobuf v1.3.3/go.mod"
"github.com/golang/protobuf v1.3.5"
"github.com/golang/protobuf v1.3.5/go.mod"
"github.com/google/btree v0.0.0-20180813153112-4030bb1f1f0c/go.mod"
"github.com/google/btree v1.0.0/go.mod"
"github.com/google/go-cmp v0.2.0/go.mod"
"github.com/google/go-cmp v0.3.0/go.mod"
"github.com/google/go-cmp v0.3.2-0.20191216170541-340f1ebe299e/go.mod"
"github.com/google/go-cmp v0.4.0"
"github.com/google/go-cmp v0.4.0/go.mod"
"github.com/google/gofuzz v1.0.0/go.mod"
"github.com/google/martian v2.1.0+incompatible/go.mod"
"github.com/google/pprof v0.0.0-20181206194817-3ea8567a2e57/go.mod"
"github.com/google/pprof v0.0.0-20190515194954-54271f7e092f/go.mod"
"github.com/google/renameio v0.1.0/go.mod"
"github.com/googleapis/gax-go/v2 v2.0.4/go.mod"
"github.com/googleapis/gax-go/v2 v2.0.5/go.mod"
"github.com/gorilla/csrf v1.6.0/go.mod"
"github.com/gorilla/handlers v1.4.1/go.mod"
"github.com/gorilla/mux v1.7.3/go.mod"
"github.com/gorilla/securecookie v1.1.1/go.mod"
"github.com/gorilla/websocket v1.4.1"
"github.com/gorilla/websocket v1.4.1/go.mod"
"github.com/hashicorp/golang-lru v0.5.0/go.mod"
"github.com/hashicorp/golang-lru v0.5.1/go.mod"
"github.com/hashicorp/hcl v1.0.0/go.mod"
"github.com/hashicorp/yamux v0.0.0-20200609203250-aecfd211c9ce"
"github.com/hashicorp/yamux v0.0.0-20200609203250-aecfd211c9ce/go.mod"
"github.com/jessevdk/go-flags v1.4.0/go.mod"
"github.com/json-iterator/go v1.1.9"
"github.com/json-iterator/go v1.1.9/go.mod"
"github.com/jstemmer/go-junit-report v0.0.0-20190106144839-af01ea7f8024/go.mod"
"github.com/kisielk/gotool v1.0.0/go.mod"
"github.com/klauspost/compress v1.10.3"
"github.com/klauspost/compress v1.10.3/go.mod"
"github.com/kr/pretty v0.1.0"
"github.com/kr/pretty v0.1.0/go.mod"
"github.com/kr/pty v1.1.1/go.mod"
"github.com/kr/text v0.1.0"
"github.com/kr/text v0.1.0/go.mod"
"github.com/leodido/go-urn v1.2.0"
"github.com/leodido/go-urn v1.2.0/go.mod"
"github.com/mattn/go-colorable v0.0.9/go.mod"
"github.com/mattn/go-colorable v0.1.4/go.mod"
"github.com/mattn/go-colorable v0.1.7"
"github.com/mattn/go-colorable v0.1.7/go.mod"
"github.com/mattn/go-isatty v0.0.4/go.mod"
"github.com/mattn/go-isatty v0.0.8/go.mod"
"github.com/mattn/go-isatty v0.0.11/go.mod"
"github.com/mattn/go-isatty v0.0.12"
"github.com/mattn/go-isatty v0.0.12/go.mod"
"github.com/mitchellh/mapstructure v1.1.2/go.mod"
"github.com/modern-go/concurrent v0.0.0-20180228061459-e0a39a4cb421"
"github.com/modern-go/concurrent v0.0.0-20180228061459-e0a39a4cb421/go.mod"
"github.com/modern-go/reflect2 v0.0.0-20180701023420-4b7aa43c6742"
"github.com/modern-go/reflect2 v0.0.0-20180701023420-4b7aa43c6742/go.mod"
"github.com/nkovacs/streamquote v0.0.0-20170412213628-49af9bddb229/go.mod"
"github.com/pkg/browser v0.0.0-20180916011732-0a3d74bf9ce4"
"github.com/pkg/browser v0.0.0-20180916011732-0a3d74bf9ce4/go.mod"
"github.com/pkg/errors v0.8.0/go.mod"
"github.com/pkg/errors v0.8.1/go.mod"
"github.com/pmezard/go-difflib v1.0.0"
"github.com/pmezard/go-difflib v1.0.0/go.mod"
"github.com/prometheus/client_model v0.0.0-20190812154241-14fe0d1b01d4/go.mod"
"github.com/rogpeppe/go-internal v1.3.0/go.mod"
"github.com/sergi/go-diff v1.0.0"
"github.com/sergi/go-diff v1.0.0/go.mod"
"github.com/spf13/pflag v1.0.3/go.mod"
"github.com/spf13/pflag v1.0.5"
"github.com/spf13/pflag v1.0.5/go.mod"
"github.com/stretchr/objx v0.1.0/go.mod"
"github.com/stretchr/testify v1.2.2/go.mod"
"github.com/stretchr/testify v1.3.0/go.mod"
"github.com/stretchr/testify v1.4.0"
"github.com/stretchr/testify v1.4.0/go.mod"
"github.com/ugorji/go v1.1.7"
"github.com/ugorji/go v1.1.7/go.mod"
"github.com/ugorji/go/codec v1.1.7"
"github.com/ugorji/go/codec v1.1.7/go.mod"
"github.com/valyala/bytebufferpool v1.0.0/go.mod"
"github.com/valyala/fasttemplate v1.0.1/go.mod"
"go.coder.com/cli v0.4.0"
"go.coder.com/cli v0.4.0/go.mod"
"go.coder.com/flog v0.0.0-20200908145530-d7adc3802a47"
"go.coder.com/flog v0.0.0-20200908145530-d7adc3802a47/go.mod"
"go.opencensus.io v0.21.0/go.mod"
"go.opencensus.io v0.22.0/go.mod"
"go.opencensus.io v0.22.2"
"go.opencensus.io v0.22.2/go.mod"
"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
"golang.org/x/crypto v0.0.0-20190510104115-cbcb75029529/go.mod"
"golang.org/x/crypto v0.0.0-20190605123033-f99c8df09eb5/go.mod"
"golang.org/x/crypto v0.0.0-20191206172530-e9b2fee46413"
"golang.org/x/crypto v0.0.0-20191206172530-e9b2fee46413/go.mod"
"golang.org/x/exp v0.0.0-20190121172915-509febef88a4/go.mod"
"golang.org/x/exp v0.0.0-20190306152737-a1d7652674e8/go.mod"
"golang.org/x/exp v0.0.0-20190510132918-efd6b22b2522/go.mod"
"golang.org/x/exp v0.0.0-20190829153037-c13cbed26979/go.mod"
"golang.org/x/exp v0.0.0-20191030013958-a1ab85dbe136/go.mod"
"golang.org/x/image v0.0.0-20190227222117-0694c2d4d067/go.mod"
"golang.org/x/image v0.0.0-20190802002840-cff245a6509b/go.mod"
"golang.org/x/lint v0.0.0-20181026193005-c67002cb31c3/go.mod"
"golang.org/x/lint v0.0.0-20190227174305-5b3e6a55c961/go.mod"
"golang.org/x/lint v0.0.0-20190301231843-5614ed5bae6f/go.mod"
"golang.org/x/lint v0.0.0-20190313153728-d0100b6bd8b3/go.mod"
"golang.org/x/lint v0.0.0-20190409202823-959b441ac422/go.mod"
"golang.org/x/lint v0.0.0-20190909230951-414d861bb4ac/go.mod"
"golang.org/x/lint v0.0.0-20190930215403-16217165b5de/go.mod"
"golang.org/x/mobile v0.0.0-20190312151609-d3739f865fa6/go.mod"
"golang.org/x/mobile v0.0.0-20190719004257-d2bd2a29d028/go.mod"
"golang.org/x/mod v0.0.0-20190513183733-4bf6d317e70e/go.mod"
"golang.org/x/mod v0.1.0/go.mod"
"golang.org/x/net v0.0.0-20180724234803-3673e40ba225/go.mod"
"golang.org/x/net v0.0.0-20180826012351-8a410e7b638d/go.mod"
"golang.org/x/net v0.0.0-20190108225652-1e06a53dbb7e/go.mod"
"golang.org/x/net v0.0.0-20190213061140-3a22650c66bd/go.mod"
"golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod"
"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
"golang.org/x/net v0.0.0-20190501004415-9ce7a6920f09/go.mod"
"golang.org/x/net v0.0.0-20190503192946-f4e77d36d62c/go.mod"
"golang.org/x/net v0.0.0-20190603091049-60506f45cf65/go.mod"
"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
"golang.org/x/net v0.0.0-20191209160850-c0dbc17a3553"
"golang.org/x/net v0.0.0-20191209160850-c0dbc17a3553/go.mod"
"golang.org/x/oauth2 v0.0.0-20180821212333-d2e6202438be/go.mod"
"golang.org/x/oauth2 v0.0.0-20190226205417-e64efc72b421/go.mod"
"golang.org/x/oauth2 v0.0.0-20190604053449-0f29369cfe45/go.mod"
"golang.org/x/sync v0.0.0-20180314180146-1d60e4601c6f/go.mod"
"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f/go.mod"
"golang.org/x/sync v0.0.0-20181221193216-37e7f081c4d4/go.mod"
"golang.org/x/sync v0.0.0-20190227155943-e225da77a7e6/go.mod"
"golang.org/x/sync v0.0.0-20190423024810-112230192c58"
"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
"golang.org/x/sys v0.0.0-20180830151530-49385e6e1522/go.mod"
"golang.org/x/sys v0.0.0-20181128092732-4ed8d59d0b35/go.mod"
"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
"golang.org/x/sys v0.0.0-20190222072716-a9d3bda3a223/go.mod"
"golang.org/x/sys v0.0.0-20190312061237-fead79001313/go.mod"
"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
"golang.org/x/sys v0.0.0-20190502145724-3ef323f4f1fd/go.mod"
"golang.org/x/sys v0.0.0-20190507160741-ecd444e8653b/go.mod"
"golang.org/x/sys v0.0.0-20190606165138-5da285871e9c/go.mod"
"golang.org/x/sys v0.0.0-20190624142023-c5567b49c5d0/go.mod"
"golang.org/x/sys v0.0.0-20191026070338-33540a1f6037/go.mod"
"golang.org/x/sys v0.0.0-20191210023423-ac6580df4449/go.mod"
"golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod"
"golang.org/x/sys v0.0.0-20200223170610-d5e6a3e2c0ae"
"golang.org/x/sys v0.0.0-20200223170610-d5e6a3e2c0ae/go.mod"
"golang.org/x/text v0.3.0/go.mod"
"golang.org/x/text v0.3.1-0.20180807135948-17ff2d5776d2/go.mod"
"golang.org/x/text v0.3.2"
"golang.org/x/text v0.3.2/go.mod"
"golang.org/x/time v0.0.0-20181108054448-85acf8d2951c/go.mod"
"golang.org/x/time v0.0.0-20190308202827-9d24e82272b4/go.mod"
"golang.org/x/time v0.0.0-20191024005414-555d28b269f0/go.mod"
"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
"golang.org/x/tools v0.0.0-20190114222345-bf090417da8b/go.mod"
"golang.org/x/tools v0.0.0-20190226205152-f727befe758c/go.mod"
"golang.org/x/tools v0.0.0-20190311212946-11955173bddd/go.mod"
"golang.org/x/tools v0.0.0-20190312151545-0bb0c0a6e846/go.mod"
"golang.org/x/tools v0.0.0-20190312170243-e65039ee4138/go.mod"
"golang.org/x/tools v0.0.0-20190425150028-36563e24a262/go.mod"
"golang.org/x/tools v0.0.0-20190506145303-2d16b83fe98c/go.mod"
"golang.org/x/tools v0.0.0-20190524140312-2c0ae7006135/go.mod"
"golang.org/x/tools v0.0.0-20190606124116-d0a3d012864b/go.mod"
"golang.org/x/tools v0.0.0-20190621195816-6e04913cbbac/go.mod"
"golang.org/x/tools v0.0.0-20190628153133-6cdbf07be9d0/go.mod"
"golang.org/x/tools v0.0.0-20190816200558-6889da9d5479/go.mod"
"golang.org/x/tools v0.0.0-20190911174233-4f2ddba30aff/go.mod"
"golang.org/x/tools v0.0.0-20191012152004-8de300cfc20a/go.mod"
"golang.org/x/tools v0.0.0-20191115202509-3a792d9c32b2/go.mod"
"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1"
"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1/go.mod"
"google.golang.org/api v0.4.0/go.mod"
"google.golang.org/api v0.7.0/go.mod"
"google.golang.org/api v0.8.0/go.mod"
"google.golang.org/api v0.9.0/go.mod"
"google.golang.org/api v0.14.0/go.mod"
"google.golang.org/appengine v1.1.0/go.mod"
"google.golang.org/appengine v1.4.0/go.mod"
"google.golang.org/appengine v1.5.0/go.mod"
"google.golang.org/appengine v1.6.1/go.mod"
"google.golang.org/genproto v0.0.0-20180817151627-c66870c02cf8/go.mod"
"google.golang.org/genproto v0.0.0-20190307195333-5fe7a883aa19/go.mod"
"google.golang.org/genproto v0.0.0-20190418145605-e7d98fc518a7/go.mod"
"google.golang.org/genproto v0.0.0-20190425155659-357c62f0e4bb/go.mod"
"google.golang.org/genproto v0.0.0-20190502173448-54afdca5d873/go.mod"
"google.golang.org/genproto v0.0.0-20190801165951-fa694d86fc64/go.mod"
"google.golang.org/genproto v0.0.0-20190819201941-24fa4b261c55/go.mod"
"google.golang.org/genproto v0.0.0-20190911173649-1774047e7e51/go.mod"
"google.golang.org/genproto v0.0.0-20191115194625-c23dd37a84c9/go.mod"
"google.golang.org/genproto v0.0.0-20191216164720-4f79533eabd1"
"google.golang.org/genproto v0.0.0-20191216164720-4f79533eabd1/go.mod"
"google.golang.org/grpc v1.19.0/go.mod"
"google.golang.org/grpc v1.20.1/go.mod"
"google.golang.org/grpc v1.21.1/go.mod"
"google.golang.org/grpc v1.23.0/go.mod"
"google.golang.org/grpc v1.25.1"
"google.golang.org/grpc v1.25.1/go.mod"
"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127"
"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
"gopkg.in/errgo.v2 v2.1.0/go.mod"
"gopkg.in/yaml.v2 v2.2.2/go.mod"
"gopkg.in/yaml.v2 v2.2.8"
"gopkg.in/yaml.v2 v2.2.8/go.mod"
"honnef.co/go/tools v0.0.0-20190102054323-c2f93a96b099/go.mod"
"honnef.co/go/tools v0.0.0-20190106161140-3f1c8253044a/go.mod"
"honnef.co/go/tools v0.0.0-20190418001031-e561f6794a2a/go.mod"
"honnef.co/go/tools v0.0.0-20190523083050-ea95bdfd59fc/go.mod"
"honnef.co/go/tools v0.0.1-2019.2.3/go.mod"
"nhooyr.io/websocket v1.8.6"
"nhooyr.io/websocket v1.8.6/go.mod"
"rsc.io/binaryregexp v0.2.0/go.mod"
)

go-module_set_globals

DESCRIPTION="The agent for Coder Cloud"
HOMEPAGE="https://github.com/cdr/cloud-agent"
SRC_URI="${EGO_SUM_SRC_URI}
	https://github.com/cdr/cloud-agent/archive/refs/tags/v0.2.3.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND=(
	dev-lang/go
)

src_compile() {
	go build -o coder-cloud-agent  main.go || die
}

src_install() {
	dobin coder-cloud-agent
}
