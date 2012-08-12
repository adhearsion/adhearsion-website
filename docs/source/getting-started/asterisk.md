# Using Adhearsion with Asterisk

## Requirements

To use Asterisk with Adhearsion you must be using Asterisk version 1.8.4 or later.  If you do not know which version to pick, we strongly recommend choosing a Long Term Support, or "LTS", release.  LTS releases are supported by Digium for a much longer period of time and are appropriate for production deployment.  At the time of this writing Asterisk 1.8 is the current LTS release and the next LTS release, Asterisk 11, is in beta.

## Getting Asterisk

### Asterisk Packages

For many platforms the easiest way to install Asterisk is to use the packages provided by your operating system or distribution.  At the time of this writing, the following Linux distributions provide a suitable version of Asterisk for use with Adhearsion 2.0:

* [Ubuntu 11.10 and later (12.04 recommended)](http://ubuntu.com) ([12.04 Precise](http://packages.ubuntu.com/precise/asterisk) [11.10 Oneiric](http://packages.ubuntu.com/oneiric/asterisk))
* [Debian Wheezy](http://debian.org) ([Wheezy](http://packages.debian.org/wheezy/asterisk))

In addition to the vendor-provided packages above, Digium provides packages for several common distributions:

* [Debian/Ubuntu](https://wiki.asterisk.org/wiki/display/AST/Asterisk+Packages#AsteriskPackages-APT%28Debian%2FUbuntu%29)
* [RedHat Enterprise Linux 5/CentOS 5](https://wiki.asterisk.org/wiki/display/AST/Asterisk+Packages#AsteriskPackages-APT%28Debian%2FUbuntu%29)

### Compiling Asterisk

If you are not able to obtain packages for your operating system, Asterisk can be compiled on many additional platforms, including FreeBSD, Mac OSX and even Solaris. Please see the [Asterisk installation documentation](https://wiki.asterisk.org/wiki/display/AST/Installing+Asterisk+From+Source) for further information.

## Configuring Asterisk

##### AMI User

It is necessary to configure an AMI user by which Adhearsion can connect to Asterisk. This can be done in manager.conf, and a sample configuration is provided below:

<pre class="brush: ruby;">
[general]
enabled = yes
port = 5038
bindaddr = 0.0.0.0

[myuser]
secret = mypassword
read = all
write = all
eventfilter = !Event: RTCP*
</pre>

Note that the user needs acess to all AMI events and actions. Also, we have setup an event filter here to prevent sending Adhearsion RTCP events. This is optional, but recommended, because while Asterisk generates a great number of these events Adhearsion cannot normally do anything useful with them. Thus, we can improve Adhearsion's performance by not sending it these events in the first place.

##### Route calls to AsyncAGI

To process calls with Adhearsion they must be routed through AsyncAGI.  Add the following context your extensions.conf:

<pre>
[adhearsion]
exten => _.,1,AGI(agi:async)
</pre>

This will route all calls that hit the "adhearsion" context to your Adhearsion application.  To get calls into the "adhearsion" context, you should configure your SIP peers or Dahdi or other channels to have "context=adhearsion" in their configuration.  Please consult the Asterisk documentation for more information on setting up peers and channels.

Note also that on versions Asterisk 1.8, it is necessary to add an empty context with the name 'adhearsion-redirect':
<pre>
[adhearsion-redirect]
</pre>

## Getting Help

If you need help configuring Asterisk there are several resources available:

* [The Asterisk Wiki](http://wiki.asterisk.org) - The official Asterisk wiki maintained by Digium. This has excellent reference information and is the most up-to-date.  Note that while it contains great reference information it tends to lack "how to" guides or very many example configuration scenarios.
* [VoIP-Info.org Wiki](http://www.voip-info.org/) - The original community wiki for all things Voice over IP.  This is a fantastic resource with many years of documentation compiled.  Note that much of the information is out of date however, especially for Asterisk.  As you read it, make sure the content applies to the version of Asterisk you are running!
* [Asterisk-Users Mailing List](http://lists.digium.com/mailman/listinfo/asterisk-users/) - The Asterisk-Users mailing list is a great community resource that also is monitored by the Asterisk developers at Digium.
* [Adhearsion Community Support](/community) - As always we invite you to post your questions to the Adhearsion community via IRC or our own mailing list.

