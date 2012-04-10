# Config

[TOC]

Adhearsion 2.0 brings a brand new configuration system which is environment-aware, self-describing and both programatically- and human-inspectable. The app's central configuration system holds settings for adhearsion core and all 3rd-party and custom plugins.

## Viewing current/default config

In order to visually inspect the current state of the application's configuration, simply run the rake task config:show, like so:

<pre class="terminal">
{{ d['getting-started/installation.sh|idio|shint|ansi2html']['rake-config-show'] }}
</pre>

This output shows the currently active configuration as a combination of default values and overrides. It also provides brief documentation relating to each option.

The active configuration is derived from the default values for each key, overloaded first by the on-disk configuration (in config/adhearsion.rb) and that provided by the app's environment (see below).

## Configuring Adhearsion & Plugins

In order to override an application's settings, you can set new values in config/adhearsion.rb. To get started, you can actually copy-paste the output from "rake config:show", and modify it for your needs. The syntax of the config file is relatively self-explanatory:

<pre class="brush: ruby;">
{{ a['getting-started/installation.sh|idio|shint|ansi2html']['create-app:files:source/getting-started/myapp/config/adhearsion.rb'] }}
</pre>

## Storing configuration in the environment

It is bad practice to store sensitive data (eg credentials/API keys) in source control, or to mix environment-specific configuration with your application's standard behaviour. You can read more about this philosophy as part of the [twelve-factor manifesto](http://www.12factor.net/config). Adhearsion allows you to configure any part of the core system or plugins using environment variables. The output from "rake config:show" includes a capitalised reference to the environment variable name corresponding to each configuration key.

For example, to override the punchblock username and password at runtime, you may do this:

<pre class="terminal">
  <br/>
AHN_PUNCHBLOCK_USERNAME=testuser AHN_PUNCHBLOCK_PASSWORD=foobar ahn start .
</pre>

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/routing">Routing</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/events">Events</a>
  </span>
</div>
