source ~/.rvm/scripts/rvm
rvm use 1.9.3

### @export "deploy-create-app"
gem install adhearsion
ahn create myapp
cd myapp

### @export "bundle-install"
bundle install
bundle package
gem install heroku

### @export "git-init"
git init
git add .
git commit -a -m "Initial commit"

### @export "create-heroku-app"
heroku apps:create --stack cedar

### @export "set-heroku-config"
heroku config:add AHN_PUNCHBLOCK_USERNAME=foo@bar.com AHN_PUNCHBLOCK_USERNAME=foobar

### @export "push-heroku-app"
git push heroku master

### @export "scale-heroku-app"
heroku ps:scale ahn=1 web=0

### @export "delete-heroku-app"
set `heroku apps:info | grep -oE '=== .*' | cut -c5-`
heroku apps:destroy --app $1 --confirm $1
