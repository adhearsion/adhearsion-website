# Using Adhearsion with FreeSWITCH

## Requirements

* [FreeSWITCH](http://www.freeswitch.org) 1.2 or later (earlier versions may work but are not tested)

## Getting FreeSWITCH

Unfortunately there are no packages for FreeSWITCH included with any common Linux distribution.  However the FreeSWITCH project provides packages in [RPM](http://files.freeswitch.org/RPMS/) and [DPKG](http://files.freeswitch.org/repo/) formats.  FreeSWITCH can also be installed by downloading the source code and compiling it.  Full build instructions can be found on the [FreeSWITCH Install Guide](http://wiki.freeswitch.org/wiki/Installation_Guide).

## Building FreeSWITCH with Text-To-Speech support

FLite is a free TTS engine that comes with FreeSWITCH but is disabled by default. Follow [this guide](http://wiki.freeswitch.org/wiki/Mod_flite) to install the free FLite module. When following this guide, keep in mind that `modules.conf` is in the source code directory and `modules.conf.xml` is in the directory where FreeSWITCH was installed. NB: you can compile and enable _only one_ TTS engine at a time, due to conflicts between the various engines.

## Configuring FreeSWITCH

Note: Depending on your manner of install (RPM, source, etc), your FreeSWITCH conf directory is likely either `/etc/freeswitch/conf` or `/usr/local/freeswitch/conf`. Please substitute the correct one for your situation when following these instructions.

In order for Adhearsion to drive FreeSWITCH, FreeSWITCH must have the inbound event socket configured correctly (in `/etc/freeswitch/conf/autoload_configs/event_socket.conf.xml`):

```xml
<configuration name="event_socket.conf" description="Socket Client">
  <settings>
    <param name="nat-map" value="false"/>
    <param name="listen-ip" value="127.0.0.1"/>
    <param name="listen-port" value="8021"/>
    <param name="password" value="your-secret-password"/>
  </settings>
</configuration>
```

Next, we need to route all inbound calls to Adhearsion. Edit the dialplan `/etc/freeswitch/conf/dialplan/default.xml` and place the following configuration block near the top, immediately following the `<context name="default">` tag:

```xml
<extension name="Adhearsion">
  <condition field="destination_number" expression=".*$">
    <action application="set" data="hangup_after_bridge=false"/>
    <action application="set" data="park_after_bridge=true"/>
    <action application="park"/>
  </condition>
</extension>
```

The 'park' application essentially puts the call on hold. The event socket notifies Adhearsion of the call as an event.

To record calls, make sure to create the `/var/punchblock/record` directory with permissions set to allow the user running freeswitch to access this directory.

## Installing and Configuring Adhearsion

Please read and follow the instructions in the general [Installation](/docs/getting-started/installation) guide before continuing on to the following FreeSWITCH-specific Adhearsion configuration.

## Configuring Adhearsion for FreeSWITCH

As always the full list of configuration options can be viewed, along with a description and their default values, by typing `rake config:show` in your application directory.  There are a few configuration options that are particularly important:

* `config.punchblock.platform` must be set to `:freeswitch`
* `config.punchblock.password` must be a string, the EventSocket password (the your-secret-password above, the default is "ClueCon")
* `config.punchblock.host` is an optional string, defaults to localhost (127.0.0.1) or you can specify the host ip
* `config.punchblock.port` is an optional integer, defaults to 8021 (FreeSWITCH default) or you can specify a custom port

For Text-To-Speech (TTS), you need:

* ```config.punchblock.media_engine``` for Text-To-Speech, can be a string or symbol. FreeSWITCH ships with support for ```:flite```, ```:cepstral```, ```:unimrcp```, and ```:shout```. [See more information](http://wiki.freeswitch.org/wiki/Mod_unimrcp) on the various TTS engines and [see above section](#building-freeswitch-with-text-to-speech-support) for help on compiling FreeSWITCH with TTS support.
* ```config.punchblock.default_voice``` for TTS, can be a string or symbol, and depends on the TTS engine you choose. For example, with ```:flite``` you can set this to ```slt```, ```rms```, ```awb```, or ```kal```.

**For audio file playback, leave these settings out or set them to nil.**

Note that as described in our [Deployment Best Practices](/docs/best-practices/deployment), we recommend NOT storing the EventSocket password in the `config/adhearsion.rb` file.  Instead this should be stored in an environment variable (specifically: `AHN_PUNCHBLOCK_PASSWORD`) that is loaded by the process prior to launching. For example, start up Adhearsion with `AHN_PUNCHBLOCK_PASSWORD=your-secret-password ahn start /path/to/app`

## Getting Help

* [The FreeSWITCH Wiki](http://wiki.freeswitch.org) is an excellent source of configuration documentation and how-to articles.
* The FreeSWITCH community also offers support via IRC on irc.freenode.net in #freeswitch
* [FreeSWITCH-Users Mailing List](http://lists.freeswitch.org/mailman/listinfo/freeswitch-users) - The FreeSWITCH-Users mailing list is a great community resource that also is monitored by the FreeSWITCH developers.
* [Adhearsion Community Support](/community) - As always we invite you to post your questions to the Adhearsion community via IRC or our own mailing list.

<a href="#" rel="docs-nav-active" style="display:none;">docs-nav-getting-started</a>
<a href="#" rel="docs-nav-active" style="display:none;">docs-nav-getting-started-installation</a>
