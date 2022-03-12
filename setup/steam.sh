steam_download() {
	[ -d "$STEAM_CMD_DIR" ] || mkdir -p "$STEAM_CMD_DIR"

	wget "$STEAM_CMD_URL" -P "$STEAM_CMD_DIR" || {
		v "failed to donwload $STEAM_CMD_IMAGE"
		exit 1
	}
}

steam_install() {
	tar -xvzf "${STEAM_CMD_DIR}/${STEAM_CMD_IMAGE}" -C $STEAM_CMD_DIR
}

steam_setup() {
	steam_download
	steam_install
}
