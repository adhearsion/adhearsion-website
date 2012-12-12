# [Best Practices](/docs/best-practices) > Deployment

[TOC]

Adhearsion can be deployed any way you like, but here are some guidelines to make the process easier. These will evolve over time:

## Deploying to Heroku

Heroku is the current preferred deployment environment, because of the simplicity with which applications may be deployed there.

The first step is to generate an Adhearsion application:

<pre class="terminal">

$ gem install adhearsion
Successfully installed adhearsion-2.1.0
1 gem installed
$ ahn create myapp
<span class="ansi1"><span class="ansi32">      create</span></span>  config
<span class="ansi1"><span class="ansi32">      create</span></span>  config/adhearsion.rb
<span class="ansi1"><span class="ansi32">      create</span></span>  config/environment.rb
<span class="ansi1"><span class="ansi32">      create</span></span>  lib
<span class="ansi1"><span class="ansi32">      create</span></span>  lib/simon_game.rb
<span class="ansi1"><span class="ansi32">      create</span></span>  script
<span class="ansi1"><span class="ansi32">      create</span></span>  script/ahn
<span class="ansi1"><span class="ansi32">      create</span></span>  spec
<span class="ansi1"><span class="ansi32">      create</span></span>  spec/spec_helper.rb
<span class="ansi1"><span class="ansi32">      create</span></span>  spec/call_controllers
<span class="ansi1"><span class="ansi32">      create</span></span>  spec/support
<span class="ansi1"><span class="ansi32">      create</span></span>  Gemfile
<span class="ansi1"><span class="ansi32">      create</span></span>  .gitignore
<span class="ansi1"><span class="ansi32">      create</span></span>  .rspec
<span class="ansi1"><span class="ansi32">      create</span></span>  Procfile
<span class="ansi1"><span class="ansi32">      create</span></span>  Rakefile
<span class="ansi1"><span class="ansi32">      create</span></span>  README.md
<span class="ansi1"><span class="ansi32">       chmod</span></span>  script/ahn
$ cd myapp
</pre>

We must then bundle the required gems, and thus create a Gemfile.lock:

<pre class="terminal">

$ bundle install
Fetching gem metadata from http://rubygems.org/.........
Fetching gem metadata from http://rubygems.org/..
Using rake (0.9.2.2)
Using i18n (0.6.0)
Using multi_json (1.3.6)
Using activesupport (3.2.8)
Using adhearsion-loquacious (1.9.3)
Using bundler (1.1.4)
Using timers (1.0.1)
Using celluloid (0.11.1)
Using countdownlatch (1.0.0)
Using deep_merge (1.0.0)
Using ffi (1.1.5)
Using future-resource (1.0.0)
Using connection_pool (0.9.2)
Using girl_friday (0.10.0)
Using has-guarded-handlers (1.3.1)
Using little-plugger (1.1.3)
Using logging (1.7.2)
Using coderay (1.0.7)
Using method_source (0.8)
Using slop (3.3.2)
Using pry (0.9.10)
Using eventmachine (0.12.10)
Using nokogiri (1.5.5)
Using niceogiri (1.0.2)
Using blather (0.8.0)
Using nio4r (0.4.0)
Using celluloid-io (0.11.0)
Using ruby_ami (1.2.1)
Using json (1.7.4)
Using ruby_fs (1.0.0)
Using ruby_speech (1.0.0)
Using state_machine (1.1.2)
Using punchblock (1.4.0)
Using thor (0.16.0)
Using adhearsion (2.1.0)
<span class="ansi32">Your bundle is complete! Use `bundle show [gemname]` to see where a bundled gem is installed.</span>
$ bundle package
Using rake (0.9.2.2)
Using i18n (0.6.0)
Using multi_json (1.3.6)
Using activesupport (3.2.8)
Using adhearsion-loquacious (1.9.3)
Using bundler (1.1.4)
Using timers (1.0.1)
Using celluloid (0.11.1)
Using countdownlatch (1.0.0)
Using deep_merge (1.0.0)
Using ffi (1.1.5)
Using future-resource (1.0.0)
Using connection_pool (0.9.2)
Using girl_friday (0.10.0)
Using has-guarded-handlers (1.3.1)
Using little-plugger (1.1.3)
Using logging (1.7.2)
Using coderay (1.0.7)
Using method_source (0.8)
Using slop (3.3.2)
Using pry (0.9.10)
Using eventmachine (0.12.10)
Using nokogiri (1.5.5)
Using niceogiri (1.0.2)
Using blather (0.8.0)
Using nio4r (0.4.0)
Using celluloid-io (0.11.0)
Using ruby_ami (1.2.1)
Using json (1.7.4)
Using ruby_fs (1.0.0)
Using ruby_speech (1.0.0)
Using state_machine (1.1.2)
Using punchblock (1.4.0)
Using thor (0.16.0)
Using adhearsion (2.1.0)
<span class="ansi32">Your bundle is complete! Use `bundle show [gemname]` to see where a bundled gem is installed.</span>
Updating .gem files in vendor/cache
  * rake-0.9.2.2.gem
  * i18n-0.6.0.gem
  * multi_json-1.3.6.gem
  * activesupport-3.2.8.gem
  * adhearsion-loquacious-1.9.3.gem
  * timers-1.0.1.gem
  * celluloid-0.11.1.gem
  * countdownlatch-1.0.0.gem
  * deep_merge-1.0.0.gem
  * ffi-1.1.5.gem
  * future-resource-1.0.0.gem
  * connection_pool-0.9.2.gem
  * girl_friday-0.10.0.gem
  * has-guarded-handlers-1.3.1.gem
  * little-plugger-1.1.3.gem
  * logging-1.7.2.gem
  * coderay-1.0.7.gem
  * method_source-0.8.gem
  * slop-3.3.2.gem
  * pry-0.9.10.gem
  * eventmachine-0.12.10.gem
  * nokogiri-1.5.5.gem
  * niceogiri-1.0.2.gem
  * blather-0.8.0.gem
  * nio4r-0.4.0.gem
  * celluloid-io-0.11.0.gem
  * ruby_ami-1.2.1.gem
  * json-1.7.4.gem
  * ruby_fs-1.0.0.gem
  * ruby_speech-1.0.0.gem
  * state_machine-1.1.2.gem
  * punchblock-1.4.0.gem
  * thor-0.16.0.gem
  * adhearsion-2.1.0.gem
