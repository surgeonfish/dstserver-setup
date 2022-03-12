MODOVERRIDES="${CLUSTER_DIR}/Master/modoverrides.lua"
MODSETUP="${DSTSERVER_DIR}/mods/dedicated_server_mods_setup.lua"

mods_get_from_cluster() {
	local __mods

	__mods=$(cat $MODOVERRIDES | grep -Po 'workshop-\K[0-9]+')
	[ -z "__mods" ] && {
		unset "$1"
		return 1
	}

	export "$1=$__mods"
	return 0
}

mods_get_from_dstserver() {
	local __mods

	[ -e $MODSETUP ] || {
		touch $MODSETUP
		unset "$1"
		return 1
	}

	__mods=$(cat $MODSETUP | grep -Po '^ServerModSetup\(\"\K[0-9]+')
	[ -z "__mods" ] && {
		unset "$1"
		return 1
	}

	export "$1=$__mods"
	return 0
}

mods_add() {
	local __mod = $1
	v "adding mod:${__mod}"
	echo "ServerModSetup(\"${__mod}\")" >> $MODSETUP
}

mods_del() {
	local __mod = $1
	v "removing mod:$__mod"
	sed -i "s/ServerModSetup(\"${__mod}\")" $MODSETUP
}

mods_setup() {
	local mods smods found

	mods_get_from_cluster mods
	mods_get_from_dstserver smods

	for mod in $mods; do
		found=0
		for smod in $smods; do
			[ "$mod" == "$smod" ] && found=1
		done

		if [ $found -eq 0 ]; then
			mods_del $mod
		else
			mods_add $mod
		fi
	done
}
