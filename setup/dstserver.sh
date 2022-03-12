TERMINAL_UTIL="screen"
DSTSERVER_BIN="dontstarve_dedicated_server_nullrenderer"

dstserver_update() {
	cd $STEAM_CMD_DIR
	./steamcmd.sh << EOF
login anonymous
force_install_dir $DSTSERVER_DIR
app_update 343050 validate
quit
EOF
}

dstserver_shutdown() {
	[ "$TERMINAL_UTIL" = "screen" ] && {
		local socks="$(screen -ls | grep -Po "[0-9]+\.[a-z A-Z]+")"
		local pid session
		for sock in $socks; do
			# the pid of this session
			pid="$(echo $sock | grep -Po "[0-9]+")"
			# the name of this session
			session="$(echo $sock | grep -Po "[a-z A-Z]+")"

			# NOTE: if the shard server is running on this session,
			# shut it down.
			pstree -p $pid | grep $DSTSERVER_BIN && {
				screen -S $session -X stuff 'c_shutdown()\015'
			}
		done
	}
}

dstserver_create_script() {
	local bin="./${DSTSERVER_BIN}"
	local shard=$1
	local script="${DSTSERVER_DIR}/bin/$2"
	local psdir="$(dirname $DSTWORLDS_DIR)"
	local confdir="$(basename $DSTWORLDS_DIR)"
	local options

	unset options
	append options "-console"
	append options "-persistent_storage_root $psdir"
	append options "-conf_dir $confdir"
	append options "-cluster $CLUSTER"
	append options "-shard $shard"

	echo "$bin $options" > $script
	chmod +x $script
}

dstserver_setup() {
	dstserver_update
	# TODO: link some librarys to $DSTSERVER_DIR
	dstserver_create_script "Master" "master.sh"
	dstserver_create_script "Caves" "caves.sh"
}
