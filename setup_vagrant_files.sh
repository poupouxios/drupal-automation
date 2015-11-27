#!/bin/bash

CURRENT_DIR=/home/vagrant/source
core_structure_folder=$CURRENT_DIR/core_structure

if [ -d "$core_structure_folder" ]; then
	vagrant_folder=$CURRENT_DIR/public/vagrant
	external_current_folder=$CURRENT_DIR/public/current

	items_to_symlink=( core vendor  includes misc modules profiles scripts themes authorize.php cron.php index.php update.php web.config xmlrpc.php install.php )

	if [ ! -h "$vagrant_folder/sites" ]; then
		echo "Symlinking $external_current_folder/sites to $vagrant_folder/sites"
		ln -s $external_current_folder/sites $vagrant_folder/sites
	fi

	for item in ${items_to_symlink[@]}; do
		if [ ! -f "$vagrant_folder/$item" ] && [ ! -h "$vagrant_folder/$item" ] && ([ -f "$core_structure_folder/$item" ] || [ -d "$core_structure_folder/$item" ]);  then
			ln -s $core_structure_folder/$item $vagrant_folder/$item
		fi
	done

	if [ ! -f "$vagrant_folder/.htaccess" ]; then
		echo "Symlinking .htaccess file.."
		ln -s $core_structure_folder/.htaccess $vagrant_folder/.htaccess
	fi
else
	echo "Core structure folder doesnt exist. Script terminating.."
	exit
fi
