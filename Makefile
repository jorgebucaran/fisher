SHELL:=/bin/bash -O nullglob

XDG_CONFIG_HOME ?= $$HOME/.config
FISH_CONFIG := $(XDG_CONFIG_HOME)/fish/config.fish

FISHER_HOME := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
FISHER_CONFIG := $(XDG_CONFIG_HOME)/fisherman
FISHER_CACHE := $(FISHER_CONFIG)/cache
FISHER_FILE := $(FISHER_CONFIG)/fishfile

MAN := $(FISHER_HOME)/man
MAN1 := $(wildcard $(MAN)/man1/*.md)
MAN5 := $(wildcard $(MAN)/man5/*.md)
MAN7 := $(wildcard $(MAN)/man7/*.md)
DOCS := $(MAN1:%.md=%.1) $(MAN5:%.md=%.5) $(MAN7:%.md=%.7)

INDEX := $(FISHER_CACHE)/.index
VERSION = `cat $(FISHER_HOME)/VERSION`

.PHONY: all test flush uninstall release

all: $(FISH_CONFIG) $(FISHER_CACHE) $(FISHER_FILE) $(DOCS)
	@echo "** Reload your shell and type 'fisher' to get started **"

test:
	fish -c "fishtape test/*.fish"

uninstall:
	sed -E '/set (fisher_home|fisher_config) /d;/source \$$fisher_home/d' \
		$(FISH_CONFIG) > $(FISH_CONFIG).tmp
	mv $(FISH_CONFIG).tmp $(FISH_CONFIG)
	$(call MSG,"Reload your shell to apply changes.")

release: $(FISHER_HOME)
	if [ "`git -C $^ status --short --porcelain | xargs`" = "M VERSION" ]; then\
		echo "`git -C $^ describe --abbrev=0 2>/dev/null || echo \*` -> $(VERSION)";\
		sed "s/latest-v.\..\..-00B9FF/latest-v$(VERSION)-00B9FF/" $^/README.md > $^/README.md.swap;\
		mv $^/README.md.swap $^/README.md;\
		git -C $^ add README.md;\
		git -C $^ add $^/VERSION;\
		git -C $^ commit --quiet -m $(VERSION);\
		git -C $^ tag $(VERSION) -m v$(VERSION) --force > /dev/null;\
	else\
		echo "Commit changes and update VERSION to tag a new release.";\
	fi

$(FISH_CONFIG):
	mkdir -p $(dir $@) && touch $@
	echo "set fisher_home $(FISHER_HOME)" | sed "s|/$$||;s|$$HOME|~|" > $@.fisher
	echo "set fisher_config $(FISHER_CONFIG)" | sed "s|$$HOME|~|" >> $@.fisher
	echo "source \$$fisher_home/config.fish" >> $@.fisher
	awk 'FNR==NR{ print; a[$$0]; next } !($$0 in a) || /^$$/' $@ $@.fisher > $@.tmp
	mv $@.tmp $@ && rm $@.fisher

$(FISHER_CACHE):
	mkdir -p $@

$(FISHER_FILE):
	touch $@

%.1 %.5 %.7: %.md
	-@if type ronn 2>/dev/null 1>&2; then \
		ronn --manual=fisherman --roff $? 1>&2 2> /dev/null;\
	fi;\