$ gem install heroku
Successfully installed heroku-2.24.0
1 gem installed
</pre>

All applications deployed to Heroku must live in a git repository, so create one and commit your code:

<pre class="terminal">

$ git init
Initialized empty Git repository in /Users/ben/code/VoIP/adhearsion/website/docs/artifacts/7d8c070bbf85cbd9e219b23adbb8ae9e/source/best-practices/myapp/.git/
$ git add .
$ git commit -a -m "Initial commit"
[master (root-commit) 14c667b] Initial commit
 45 files changed, 305 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 .rspec
 create mode 100644 Gemfile
 create mode 100644 Gemfile.lock
 create mode 100644 Procfile
 create mode 100644 README.md
 create mode 100644 Rakefile
 create mode 100644 config/adhearsion.rb
 create mode 100644 config/environment.rb
 create mode 100644 lib/simon_game.rb
 create mode 100755 script/ahn
 create mode 100644 spec/spec_helper.rb
 create mode 100644 vendor/cache/activesupport-3.2.3.gem
 create mode 100644 vendor/cache/adhearsion-2.0.0.gem
 create mode 100644 vendor/cache/adhearsion-loquacious-1.9.2.gem
 create mode 100644 vendor/cache/blather-0.7.0.gem
 create mode 100644 vendor/cache/celluloid-0.10.0.gem
 create mode 100644 vendor/cache/coderay-1.0.6.gem
 create mode 100644 vendor/cache/connection_pool-0.1.0.gem
 create mode 100644 vendor/cache/countdownlatch-1.0.0.gem
 create mode 100644 vendor/cache/deep_merge-1.0.0.gem
 create mode 100644 vendor/cache/eventmachine-0.12.10.gem
 create mode 100644 vendor/cache/ffi-1.0.11.gem
 create mode 100644 vendor/cache/future-resource-1.0.0.gem
 create mode 100644 vendor/cache/girl_friday-0.9.7.gem
 create mode 100644 vendor/cache/has-guarded-handlers-1.2.0.gem
 create mode 100644 vendor/cache/i18n-0.6.0.gem
 create mode 100644 vendor/cache/little-plugger-1.1.3.gem
 create mode 100644 vendor/cache/logging-1.7.2.gem
 create mode 100644 vendor/cache/macaddr-1.5.0.gem
 create mode 100644 vendor/cache/method_source-0.7.1.gem
 create mode 100644 vendor/cache/multi_json-1.2.0.gem
 create mode 100644 vendor/cache/niceogiri-1.0.1.gem
 create mode 100644 vendor/cache/nokogiri-1.4.7.gem
 create mode 100644 vendor/cache/pry-0.9.8.4.gem
 create mode 100644 vendor/cache/punchblock-1.0.0.gem
 create mode 100644 vendor/cache/rake-0.9.2.2.gem
 create mode 100644 vendor/cache/ruby_ami-1.0.0.gem
 create mode 100644 vendor/cache/ruby_speech-1.0.0.gem
 create mode 100644 vendor/cache/slop-2.4.4.gem
 create mode 100644 vendor/cache/state_machine-1.1.2.gem
 create mode 100644 vendor/cache/systemu-2.5.0.gem
 create mode 100644 vendor/cache/thor-0.14.6.gem
 create mode 100644 vendor/cache/uuid-2.3.5.gem
 create mode 100644 vendor/cache/uuidtools-2.1.2.gem
