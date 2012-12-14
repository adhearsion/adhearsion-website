# [Getting Started](/docs) > Installation

[TOC]

## Install the Adhearsion gem

First, install the Adhearsion gem and its dependencies:

<pre class="terminal">

$ gem install adhearsion
</pre>

## Create an Adhearsion application

Next, create your first Adhearsion application:

<pre class="terminal">

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

## Configure your application

Looking at the output from `ahn create`, you will see several files are generated for you.  Here are the most important ones:

### Gemfile

Here is the Gemfile that is generated with your new application:

```ruby
source :rubygems

gem "adhearsion", "~> 2.1.0"

#
# Here are some example plugins you might like to use. Simply
# uncomment them and run `bundle install`.
#

# gem 'adhearsion-asterisk'
# gem 'adhearsion-rails'
# gem 'adhearsion-activerecord'
# gem 'adhearsion-ldap'
# gem 'adhearsion-xmpp'
# gem 'adhearsion-drb'
```

In it you can see the Adhearsion framework itself is required.  Also included, but commented out, are several popular or useful plugins.  To enable their usage, simply uncomment the line from the Gemfile.  When you are done with that, install all the plugins you selected by running `bundle install`:

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
</pre>

### config/adhearsion.rb

Next is the main Adhearsion configuration file, `config/adhearsion.rb`:

```ruby
# encoding: utf-8

Adhearsion.config do |config|

  # Centralized way to specify any Adhearsion platform or plugin configuration
  # - Execute rake config:show to view the active configuration values
  #
  # To update a plugin configuration you can write either:
  #
  #    * Option 1
  #        Adhearsion.config.&lt;plugin-name&gt; do |config|
  #          config.&lt;key&gt; = &lt;value&gt;
  #        end
  #
  #    * Option 2
  #        Adhearsion.config do |config|
  #          config.&lt;plugin-name&gt;.&lt;key&gt; = &lt;value&gt;
  #        end

  config.development do |dev|
    dev.platform.logging.level = :debug
  end

  ##
  # Use with Rayo (eg Voxeo PRISM)
  #
  # config.punchblock.username = "" # Your XMPP JID for use with Rayo
  # config.punchblock.password = "" # Your XMPP password

  ##
  # Use with Asterisk
  #
  # config.punchblock.platform = :asterisk # Use Asterisk
  # config.punchblock.username = "" # Your AMI username
  # config.punchblock.password = "" # Your AMI password
  # config.punchblock.host = "127.0.0.1" # Your AMI host

  ##
  # Use with FreeSWITCH
  #
  # config.punchblock.platform = :freeswitch # Use FreeSWITCH
  # config.punchblock.password = "" # Your Inbound EventSocket password
  # config.punchblock.host = "127.0.0.1" # Your IES host
end

Adhearsion::Events.draw do

  # Register global handlers for events
  #
  # eg. Handling Punchblock events
  # punchblock do |event|
  #   ...
  # end
  #
  # eg Handling PeerStatus AMI events
  # ami name: 'PeerStatus' do |event|
  #   ...
  # end
  #
end

Adhearsion.router do

  #
  # Specify your call routes, directing calls with particular attributes to a controller
  #

  route 'default', SimonGame
end
```

This is just a skeleton however.  To see the full list of available configuration options avaiable, you can always run `rake config:show`.  Note that your output may be different, depending on which plugins you selected above:

<pre class="terminal">

$ rake config:show

Adhearsion configured environment: development

Adhearsion.config do |config|

  # ******* Configuration for platform **************

<span class="ansi33">  # </span><span class="ansi32">Active environment. Supported values: development, production, staging, test [AHN_PLATFORM_ENVIRONMENT]</span>
<span class="ansi33">  config.platform.</span><span class="ansi37">environment       </span><span class="ansi33"> = </span><span class="ansi36">:development</span>

<span class="ansi33">  # </span><span class="ansi32">Folder to include the own libraries to be used. Adhearsion loads any ruby file</span>
<span class="ansi33">  # </span><span class="ansi32">located into this folder during the bootstrap process. Set to nil if you do not</span>
<span class="ansi33">  # </span><span class="ansi32">want these files to be loaded. This folder is relative to the application root folder. [AHN_PLATFORM_LIB]</span>
<span class="ansi33">  config.platform.</span><span class="ansi37">lib               </span><span class="ansi33"> = </span><span class="ansi36">"lib"</span>

