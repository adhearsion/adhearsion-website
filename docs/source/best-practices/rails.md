# Rails Integration

[TOC]

It is possible to integrate an Adhearsion application with a Rails application, such that Adhearsion has access to the environment of the rails app, including its models. To do this, it is preferable to merge the directory structure of the applications.

First, generate a new rails app:

<pre class="terminal">

{11:29}[ruby-1.9.3]~/Downloads ben% rails new testapp
      create
      create  README.rdoc
      create  Rakefile
      create  config.ru
      create  .gitignore
      create  Gemfile
      create  app
      create  app/assets/images/rails.png
      create  app/assets/javascripts/application.js
      create  app/assets/stylesheets/application.css
      create  app/controllers/application_controller.rb
      create  app/helpers/application_helper.rb
      create  app/mailers
      create  app/models
      create  app/views/layouts/application.html.erb
      create  app/mailers/.gitkeep
      create  app/models/.gitkeep
      create  config
      create  config/routes.rb
      create  config/application.rb
      create  config/environment.rb
      create  config/environments
      create  config/environments/development.rb
      create  config/environments/production.rb
      create  config/environments/test.rb
      create  config/initializers
      create  config/initializers/backtrace_silencers.rb
      create  config/initializers/inflections.rb
      create  config/initializers/mime_types.rb
      create  config/initializers/secret_token.rb
      create  config/initializers/session_store.rb
      create  config/initializers/wrap_parameters.rb
      create  config/locales
      create  config/locales/en.yml
      create  config/boot.rb
      create  config/database.yml
      create  db
      create  db/seeds.rb
      create  doc
      create  doc/README_FOR_APP
      create  lib
      create  lib/tasks
      create  lib/tasks/.gitkeep
      create  lib/assets
      create  lib/assets/.gitkeep
      create  log
      create  log/.gitkeep
      create  public
      create  public/404.html
      create  public/422.html
      create  public/500.html
      create  public/favicon.ico
      create  public/index.html
      create  public/robots.txt
      create  script
      create  script/rails
      create  test/fixtures
      create  test/fixtures/.gitkeep
      create  test/functional
      create  test/functional/.gitkeep
      create  test/integration
      create  test/integration/.gitkeep
      create  test/unit
      create  test/unit/.gitkeep
      create  test/performance/browsing_test.rb
      create  test/test_helper.rb
      create  tmp/cache
      create  tmp/cache/assets
      create  vendor/assets/javascripts
      create  vendor/assets/javascripts/.gitkeep
      create  vendor/assets/stylesheets
      create  vendor/assets/stylesheets/.gitkeep
      create  vendor/plugins
      create  vendor/plugins/.gitkeep
         run  bundle install
Fetching gem metadata from https://rubygems.org/.........
Using rake (0.9.2.2)
Using i18n (0.6.0)
Using multi_json (1.3.2)
Using activesupport (3.2.3)
Using builder (3.0.0)
Using activemodel (3.2.3)
Using erubis (2.7.0)
Using journey (1.0.3)
Using rack (1.4.1)
Using rack-cache (1.2)
Using rack-test (0.6.1)
Using hike (1.2.1)
Using tilt (1.3.3)
Using sprockets (2.1.2)
Using actionpack (3.2.3)
Using mime-types (1.18)
Using polyglot (0.3.3)
Using treetop (1.4.10)
Using mail (2.4.4)
Using actionmailer (3.2.3)
Using arel (3.0.2)
Using tzinfo (0.3.33)
Using activerecord (3.2.3)
Using activeresource (3.2.3)
Using bundler (1.1.0)
Using coffee-script-source (1.3.1)
Using execjs (1.3.0)
Using coffee-script (2.2.0)
Using rack-ssl (1.3.2)
Using json (1.6.6)
Using rdoc (3.12)
Using thor (0.14.6)
Using railties (3.2.3)
Using coffee-rails (3.2.2)
Using jquery-rails (2.0.2)
Using rails (3.2.3)
Installing sass (3.1.16)
Using sass-rails (3.2.5)
Installing sqlite3 (1.3.6) with native extensions
Using uglifier (1.2.4)
Your bundle is complete! Use `bundle show [gemname]` to see where a bundled gem is installed.
</pre>

Next, generate an Adhearsion application by the same name, without overwriting config/environment.rb, Gemfile, .gitignore or Rakefile:

<pre class="terminal">

{12:27}[ruby-1.9.3]~/Downloads ben% ahn create testapp
       exist  config
      create  config/adhearsion.rb
    conflict  config/environment.rb
Overwrite /Users/ben/Downloads/testapp/config/environment.rb? (enter "h" for help) [Ynaqdh] n
        skip  config/environment.rb
       exist  lib
      create  lib/simon_game.rb
       exist  script
      create  script/ahn
      create  spec
      create  spec/spec_helper.rb
      create  spec/call_controllers
      create  spec/support
    conflict  Gemfile
Overwrite /Users/ben/Downloads/testapp/Gemfile? (enter "h" for help) [Ynaqdh] n
        skip  Gemfile
    conflict  .gitignore
Overwrite /Users/ben/Downloads/testapp/.gitignore? (enter "h" for help) [Ynaqdh] n
        skip  .gitignore
      create  .rspec
      create  Procfile
    conflict  Rakefile
Overwrite /Users/ben/Downloads/testapp/Rakefile? (enter "h" for help) [Ynaqdh] n
        skip  Rakefile
      create  README.md
       chmod  script/ahn
ahn create .  18.81s user 0.80s system 20% cpu 1:33.57 total
</pre>

The differences in environment.rb and .gitignore are such that retaining the rails version is appropriate. Adhearsion must, however, be added to the Gemfile:

<pre class="brush: ruby;">
gem 'adhearsion', '~>2.0'
</pre>

Additionally, Adhearsion's rake tasks must be loaded, by placing the following content in lib/tasks/adhearsion.rake:

<pre class="brush: ruby;">
namespace :adhearsion do
  require 'adhearsion/tasks'
end
</pre>

You may start the rails application as normal. Additionally, starting the Adhearsion application may be done as usual, along with a specification of the appropriate rails environment:

<pre class="terminal">

{12:27}[ruby-1.9.3]~/Downloads ben% RAILS_ENV=production ahn start testapp
</pre>

All of your rails models will be accessible within your Adhearsion application, and you may use them in your call controllers or elsewhere.

<a href="#" rel="docs-nav-active" style="display:none;">docs-nav-best-practices</a>

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/best-practices/sysadmin">Notes for System Administrators</a>
  </span>
</div>
