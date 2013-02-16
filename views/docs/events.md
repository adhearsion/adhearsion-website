# Events

[TOC]

Adhearsion includes a flexible event handling system, and events may be handled either globally or per-call:

## Global events

In order to handle events global to the whole system, one must declare a (potentially-guarded) handler. There are two methods by which this may be achieved:

config/adhearsion.rb:

```ruby
Adhearsion::Events.draw do

  # eg. Handling Punchblock events
  # punchblock do |event|
  #   ...
  # end
  #
  # eg Handling PeerStatus AMI events
  # ami name: 'PeerStatus' do |event|
  #   ...
  # end

end
```

or, elsewhere in your code:

```ruby
# eg. Handling Punchblock events
# Adhearsion::Events.punchblock do |event|
#   ...
# end
```

The available categories of events are currently:

* punchblock
* ami
* after_initialized
* exception

## Per-call events

```ruby
class MyController < Adhearsion::CallController
  before_call do
    call.register_event_handler do |event|
      ...
    end
  end
end
```

## Guards

The available guards are the same as those which apply in the Routing DSL, and are documented on the [has-guarded-handlers wesbite](https://github.com/adhearsion/has-guarded-handlers).

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/config">Config</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/logging">Logging</a>
  </span>
</div>
