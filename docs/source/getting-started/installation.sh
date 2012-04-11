source ~/.rvm/scripts/rvm
rvm remove jruby
rvm remove 1.9.3

### @export "rvm-install-jruby"
rvm install jruby
rvm use jruby
# JRuby must run in Ruby 1.9 mode:
export JRUBY_OPTS="--1.9"

### @export "rvm-install-193"
rvm install 1.9.3
rvm use 1.9.3

### @export "install-gem"
gem install adhearsion

### @export "create-app"
ahn create myapp
cd myapp

### @export "bundle-install"
bundle install

### @export "rake-config-show"
rake config:show
