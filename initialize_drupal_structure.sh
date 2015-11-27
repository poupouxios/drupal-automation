#!/bin/bash

CURRENT_DIR=$PWD
core_structure_folder=$CURRENT_DIR/core_structure
public_folder=$CURRENT_DIR/public
current_folder=$public_folder/current
internet_available=false
drupal_version=7

echo "Checking if internet is available..."
wget -q --spider http://google.com

if [ $? -eq 0 ]; then
  internet_available=true
else
	echo "You are not connected to the internet. The process will continue assuming you've already ran this script before and the structure is in place" 
fi

if [ ! -d "$public_folder" ]; then
	echo "Creating public folder.."
  mkdir $public_folder
fi

if [ ! -d "$CURRENT_DIR/db" ]; then
	echo "Creating db folder.."
  mkdir $CURRENT_DIR/db
fi


items_to_symlink=( core vendor includes misc modules profiles scripts themes authorize.php cron.php index.php update.php web.config xmlrpc.php install.php )

if [ ! -d "$core_structure_folder" ] && $internet_available ; then
	while true; do
		  read -p "Which version of Drupal you want to install? (7 or 8): " drupal_version
			case $drupal_version in
		      7* ) break;;
		      8* ) drupal_version=8.0; break;;
		      * ) echo "Please enter 7 or 8.";;
		  esac
	done
	mkdir $core_structure_folder
	cd $core_structure_folder
	shopt -s dotglob
	git clone -b $drupal_version.x https://github.com/drupal/drupal.git
	mv drupal/* ./
	shopt -u dotglob
	rm -rf drupal
	cd ..
elif $internet_available ; then
	if [ -d "$core_structure_folder/core" ]; then
		drupal_version=8.0;
	fi
	echo "Checking for new updates in drupal core.."
	cd $core_structure_folder
	git pull origin $drupal_version.x
fi

if [ -d "$core_structure_folder" ]; then
	if [ ! -d "$public_folder/vagrant" ]; then
		echo "Creating public/vagrant folder.."
		mkdir $public_folder/vagrant
	fi

	if [ ! -d "$public_folder/current" ]; then
		echo "Creating public/current folder.."
		mkdir $public_folder/current
	fi

	if [ ! -d "$current_folder/sites" ]; then
		echo "Creating public/current/sites folder.."
		mkdir $current_folder/sites
	fi

	if [ ! -d "$current_folder/sites/default" ]; then
		echo "Creating $current_folder/sites/default folder.."
    cp -r $core_structure_folder/sites/* $current_folder/sites
    chmod 755 $current_folder/sites/default
	fi

	if [ ! -d "$current_folder/sites/all" ] && [ "$drupal_version" == "7" ]; then
		echo "Creating public/current/sites/all folder.."
		mkdir $current_folder/sites/all
	fi

	for item in ${items_to_symlink[@]}; do
		if [ ! -f "$current_folder/$item" ] && [ ! -h "$current_folder/$item" ]  && ([ -f "$core_structure_folder/$item" ] || [ -d "$core_structure_folder/$item" ]); then
			echo "symlinking $core_structure_folder/$item to $current_folder/$item"
			ln -s $core_structure_folder/$item $current_folder/$item
		fi
	done

	if [ ! -d "$current_folder/sites/default/files" ]; then
		echo "Creating public/current/sites/default/files folder.."
		mkdir $current_folder/sites/default/files
	fi

	echo "Making writable the sites/default/files folder.."
	chmod 777 $current_folder/sites/default/files

	if [ ! -f "$current_folder/sites/default/settings.php" ]; then
		echo "Creating public/current/sites/default/settings.php file.."
		cp $current_folder/sites/default/default.settings.php $current_folder/sites/default/settings.php 
	fi
else
	echo "You didn't run before the script and the drupal core files don't exist. Script terminating.."
	exit
fi
