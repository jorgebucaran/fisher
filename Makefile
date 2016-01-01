SHELL:=/bin/bash -O nullglob

XDG_CONFIG_HOME ?= $$HOME/.config
FISH_CONFIG := $(XDG_CONFIG_HOME)/fish/config.fish

FISHER_HOME := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
FISHER_CONFIG := $(XDG_CONFIG_HOME)/fisherman
FISHER_CACHE := $(FISHER_CONFIG)/cache

MAN := $(FISHER_HOME)/man
MAN1 := $(wildcard $(MAN)/man1/*.md)
MAN5 := $(wildcard $(MAN)/man5/*.md)
MAN7 := $(wildcard $(MAN)/man7/*.md)
DOCS := $(MAN1:%.md=%.1) $(MAN5:%.md=%.5) $(MAN7:%.md=%.7)

AUTHORS = $(FISHER_HOME)/AUTHORS.md
VERSION = `cat $(FISHER_HOME)/VERSION`

MSG = printf "\033[47m\033[30m%s\033[0m\n" $(1)
TILDEIFY = sed "s|$$HOME|~|"

.PHONY: all test flush uninstall release

all: $(FISH_CONFIG) $(FISHER_CACHE) $(AUTHORS) $(DOCS)
	@$(call MSG,"Reset your shell to apply changes")

test:
	@fish -c "fishtape test/*.fish"

flush:
	@rm -rf $(FISHER_CONFIG)/*

uninstall:
	@echo "Removing configuration from $(FISH_CONFIG)" | $(TILDEIFY)
	@sed -E '/set (fisher_home|fisher_config) /d;/source \$$fisher_home/d' \
		$(FISH_CONFIG) > $(FISH_CONFIG).tmp
	@mv $(FISH_CONFIG).tmp $(FISH_CONFIG)
	@$(call MSG,"Reset your shell to apply changes")

release: $(FISHER_HOME)
	@if [ "`git -C $^ status --short --porcelain | xargs`" = "M VERSION" ]; then\
		echo "`git -C $^ describe --abbrev=0 2>/dev/null || echo \*` -> $(VERSION)";\
		sed "s/fisherman-v.\..\..-00B9FF/fisherman-v$(VERSION)-00B9FF/" $^/README.md > $^/README.md.swap;\
		mv $^/README.md.swap $^/README.md;\
		git -C $^ add README.md;\
		git -C $^ add $^/VERSION;\
		git -C $^ commit --quiet -m $(VERSION);\
		git -C $^ tag $(VERSION) -m v$(VERSION) --force >/dev/null;\
	else\
		echo "Commit changes and update VERSION to tag a new release.";\
	fi

$(FISH_CONFIG):
	@echo "Adding configuration to $@" | $(TILDEIFY)
	@mkdir -p $(dir $@) && touch $@
	@echo "set fisher_home $(FISHER_HOME)" | sed "s|/$$||;s|$$HOME|~|" > $@.fisher
	@echo "set fisher_config $(FISHER_CONFIG)" | sed "s|$$HOME|~|" >> $@.fisher
	@echo "source \$$fisher_home/config.fish" >> $@.fisher
	@awk '!config[$$0]++' $@.fisher $@ > $@.tmp
	@mv $@.tmp $@ && rm $@.fisher

$(FISHER_CACHE):
	@[ -d $@ ] || echo "Creating $@" | $(TILDEIFY)
	@mkdir -p $@

$(AUTHORS): $(FISHER_HOME)
	@echo "# Authors" > $@
	@git -C $^ shortlog -sne | cut -f2- | \
		sed -E 's/([^<>]+)<([^<>]*)>/* \1 \&lt;[\2](mailto:\2)\&gt;/' >> $@

%.1 %.5 %.7: %.md
	@ronn --manual=fisherman --roff $? 2>&1 | sed 's/^ *roff: *//;s|//|/|g'
