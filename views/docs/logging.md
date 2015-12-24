# Logging

[TOC]

Adhearsion includes a comprehensive logging system, powered by the [Logging](https://github.com/TwP/logging) gem, where every class has a logger of its own, and every object may have a logger if it implements `#logger_name`. This makes for highly context-aware logging, and the possibility of easy application-specific logging.

## Writing to the log

In order to write to the log (eg at INFO level), simply do the following:

```ruby
logger.info "This will be printed at INFO level."
```

The default available log levels are TRACE, DEBUG, INFO, WARN, ERROR, FATAL.

## Send logs elsewhere

By default, logs are streamed to stdout in accordance with [12factor guidance](http://12factor.net/logs). If you wish to persist logs to disk or route them to some sort of aggregation system, you must do so within the platform that hosts your Adhearsion application. If you've followed the [deployment instructions](/docs/best-practices/deployment) then you already have this setup.

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
