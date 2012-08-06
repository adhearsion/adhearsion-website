# [Getting Started](/docs) > Prerequisites

To use Adhearsion you will need a few things:

* A Ruby Interpreter
* A Telephony Engine

## A Ruby Interpreter
Adhearsion requires [Ruby](http://ruby-lang.org) version 1.9.2 or later. [JRuby](http://jruby.org) version 1.6.5 or later running in Ruby19 mode (--1.9) is also supported.

Most operating systems come with a version of Ruby installed.  However, it is very important to check the version.  Mac OS X ships with a version of Ruby based on 1.8.7, which is too old.  Debian and its derivatives, including Ubuntu, provide a version of Ruby 1.9 with the package called "ruby19".

One easy, cross-platform way to install an acceptable version of Ruby is to use the [Ruby Version Manager](http://rvm.beginrescueend.com), also called ["RVM"](http://rvm.beginrescueend.com).

After you have RVM installed, installing Ruby 1.9.3 with RVM is easy:

<pre class="terminal">
{{ d['installation.sh|idio|shint|ansi2html']['rvm-install-193'] }}
</pre>

If you prefer JRuby, RVM can also install JRuby:

<pre class="terminal">
{{ d['installation.sh|idio|shint|ansi2html']['rvm-install-jruby'] }}
</pre>

## A Telephony Engine
Adhearsion 2 supports the following telephony engines:

* [FreeSWITCH](http://freeswitch.org) version 1.0.6 or later
* [Asterisk](http://asterisk.org) version 1.8.0 or later
* [PRISM](http://voxeolabs.com/prism/) version 11.1 with the [rayo-server](https://github.com/rayo/rayo-server) application installed.
* Generally speaking, anything that supports the [Rayo](https://github.com/rayo/rayo-server/wiki) protocol.

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs">Getting Started</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/getting-started/installation">Installation</a>
  </span>
</div>

<a href="#" rel="docs-nav-active" style="display:none;">docs-nav-getting-started</a>
