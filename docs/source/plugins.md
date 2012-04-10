# Plugins

[TOC]

The ability to easily add reusable functionality to a framework is one of its most important features. The Plugin system in Adhearsion 2.0 has been completely redesigned to provide a wider range of integration points.

### What is an Adhearsion 2.0 Plugin?

A plugin in Adhearsion, as in many other Ruby frameworks, simply represents a collection of functionality. Most often plugins add new functionality to your calls in the form of modules used as mixins to the base CallController class. This functionality is packaged as a gem to facilitate its installation, reuse, and sharing with the community. CallController methods, initializer code, integrated configuration, rake tasks and code generators all are possible with the new plugin classes.

### Anatomy of a Plugin

The easiest way to create a skeleton plugin is to use the Adhearsion command "ahn generate".
By running the following ahn generate plugin GreetPlugin a directory named greet_plugin will be created in the current working directory. The plugin itself, being a gem, can reside anywhere, unlike components that needed to be inside the application directory. The output from this command should show the files being created, like this:

<pre class="terminal">
{{ d['plugins.sh|idio|shint|ansi2html']['generate-plugin'] }}
</pre>

### Gem Plugin Structure

The greet_plugin.gemspec file contains information on your plugin, including required dependencies, contact information and other metadata. Enter your contact information, the name and description of your plugin and list any development and runtime dependencies to have a fully functional gem.

The README is customarily formatted in Markdown and its use is strongly encouraged to help people understand how to use your plugin.

The Rakefile contains tasks that pertain to the plugin gem itself, such as running unit tests. Note that it is separate from adding tasks to Adhearsion applications; this will be covered below.

### Plugin Files

The entry point for the plugin, as usual with gems, resides in lib/greet_plugin.rb. It is mainly composed of requires for the plugin classes and modules. When adding functionality to a plugin, it will need to be require'd here to be available. Plugins are namespaced by package name to avoid conflicts.

lib/greet_plugin.rb:

<pre class="brush: ruby;">
{{ a['plugins.sh|idio|shint|ansi2html']['generate-plugin:files:source/myapp/greet_plugin/lib/greet_plugin.rb'] }}
</pre>

In this example Adhearsion plugin:
* version.rb contains the current version number for the plugin, and is used during packaging.
* plugin.rb contains the hooks into the Adhearsion framework that are called when the plugin is loaded by the Adhearsion application.
* controller_methods.rb contains a module that gets mixed into the base CallController class, making its methods available to all calls running in Adhearsion.

<pre class="brush: ruby;">
# lib/greet_plugin/plugin.rb
module GreetPlugin
  class Plugin < Adhearsion::Plugin
    # Actions to perform when the plugin is loaded
    #
    init :greet_plugin do
      logger.info "GreetPlugin has been loaded"
    end

    # Basic configuration for the plugin
    #
    config :greet_plugin do
      greeting "Hello", :desc => "What to use to greet users"
    end

    # Defining a Rake task is easy
    # The following can be invoked with:
    #   rake plugin_demo:info
    #
    tasks do
      namespace :greet_plugin do
        desc "Prints the PluginTemplate information"
        task :info do
          STDOUT.puts "GreetPlugin plugin v. #{VERSION}"
        end
      end
    end
  end
end
</pre>

In plugin.rb there are three important blocks shown.
* The first is the #init block which is invoked by Adhearsion when the plugin is first loaded. In this case, all this does is write an informational message to the log showing that the plugin was, in fact, loaded.
* The second is the #config block that registers configuration options with the Adhearsion framework. This is important because it allows your users to easily discover the possible configuration options for your plugin by simply running rake config:show within their Adhearsion applications. It also allows you to document the configuration options and set default values.
* The third block is the #tasks block, which registers Rake tasks to be available within the Adhearsion application. In this case it adds a Rake task called greet_plugin:info that prints the version number of the plugin.

## Plugin Initialization

Every plugin goes through two separate phases before it is ready to run. While Adhearsion is starting up, and prior to taking any calls, the plugin first gets initialized through a supplied #init block. This block may be used to set up any basic requirements or validate the configuration. Later, after the Adhearsion framework has booted, the optional #run block is called to start the plugin. An example of using this two step startup of #init and #run methods might be an IRC plugin. In the #init method, the IRC class is instantiated and configured, but no connection to the server is made. Then in #run the actual connection is opened and the service begins. Both methods are optional, but if they are defined, the mandatory arguments are the name of the plugin as a symbol and a block to provide the code to be run. A plugin can also request to be initialized before or after another plugin by name, using the :before and :after options passed as an hash to #init and/or #run.

Note that your #run method must not block indefinitely!  If necessary, place the contents of your run block within a thread so that Adhearsion can continue to start the other plugins:

<pre class="brush: ruby">
module GreetPlugin
  class Plugin < Adhearison::Plugin
    def run
      Thread.new do
        catching_standard_errors { my_blocking_runner_method }
      end
    end
  end
end
</pre>

Note the use of catching_standard_errors.  This ensures that any exceptions raised within your plugin are routed through Adhearsion's exception handling event system.  More information on this can be found in the best practices guide.

## Plugin Configuration

The #config block allows a plugin to define configuration values in a customizable and self-documenting way. Every configuration key has a name followed by its default value, and then by a :desc key to allow for a description. This is very important!  By allowing your plugin to be configured this way, its options will be exposed via rake config:show in an application directory.  Additionally, you will be able to set configuration options via the shell environment, which is handy for services like Heroku.

A config line can also validate supplied values with a transform:

<pre class="brush: ruby;">
max_connections 5, :desc => "Maximum number of connections to make",
                   :transform => lambda { |v| v.to_i }
