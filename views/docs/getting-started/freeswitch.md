# Using Adhearsion with FreeSWITCH

## Requirements

* [FreeSWITCH](http://www.freeswitch.org) 1.2.13 or later

## Getting FreeSWITCH

Unfortunately there are no packages for FreeSWITCH included with any common Linux distribution. However the FreeSWITCH project provides packages in [RPM](http://files.freeswitch.org/RPMS/) and [DPKG](http://files.freeswitch.org/repo/) formats. FreeSWITCH can also be installed by downloading the source code and compiling it. Full build instructions can be found on the [FreeSWITCH Install Guide](http://wiki.freeswitch.org/wiki/Installation_Guide). Note that you should [install mod_rayo](https://wiki.freeswitch.org/wiki/Mod_rayo) to use Adhearsion via the Rayo protocol.

## Building FreeSWITCH with Text-To-Speech support

FLite is a free TTS engine that comes with FreeSWITCH but is disabled by default. Follow [this guide](http://wiki.freeswitch.org/wiki/Mod_flite) to install the free FLite module. When following this guide, keep in mind that `modules.conf` is in the source code directory and `modules.conf.xml` is in the directory where FreeSWITCH was installed. NB: you can compile and enable _only one_ TTS engine at a time, due to conflicts between the various engines.

## Configuring FreeSWITCH

Note: Depending on your manner of install (RPM, source, etc), your FreeSWITCH conf directory is likely either `/etc/freeswitch/conf` or `/usr/local/freeswitch/conf`. Please substitute the correct one for your situation when following these instructions.

In order for Adhearsion to drive FreeSWITCH, FreeSWITCH must load and configure mod_rayo (in `/etc/freeswitch/conf/autoload_configs/rayo.conf.xml`). The default configuration should be sufficient to get started, but you should at least change credentials before going to production.

Next, we need to route all inbound calls to Adhearsion. Edit the dialplan `/etc/freeswitch/conf/dialplan/default.xml` and place the following configuration block near the top, immediately following the `<context name="default">` tag:

```xml
<extension name="Adhearsion">
  <condition>
    <action application="rayo"/>
  </condition>
</extension>
```

The 'rayo' application notifies Adhearsion of the incoming call and offers it control.

Lastly, if FreeSWITCH was already running, remember to run the `reloadxml` command via the FreeSWITCH console to reload the config files.

## Installing and Configuring Adhearsion

Please read and follow the instructions in the general [Installation](/docs/getting-started/installation) guide before continuing on to the following FreeSWITCH-specific Adhearsion configuration.

## Configuring Adhearsion for FreeSWITCH

As always the full list of configuration options can be viewed, along with a description and their default values, by typing `rake config:show` in your application directory.  There are a few configuration options that are particularly important:

* `config.punchblock.platform` must be set to `:xmpp`
* `config.punchblock.username` must match that in your FreeSWITCH mod_rayo config, by default "usera@[your-FS-IP]"
* `config.punchblock.password` must match that in your FreeSWITCH mod_rayo config, by default "1"

Note that as described in our [Deployment Best Practices](/docs/best-practices/deployment), we recommend NOT storing the Rayo password in the `config/adhearsion.rb` file.  Instead this should be stored in an environment variable (specifically: `AHN_PUNCHBLOCK_PASSWORD`) that is loaded by the process prior to launching. For example, start up Adhearsion with `AHN_PUNCHBLOCK_PASSWORD=your-secret-password ahn start /path/to/app`

## Getting Help

* [The FreeSWITCH Wiki](http://wiki.freeswitch.org) is an excellent source of configuration documentation and how-to articles.
* The FreeSWITCH community also offers support via IRC on irc.freenode.net in #freeswitch
* [FreeSWITCH-Users Mailing List](http://lists.freeswitch.org/mailman/listinfo/freeswitch-users) - The FreeSWITCH-Users mailing list is a great community resource that also is monitored by the FreeSWITCH developers.
* [Adhearsion Community Support](/community) - As always we invite you to post your questions to the Adhearsion community via IRC or our own mailing list.

<a href="#" rel="docs-nav-active" style="display:none;">docs-nav-getting-started</a>
<a href="#" rel="docs-nav-active" style="display:none;">docs-nav-getting-started-installation</a>
