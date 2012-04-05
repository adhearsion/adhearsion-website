# Plugins

[TOC]

The ability to easily add reusable functionality to a framework is one of the most important features. Plugins in Adhearsion 2.0 have been completely rebuilt to better suit the new structure and allow them to provide a wider variety of features. Controller methods, initializer code, specific configuration, rake tasks and included generators all are possible with the new plugin classes. In this first post we will be generating a plugin using the CLI and looking through the resulting code.

### Components in Adhearsion 1.x

The previous release of Adhearsion was deeply tied to the concept of a dialplan and related contexts, like the dialplan itself or event handling code. That brought the component architecture to simply define a series of methods that were available in some or all of the contexts. Components, however easy to create and use, were limited in scope and very difficult to properly test. Adhearsion 2.0 completely removes support for components in favor of plugins.

### What is an Adhearsion 2.0 Plugin?

A plugin, in Adhearsion as in many other Ruby frameworks, simply represents a collection of code, usually in the form of modules used as mixins to CallControllers. The library is packaged as a gem to facilitate its use, reuse, and sharing with the community. In addition to providing classes and modules, a plugin can bring a series of extra functionalities that will be demonstrated below.

### Anatomy of a Plugin

The easiest way to create a skeleton plugin is to use the Adhearsion command "ahn generate".
By running the following ahn generate plugin GreetPlugin a directory named greet_plugin will be created in the current working directory. The plugin itself, being a gem, can reside anywhere, unlike components that needed to be inside the application directory. The output from this command should show the files being created, like this:

<pre class="brush: ruby;">
create  greet_plugin
create  greet_plugin/lib
create  greet_plugin/lib/greet_plugin
create  greet_plugin/spec
create  greet_plugin/greet_plugin.gemspec
create  greet_plugin/Rakefile
create  greet_plugin/README.md
create  greet_plugin/Gemfile
create  greet_plugin/lib/greet_plugin.rb
create  greet_plugin/lib/greet_plugin/version.rb
create  greet_plugin/lib/greet_plugin/plugin.rb
create  greet_plugin/lib/greet_plugin/controller_methods.rb
create  greet_plugin/spec/spec_helper.rb
create  greet_plugin/spec/greet_plugin/controller_methods_spec.rb
</pre>

### Gem Plugin Structure

The .gemspec file contains information on your plugin, required dependencies and other necessary data. Enter your contact information, the name and description of your plugin and list any dependencies in greet_plugin.gemspec to have a fully functional gem. The README is customarily formatted in Markdown and its use is strongly encouraged to help people understand how to use your plugin. The Rakefile contains tasks that pertain to the plugin gem itself, such as running unit tests. Note that it is separate from adding tasks to Adhearsion applications; this will be covered later.

### Plugin Files

The entry point for the plugin, as usual with gems, resides in lib/greet_plugin.rb. It is mainly composed of requires for the plugin classes and modules. When adding functionality to a plugin, it will need to be require'd here to be available. Plugins are namespaced by package name to avoid conflicts.

<pre class="brush: ruby;">
# lib/greet_plugin.rb
module GreetPlugin
  require "greet_plugin/version"
  require "greet_plugin/plugin"
  require "greet_plugin/controller_methods"
end
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

In plugin.rb there are three important blocks shown. The first is the #init block which is invoked by Adhearsion when the plugin is first loaded. In our case, all this does is write an informational message to the log showing that the plugin was, in fact, loaded. The second is the #config block that registers configuration options with the Adhearsion framework. This is important because it allows your users to easily discover the possible configuration options for your plugin by simply running rake config:show within their Adhearsion applications. It also allows you to document the configuration options and set default values. The third block is the #tasks block, which registers Rake tasks to be available within the Adhearsion application. In this case it adds a Rake task called greet_plugin:info that prints the version number of the plugin.

### Plugin Methods: #init and #run

The #init method defines code that is run when the plugin is loaded. Every plugin goes through two separate phases before it is ready to run. The plugin first gets initialized through #init, which sets up any basic requirements or configuration. Later, when the Adhearsion framework has booted, the #run block is called to start the plugin. An example of using the #init and #run methods might be an IRC plugin. In the #init method, the IRC class is instantiated and configured, but no connection to the server is made. Then in #run the actual connection is opened and the service begins. Both methods are optional, but if they are defined, the mandatory arguments are the name of the plugin as a symbol and a block to provide the code to be run. A plugin can also request to be initialized before or after another plugin by name, using the :before and :after options passed as an hash to #init and/or #run.

### Plugin Methods: #config

The #config block allows a plugin to define configuration values in a customizable and self-documenting way. Every configuration line has the key, followed by a default value, optionally followed by a :desc key to allow for a description. rake config:show in an application directory will display all config keys provided by the core and the plugins, with their descriptions.

