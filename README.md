## Drupal-automation

Drupal automation is an automatic way to fetch Drupal 7 or 8 from GitHub and setup a local Drupal version on your pc to play around. It initializes all the necessary files and folders to run along with [Vagrant](https://www.vagrantup.com/) and [Ansible](http://www.ansible.com/) that are not listed here.

## Motivation

In my free time, I develop web apps by using Drupal and I tend to use Vagrant and Ansible to setup everytime a new project. However, every time I have to download manually the Drupal core code, place it in a folder, setup the necessary vagrant and ansible files and then have a project ready to start.

So I created these small bash scripts that download from Drupal github repo the latest Drupal 7 or 8 code and setup all the necessary files to have a project ready to play in less than 5 minutes.

The end goal of this project is to use this as a submodule on each of my projects and update it every time with any new changes or new features.

## Installation

An example of this repo in use can be found in my (Drupal Vagrant repo)[https://github.com/poupouxios/drupal-vagrant]. By its own it doesn't do too much. It needs to be set as a submodule in a Drupal project.

This project is tested on Ubuntu 14.04 and up. The necessary command that need to exist is only [git](sudo apt-get install git).
