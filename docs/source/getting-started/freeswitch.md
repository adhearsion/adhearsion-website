# Using Adhearsion with FreeSWITCH

At the time of this writing, Adhearsion 2.1.0, FreeSWITCH support is considered EXPERIMENTAL.  We need your feedback to continue to improve our FreeSWITCH support.  Please report all issues on the [Adhearsion mailing list](http://groups.google.com/group/adhearsion) or via [Github Issues](https://github.com/adhearsion/adhearsion/issues).

## Requirements

* [FreeSWITCH](http://www.freeswitch.org) 1.2 or later (earlier versions may work but are not tested)

## Getting FreeSWITCH

Unfortunately there are no packages for FreeSWITCH included with any common Linux distribution.  However the FreeSWITCH project provides packages in [RPM](http://files.freeswitch.org/RPMS/) and [DPKG](http://files.freeswitch.org/repo/) formats.  FreeSWITCH can also be installed by downloading the source code and compiling it.  Full build instructions can be found on the [FreeSWITCH Install Guide](http://wiki.freeswitch.org/wiki/Installation_Guide).

## Building FreeSWITCH with Text-To-Speech support

FLite is a free TTS engine that comes with FreeSWITCH but is disabled by default. Follow [this guide](http://wiki.freeswitch.org/wiki/Mod_flite) to install the free FLite module. When following this guide, keep in mind that ```modules.conf``` is in the source code directory and ```modules.conf.xml``` is in the directory where FreeSWITCH was installed. NB: you can compile and enable _only one_ TTS engine at a time, due to conflicts between the various engines.

## Configuring FreeSWITCH

In order for Adhearsion to drive FreeSWITCH, FreeSWITCH must have the inbound event socket configured correctly (in <code>/etc/freeswitch/conf/autoload_configs/event_socket.conf.xml</code>):

<pre class="brush: xml;">
&lt;configuration name="event_socket.conf" description="Socket Client"&gt;
  &lt;settings&gt;
    &lt;param name="nat-map" value="false"/&gt;
    &lt;param name="listen-ip" value="127.0.0.1"/&gt;
    &lt;param name="listen-port" value="8021"/&gt;
    &lt;param name="password" value="your-secret-password"/&gt;
  &lt;/settings&gt;
&lt;/configuration&gt;
</pre>

Next, we need to route all inbound calls to Adhearsion. Edit the dialplan <code>/etc/freeswitch/conf/dialplan/public/00_inbound.xml</code> (or you can create a new file in the same directory):

<pre class="brush: xml;">
&lt;extension name="Adhearsion"&gt;
  &lt;condition field="destination_number" expression=".*$"&gt;
    &lt;action application="park"/&gt;
  &lt;/condition&gt;
&lt;/extension&gt;
</pre>

The 'park' application essentially puts the call on hold. The event socket notifies Adhearsion of the call as an event.

If you plan to record calls, whether voicemail or for auditing, make sure there is a `recordings` directory in the FreeSWITCH application directory. Otherwise, depending upon the Adhearsion version, FS may fail to record and Adhearsion will not report the error (see [issue #243](https://github.com/adhearsion/adhearsion/issues/243).

## Configuring Adhearsion for FreeSWITCH

As always the full list of configuration options can be viewed, along with a description and their default values, by typing <code>rake config:show</code> in your application directory.  There are a few configuration options that are particularly important:

* ```config.punchblock.platform``` must be set to ```:freeswitch```
* ```config.punchblock.password``` must be a string, the EventSocket password (the your-secret-password above, the default is "ClueCon")
* ```config.punchblock.host``` is an optional string, defaults to localhost (127.0.0.1) or you can specify the host ip
* ```config.punchblock.port``` is an optional integer, defaults to 8021 (FreeSWITCH default) or you can specify a custom port

If you plan to use Text-To-Speech, you need to set these:

* ```config.punchblock.media_engine``` for Text-To-Speech, can be a string or symbol. FreeSWITCH ships with support for ```:flite```, ```:cepstral```, ```:unimrcp```, and ```:shout```. [See more information](http://wiki.freeswitch.org/wiki/Mod_unimrcp) on the various TTS engines and [see above section](#building-freeswitch-with-text-to-speech-support) for help on compiling FreeSWITCH with TTS support.
* ```config.punchblock.default_voice``` for TTS, can be a string or symbol, and depends on the TTS engine you choose. For example, with ```:flite``` you can set this to ```slt```, ```rms```, ```awb```, or ```kal```.

If you plan to playback audio files, leave these settings out or set them to nil. If you plan to use audio files and TTS in your application, see [issue #225](https://github.com/adhearsion/adhearsion/issues/225).

Note that as described in our [Deployment Best Practices](/docs/best-practices/deployment), we recommend NOT storing the EventSocket password in the <code>config/adhearsion.rb</code> file.  Instead this should be stored in an environment variable (specifically: <code>AHN_PUNCHBLOCK_PASSWORD</code>) that is loaded by the process prior to launching. For example, start up Adhearsion with AHN_PUNCHBLOCK_PASSWORD=your-secret-password ahn start /path/to/app


## Getting Help

* [The FreeSWITCH Wiki](http://wiki.freeswitch.org) is an excellent source of configuration documentation and how-to articles.
* The FreeSWITCH community also offers support via IRC on irc.freenode.net in #freeswitch
* [FreeSWITCH-Users Mailing List](http://lists.freeswitch.org/mailman/listinfo/freeswitch-users) - The FreeSWITCH-Users mailing list is a great community resource that also is monitored by the FreeSWITCH developers.
* [Adhearsion Community Support](/community) - As always we invite you to post your questions to the Adhearsion community via IRC or our own mailing list.