A config line can also validate supplied values with a transform:

<pre class="brush: ruby;">
max_connections 5, :desc => "Maximum number of connections to make", :transform => lambda { |v| v.to_i }
</pre>
The :transform will be used to modify the configuration value after it is read from the end-user's setting.

### Plugin Methods: #tasks

The #tasks method allows the plugin developer to define Rake tasks to be made available inside an Adhearsion application. Task definitions follow Rake conventions.

In our exploration of a newly generated plugin, we have so far mostly looked at the facilities Adhearsion provides to hook into the framework and your application. It is now time to actually build some new business logic, although it is entirely possible to have a plugin that consists of Rake tasks or configuration variables only.
A plugin is at its heart simply a Ruby gem, and bundled code needs to be loaded through requiring the proper files.
The generated plugin has a single business logic file in lib/controller_methods.rb. Neither the file name nor the module name are mandatory, this is just normal Ruby code.

### Plugin Code

Content is as follows:

lib/controller_methods.rb

<pre class="brush: ruby;">
module GreetPlugin
  module ControllerMethods
    # The methods are defined in a normal method the user will then mix in their CallControllers
    # The following also contains an example of configuration usage
    def greet(name)
      play "#{Adhearsion.config[:greet_plugin].greeting}, #{name}"
    end
  end
end
</pre>
The module is intended to be used as a mixin in call controllers.

### Testing your code

Module usage can be seen in action in the generated test file, which also showcases how the call controller methods can be easily tested.

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
Since plugin code is a normal Ruby library, it can be tested in an easy way using Rspec and some facilities provided by Adhearsion.

### Using the plugin

You have generated your new plugin, built tests and are ready to use it. Now what?
The plugin is a gem, so you might eventually publish it, but you can simply use it locally by adding a path line to your application's Gemfile.

Gemfile

<pre class="brush: ruby;">
gem 'adhearsion', '>= 2.0.0.rc1'
gem 'greet_plugin', :path => '/home/user/projects/greet_plugin'

# ... whatever other gems you need
</pre>

Do not forget to run 'bundle install' to load eventual dependencies after adding the gem.

### Adding an entire CallController

It is also possible to provide a full CallController implementation that can be used out-of-the-box by your application. Ben Langfeld's excellent blog post explains how a CallController works and what you can do with it.
We will be adding a new controller to our plugin, complete with new configuration keys and test. Our goal is to have a controller that dials a SIP device during office hours, and plays a message when the office is closed.

#### Setup

First, we add configuration for the times used:

lib/greet_plugin/plugin.rb

<pre class="brush: ruby;">
config :greet_plugin do
  greeting "Hello", :desc => "What to use to greet users"
  office_hours_start 8, :desc => "Start of office hours, integer, 24 hour format"
  office_hours_end 18, :desc => "End of office hours, integer, 24 hour format"
end
</pre>

To ease testing of time-based features, we add the excellent Timecop gem to our gemspec, under the development group, and add "require 'timecop'" at the top of spec/spec_helper.rb.

#### Tests first!

We then add a few tests, taking advantage of Adhearsion testing facility and the generated helpers. The tests describe what we will be implementing in the controller.

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
      Timecop.freeze(Time.utc(2012, 3, 8, 12, 0, 0))
      subject.expects(:dial).once
      subject.run
    end

    it 'plays a message when outside office hours' do
      Timecop.freeze(Time.utc(2012, 3, 8, 22, 0, 0))
      subject.expects(:play).once
      subject.run
    end
  end
end
</pre>

#### Our CallController

Last but not least, we build the actual CallController.

lib/greet_plugin/hours_controller.rb

<pre class="brush: ruby;">
module GreetPlugin
  class HoursController < Adhearsion::CallController
    def run
      if Time.now.hour.between?(Adhearsion.config[:greet_plugin].office_hours_start, Adhearsion.config[:greet_plugin].office_hours_end)
        dial "SIP/101"
      else
        play "Office is  open between #{Adhearsion.config[:greet_plugin].office_hours_start} and #{Adhearsion.config[:greet_plugin].office_hours_end}."
      end
    end
  end
end
</pre>

#### Routes
To allow our application to reach the controller, we add routes in its configuration. For the purpose of this post, we will simply be using the default route.

my_application_dir/config/adhearsion.rb

<pre class="brush: ruby;">
Adhearsion.router do
  route 'default', GreetPlugin::HoursController
end
</pre>

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/call-controllers">Call Controllers</a>
  </span>
  <span class='forward'>
    Continue to <a href="/docs/routing">Routing</a>
  </span>
</div>
