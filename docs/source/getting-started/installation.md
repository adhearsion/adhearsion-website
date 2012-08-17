# [Getting Started](/docs) > Installation

[TOC]

## Install the Adhearsion gem

First, install the Adhearsion gem and its dependencies:

<pre class="terminal">
{{ d['installation.sh|idio']['install-gem'] }}
</pre>

## Create an Adhearsion application

Next, create your first Adhearsion application:

<pre class="terminal">
{{ d['installation.sh|idio|shint|ansi2html']['create-app'] }}
</pre>

## Configure your application

Looking at the output from "ahn create", you will see several files are generated for you.  Here are the most important ones:

### Gemfile

Here is the Gemfile that is generated with your new application:

<pre class="brush: ruby;">
{{ a['installation.sh|idio|shint-meta']['create-app:files:source/getting-started/myapp/Gemfile'] }}
</pre>

In it you can see the Adhearsion framework itself is required.  Also included, but commented out, are several popular or useful plugins.  To enable their usage, simply uncomment the line from the Gemfile.  When you are done with that, install all the plugins you selected by running "bundle install":

<pre class="terminal">
{{ d['installation.sh|idio|shint|ansi2html']['bundle-install'] }}
</pre>

### config/adhearsion.rb

Next is the main Adhearsion configuration file, config/adhearsion.rb:

<pre class="brush: ruby;">
{{ a['installation.sh|idio|shint-meta']['create-app:files:source/getting-started/myapp/config/adhearsion.rb'] }}
</pre>

This is just a skeleton however.  To see the full list of available configuration options avaiable, you can always run "rake config:show".  Note that your output may be different, depending on which plugins you selected above:

<pre class="terminal">
{{ d['installation.sh|idio|shint|ansi2html']['rake-config-show'] }}
</pre>

### Connecting to your telephony engine

Adhearsion currently supports three protocols for communication with the telephony engine it is controlling; [Rayo](https://github.com/rayo/rayo-server/wiki), Asterisk [AMI](http://www.voip-info.org/wiki/view/Asterisk+manager+API) with [AsyncAGI](http://www.voip-info.org/wiki/view/Asterisk+AGI) and FreeSWITCH [EventSocket](http://wiki.freeswitch.org/wiki/Event_Socket). As such, the configuration for each is slightly different. You will notice that the generated config file contains scaffolding for each, and that the default protocol is Rayo. You are, however, encouraged to [store sensitive credentials in the application's environment](/docs/config#storing-configuration-in-the-environment) rather than in the config file.

Please see the documentation for connecting Adhearsion to the telephony engine of your choice:

* [Asterisk](/docs/getting-started/asterisk)
* [FreeSWITCH](/docs/getting-started/freeswitch) (EXPERIMENTAL)
* [PRISM](/docs/getting-started/prism)

## Make a test call

By default, a generated Adhearsion app includes the SimonGame. You can boot your app by running "ahn -" and immediately make a call to it. If everything is configured correctly, you should be prompted to play a game. Enjoy your time working with Adhearsion, and feel free to explore the rest of the documentation provided here.

<a href="#" rel="docs-nav-active" style="display:none;">docs-nav-getting-started</a>

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/getting-started/prerequisites">Prerequisites</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/console">Console</a>
  </span>
</div>
