function __fisher_purge
  set -l FISH_CONFIG "$~/.config/fish/config.fish"
  sed -E '/set ($fisher_home|$fisher_config) /d;/source \$$fisher_home/d' \
	$FISH_CONFIG > $FISH_CONFIG.tmp
	mv $FISH_CONFIG.tmp $FISH_CONFIG
	echo "Reload your shell to apply changes."
end
