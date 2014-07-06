# Calls

[TOC]

Adhearsion's primary state primative is its `Call` objects, which represent an individual call/leg/channel in an Adhearsion application, and its sub-class `OutboundCall` which represents an outbound call *from* Adhearsion. These objects are created at the point at which a new call can be identified (an offer from the VoIP engine, or a request to dial out from application code) and are kept alive until such time as the call ends. In MVC terms, they can be thought of as occupying the View role.

## Expiry

You may have got to this page from the link in the message of a `Adhearsion::ExpiredError` exception. These exceptions are raised in the case where a call actor has been shut down because the call ended, or has crashed for some other reason (a separate exception will have been raised earlier from *inside* the actor). Once this shutdown has occurred, you can no longer meaningfully call methods on the Call.

In reality, a Call actor can outlive the call it represents - by default, they will live for one second after a call is hung up, giving you time to extract state such as SIP headers. You can configure this value using the `after_hangup_lifetime` config option; see [/docs/config](the configuration docs) for more details. This value was reduced in Adhearsion 2.5 from 30 seconds in order to provide improved default performance for the large majority of apps which do not need long-living zombie calls; the lower you can keep this value while maintaining the functionality your app requires, the better.

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/console">Console</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/call-controllers">Call Controllers</a>
  </span>
</div>
