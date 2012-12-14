# [Best Practices](/docs/best-practices) > Testing

[TOC]

## Differences from the Web

Testing telephony applications is a lot like testing web applications.  Much of the toolchain is the same; inside Adhearsion we use [rspec](https://www.relishapp.com/rspec), [cucumber](http://cukes.info), [guard](https://github.com/guard/guard) and [simplecov](https://github.com/colszowka/simplecov).  For testing apps we also use tools like [FactoryGirl](https://github.com/thoughtbot/factory_girl/), [fakeweb](https://github.com/chrisk/fakeweb/) and [vcr](https://github.com/myronmarston/vcr/).  The fundamentals of testing Ruby classes is of course the same: construct a set of test inputs, set up expectations for outputs and behavior, then run the code.

However there are some important differences, especially with how you think about testing your application:

* Adhearsion applications are (semi-)long-running. The lifecycle of a web request is usually very short, measured in milliseconds.  The lifecycle of a telephone call may be measured in minutes or hours. This has an impact when thinking of the resources you consume, especially things like database pool handles or large chunks of memory.
* Your inputs may be more limited as callers traditionally only have access to DTMF to send you information.
* But you also need to consider what happens when mixing in inputs from sources like XMPP or Speech Recognition.  When using Speech Recognition in particular it is important to consider the ways in which your expected input may be interpreted incorrectly.
* Most importantly, in the context of a call, lots of things are happening concurrently: call events (joined/unjoined, active speaker notifications, billing events) and external events (XMPP instant messages or presence updates, interaction from other calls, etc).


## Unit testing
Unit testing is attempting to test an individual unit in isolation.  You will construct a set of inputs, define expectations (or mocks, if necessary) on any external behavior, and validate the result returned.  Typically a unit is a single method within a class.

For example, given a class that looks like this:

```ruby
class MyApp
  def double(in)
    in * in
  end
end
```

You would want to have the following tests:

* Ensure that for a given input the output was twice the input
* Tests to ensure that a consistent behavior is encountered when non-Fixnum inputs are used (should it raise? return nil?)

<br>
### Call Controllers
Beyond testing basic functionality it becomes important to test how your calls will interact with your application.  Most of that interaction happens within [Call Controllers](/docs/call-controllers).  Because Call Controllers are simply classes that inherit from the Adhearsion::CallController class, testing these is just like testing any other Ruby class.  However you will likely want to mock out the methods where the telephone call interacts with the framework, such as <code>#ask</code>, <code>#play</code>, <code>#answer</code> and <code>#hangup</code>.  For example, a Call Controller like this:

```ruby
class MyApp < Adhearsion::CallController
  FACTOR = 2
  def run
    answer
    result = ask "How much is #{FACTOR} times #{FACTOR}?"
    if result.response == double FACTOR
      play "tt-weasels"
    end
    hangup
  end
end
```

You would want to have the following in your tests (these would be satisfied across several individual tests):

* An assertion that <code>#answer</code> was invoked first
* An assertion that <code>#ask</code> was called with the correct question string ("How much is 2 times 2?")
* Mocking the result from <code>#ask</code> to pretend that the caller pressed a DTMF digit
* An assertion that <code>#play</code> was called with "tt-weasels" *only if* the mocked result is "4"
* An assertion that <code>#hangup</code> was invoked last

A sample controller test might look something like this:

```ruby
require 'spec_helper'

describe MyController do
  let(:mock_call) { mock 'Call', :to => '1112223333', :from => "2223334444" }
  let(:metadata)  { {} }

  subject { MyController.new mock_call, metadata }

  its(:metadata) { should eq({}) }
end
```

This is a skeleton for controllers that will pass with a controller generated using Adhearsion's generator utility.

<br>
### Plugins
Please see the documentation on the [Plugins](/docs/plugins#testing-your-code) page.

## Integration Testing
<img src="/images/vertical-integration.jpg" style="float: right;">
Integration testing is the attempt to test the interaction between two or more pieces of an application.  This may even be an entire application end-to-end. The goal then is to provide your inputs and measure their results without making assertions on *how* the code makes them happen.  Said another way: the implementation details are unimportant, but the observable behavior is.  For example, you may describe test inputs like this:

* Caller dials 14045551234
* Caller hears the "greeting" prompt
* Caller dials "1"
* Caller hears the "directions" prompt
* Caller hangs up
* The Call Detail Record is written to the database

This syntax may sound like Cucumber, and it is.  Cucumber is one of the tools used in setting up integration tests.

Here are some of the other tools often used to effect integration testing:

* [SIPp](http://sipp.sourceforge.net) was originally designed to load test SIP systems, but its generic XML format can be used to set up call flows.  It is not a particularly easy tool to use, but it does scale well and there are not many other options for tools in this category.
* [LoadBot](https://github.com/mojolingo/ahn-loadbot) is actually an Adhearsion 1.x application that was written for testing other Adhearsion apps.  However, because it tests over a telephone call, it can be used to test any system, including systems not using Adhearsion at all.  The primary benefit of LoadBot over SIPp is simplicity: LoadBot's call actions are described in a simple YAML format making testing very easy.
* [Cucumber-VoIP](https://github.com/benlangfeld/cucumber-voip) is a plugin for Cucumber that intends to allow you to write BDD-style tests and make assertions on the audio as heard by the speech engine. This tool is not yet fully realized but may still be helpful.

<a href="#" rel="docs-nav-active" style="display:none;">docs-nav-best-practices</a>

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/best-practices">Best Practices</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/best-practices/deployment">Deployment</a>
  </span>
</div>
