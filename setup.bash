#!/bin/sh
set -e
shopt -s nullglob
shopt -s dotglob # To include hidden files

APP_NAME=$1
INSTALL_PATH=${2-.}
SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd $INSTALL_PATH
rails new $APP_NAME --skip-bundle
cd $APP_NAME
rm Gemfile
cp $SCRIPT_PATH"/files/Gemfile" .
bundle install --without production
git init
echo 'tmp/**.*' >> .gitignore
echo 'log/**.*' >> .gitignore

cat $SCRIPTPATH"/files/config/db_config" > config/database.yml

sed -ie "s/APP_NAME/$APP_NAME/g" config/database.yml
DB_PWD=`bash $SCRIPT_PATH/scripts/genpasswd.bash`
sed -ie "s/DATABASE_PWD/$DB_PWD/g" config/database.yml
rm config/database.ymle

bundle exec rails generate bootstrap:install --no-coffeescript
bundle exec rails generate simple_form:install --bootstrap
bundle exec rails generate rspec:install
bundle exec guard init
bundle exec guard init rspec

SCAFFOLD_PATH=$SCRIPT_PATH"/files/scaffolding/html/*.*"
cp $SCAFFOLD_PATH "lib/templates/erb/scaffold/."

bundle exec rails g scaffold user email:string crypted_password:string password_salt:string persistence_token:string --no-helper --no-assets --no-controller-specs --no-view-specs

bundle exec rake db:create
bundle exec rake db:migrate

cat $SCRIPT_PATH"/files/config/routes.rb" > config/routes.rb

REPLACE_SCRIPT=$SCRIPT_PATH/scripts/replace_folder.bash
bash $REPLACE_SCRIPT "app/controllers" $SCRIPT_PATH"/files/controllers" "app/"
bash $REPLACE_SCRIPT "app/models" $SCRIPT_PATH"/files/models" "app/"
bash $REPLACE_SCRIPT "app/views" $SCRIPT_PATH"/files/views" "app/"
bash $REPLACE_SCRIPT "app/helpers" $SCRIPT_PATH"/files/helpers" "app/"
bash $REPLACE_SCRIPT "spec" $SCRIPT_PATH"/files/spec" "."
rm -r test/

rm "app/assets/stylesheets/application.css"
rm "app/assets/javascripts/application.js"
ASSETS_PATH=$SCRIPT_PATH"/files/assets"
cp -r $ASSETS_PATH "app/"

echo "@import \"import\";" >> app/assets/stylesheets/bootstrap_and_overrides.css.less

INITIALIZERS_PATH=$SCRIPT_PATH"/files/config/initializers"
cp -r $INITIALIZERS_PATH config/.
sed -i '' -- "s/USER_NAME/\"$USER\"/g" config/initializers/constants.rb

git add .
git commit -m "Initial commitby Albins RailsSetup"
