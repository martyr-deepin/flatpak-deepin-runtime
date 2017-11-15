REPO=repo
TMP=sdk
ARGS="--user"
ARCH?=$(shell flatpak --default-arch)
BUILDER_OPTIONS = --rebuild-on-sdk-change --require-changes --ccache --force-clean

all: cleanjson $(REPO)/config $(foreach file, $(wildcard *.yaml), $(subst .yaml,.app,$(file)))

%.app: com.deepin.Sdk.json
	flatpak-builder $(BUILDER_OPTIONS) $${OPTS}\
		--arch=$(ARCH) \
		--repo=$(REPO) \
		--subject="build of com.deepin.Sdk, `date`" ${EXPORT_ARGS} $(TMP) $<

com.deepin.Sdk.json:
	python json2yaml.py com.deepin.Sdk.yaml > com.deepin.Sdk.json
	sed -i 's/BUILDVERGETTEXT/master/g' com.deepin.Sdk.json
	sed -i 's/BUILDVERCORE/master/g' com.deepin.Sdk.json
	sed -i 's/BUILDVERWIDGET/master/g' com.deepin.Sdk.json
	sed -i 's/BUILDVERWM/master/g' com.deepin.Sdk.json
	sed -i 's/BUILDVERQT5INTE/master/g' com.deepin.Sdk.json
	sed -i 's/BUILDVERQT5DXCB/master/g' com.deepin.Sdk.json

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

cleanjson:
	rm com.deepin.Sdk.json

clean:
	echo "clean finish"
	#rm -rf $(TMP) .flatpak-builder
