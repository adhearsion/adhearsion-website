# Console

[TOC]

When starting an Adhearsion app in the foreground (ahn start), a console is provided to interact with the application and its calls. It is possible to take control of currently active calls, execute commands on them, make outbound calls, etc.

## Taking a currently active call

When a call has one or more controllers running against it, it is possible to sieze control of the call using the console #take method. You may either supply the call's ID or the call object itself, or supply no parameters and be presented with a list of calls to choose from. If there is only one active call, you will not be presented with a choice.

<pre class='terminal'>
  <br/>
AHN> take
</pre>

Once you have control of a call, other controllers will stop executing (at the next time they try to run a command against the call) and you may use any CallController methods you like. The console itself is just an interactive CallController.

## Routing calls directly to the console

It is not currently possible to route calls directly to the console, but this feature is coming soon. In the meantime, the following hack is a potential solution, giving you enough time after the call comes in to grab it in the same way as any other:

<pre class="brush: ruby;">
Adhearsion.routes do
  route 'ConsoleCatch' do
    logger.info "Call #{call.id} waiting..."
    sleep 10
  end
end
</pre>

## Making outbound calls

The current preferred method of making an outbound call is like so:

<pre class='terminal'>
  <br/>
AHN> Adhearsion::OutboundCall.originate 'sip:arabbit@mojolingo.com', :from => 'sip:foo@bar.com'
</pre>

The call will pass through the router in the same way as an incoming call.

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/getting-started/installation">Installation</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/call-controllers">Call Controllers</a>
  </span>
</div>
