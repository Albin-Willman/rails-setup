#!/bin/sh
set -e
shopt -s nullglob
shopt -s dotglob # To include hidden files

SCRIPT_PATH="/Users/Albin/sideprojects/rails-setup"
INSTALL_PATH="/Users/Albin/sideprojects/tmp"
APP_NAME = $1

cd $INSTALL_PATH
rails new $APP_NAME
cd $APP_NAME
rm Gemfile
cp $SCRIPT_PATH"/files/Gemfile" .
bundle install
git ignore tmp/**.*

rails generate bootstrap:install --no-coffeescript
rails generate simple_form:install --bootstrap
cp $SCRIPT_PATH"/files/scaffolding/*.html.erb" "lib/templates/erb/scaffold."

rails g scaffold user email:string crypted_password:string password_salt:string persistence_token:string --no-helper --no-assets --no-controller-specs --no-view-specs

rm "app/controllers/*.rb"
rm "app/models/*.rb"
rm -r "app/views"
mkdir app/views

cp $SCRIPT_PATH"/files/controllers/*" "app/controllers/."
cp $SCRIPT_PATH"/files/models/*" "app/controllers/."
cp -r $SCRIPT_PATH"/files/views/*" "app/controllers/."

