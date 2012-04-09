# Routing

[TOC]

In Adhearsion 2, all calls come in to a single place, the Router. The VoIP platform, be it Asterisk, Voxeo PRISM, or anything else, does not instruct Adhearsion on how to route the call. Instead, we have a DSL for defining routes, which can have some interesting rules, in order to decide what should happen to each individual call. This lives in the application's config file, config/adhearsion.rb. An equivalent to the above app, minus the body of each context, might look something like this:

<pre class="brush: ruby;">
Adhearsion.router do
  route 'Authorized callers', FooController, :to => /789/

  route 'Everyone else' do
    answer
    menu...
  end
end
</pre>

A route is a combination of its guards and its target, which may either be a particular CallController class, or a block of code. You can see an example of the syntax for each here.

In the above example the to attribute of the incoming Call object is matched against a regex. This is supplied using hash syntax. This entire matching routine uses a system extracted from Jeff Smick's excellent Blather XMPP client library, called [has-guaded-handlers](https://adhearsion.github.com/has-guarded-handlers), which in turn borrows from the idea of [Guards](http://en.wikibooks.org/wiki/Erlang_Programming/guards) from [Erlang](http://www.erlang.org/). The route will be allowed to match a call only if all of its guards are satisfied.

One may specify many different kinds of guards, and here are some examples (the same ideas work for event handlers in Adhearsion and stanza handlers in Blather, by the way):

<pre class="brush: ruby;">
# This requires the call being routed to be of the type specified.
route 'foo', Adhearsion::OutboundCall

# A contrived example, but a symbol calls the matching method and
# requires a truthy response
route 'foo', :active?

# This calls the method #from and requires an exact match to the
# string specified (this can be any other type).
route 'foo', :from => 'sip:me@there.com'

# An array as the hash key requires the return value of #from to
# match one of the provided values.
route 'foo', :from => ['sip:me@there.com', 'sip:you@other.com']

# Multiple hash keys act like logical AND and thus all must match.
route 'foo', :from => 'sip:me@there.com', :to => 'sip:us@here.com'

# Elements of an array act like logical OR and thus if at least
# one matches, the guards will pass.
route 'foo', [{:from => 'sip:me@there.com'}, {:to => 'sip:us@here.com'}]

# One may provide a lambda/Proc which can perform any arbitrary
# operation upon the call object. A truthy return value passes
# the guard.
route 'foo', lambda { |call| Time.now.hour < 20 }
</pre>

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/call-controllers">Call Controllers</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/config">Config</a>
  </span>
</div>
