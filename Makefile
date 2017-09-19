REPO=repo
TMP=sdk
ARGS="--user"
ARCH?=$(shell flatpak --default-arch)
BUILDER_OPTIONS = --rebuild-on-sdk-change --require-changes --ccache --force-clean

all: $(REPO)/config $(foreach file, $(wildcard *.json), $(subst .json,.app,$(file)))

%.app: %.json
	flatpak-builder $(BUILDER_OPTIONS) \
		--arch=$(ARCH) \
		--repo=$(REPO) \
		--subject="build of com.deepin.Sdk, `date`" ${EXPORT_ARGS} $(TMP) $<

export:
	flatpak build-update-repo $(REPO) ${EXPORT_ARGS}

$(REPO)/config:
	ostree init --mode=archive-z2 --repo=$(REPO)

remotes:
	flatpak remote-add $(ARGS) flathub --from https://sdk.flathub.org/flathub.flatpakrepo --if-not-exists

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
