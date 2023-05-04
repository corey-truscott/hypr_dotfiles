if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep Hyprland || Hyprland
fi
