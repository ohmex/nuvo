# Use w64devkit on windows to build [https://github.com/skeeto/w64devkit]
PLATFORMVERSION=1.0
SDCCVERSION=13763
TOOLSVERSION=2022

# Default the tool version to be the current date as YYYY.MM.DD
#TOOLSVERSION?=$(shell date '+%Y.%m.%d')

BASEURL=https://github.com/ohmex/nuvo/releases/download/v$(PLATFORMVERSION)

PACKAGEFILE=package_nuvo_c51_index.json

# Version for pre-release testing on my private server at home
TESTPACKAGEFILE=package_test_index.json
TESTBASEURL=http://localhost/nuvo
TESTBASEDIR=C:/xampp/htdocs/nuvo

# Make sure these definitions are visible for the sub-makes
export

.PHONY: core tools sdcc clean upload release


$(TESTPACKAGEFILE): ../$(PACKAGEFILE)
	sed 's#http.*/download/#$(TESTBASEURL)/release/#' $^ > $@

../$(PACKAGEFILE): core tools sdcc
	@echo "Generating the package_index file."
	./assemble.sh $@

core tools sdcc:
	make -f Makefile.$@

clean:
	rm -rf *~ ../*.jsone *.bak *.orig *.rej
	rm -rf release parts/* package_test_index.json
	rm -f ../*.json

# Upload to my private test server, totally useless for anybody else.
upload: $(TESTPACKAGEFILE)
	@echo "uploading to $(TESTBASEDIR)"
	#rsync -av -rsh=ssh --delete release $(TESTPACKAGEFILE) $(TESTBASEDIR)
	cp -R release $(TESTPACKAGEFILE) $(TESTBASEDIR)
	@echo "URL for board manager: $(TESTBASEURL)/$(TESTPACKAGEFILE)"

DATE=$(shell date '+%F')

release:
	# Update the version number in the changelog if not already done:
	grep -q "$(PLATFORMVERSION)" ../CHANGELOG.md || \
	sed -i "/^## \[Unreleased\]/ a\\\n\n## [$(PLATFORMVERSION) - $(DATE)]" ../CHANGELOG.md
	git add ../CHANGELOG.md ../$(PACKAGEFILE)
	git add parts/tools-*-$(SDCCVERSION).txt parts/tools-*-$(TOOLSVERSION).txt parts/platform-*-$(PLATFORMVERSION).txt
	git commit
	git tag v$(PLATFORMVERSION)
