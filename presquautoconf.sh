#!/bin/bash

ROMS_DIR='/recalbox/share/roms'

[ ! -d "$ROMS_DIR" ] && echo "Erreur: mauvais ROM_DIR" && exit 1


function_exists(){
	name="$1"
	type "$1" 2>/dev/null | grep -q "$1 is a function" && return 0
	return 1
}

##
# @param string dir
# @param string checks
##
check_bios(){
	dir="$ROMS_DIR"/"$1"
	[ ! -d "$dir" ] && echo "Missing dir $dir"
	missings=0
	checks="$2"
	for check in $checks; do
		[ ! -f "$dir"/"$check".zip ] && [ ! -f "$dir"/"$check".ZIP ] && echo "Missing [$1].bios: $check.ZIP" && missings=$(($missings + 1))
	done
	[ $missings -gt 0 ] && echo && echo "Missing $missings [$1].bios files..." && echo && return 1
	return 0
}

# check_mame(){
#	check_bios "mame" "acpsx cpzn1 cpzn2 cvs decocass konamigx megaplay megatech neogeo nss pgm playch10 skns stvbios taitofx1 tps"
# }
check_fba_libretro(){
	check_bios "fba_libretro" "neogeo pgm"
}

check(){
	dir="$ROMS_DIR"/"$1"
	
	[ ! -d "$dir"  ] && echo "Error: Missing Folder $dir" && return
	ls "$dir"/*.zip 2>/dev/null >/dev/null || return 1

	fun="check_$1"
	function_exists "$fun"
	exists=$?
	if [ "$exists" -eq 0 ]; then
		eval "$fun" && return 0 || return 1
	fi
	return 0
}

rom_dirs="atari2600 gamegear lynx n64 psx snes atari7800 gb mame neogeo vectrex cavestory gba mastersystem nes scummvm virtualboy fba gbc megadrive ngp sega32x wswan fba_libretro gw moonlight pcengine segacd fds lutro msx prboom sg1000"
rom_dirs_ok=""
for rom_dir in $rom_dirs; do
	check "$rom_dir" && rom_dirs_ok="$rom_dirs_ok $rom_dir"
done

display_mame(){
	echo "neogeo.emulator=libretro"
	if [ -f "$ROMS_DIR"/mame/plgirls.zip ]; then
		#imame4all
		echo "neogeo.core=imame4all"
	else
		#mame2003
		echo "neogeo.core=lr-mame2003"
	fi
}
display_fba(){
	echo "neogeo.emulator=fba2x"
	echo ";neogeo.core=fba"
}
display_fba_libretro(){
	echo "neogeo.emulator=libretro"
	echo "neogeo.core=fba"
}

function display_config(){
	romset="$1"
	fun="display_$1"
	function_exists "$fun"
	exists=$?
	if [ "$exists" -eq 0 ]; then
		eval "$fun"
	else
		echo "- $romset"
	fi
}

echo
echo "Les configurations disponibles sont les suivantes :"
for dir in $rom_dirs_ok; do
	echo "- $dir:"
	display_config $dir
done

echo

#grep "^[;?]neogeo.emulator=" /recalbox/share/system/recalbox.conf
