# Common Problems

[TOC]

## Unrenderable document error

It is common to see the following error on Asterisk:

[2012-06-14 12:08:46] ERROR Adhearsion::Call: 008410de-feb6-48a6-9390-2388a89412ef: Error playing back the prompt: Output failed for argument "5" due to #<Punchblock::ProtocolError: name="unrenderable document error" text="The provided document could not be rendered." call_id=nil component_id=nil>

What this means is that the requested output document could not be rendered on the call, and ocurrs most commonly when using Asterisk or FreeSWITCH without a text to speach engine, but attempting to use the speak/say CallController methods. In this case, Asterisk cannot invoke text-to-speech and so raises this error.

Many people see this error when calling into a default generated Adhearsion application on Asterisk, and this is because the SimonGame uses text-to-speech.

## Stack exhaustion

A stack error is sometimes encountered when running on Ruby 1.9.3 via RVM, looking similar to the following:

[2012-11-15 21:32:45] ERROR Celluloid: Punchblock::Translator::Freeswitch crashed!
SystemStackError: stack level too deep

It is a known issue with Celluloid and RVM, and the best solution is to uninstall your current Ruby, update RVM using "rvm get head" and reinstall Ruby.

rbenv does not exhibit this issue.

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/upgrading">Upgrading</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/dealing-with-bugs">Dealing with bugs</a>
  </span>
</div>
