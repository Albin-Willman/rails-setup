#!/bin/sh
set -e
shopt -s nullglob
shopt -s dotglob # To include hidden files

SCRIPT_PATH="/Users/Albin/sideprojects/rails-setup"
INSTALL_PATH=${2-.}
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

rake db:create
rake db:migrate

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

cat $SCRIPT_PATH"/files/assets/js/application.js" > app/assets/javascripts/application.js

cat $SCRIPT_PATH"/files/assets/css/application.css" > app/assets/stylesheets/application.css
STYLE_PATTERN=$SCRIPT_PATH"/files/assets/less/*.less"
cp $STYLE_PATTERN app/assets/stylesheets/.

echo "@import \"import\";" >> app/assets/stylesheets/bootstrap_and_overrides.css.less

INITIALIZERS_PATH=$SCRIPT_PATH"/files/config/initializers"
cp -r $INITIALIZERS_PATH config/.
sed -i '' -- "s/USER_NAME/\"$USER\"/g" config/initializers/constants.rb
