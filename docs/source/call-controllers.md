## Call Controllers

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

Unfortunately, dialplan.rb contexts and their contents are not particularly testable. It is also not very easy to compose complex operations, and spaghetti code can quickly result. The solution to this in many of our Adhearsion 1.x applications was a structure like this:

dialplan.rb:

<pre class="brush: ruby;">
adhearsion { do_super_secret_project_call }
</pre>

component/super_secret_project.rb:

<pre class="brush: ruby;">
methods_for :dialplan do
  def do_super_secret_project_call
    SuperSecretProjectCall.new(self).run
  end
end

class SuperSecretProjectCall
  def initialize(dialplan)
    @dialplan = dialplan
  end

  def run
    pin = collect_pin
    ...
  end

  def collect_pin
    @dialplan.input 4
  end
end
</pre>

This is better, but there is a lot of boilerplate and this style of writing applications was not well documented. The solution? A brand new mechanism for Adhearsion 2 named Call Controllers.

No longer are Adhearsion applications limited to being simple scripts. With Call Controllers, Adhearsion applications become real MVC applications. A controller is, well, the controller; the call object is the 'view' (being the method of interaction between the human and the application, it qualifies here, even though it is not actually visible); and one may use whatever models one likes, be they backed by a database, a directory (like LDAP) or anything else. Indeed, one might wish to make use of a second view, such as an XMPP interaction or some kind of push-based rendering to a visual display.

So, how does one write an application based on call controllers? Simple: create a class inheriting from Adhearsion::CallController, ensure it responds to #run, drop it into the lib/ directory and route calls to it as described above. That might look something like this:

config/adhearsion.rb:

<pre class="brush: ruby;">
Adhearsion.routes do
  route 'default', SuperSecretProjectCall
end
</pre>

lib/super_secret_project_call.rb:

<pre class="brush: ruby;">
class SuperSecretProjectCall < Adhearsion::CallController
  def run
    pin = collect_pin
    ...
  end

  def collect_pin
    input 4
  end
end
</pre>

As you can see, a route definition can take a class rather than a block, and it will use that call controller for the call (in fact, when you pass a block to #route, you are actually creating a call controller under the covers). The controller class itself lives in the lib directory, which, by default, is auto-loaded by Adhearsion. You may configure this like so:

config/adhearsion.rb:

<pre class="brush: ruby;">
Adhearsion.config do |config|
  config.lib = 'application/call_controllers'
end
</pre>

Within a call controller, you have access to all of the usual dialplan DSL methods as instance methods, and you also have access to the call object (#call). In addition, it is possible to define some callbacks to be executed at the appropriate time. These are before_call and after_call, they are class methods, and they take either a block or a symbol (called as an instance method) like so:

lib/super_secret_project_call.rb:

<pre class="brush: ruby;">
class SuperSecretProjectCall < Adhearsion::CallController
  before_call do
    @user = User.find_by_phone_number call.from
  end

  after_call :save_user

  def run
    pin = collect_pin
    ...
  end

  def collect_pin
    input 4
  end

  def save_user
    @user.save
  end
end
</pre>

Testing call controllers is easy, but we have covered quite enough for today, so that topic will be revisited in a future blog post. Additionally, there will be other features added to call controllers, probably in Adhearsion 2.1, like ticked timers (allowing, for example, to check an account balance every minute of the call). Further, Adhearsion 2 will include generators for call controllers as well as some test scaffolding. Watch out for further details coming soon.

### Menu DSL

Rapid and painless creation of complex IVRs has always been one of the defining features of Adhearsion for beginning and advanced programmers alike. Through the #menu DSL method, the framework abstracts and packages the output and input management and the complex state machine needed to implement a complete menu with audio prompts, digit checking, retries and failure handling, making creating menus a breeze.

The menu DSL has received a major overhaul in Adhearsion 2.0, with the goals of clarifying syntax and adding functionality.

#### The Old Way

The Adhearsion 1.x menu structure used to work as follows, with the now obsolete concept of a dialplan and context.

<pre class="brush: ruby;">
foo {
  menu "Press 1 for Administration", "Press 2 for Tech Support",
       :timeout => 8.seconds, :tries => 3 do |link|
    link.admin 1
    link.tech 2
    link.on_invalid do
      speak 'Invalid input'
    end

    link.on_premature_timeout do
      speak 'Sorry'
    end

    link.on_failure do
      speak 'Goodbye'
      hangup
    end
  end
}

admin {
  speak 'You have reached the Administration department'
}

tech {
  speak 'You have reached the Technical Support office'
}
</pre>

The main shortcomings of this structure were mostly related to the inherent difficulty of maintaining a complex dialplan all in a single file, or breaking it up in helper components with no imposed logical structure. The old DSL was also not very intuitive, as you were specifying the target for the link before the pattern, in addition to having the block argument as a basically redundant part.

#### The New & Improved Way

The focus for the menu DSL in Adhearsion 2.0 was primarily on improving its functionality to work with call controllers and to fit the new framework structure. Working towards those goals, the menu definition block was streamlined while keeping readability and the general functionality of 1.x.

<pre class="brush: ruby;">
class MyController < Adhearsion::CallController
  def run
    answer
    menu "Where can we take you today?",
         :timeout => 8.seconds, :tries => 3 do
      match 1, BooController
      match "2", MyOtherController
      match 3, 4, { pass YetAnotherController }
      match 5, FooController
      match 6..10 do |dialed|
        say_dialed dialed
      end

      timeout { do_this_on_timeout }

      invalid do
        invoke InvalidController
      end

      failure do
        speak 'Goodbye'
        hangup
      end
    end

    speak "This code gets executed unless #pass is used"
  end

  def say_dialed(dialed)
    speak "#{dialed} was dialed"
  end

  def do_this_on_timeout
    speak 'Timeout'
  end
end
</pre>

The first arguments to #menu are a list of sounds to play, as accepted by #play, including strings for TTS, Date and Time objects, and file paths. #play and the other input and output methods, all renovated, will be covered in a subsequent post. Sounds will be played at the beginning of the menu and after each timeout or invalid input, if the maximum number of tries has not been reached yet.

The :tries and :timeout options respectively specify the number of tries before going into failure, and the timeout in seconds allowed before the first and each subsequent digit input.

The most important section is the following block, which specifies how the menu will be constructed and handled.

The #match method takes an Integer, a String, a Range or any number of them as the required input(s) for the match payload to be executed. The last argument to a #match is either the name of a CallController, which will be invoked, or a block to be executed. Matched input is passed in to the associated block, or to the controller through it instance variable @options[:extension].

\#menu executes the payload for the first exact unambiguous match it finds after each input or timing out. In a situation where there might be overlapping patterns, such as 10 and 100, #menu will wait for timeout after the second digit.

Internally, the state machine has been re-implemented without using exceptions as a mean for flow control, which was a concern for #menu usage in begin..rescue blocks.

\#timeout, #invalid and #failure replace #on_invalid, #on_premature_timeout and #on_failure. All of them only accept blocks as payload, but #pass or #invoke can be used to execute controllers inside them.

\#invalid has its associated block executed when the input does not possibly match any pattern. #timeout block is run when time expires before or between input digits, without there being at least one exact match. #failure runs its block when the maximum number of tries is reached without an input match.

Execution of the current context resumes after #menu finishes. If you wish to jump to an entirely different controller, #pass can be used. #menu will return :failed if failure was reached, or :done if a match was executed.

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/getting-started/installation">Installation</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/plugins">Plugins</a>
  </span>
</div>
