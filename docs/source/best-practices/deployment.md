# [Best Practices](/docs/best-practices) > Deployment

[TOC]

Adhearsion can be deployed any way you like, but here are some guidelines to make the process easier. These will evolve over time:

## Deploying to Heroku

Heroku is the current preferred deployment environment, because of the simplicity with which applications may be deployed there.

The first step is to generate an Adhearsion application:

<pre class="terminal">
{{ d['deployment.sh|idio|shint|ansi2html']['deploy-create-app'] }}
</pre>

We must then bundle the required gems, and thus create a Gemfile.lock:

<pre class="terminal">
{{ d['deployment.sh|idio|shint|ansi2html']['bundle-install'] }}
</pre>

All applications deployed to Heroku must live in a git repository, so create one and commit your code:

<pre class="terminal">
{{ d['deployment.sh|idio|shint|ansi2html']['git-init'] }}
</pre>

Now we can create the Heroku application, taking care to specify the target stack as 'cedar'.

<pre class="terminal">
{{ d['deployment.sh|idio|shint|ansi2html']['create-heroku-app'] }}
</pre>

Including sensitive data in a repository is bad practice, so we keep our Punchblock credentials in the environment on Heroku, as so:

<pre class="terminal">
{{ d['deployment.sh|idio|shint|ansi2html']['set-heroku-config'] }}
</pre>

We're now ready to push the application to Heroku, which is very simple:

<pre class="terminal">
{{ d['deployment.sh|idio|shint|ansi2html']['push-heroku-app'] }}
</pre>

Once the application is resident on Heroku, we can appropriately scale the number of processes and watch our application boot.

<pre class="terminal">
{{ d['deployment.sh|idio|shint|ansi2html']['scale-heroku-app'] }}
</pre>

## Deploying to the cloud/a VPS/bare metal

### Upstart

### Monitoring

### Versioning

<a href="#" rel="docs-nav-active" style="display:none;">docs-nav-best-practices</a>

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/best-practices/testing">Testing</a>
  </span>
</div>
