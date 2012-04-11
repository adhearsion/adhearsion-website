[TOC]

Upgrading from Adhearsion 1.x to 2.0
====================================

Adhearsion 2.0 brings many changes.  It marks the first time since release 0.8.0 in 2008 that we have broken backward compatibility with previous versions.  This means that, while you have access to a rich set of new features, it also means existing applications will need to be ported to run on Adhearsion 2.  This document aims to list the changes required to migrate an Adhearsion 1.x application up to Adhearsion 2.

## Prerequisites

Adhearsion 2.0 has an all new list of prerequisites.  Before going any further, please see the [Prerequisites](/docs/getting-started/prerequisites) page.

## ahn_log has become logger

This is mostly a simple search & replace change.  Find all instances of "ahn_log" and replace them with "logger".  However, we have also deprecated logger namespaces.  For example, "ahn_log.myapp.info" would log messages within the "myapp" namespace.  This is no longer supported so it would need to become "logger.info".  Fortunately we have added a lot more information to the default logging formatter that includes the originating class name that generated the log message. Hopefully have a minimal or net positive impact to most applications.

## No more dialplan.rb

This is the single most visible change.  Previously, and Adhearsion application's entry point was dialplan.rb, and the entry point in dialplan.rb was driven by the context provided by Asterisk.  Since Adhearsion 2.0 runs on multiple platforms, and the concept of a "context" is Asterisk-specific, we needed to do something different.  The recommended way to migrate dialplan.rb is to break each dialplan.rb block up into a separate [CallController](/docs/call-controllers). Then you will need to add routes to config/adhearsion.rb that map Asterisk contexts to the new CallControllers.  For example, given the following dialplan.rb:

<pre class="brush: ruby;">
adhearsion {
  simon_game
}

my_menu {
  menu 'welcome' do |link|
    link.shipment_status  1
    link.ordering         2
    link.representative   0
  end
}

shipment_status {
  # ...
}

ordering {
  # ...
}

representative {
  dial 'SIP/operator'
}

fibonacci {
  i = 1
  last_i = 0
  loop do
    say_digits i
    last_i, i = i, i + last_i
  end
}
</pre>

Would become the following three CallController classes:

<pre class="brush: ruby;">
class MyMenu < Adhearsion::CallController
  def run
    # Important! Adhearsion 2 no longer auto-answers the call
    answer
    menu 'welcome', do
      match 1, ShipmentStatus
      match 2, Ordering
      match 3 do
        dial 'SIP/operator'
      end
  end
end

class ShipmentStatus < Adhearsion::CallController
  def run
    # ...
  end
end

class Ordering < Adhearsion::CallController
  def run
    # ...
  end
end

class Fibonacci < Adhearsion::CallController
  def run
    answer
    i = 1
    last_i = 0
    loop do
      say_digits i
      last_i, i = i, i + last_i
    end
  end
end
</pre>
SimonGame is already a CallController so no wrapper class is required.

Next you will need to map the Asterisk contexts back to these CallControllers.  This is in config/adhearsion.rb:

<pre class="brush: ruby;">
Adhearsion.router do
  route 'adhearsion context', SimonGame, [:[], :agi_context] => 'adhearsion'
  route 'my_menu context', MyMenu, [:[], :agi_context] => 'my_menu'
  route 'fibonacci context', Fibonacci, [:[], :agi_context] => 'fibonacci'
end
</pre>

## No more events.rb

Just as with dialplan.rb, events.rb has been deprecated and removed.  However the powerful event handling system has only become more powerful in Adhearsion 2.0.  Events can now easily be defined anywhere in your application.  You may choose to put them into config/adhearsion.rb if you have a small number of events.  However, in most cases it makes sense to package your event handling code either as a standalone class or along with a related CallController.  This approach makes testing event handlers much easier.

One other advantage to the new eventing system is the flexibility with which you can subscribe to events.  Instead of receiving all Asterisk Manager Interface events and then filtering in application code based on the name, you may elect to register to receive only specific events.  More on this is described in the [Events documentation](/docs/events).

Given an example events.rb:

<pre class="brush: ruby;">
events.after_initialized.each do
  ahn_log.info "Adhearsion has finished starting up and all I got was this lousy :after_initialized event..."
end

events.exception.each do |e|
  ahn_log.info "Ack! I got an exception! The sky is falling and it smells like #{e.class}"
end

events.asterisk.manager_interface.each do |event|
  case event.name
  when 'NewChannel'
    ahn_log.info "A new channel has been created: #{event.inspect}"
  when 'NewState'
    ahn_log.info "A channel is changing state: #{event.inspect}"
  end
end
</pre>

Would become something like this:
<pre class="brush: ruby;">
Adhearsion::Events.draw do
  after_initialized do
    ahn_log.info "Adhearsion has finished starting up and all I got was this lousy :after_initialized event..."
  end

  exception do |e|
    logger.info "Ack! I got an exception! The sky is falling and it smells like #{e.class}"
  end
end
</pre>

Asterisk Manager Interface events are a little different. In the case of "NewChannel" events, we may prefer to register for Punchblock::Offer events, which will work on Asterisk as well as Rayo or any other supported telephony engine in the future. There is an important distinction here thought:

* AMI "NewChannel" events report every new channel that is created in Asterisk, whether or not that call is ultimately routed to Adhearsion.
* Punchblock::Offer events only fire for calls that are routed to Adhearsion.

Most telephony backends do not offer a functional equivalent of the NewChannel event so there is no direct replacement.  Be aware of the differences here.  For the purposes of this document, we will assume that Punchblock::Offer events are sufficient for our needs.

Examples:
<pre class="brush: ruby;">
Adhearsion::Events.punchblock Punchblock::Offer do |offer|
  # This block will only be invoked with Punchblock::Offer events
  logger.info "A new channel has been created: #{offer.inspect}"
end

Adhearsion::Events.ami :name => 'NewState' do |state|
  # This block will only be invoked with "NewState" AMI events
  logger.info "A channel is changing state: #{state.inspect}"
end
</pre>

For examples on using the XMPP events within Adhearsion 2.0, please see [the adhearsion-xmpp plugin page](https://github.com/adhearsion/adhearsion-xmpp).
