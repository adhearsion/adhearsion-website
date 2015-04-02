# Routing

[TOC]

In Adhearsion 2, all calls come in to a single place, the Router. The VoIP platform, be it Asterisk, Voxeo PRISM, or anything else, does not instruct Adhearsion on how to route the call. Instead, we have a DSL for defining routes, which can have some interesting rules, in order to decide what should happen to each individual call. This lives in the application's config file, `config/routes.rb`.

```ruby
Adhearsion.router do
  route 'Authorized callers', FooController, to: /789/

  route 'Everyone else' do
    answer
    menu...
  end
end
```

The first option is a freeform route label which is used primarily for logging.  The rest of the route is a combination of its guards and its target, which may either be a particular CallController class or a block of code. You can see an example of the syntax for each above.

In the above example the `:to` attribute of the incoming Call object is matched against a regular expression. This is supplied using hash syntax. This matching syntax borrows from Jeff Smick's excellent Blather XMPP client library, called [has-guaded-handlers](https://adhearsion.github.com/has-guarded-handlers), which in turn borrows from the idea of [Guards](http://en.wikibooks.org/wiki/Erlang_Programming/guards) from [Erlang](http://www.erlang.org/). The route will be allowed to match a call only if all of its guards are satisfied.

The general structure of a route definition is one of the two following formats:

```ruby
route "Label", Controller, :filters

# -or-

route "Label", :filters do
  # This block treated like an implicit CallController
end
```

You may mix and match styles as needed. In the arguments above, the "Label" is purely informational and is only used when writing to the logs. While discouraged, it is valid to use the same route label for more than one route.  The `:filters` are  series of guards, which are described below.  You must specify either a CallController class to handle calls which match the route, or provide a block which becomes an implicit CallController.

One may specify many different kinds of guards, which determine whether a given call matches the route. Here are some examples:

```ruby
# This requires the call being routed to be an object of the type specified.
route 'Outbound Calls', OutboundCallController, Adhearsion::OutboundCall

# A contrived example, but a symbol calls the matching method and
# requires a truthy response
route 'Active Calls', ActiveCallsController, :active?

# This calls the method #from and requires an exact match to the
# string specified (this can be any other type).
route 'Only calls from me@there.com', MeController, from: 'sip:me@there.com'

# An array as the hash key requires the return value of #from to
# match one of the provided values.
route 'Calls from me or you', MeOrYouController, from: ['sip:me@there.com', 'sip:you@other.com']

# Multiple hash keys act like logical AND and thus all must match.
route 'Calls between me and us', MeAndUsController, from: 'sip:me@there.com', to: 'sip:us@here.com'

# Elements of an array act like logical OR and thus if at least
# one matches, the guards will pass.
route 'Calls from me or to us', MeOrUsController, [{from: 'sip:me@there.com'}, {to: 'sip:us@here.com'}]

# One may provide a lambda/Proc which can perform any arbitrary
# operation upon the call object. A truthy return value passes
# the guard.
route 'Calls before 8PM', DaytimeController, lambda { |call| Time.now.hour < 20 }

# For those upgrading from Adhearsion 1.x, or simply wishing to
# use Asterisk contexts as a routing key, the context name
# is accessible as a guard as well:
route 'Calls from Asterisk context-name', ContextNameController, agi_context: 'context-name'
```

## Modifiers

It is possible to modify routes to achieve certain goals. In all cases, you can include multiple routes within a modifier or nest modifiers to combine them.

### Do not auto-accept calls that match

By default, Adhearsion will indicate ringing to any call that matches a route until you call `answer` in your controller. Sometimes (mostly when bridging) this is undesireable, and you can prevent it like so:

```ruby
Adhearsion.router do
  unaccepting do
    route 'Everyone else' do
      # Do some authorization or similar
      unless authorized?
        reject
        return
      end
      accept
      # Do some stuff before answering
      answer
      menu...
    end
  end
end
```

### Do not hangup after controller execution

By default, Adhearsion will hangup the call after execution of the controller specified in the router (or any controllers it passes to or invokes). This is to ensure that calls are not left hanging around because your controller forgets to hangup, or crashes. Sometimes it is desireable to keep calls around, for example if your controller hands back control to Asterisk's `extensions.conf`. You can instruct Adhearsion not to automatically hang up by specifying the route as openended:

```ruby
Adhearsion.router do
  openended do
    route 'Everyone else' do
      answer
      # hand back to extensions.conf
    end
  end
end
```

### Do not execute a controller

Sometimes, you may not want to execute a controller on a call, but instead just manipulate it directly, perhaps by registering handlers for its events. You can do this by specifying a route as evented:

```ruby
Adhearsion.router do
  evented do
    route 'Everyone else' do |call|
      call.answer
    end
  end
end
```

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/call-controllers">Call Controllers</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/config">Config</a>
  </span>
</div>
