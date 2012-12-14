# Logging

[TOC]

Adhearsion includes a comprehensive logging system, powered by the [Logging](https://github.com/TwP/logging) gem, where every class has a logger of its own, and every object may have a logger if it implements #logger_name. This makes for highly context-aware logging, and the possibility of easy application-specific logging.

## Writing to the log

In order to write to the log (eg at INFO level), simply do the following:

```ruby
logger.info "This will be printed at INFO level."
```

The default available log levels are TRACE, DEBUG, INFO, WARN, ERROR, FATAL.

## Send logs elsewhere

By default, the logs are output to log/adhearsion.log and stdout.

### Change the log file location

You may change the location of the log file by altering the 'config.platform.logging.outputters' config setting, like so:

<pre class="terminal">

ADHEARSION_PLATFORM_LOGGING_OUTPUTTERS=/var/log/adhearsion.log ahn start -
</pre>

### Log to syslog

See [the logging gem](https://github.com/TwP/logging/blob/master/lib/logging/appenders/syslog.rb#L23).

### Send logs by email

See [the logging gem](https://github.com/TwP/logging/blob/master/lib/logging/appenders/email.rb#L25).

## Change the log format

See [the logging gem](https://github.com/TwP/logging/blob/master/examples/layouts.rb).

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/events">Events</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/plugins">Plugins</a>
  </span>
</div>
