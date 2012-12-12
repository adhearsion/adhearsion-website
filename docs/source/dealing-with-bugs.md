# Dealing with bugs

[TOC]

If you encounter an issue with an Adhearsion application, and you are not certain it is a bug in Adhearsion or in your use of the framework, you should first discuss the problem on the [mailing list](http://groups.google.com/group/adhearsion). If it is then identified to be a fault with Adhearsion, you will be directed to open an issue on the [Github issue tracker](https://github.com/adhearsion/adhearsion/issues). See the notes below on [filing a bug report](#filing-a-bug-report) for more details.

## Running pre-release Adhearsion

If you encounter a bug, it's entirely possible that it has already been fixed in Adhearsion but not yet included in a released version. You can establish this by trying to run your application with a pre-release version of Adhearsion direct from source control. You can do this by modifying your application's Gemfile as follows:

<pre class="brush: ruby;">
  gem 'adhearsion', github: 'adhearsion', branch: 'develop'
  gem 'punchblock', github: 'adhearsion/punchblock', branch: 'develop'
</pre>

If it is suggested to you that you try a different branch, substitute that for 'develop' in your Gemfile.

You may then run <code>bundle install</code> to get the correct dependencies, and then boot your application. If the problem is resolved, feel free to voice your desire for a new release of Adhearsion to the [community](/community). If it persists, you should consider [filing a bug report](#filing-a-bug-report).

## Filing a bug report

* Bug reports should be filed on the [Github issue tracker](https://github.com/adhearsion/adhearsion/issues). Bug reports should contain the following things:
  * A sensible subject that helps quickly identify the issue.
  * Full steps to reproduce the issue.
  * Full log output at trace level. Feel free to point out specific log lines which you believe may be relevant, but please provide as much context as possible.
  * Full references for version numbers (of Adhearsion, dependencies, Ruby, etc), environment (including OS, environment settings, mode of deployment, etc). One easy way to do this is to post your Gemfile.lock, though you will still need to tell us what version of Ruby is in use.
  * Where possible, a minimal test case. This would preferably take the form of a git repository containing an adhearsion application which, when cloned and booted, exhibits the issue with minimal modification.
* Some more guidelines on filing good bug reports:
  * http://www.chiark.greenend.org.uk/~sgtatham/bugs.html
  * http://itscommonsensestupid.blogspot.com/2008/07/tips-to-write-good-bug-report.html
  * http://timheuer.com/blog/archive/2011/10/12/anatomy-of-a-good-bug-report.aspx

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/common_problems">Common Problems</a>
  </span>
  <span class='forward'>
    Continue to <a href="/api">API Docs</a>
  </span>
</div>
