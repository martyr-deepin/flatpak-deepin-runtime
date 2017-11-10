REPO=repo
TMP=sdk
ARGS="--user"
ARCH?=$(shell flatpak --default-arch)
BUILDER_OPTIONS = --rebuild-on-sdk-change --require-changes --ccache --force-clean

all: settex $(REPO)/config $(foreach file, $(wildcard *.json), $(subst .json,.app,$(file)))

%.app: %.json
	flatpak-builder $(BUILDER_OPTIONS) \
		--arch=$(ARCH) \
		--repo=$(REPO) \
		--subject="build of com.deepin.Sdk, `date`" ${EXPORT_ARGS} $(TMP) $<

settex:
	set -i 's/BUILDVERGETTEXT/master/g' com.deepin.Sdk.json
	set -i 's/BUILDVERCORE/master/g' com.deepin.Sdk.json
	set -i 's/BUILDVERWIDGET/master/g' com.deepin.Sdk.json
	set -i 's/BUILDVERWM/master/g' com.deepin.Sdk.json
	set -i 's/BUILDVERQT5INTE/master/g' com.deepin.Sdk.json
	set -i 's/BUILDVERQT5DXCB/master/g' com.deepin.Sdk.json
export:
	flatpak build-update-repo $(REPO) ${EXPORT_ARGS}

$(REPO)/config:
	ostree init --mode=archive-z2 --repo=$(REPO)

remotes:
	flatpak remote-add $(ARGS) flathub  https://flathub.org/repo --if-not-exists --no-gpg-verify

deps:
	flatpak install --arch=$(ARCH) $(ARGS) flathub org.freedesktop.Platform.Locale 1.6; true
	flatpak install --arch=$(ARCH) $(ARGS) flathub org.freedesktop.Sdk.Locale 1.6; true
	flatpak install --arch=$(ARCH) $(ARGS) flathub org.freedesktop.Platform 1.6; true
	flatpak install --arch=$(ARCH) $(ARGS) flathub org.freedesktop.Sdk 1.6; true
	flatpak install --arch=$(ARCH) $(ARGS) flathub org.freedesktop.Sdk.Debug 1.6; true

check:
	json-glib-validate *.json

clean:
	echo "clean finish"
	#rm -rf $(TMP) .flatpak-builder
