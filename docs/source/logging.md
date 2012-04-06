# Logging

[TOC]

Adhearsion includes a comprehensive logging system, powered by the [Logging](https://github.com/TwP/logging) gem, where every class has a logger of its own, and every object may have a logger if it implements #logger_name. This makes for highly context-aware logging, and the possibility of easy application-specific logging.

## Writing to the log

In order to write to the log (eg at INFO level), simply do the following:

<pre class="brush: ruby;">
logger.info "This will be printed at INFO level."
</pre>

The default available log levels are TRACE, DEBUG, INFO, WARN, ERROR, FATAL.

## Send logs elsewhere

### Change the log file location

### Log to syslog

### Send logs by email

## Change the log format

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/config">Config</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/plugins">Plugins</a>
  </span>
</div>
