#!/bin/bash

CURRENT_DIR=/home/vagrant/source
core_structure_folder=$CURRENT_DIR/core_structure

if [ -d "core_structure_folder"]; then
	vagrant_folder=$CURRENT_DIR/public/vagrant
	external_current_folder=$CURRENT_DIR/public/current

	items_to_symlink=( sites/default includes misc modules profiles scripts themes authorize.php cron.php index.php update.php web.config xmlrpc.php install.php )

	if [ ! -d "$vagrant_folder/sites" ]; then
		echo "Creating $vagrant_folder/sites folder.."
		mkdir $vagrant_folder/sites
	fi

	if [ ! -h "$vagrant_folder/sites/all" ]; then
		echo "Symlinking $external_current_folder/sites/all to $vagrant_folder/sites/all"
		ln -s $external_current_folder/sites/all $vagrant_folder/sites/all
	fi

	for item in ${items_to_symlink[@]}; do
		if [ ! -f "$vagrant_folder/$item" ] && [ ! -d "$vagrant_folder/$item" ]; then
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