</pre>

Now we can create the Heroku application, taking care to specify the target stack as 'cedar'.

<pre class="terminal">

$ heroku apps:create --stack cedar
Creating blazing-meadow-8760... done, stack is cedar
http://blazing-meadow-8760.herokuapp.com/ | git@heroku.com:blazing-meadow-8760.git
Git remote heroku added
</pre>

Including sensitive data in a repository is bad practice, so we keep our Punchblock credentials in the environment on Heroku, as so:

<pre class="terminal">

$ heroku config:add AHN_PUNCHBLOCK_USERNAME=foo@bar.com AHN_PUNCHBLOCK_USERNAME=foobar
Adding config vars and restarting app... done, v2
  AHN_PUNCHBLOCK_USERNAME =&gt; foobar
</pre>

We're now ready to push the application to Heroku, which is very simple:

<pre class="terminal">

$ git push heroku master
Counting objects: 53, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (47/47), done.
Writing objects: 100% (53/53), 3.01 MiB | 115 KiB/s, done.
Total 53 (delta 0), reused 0 (delta 0)

-----&gt; Heroku receiving push
-----&gt; Ruby/Rails app detected
-----&gt; Installing dependencies using Bundler version 1.1.2
       Running: bundle install --without development:test --path vendor/bundle --binstubs bin/ --deployment
       Installing rake (0.9.2.2)
       Installing i18n (0.6.0)
       Installing multi_json (1.2.0)
       Installing activesupport (3.2.3)
       Installing adhearsion-loquacious (1.9.2)
       Using bundler (1.1.2)
       Installing celluloid (0.10.0)
       Installing countdownlatch (1.0.0)
       Installing deep_merge (1.0.0)
       Installing ffi (1.0.11) with native extensions
       Installing future-resource (1.0.0)
       Installing connection_pool (0.1.0)
       Installing girl_friday (0.9.7)
       Installing systemu (2.5.0)
       Installing macaddr (1.5.0)
       Installing uuid (2.3.5)
       Installing has-guarded-handlers (1.2.0)
       Installing little-plugger (1.1.3)
       Installing logging (1.7.2)
       Installing coderay (1.0.6)
       Installing method_source (0.7.1)
       Installing slop (2.4.4)
       Installing pry (0.9.8.4)
       Installing eventmachine (0.12.10) with native extensions
       Installing nokogiri (1.4.7) with native extensions
       Installing niceogiri (1.0.1)
       Installing blather (0.7.0)
       Installing uuidtools (2.1.2)
       Installing ruby_ami (1.0.0)
       Installing ruby_speech (1.0.0)
       Installing state_machine (1.1.2)
       Installing punchblock (1.0.0)
       Installing thor (0.14.6)
       Installing adhearsion (2.0.0)
       Updating .gem files in vendor/cache
       Your bundle is complete! It was installed into ./vendor/bundle
       Cleaning up the bundler cache.
-----&gt; Writing config/database.yml to read from DATABASE_URL
-----&gt; Rails plugin injection
       Injecting rails_log_stdout
-----&gt; Discovering process types
       Procfile declares types      -&gt; ahn
       Default types for Ruby/Rails -&gt; console, rake, web, worker
-----&gt; Compiled slug size is 8.5MB
-----&gt; Launching... done, v5
       http://blazing-meadow-8760.herokuapp.com deployed to Heroku

To git@heroku.com:blazing-meadow-8760.git
 * [new branch]      master -&gt; master
</pre>

Once the application is resident on Heroku, we can appropriately scale the number of processes and watch our application boot.

<pre class="terminal">

$ heroku ps:scale ahn=1 web=0
Scaling ahn processes... done, now running 1
Scaling web processes... done, now running 0
</pre>

## Deploying to the cloud/a VPS/bare metal

[Foreman](http://ddollar.github.com/foreman) is a good option for managing your application's processes both in development and production. In development, you should run foreman start, but in production you should probably export to something like Ubuntu Upstart.

It is possible to instruct Foreman to include extra environment variables when executing your application. This is done by including an .env file in the app directory when running foreman or exporting to Upstart. The file should be similar to this:

<pre class="brush: ruby;">
AHN_PUNCHBLOCK_USERNAME=foobar
AHN_PUNCHBLOCK_PASSWORD=barfoo
</pre>

You can optionally place this file elsewhere and specify its location using --env.

Check the Foreman docs for more details.

<a href="#" rel="docs-nav-active" style="display:none;">docs-nav-best-practices</a>

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/best-practices/testing">Testing</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/best-practices/sysadmin">Notes for System Administrators</a>
  </span>
</div>
