sharepath = $(DESTDIR)/usr/share
fishpath = $(sharepath)/fish
fisherpath = $(sharepath)/fisherman
manpath = $(sharepath)/man

.PHONY: all
all:

.PHONY: install
install:
	# prepare directories because install -Dt won't do it on the CI server
	mkdir -p "$(fisherpath)/completions" "$(fisherpath)/functions"
	# the main config, which can be sourced by the user
	install -Dm 644 config-fisherman.fish "$(fishpath)/config-fisherman.fish"
	install -Dm 644 config.fish "$(fisherpath)/config.fish"
	install -Dm 644 config-fisherman.fish "$(fishpath)/config-fisherman.fish"
	# completions
	install -Dt "$(fisherpath)/completions" completions/*
	# functions
	install -Dt "$(fisherpath)/functions" functions/*
	# man pages, README and LICENSE
	install -Dt "$(manpath)/man1" man/man1/*

.PHONY: clean
clean:
