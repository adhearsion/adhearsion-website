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
{{ a['installation.sh|idio|shint|ansi2html']['create-app:files:source/getting-started/myapp/Gemfile'] }}
</pre>

In it you can see the Adhearsion framework itself is required.  Also included, but commented out, are several popular or useful plugins.  To enable their usage, simply uncomment the line from the Gemfile.  When you are done with that, install all the plugins you selected by running "bundle install":

<pre class="terminal">
{{ d['installation.sh|idio|shint|ansi2html']['bundle-install'] }}
</pre>

### config/adhearsion.rb

Next is the main Adhearsion configuration file, config/adhearsion.rb:

<pre class="brush: ruby;">
{{ a['installation.sh|idio|shint|ansi2html']['create-app:files:source/getting-started/myapp/config/adhearsion.rb'] }}
</pre>

This is just a skeleton however.  To see the full list of available configuration options avaiable, you can always run "rake config:show".  Note that your output may be different, depending on which plugins you selected above:

<pre class="terminal">
{{ d['installation.sh|idio|shint|ansi2html']['rake-config-show'] }}
</pre>

### Connecting to your telephony engine

Adhearsion currently supports two protocols for communication with the telephony engine it is controlling; [Rayo](https://github.com/rayo/rayo-server/wiki) and Asterisk [AMI](http://www.voip-info.org/wiki/view/Asterisk+manager+API) with [AsyncAGI](http://www.voip-info.org/wiki/view/Asterisk+AGI). As such, the configuration for each is slightly different. You will notice that the generated config file contains scaffolding for each, and that the default protocol is Rayo. You are, however, encouraged to [store sensitive credentials in the application's environment](/docs/config#storing-configuration-in-the-environment) rather than in the config file.

#### Rayo (PRISM)

If you are using a Rayo server, you will need to configure your JID and password and ensure that the DIDs have been mapped to your selected JID. Refer to your Rayo server's documentation for how to do this.  You likely will also want to configure your root_domain to point to your Rayo server's domain name for routing outbound calls.

#### Asterisk

If you are using Asterisk, there are a couple of steps to configure it for use with Adhearsion:

##### AMI User

It is necessary to configure an AMI user by which Adhearsion can connect to Asterisk. This can be done in manager.conf, and a sample configuration is provided below:

<pre class="brush: ruby;">
[general]
enabled = yes
port = 5038
bindaddr = 0.0.0.0

[myuser]
secret = mypassword
read = all
write = all
eventfilter = !Event: RTCP*
</pre>

Note that the user needs acess to all AMI events and actions. Also, we have setup an event filter here to prevent sending Adhearsion RTCP events. This is optional, and is because Asterisk generates a great number of these events, and Adhearsion cannot normally do anything useful with them. Thus, we can improve Adhearsion's performance by not sending it these events in the first place.

##### Route calls to AsyncAGI

You will need to route calls to AsyncAGI, which allows Adhearsion to take control of them. You should add something similar to the following config to extensions.conf:

<pre class="brush: ruby;">
[your_context_name]
exten => _.,1,AGI(agi:async)
</pre>

This will route all calls with a numeric extension to Adhearsion.

Note also that on versions of Asterisk before 10, it is necessary to add an empty context with the name 'adhearsion-redirect'.

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