</pre>
The :transform will be used to modify the configuration value after it is read from the end-user's setting.

## Plugin Rake Tasks

The #tasks method allows the plugin developer to define Rake tasks to be made available inside an Adhearsion application. Task definitions follow Rake conventions.

## Making the plugin useful

In our exploration of a newly generated plugin, we have so far mostly looked at the facilities Adhearsion provides to hook into the framework and your application. While simple plugins that are nothing more than rake tasks and generators have their place, you probably want to go further.  This section will discuss how to add funtionality to Adhearsion calls.

A plugin is at its heart simply a Ruby gem, and bundled code needs to be loaded through requiring the proper files.
The generated plugin has a single business logic file in lib/controller_methods.rb. Neither the file name nor the module name are mandatory, this is just normal Ruby code.

### Plugin Code

Content is as follows:

lib/controller_methods.rb

<pre class="brush: ruby;">
module GreetPlugin
  module ControllerMethods
    # The methods are defined in a normal method the user will then
    # mix in their CallControllers.
    # The following also contains an example of configuration usage.
    #
    def greet(name)
      play "#{Adhearsion.config[:greet_plugin].greeting}, #{name}"
    end
  end
end
</pre>
The module is intended to be used as a mixin in call controllers.

### Testing your code

Module usage can be seen in action in the generated test file, which also illustrates how the call controller methods can be easily tested.

spec/greet_plugin/controller_methods_spec.rb

<pre class="brush: ruby;">
require 'spec_helper'
module GreetPlugin
  describe Plugin do
    describe "mixed in to a CallController" do
      class TestController < Adhearsion::CallController
        include GreetPlugin::ControllerMethods
      end

      let(:mock_call) { mock 'Call' }

      subject do
        TestController.new mock_call
      end

      describe "#greet" do
        it "greets with the correct parameter" do
          subject.expects(:play).once.with("Hello, Luca")
          subject.greet "Luca"
        end
      end
    end
  end
end
</pre>
Since plugin code is a normal Ruby library, it can be tested using familiar tools like Test::Unit or RSpec.

Note that, at first, Adhearsion Routes or XMPP handlers may seem difficult to test.  However, a good practice is to put all your business logic into classes and methods, and then simply invoke the methods from the routes or handlers.  In this way you can maintain good code test coverage and keep your route definitions small and readable.

### Using the plugin

You have generated your new plugin, built tests and are ready to use it. Now what?
The plugin is a gem, so you might eventually publish it. In the meantime you can simply use it locally by adding a path line to your application's Gemfile.

Gemfile

<pre class="brush: ruby;">
gem 'adhearsion', '>= 2.0.0'
gem 'greet_plugin', :path => '/home/user/projects/greet_plugin'

# ... whatever other gems you need
</pre>

Do not forget to run 'bundle install' after adding the gem.

### Adding an entire CallController

It is also possible to provide a full CallController implementation that can be used out-of-the-box by your application. There is an entire section of the documentation dedicated to [CallControllers](docs/call-controllers).  Please refer to that section for full details on available methods within CallControllers.
Below you will see how to create a new controller in the plugin, complete with new configuration keys and test. Our goal is to have a controller that dials a SIP device during office hours and plays a message when the office is closed.

#### Setup

First, add configuration variables to allow controlling the time-of-day routing:

lib/greet_plugin/plugin.rb

<pre class="brush: ruby;">
config :greet_plugin do
  greeting "Hello", :desc => "What to use to greet users"
  office_hours_start 8, :desc => "Start of office hours, integer, 24 hour format"
  office_hours_end 18, :desc => "End of office hours, integer, 24 hour format"
end
</pre>

One way to make testing time-based features easy is to use the Timecop gem. Just add it to your gemspec under the development group and add "require 'timecop'" at the top of spec/spec_helper.rb.

#### Tests first!

Now add a few tests, taking advantage of Adhearsion's testing facilities and the generated helpers. The tests describe what will be implemented in the controller.

spec/hours_controller_spec.rb

<pre class="brush: ruby;">
require 'spec_helper'
module GreetPlugin
  describe HoursController do
    let(:mock_call) { mock 'Call' }
    subject do
      HoursController.new mock_call
    end

    it 'dials out when inside office hours' do
      Timecop.freeze Time.utc(2012, 3, 8, 12, 0, 0)
      subject.expects(:dial).once
      subject.run
    end

    it 'plays a message when outside office hours' do
      Timecop.freeze Time.utc(2012, 3, 8, 22, 0, 0)
      subject.expects(:play).once
      subject.run
    end
  end
end
</pre>

#### The CallController

Last but not least, the actual CallController.

lib/greet_plugin/hours_controller.rb

<pre class="brush: ruby;">
module GreetPlugin
  class HoursController < Adhearsion::CallController
    def run
      if in_office_hours
        dial "SIP/101"
      else
        say "Our office is open between #{config.office_hours_start} and #{config.office_hours_end}. Please call back later."
      end
    end

    private

    def in_office_hours
      Time.now.hour.between? config.office_hours_start, config.office_hours_end
    end

    def config
      Adhearsion.config[:greet_plugin]
    end
  end
end
</pre>

#### Routes
To make calls in the application reach this controller, you will need to create a route. The example below uses a generic route that matches all calls (no filters).

my_application_dir/config/adhearsion.rb

<pre class="brush: ruby;">
Adhearsion.router do
  route 'default', GreetPlugin::HoursController
end
</pre>

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/logging">Logging</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/best-practices">Best Practices</a>
  </span>
</div>
