# Console

[TOC]

When starting an Adhearsion app in the foreground (ahn start), a console is provided to interact with the application and its calls. It is possible to take control of currently active calls, execute commands on them, make outbound calls, etc.

## Taking a currently active call

When a call has one or more controllers running against it, it is possible to sieze control of the call using the console `#take` method. You may either supply the call's ID or the call object itself, or supply no parameters and be presented with a list of calls to choose from. If there is only one active call, you will not be presented with a choice.

<pre class='terminal'>

AHN> take
Please choose a call:
 # (inbound/outbound) details
0: (i) 5vg6dkqc-lx7-2zujv5xbe7zd from sip:rwkdjpmu@192.168.1.74 to sip:usera@127.0.0.1
1: (i) 5vg6dkqc-lx7-2n2wgrzooard from sip:rwkdjpmu@192.168.1.74 to sip:usera@127.0.0.1
 #> 1
AHN<5vg6dkqc-lx7-2n2wgrzooard>
</pre>

Once you have control of a call, other controllers will stop executing (at the next time they try to run a command against the call) and you may use any CallController methods you like. The console itself is just an interactive CallController.

## Routing calls directly to the console

It is not currently possible to route calls directly to the console, but this feature is coming soon. In the meantime, the following hack is a potential solution, preventing the router from hanging up the call so that you can grab control in the console:

```ruby
Adhearsion.routes do
  openended do
    route 'ConsoleCatch' do
      logger.info "Call #{call.id} waiting..."
    end
  end
end
```

## Making outbound calls

The current preferred method of making an outbound call is like so:

<pre class='terminal'>

AHN> Adhearsion::OutboundCall.originate 'sip:arabbit@mojolingo.com', from: 'sip:foo@bar.com'
</pre>

The call will pass through the router in the same way as an incoming call.

Note that if you are using Asterisk, the format is slightly different. The example below is SIP, but you can use any channel tecnology that Asterisk supports: SIP, IAX2, SKINNY, etc

<pre class='terminal'>
AHN> Adhearsion::OutboundCall.originate 'SIP/user1'
</pre>

As well, if you need to place calls out into the outside world, you may get an error message 
such as "I don't know how to authenticate..." if you try to call directly. 
A solution to this is to use the Local channel which allows you to call an extension in a context.
 
So, for example, if in your extensions.conf, you could have something such as:
```ruby
[outbound]
exten => _X!,1,Dial(SIP/sip-outbound/${EXTEN})
```
Then you could do the following:
<pre class='terminal'>
AHN> Adhearsion::OutboundCall.originate 'Local/4443@outbound/n'
</pre>

Note the "/n" at the end as otherwise you end up with dead channels (see: http://www.voip-info.org/wiki/view/Asterisk+local+channels)

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/getting-started/installation">Installation</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/calls">Calls</a>
  </span>
</div>
