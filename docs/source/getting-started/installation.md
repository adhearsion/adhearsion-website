## [Getting Started](/docs) > Installation

[TOC]

### Install the Adhearsion gem

First, install the Adhearsion gem and its dependencies:

<pre class="terminal">
{{ d['installation.sh|idio']['install-gem'] }}
</pre>


### Create an Adhearsion application

Next, create your first Adhearsion application:

<pre class="terminal">
{{ d['installation.sh|idio|shint|ansi2html']['create-app'] }}
</pre>


### Configure your application

Looking at the output from "ahn create", you will see several files are generated for you.  Here are the most important ones:


#### Gemfile

Here is the Gemfile that is generated with your new application:

-- d['artifacts/myapp/Gemfile|pyg'] --

In it you can see the Adhearsion framework itself is required.  Also included, but commented out, are several popular or useful plugins.  To enable their usage, simply uncomment the line from the Gemfile.  When you are done with that, install all the plugins you specified by running "bundle install":

<pre class="terminal">
{{ d['installation.sh|idio|shint|ansi2html']['bundle-install'] }}
</pre>

#### config/adhearsion.rb

Next is the main Adhearsion configuration file, config/adhearsion.rb:

-- d['artifacts/myapp/config/adhearsion.rb|pyg'] --

This is just a skeleton however.  To see the full list of available configuration options avaiable, you can always run "rake config:show".  Note that your output may be different, depending on which plugins you selected above:

<pre class="terminal">
{{ d['installation.sh|idio|shint|ansi2html']['rake-config-show'] }}
</pre>