<span class="ansi33">  # </span><span class="ansi32">Log configuration [AHN_PLATFORM_LOGGING]</span>
<span class="ansi33">  config.platform.</span><span class="ansi37">logging</span>

<span class="ansi33">  # </span><span class="ansi32">A log formatter to apply to all active outputters. If nil, the Adhearsion default formatter will be used. [AHN_PLATFORM_LOGGING_FORMATTER]</span>
<span class="ansi33">  config.platform.</span><span class="ansi37">logging.formatter </span><span class="ansi33"> = </span><span class="ansi36">nil</span>

<span class="ansi33">  # </span><span class="ansi32">Supported levels (in increasing severity) -- :trace &lt; :debug &lt; :info &lt; :warn &lt; :error &lt; :fatal [AHN_PLATFORM_LOGGING_LEVEL]</span>
<span class="ansi33">  config.platform.</span><span class="ansi37">logging.level     </span><span class="ansi33"> = </span><span class="ansi36">:debug</span>

<span class="ansi33">  # </span><span class="ansi32">An array of log outputters to use. The default is to log to stdout and log/adhearsion.log.</span>
<span class="ansi33">  # </span><span class="ansi32">Each item must be either a string to use as a filename, or a valid Logging appender (see http://github.com/TwP/logging) [AHN_PLATFORM_LOGGING_OUTPUTTERS]</span>
<span class="ansi33">  config.platform.</span><span class="ansi37">logging.outputters</span><span class="ansi33"> = </span><span class="ansi36">["log/adhearsion.log"]</span>

<span class="ansi33">  # </span><span class="ansi32">Adhearsion process name, useful to make it easier to find in the process list</span>
<span class="ansi33">  # </span><span class="ansi32">Pro tip: set this to your application's name and you can do "killall myapp"</span>
<span class="ansi33">  # </span><span class="ansi32">Does not work under JRuby. [AHN_PLATFORM_PROCESS_NAME]</span>
<span class="ansi33">  config.platform.</span><span class="ansi37">process_name      </span><span class="ansi33"> = </span><span class="ansi36">"ahn"</span>

<span class="ansi33">  # </span><span class="ansi32">Adhearsion application root folder [AHN_PLATFORM_ROOT]</span>
<span class="ansi33">  config.platform.</span><span class="ansi37">root              </span><span class="ansi33"> = </span><span class="ansi36">"/Users/bklang/src/adhearsion-website/docs/artifacts/80eddf8bb53eddb83f89b24ae751ba75/source/getting-started/myapp"</span>

  # ******* Configuration for punchblock **************

<span class="ansi33">  # </span><span class="ansi32">The domain at which to address calls [AHN_PUNCHBLOCK_CALLS_DOMAIN]</span>
<span class="ansi33">  config.punchblock.</span><span class="ansi37">calls_domain      </span><span class="ansi33"> = </span><span class="ansi36">nil</span>

<span class="ansi33">  # </span><span class="ansi32">The amount of time to wait for a connection [AHN_PUNCHBLOCK_CONNECTION_TIMEOUT]</span>
<span class="ansi33">  config.punchblock.</span><span class="ansi37">connection_timeout</span><span class="ansi33"> = </span><span class="ansi36">60</span>

<span class="ansi33">  # </span><span class="ansi32">The default TTS voice to use. [AHN_PUNCHBLOCK_DEFAULT_VOICE]</span>
<span class="ansi33">  config.punchblock.</span><span class="ansi37">default_voice     </span><span class="ansi33"> = </span><span class="ansi36">nil</span>

<span class="ansi33">  # </span><span class="ansi32">Host punchblock needs to connect (where rayo/asterisk/freeswitch is located) [AHN_PUNCHBLOCK_HOST]</span>
<span class="ansi33">  config.punchblock.</span><span class="ansi37">host              </span><span class="ansi33"> = </span><span class="ansi36">nil</span>

<span class="ansi33">  # </span><span class="ansi32">The media engine to use. Defaults to platform default. [AHN_PUNCHBLOCK_MEDIA_ENGINE]</span>
<span class="ansi33">  config.punchblock.</span><span class="ansi37">media_engine      </span><span class="ansi33"> = </span><span class="ansi36">nil</span>

