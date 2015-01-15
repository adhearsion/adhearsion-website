# [Getting Started](/docs) > Prerequisites

To use Adhearsion you will need a few things:

* A Telephony Engine
* A Ruby Interpreter

## A Telephony Engine
Adhearsion 2 supports the following telephony engines:

* [Asterisk](/docs/getting-started/asterisk)
* [FreeSWITCH](/docs/getting-started/freeswitch)
* [PRISM](/docs/getting-started/prism)

## A Ruby Interpreter
Adhearsion requires [Ruby](http://ruby-lang.org) version 1.9.2 or later. [JRuby](http://jruby.org) version 1.7.0 or later is also supported.

Most operating systems come with a version of Ruby installed.  However, it is very important to check the version.  Mac OS X ships with a version of Ruby based on 1.8.7, which is too old.  Debian and its derivatives, including Ubuntu, provide a version of Ruby 1.9 with the package called `ruby19`.

One easy, cross-platform way to install an acceptable version of Ruby is to use the [Ruby Version Manager](https://rvm.io), also called ["RVM"](https://rvm.io).

After you have RVM installed, installing Ruby 1.9.3 with RVM is easy:

<pre class="terminal">

$ rvm install 1.9.3
<span class="ansi32">Fetching yaml-0.1.4.tar.gz to /Users/ben/Developer/.rvm/archives</span>
<span class="ansi32">Extracting yaml-0.1.4.tar.gz to /Users/ben/Developer/.rvm/src</span>
<span class="ansi32">Configuring yaml in /Users/ben/Developer/.rvm/src/yaml-0.1.4.</span>
<span class="ansi32">Compiling yaml in /Users/ben/Developer/.rvm/src/yaml-0.1.4.</span>
<span class="ansi32">Installing yaml to /Users/ben/Developer/.rvm/usr</span>
<span class="ansi32">Installing Ruby from source to: /Users/ben/Developer/.rvm/rubies/ruby-1.9.3-p125, this may take a while depending on your cpu(s)...
</span>
<span class="ansi32">ruby-1.9.3-p125 - #fetching </span>
<span class="ansi32">ruby-1.9.3-p125 - #extracting ruby-1.9.3-p125 to /Users/ben/Developer/.rvm/src/ruby-1.9.3-p125</span>
<span class="ansi32">ruby-1.9.3-p125 - #extracted to /Users/ben/Developer/.rvm/src/ruby-1.9.3-p125</span>
<span class="ansi32">Applying patch 'xcode-debugopt-fix-r34840' (located at /Users/ben/Developer/.rvm/patches/ruby/1.9.3/p125/xcode-debugopt-fix-r34840.diff)</span>
<span class="ansi32">ruby-1.9.3-p125 - #autoreconf</span>
<span class="ansi32">ruby-1.9.3-p125 - #configuring </span>
<span class="ansi32">ruby-1.9.3-p125 - #compiling </span>
<span class="ansi32">ruby-1.9.3-p125 - #installing </span>
<span class="ansi32">Removing old Rubygems files...</span>
<span class="ansi32">Installing rubygems-1.8.21 for ruby-1.9.3-p125 ...</span>
<span class="ansi32">Installation of rubygems completed successfully.</span>
<span class="ansi32">ruby-1.9.3-p125 - adjusting #shebangs for (gem irb erb ri rdoc testrb rake).</span>
<span class="ansi32">ruby-1.9.3-p125 - #importing default gemsets (/Users/ben/Developer/.rvm/gemsets/)</span>
<span class="ansi32">Install of ruby-1.9.3-p125 - #complete </span>
$ rvm use 1.9.3
<span class="ansi32">Using /Users/ben/Developer/.rvm/gems/ruby-1.9.3-p125</span>
</pre>

If you prefer JRuby, RVM can also install JRuby:

<pre class="terminal">

$ rvm install jruby
<span class="ansi32">jruby-1.7.0 - #fetching </span>
<span class="ansi32">jruby-1.7.0 - #extracting jruby-bin-1.7.0 to /Users/ben/Developer/.rvm/src/jruby-1.7.0</span>
<span class="ansi32">jruby-1.7.0 - #extracted to /Users/ben/Developer/.rvm/src/jruby-1.7.0</span>
<span class="ansi32">Building Nailgun</span>
<span class="ansi32">jruby-1.7.0 - #installing to /Users/ben/Developer/.rvm/rubies/jruby-1.7.0</span>
<span class="ansi32">jruby-1.7.0 - #importing default gemsets (/Users/ben/Developer/.rvm/gemsets/)</span>
<span class="ansi32">Copying across included gems</span>
Building native extensions.  This could take a while...
Successfully installed jruby-launcher-1.0.12-java
1 gem installed
$ rvm use jruby
<span class="ansi32">Using /Users/ben/Developer/.rvm/gems/jruby-1.7.0</span>
</pre>

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs">Getting Started</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/getting-started/installation">Installation</a>
  </span>
</div>

<a href="#" rel="docs-nav-active" style="display:none;">docs-nav-getting-started</a>
