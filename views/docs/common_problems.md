# Common Problems

[TOC]

## Unrenderable document error

It is common to see the following error on Asterisk:

```
[2012-06-14 12:08:46] ERROR Adhearsion::Call: 008410de-feb6-48a6-9390-2388a89412ef: Error playing back the prompt: Output failed for argument "5" due to #<Punchblock::ProtocolError: name="unrenderable document error" text="The provided document could not be rendered." call_id=nil component_id=nil>
```

What this means is that the requested output document could not be rendered on the call, and ocurrs most commonly when using Asterisk or FreeSWITCH without a text to speach engine, but attempting to use the speak/say CallController methods. In this case, Asterisk cannot invoke text-to-speech and so raises this error.

Many people see this error when calling into a default generated Adhearsion application on Asterisk, and this is because the SimonGame uses text-to-speech.

## Stack exhaustion

A stack error is sometimes encountered when running on Ruby 1.9.3 via RVM, looking similar to the following:

```
[2012-11-15 21:32:45] ERROR Celluloid: Punchblock::Translator::Freeswitch crashed!
SystemStackError: stack level too deep
```

It is a [known issue with Celluloid and RVM](https://github.com/celluloid/celluloid/wiki/Fiber-stack-errors), and the best solution is to uninstall your current Ruby, update RVM using "rvm get head" and reinstall Ruby.

rbenv does not exhibit this issue.

If after following the above steps, you have not reached a resolution, please take the following steps:

1. [File an issue](http://github.com/adhearsion/adhearsion/issues) following the [usual guidelines](http://adhearsion.com/docs/dealing-with-bugs#toc_2).
2. [Fill in a form providing extra details](https://docs.google.com/a/langfeld.co.uk/forms/d/1MDaKgRK8-4nbY3IropyQrTzc7ofqrVvDZr4Ejm68sEQ/viewform), making sure to link to the ticket you created.

## Dropped DTMF

Adhearsion core's implementation of `CallController#ask` and `CallController#menu` suffer from a race condition between DTMF keypresses which can cause digits to be dropped. This problem is exacerbated by the use of the block validator syntax. The [adhearsion-asr](http://github.com/adhearsion/adhearsion-asr) plugin has been prepared with replacements for these methods which you are encouraged to use, and they will replace the core methods in Adhearsion 3.0.

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/upgrading">Upgrading</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/dealing-with-bugs">Dealing with bugs</a>
  </span>
</div>
