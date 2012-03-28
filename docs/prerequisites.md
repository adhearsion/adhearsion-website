Prerequisites
=============

To use Adhearsion you will need a few things:

* A Ruby Interpreter
* A Telephony Engine

## A Ruby Interpreter ##
Adhearsion requires <a href="http://ruby-lang.org">Ruby</a> version 1.9.2 or later. <a href="http://jruby.org">JRuby</a> version 1.6.5 or later running in Ruby19 mode (--1.9) is also supported.

Most operating systems come with a version of Ruby installed.  However, it is very important to check the version.  Mac OS X ships with a version of Ruby based on 1.8.7, which is too old.  Debian and its derivatives, including Ubuntu, provide a version of Ruby 1.9 with the package called "ruby19".

One easy, cross-platform way to install an acceptable version of Ruby is to use the <a href="http://rvm.beginrescueend.com">Ruby Version Manager</a>, also called <a href="http://rvm.beginrescueend.com">"RVM"</a>.

After you have RVM installed, installing Ruby 1.9.3 with RVM is easy:

<pre class="terminal">
{{ d['installation.sh|idio|shint|ansi2html']['rvm-install-193'] }}
</pre>

If you prefer JRuby, RVM can also install JRuby:

<pre class="terminal">
{{ d['installation.sh|idio|shint|ansi2html']['rvm-install-jruby'] }}
</pre>

## A Telephony Engine ##
Adhearsion 2 supports the following telephony engines:

* <a href="http://asterisk.org">Asterisk</a> version 1.8.0 or later
* <a href="http://voxeolabs.com/prism/">PRISM</a> version 11.1 with the <a href="https://github.com/rayo/rayo-server">rayo-server</a> application installed.
* Generally speaking, anything that supports the <a href="http://rayo.io">Rayo</a> protocol.


Continue to <a href="installation.html">INSTALLATION</a>
