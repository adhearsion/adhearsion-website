## Routing

[TOC]

In Adhearsion applications based on Adhearsion 1.x and earlier, the most popular way to write the meat of the application was directly in dialplan.rb, and applications would look something like this:

<pre class="brush: ruby;">
adhearsion {
  case variables[:dnid]
  when /789/
    +calls_to_the_top_secret_number
  else
    +everyone_else
  end
}

calls_to_the_top_secret_number {
  menu 'choose-your-top-secret-operation' do
    link.turn_off_the_lights 1
    link.open_the_pod_bay_doors 2
  end
}

turn_off_the_lights {
  ...
}

open_the_pod_bay_doors {
  ...
}

everyone_else {
  pin = input 4, :speak => <<-STRING
This is not the application you are looking for.
Enter the correct PIN or face instant descruction.
STRING
  if pin == '1234'
    speak 'Phew!'
  else
    speak 'Picachu, I choose you!'
  end
}
</pre>

This is, obviously, a trivialised example, but it demonstrates two points clearly. Firstly, the routing is a mess. Implicit in this example is the idea that all calls come in to the adhearsion context in Asterisk, and this invokes the matching block in 'dialplan.rb'. We then make a routing decision based on a call variable, and jump to a different dialplan context. Once there, the routing logic is not finished. The appropriately authenticated (snigger) caller hears a menu, which takes a selection and does a further context jump. Also, this application relys on Asterisk to send calls to the correct entry point, the adhearsion context. This is not portable to other platforms which do not have any concept of a 'context'.

We can do much better than this. In Adhearsion 2, all calls come in to a single place, the Router. The VoIP platform, be it Asterisk, Voxeo PRISM, or anything else, does not instruct Adhearsion on how to route the call. Instead, we have a DSL for defining routes, which can have some interesting rules, in order to decide what should happen to each individual call. This lives in the application's config file (which is now 'adhearsion.rb', by the way). An equivalent to the above app, minus the body of each context, might look something like this:

<pre class="brush: ruby;">
Adhearsion.router do
  route 'Authorized callers', :to => /789/ do
    menu...
  end

  route 'Everyone else' do
    ...
  end
end
</pre>

For now the menu usage details are omitted; we will cover the new Menu DSL in a separate post. Rest assured, it is better.

In the above example the to attribute of the incoming Call object is matched against a regex. This is supplied using hash syntax. This entire matching routine uses a system extracted by Jeff Smick's excellent Blather XMPP client library, called [has-guaded-handlers](https://github.com/adhearsion/has-guarded-handlers), which in turn borrows from the idea of [Guards](http://en.wikibooks.org/wiki/Erlang_Programming/guards) from [Erlang](http://www.erlang.org/). The route will be allowed to match a call only if all of its guards are satisfied.

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
    Back to <a href="/docs/plugins">Plugins</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/config">Config</a>
  </span>
</div>
