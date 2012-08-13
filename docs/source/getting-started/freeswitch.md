# Using Adhearsion with FreeSWITCH

At the time of this writing, Adhearsion 2.1.0, FreeSWITCH support is considered EXPERIMENTAL.  We need your feedback to continue to improve our FreeSWITCH support.  Please report all issues on the [Adhearsion mailing list](http://groups.google.com/group/adhearsion) or via [Github Issues](https://github.com/adhearsion/adhearsion/issues).

## Requirements

* [FreeSWITCH](http://www.freeswitch.org) 1.2 or later (earlier versions may work but are not tested)

## Getting FreeSWITCH

Unfortunately there are no prebuilt packages available for FreeSWITCH on any common Linux distribution.  FreeSWITCH can be installed by downloading the source code and compiling it.  Full instructions can be found on the [FreeSWITCH Install Guide](http://wiki.freeswitch.org/wiki/Installation_Guide).

## Configuring FreeSWITCH

In order for Adhearsion to drive FreeSWITCH, FreeSWITCH must have the inbound event socket configured correctly (in <code>/etc/freeswitch/conf/autoload_configs/event_socket.conf.xml</code>), and inbound calls routed to 'park'. This dialplan entry will direct all calls to Adhearsion:

<pre class="brush: xml;">
&lt;extension name='Adhearsion'&gt;
  &lt;condition field="destination_number" expression=".*$"&gt;
    &lt;action application='park'/&gt;
  &lt;/condition&gt;
&lt;/extension&gt;
</pre>

## Configuring Adhearsion for FreeSWITCH

As always the full list of configuration options can be viewed, along with a description and their default values, by typing <code>rake config:show</code> in your application directory.  There are a few configuration options that are particularly important:

* config.punchblock.platform must be set to <code>:freeswitch</code>
* config.punchblock.password must be set to the EventSocket password (eg. "ClueCon")

Note that as described in our [Deployment Best Practices](/docs/best-practices/deployment), we recommend NOT storing the EventSocket password in the <code>config/adhearsion.rb</code> file.  Instead this should be stored in an environment variable (specifically: <code>AHN_PUNCHBLOCK_PASSWORD</code>) that is loaded by the process prior to launching.


## Getting Help

* [The FreeSWITCH Wiki](http://wiki.freeswitch.org) is an excellent source of configuration documentation and how-to articles.
* The FreeSWITCH community also offers support via IRC on irc.freenode.net in #freeswitch
* [FreeSWITCH-Users Mailing List](http://lists.freeswitch.org/mailman/listinfo/freeswitch-users) - The FreeSWITCH-Users mailing list is a great community resource that also is monitored by the FreeSWITCH developers.
* [Adhearsion Community Support](/community) - As always we invite you to post your questions to the Adhearsion community via IRC or our own mailing list.

