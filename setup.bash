#!/bin/sh
set -e
shopt -s nullglob
shopt -s dotglob # To include hidden files

SCRIPT_PATH="/Users/Albin/sideprojects/rails-setup"
INSTALL_PATH="/Users/Albin/sideprojects/tmp"
APP_NAME=$1

cd $INSTALL_PATH
rails new $APP_NAME
cd $APP_NAME
rm Gemfile
cp $SCRIPT_PATH"/files/Gemfile" .
bundle install --without production
git init
git ignore tmp/**.*
git ignore log/**.*

cat $SCRIPT_PATH"/files/config/db_config" > config/database.yml
sed -i '' -- "s/APP_NAME/$APP_NAME/g" config/database.yml
DB_PWD=`bash $SCRIPT_PATH/scripts/genpasswd.bash`
sed -i '' -- "s/DATABASE_PWD/$DB_PWD/g" config/database.yml

rails generate bootstrap:install --no-coffeescript
rails generate simple_form:install --bootstrap

SCAFFOLD_PATH=$SCRIPT_PATH"/files/scaffolding/html/*.*"
cp $SCAFFOLD_PATH "lib/templates/erb/scaffold/."

rails g scaffold user email:string crypted_password:string password_salt:string persistence_token:string --no-helper --no-assets --no-controller-specs --no-view-specs

rm -r "app/controllers"
mkdir app/controllers
CONTROLLERS_PATH=$SCRIPT_PATH"/files/controllers/*.*"
cp $CONTROLLERS_PATH "app/controllers/."

CONTROLLERS_PATH=$SCRIPT_PATH"/files/models/*.*"
rm -r "app/models"
mkdir app/models
cp $CONTROLLERS_PATH "app/models/."

rm -r "app/views"
VIEWS_PATH=$SCRIPT_PATH"/files/views"
cp -r $VIEWS_PATH "app/"

