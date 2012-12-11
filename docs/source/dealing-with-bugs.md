# Dealing with bugs

[TOC]

## Running pre-release Adhearsion

If you encounter a bug, it's entirely possible that it has already been fixed in Adhearsion but not yet included in a released version. You can establish this by trying to run your application with a pre-release version of Adhearsion direct from source control. You can do this by modifying your application's Gemfile as follows:

<pre class="brush: ruby;">
  gem 'adhearsion', github: 'adhearsion', branch: 'develop'
  gem 'punchblock', github: 'adhearsion/punchblock', branch: 'develop'
</pre>

If it is suggested to you that you try a different branch, substitute that for 'develop' in your Gemfile.

You may then run <code>bundle install</code> to get the correct dependencies, and then boot your application. If the problem is resolved, feel free to voice your desire for a new release of Adhearsion to the [community](/community). If it persists, you should consider [filing a bug report](#filing-a-bug-report).

## Filing a bug report

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/common_problems">Common Problems</a>
  </span>
  <span class='forward'>
    Continue to <a href="/api">API Docs</a>
  </span>
</div>