<span class="ansi33">  # </span><span class="ansi32">The domain at which to address mixers [AHN_PUNCHBLOCK_MIXERS_DOMAIN]</span>
<span class="ansi33">  config.punchblock.</span><span class="ansi37">mixers_domain     </span><span class="ansi33"> = </span><span class="ansi36">nil</span>

<span class="ansi33">  # </span><span class="ansi32">Authentication credentials [AHN_PUNCHBLOCK_PASSWORD]</span>
<span class="ansi33">  config.punchblock.</span><span class="ansi37">password          </span><span class="ansi33"> = </span><span class="ansi36">"1"</span>

<span class="ansi33">  # </span><span class="ansi32">Platform punchblock shall use to connect to the Telephony provider. Currently supported values:</span>
<span class="ansi33">  # </span><span class="ansi32">- :xmpp</span>
<span class="ansi33">  # </span><span class="ansi32">- :asterisk</span>
<span class="ansi33">  # </span><span class="ansi32">- :freeswitch [AHN_PUNCHBLOCK_PLATFORM]</span>
<span class="ansi33">  config.punchblock.</span><span class="ansi37">platform          </span><span class="ansi33"> = </span><span class="ansi36">:xmpp</span>

<span class="ansi33">  # </span><span class="ansi32">Port punchblock needs to connect [AHN_PUNCHBLOCK_PORT]</span>
<span class="ansi33">  config.punchblock.</span><span class="ansi37">port              </span><span class="ansi33"> = </span><span class="ansi36">5222</span>

<span class="ansi33">  # </span><span class="ansi32">The number of times to (re)attempt connection to the server [AHN_PUNCHBLOCK_RECONNECT_ATTEMPTS]</span>
<span class="ansi33">  config.punchblock.</span><span class="ansi37">reconnect_attempts</span><span class="ansi33"> = </span><span class="ansi36">Infinity</span>

<span class="ansi33">  # </span><span class="ansi32">Delay between connection attempts [AHN_PUNCHBLOCK_RECONNECT_TIMER]</span>
<span class="ansi33">  config.punchblock.</span><span class="ansi37">reconnect_timer   </span><span class="ansi33"> = </span><span class="ansi36">5</span>

<span class="ansi33">  # </span><span class="ansi32">The root domain at which to address the server [AHN_PUNCHBLOCK_ROOT_DOMAIN]</span>
<span class="ansi33">  config.punchblock.</span><span class="ansi37">root_domain       </span><span class="ansi33"> = </span><span class="ansi36">nil</span>

<span class="ansi33">  # </span><span class="ansi32">Authentication credentials [AHN_PUNCHBLOCK_USERNAME]</span>
<span class="ansi33">  config.punchblock.</span><span class="ansi37">username          </span><span class="ansi33"> = </span><span class="ansi36">"usera@127.0.0.1"</span>

end
</pre>

### Connecting to your telephony engine

Adhearsion currently supports three protocols for communication with the telephony engine it is controlling; [Rayo](https://github.com/rayo/rayo-server/wiki), Asterisk [AMI](http://www.voip-info.org/wiki/view/Asterisk+manager+API) with [AsyncAGI](http://www.voip-info.org/wiki/view/Asterisk+AGI) and FreeSWITCH [EventSocket](http://wiki.freeswitch.org/wiki/Event_Socket). As such, the configuration for each is slightly different. You will notice that the generated config file contains scaffolding for each, and that the default protocol is Rayo. You are, however, encouraged to [store sensitive credentials in the application's environment](/docs/config#storing-configuration-in-the-environment) rather than in the config file.

Please see the documentation for connecting Adhearsion to the telephony engine of your choice:

* [Asterisk](/docs/getting-started/asterisk)
* [FreeSWITCH](/docs/getting-started/freeswitch)
* [PRISM](/docs/getting-started/prism)

## Make a test call

By default, a generated Adhearsion app includes the SimonGame. You can boot your app by running `ahn -` and immediately make a call to it. If everything is configured correctly, you should be prompted to play a game. Enjoy your time working with Adhearsion, and feel free to explore the rest of the documentation provided here.

<a href="#" rel="docs-nav-active" style="display:none;">docs-nav-getting-started</a>

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/getting-started/prerequisites">Prerequisites</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/console">Console</a>
  </span>
</div>
