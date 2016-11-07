SUPORTED_BOARDS := pi3
UBUNTU_IMAGE=/snap/bin/ubuntu-image
SNAPPY_PI3-IMAGE := $(shell i="0"; while ls pi3-ondra-`date +%Y%m%d`-$${i}.img* 1> /dev/null 2>&1; do i=$$((i+1)); done; echo "pi3-ondra-`date +%Y%m%d`-$${i}.img")
UBUNTU_CORE_PI3-CH := beta
PI3-GADGET_VERSION := `grep version pi3/meta/snap.yaml | awk '{print $$2}'`
PI3-GADGET_MODEL := pi3-ondra.model
PI3-GADGET_SNAP := pi3-ondra_$(PI3-GADGET_VERSION)_armhf.snap

all: $(SUPORTED_BOARDS)

build-pi3-gadget:
	snapcraft snap pi3

clean-pi3-gadget:
	rm -rf pi3-*_armhf.snap

pi3-distclean:
	rm -rf pi3-*

build-pi3-image: build-pi3-gadget
	@echo "build snappy image for pi3 ..."
	$(UBUNTU_IMAGE) \
		-c $(UBUNTU_CORE_PI3-CH) \
		--image-size 4G \
		--extra-snaps $(PI3-GADGET_SNAP) \
		--extra-snaps pi2-kernel \
		--extra-snaps snapweb \
		--extra-snaps openhab \
		-o $(SNAPPY_PI3-IMAGE) \
		$(PI3-GADGET_MODEL)
	@echo "Image build, compressing it...."
	pxz -9 $(SNAPPY_PI3-IMAGE)

clean-pi3-image:
	@echo "Cleaning old images"
	rm pi3-*.img*

pi3-gadget: build-pi3-gadget

pi3: build-pi3-image

.PHONY: all build clean distclean build-pi3-image build-pi3-gadget
