# Using Adhearsion with PRISM

## Requirements
* [Voxeo PRISM version 11.0 or later (11.5 recommended)](http://voxeolabs.com/prism)
* [rayo-server application](http://ci.voxeolabs.net/jenkins/job/Rayo/lastSuccessfulBuild/artifact/rayo-war/target/)

After downloading the Rayo WAR file it will have the build number in the file name (eg. rayo.b189.war).  Rename this file to simply "rayo.war".

While PRISM itself is a commercial product, a free license with 2-port concurrency is available to developers.  Also, the "rayo-server" application is open source and can be found on its [Github repository](https://github.com/rayo/rayo-server).

Rayo is officially supported on RedHat Enterprise Linux, CentOS and Mac OSX.  Users have also reported getting it to work successfully on Debian and Ubuntu, though this may not be supported by Voxeo.

## Getting PRISM

PRISM can be downloaded for free from the [Voxeo Labs PRISM website](http://voxeolabs.com/prism).  It is supported on Linux (RHEL/CentOS) and Mac OSX.

## Configuring PRISM


1. Set PRISM_HOME to the base directory where you installed PRISM.  This is optional, but recommended to make the following instructions copy/pasteable.  For example <code>export PRISM_HOME=/opt/voxeo/prism</code>.
2. If PRISM is running, shut it down. This can be done by using the application launcher in OSX or by running <code>/etc/init.d/voxeo-as stop</code> on Linux.
3. Rename your Rayo WAR file to simply "rayo.war" and copy it to the PRISM apps directory. By default this is <code>$PRISM_HOME/apps</code>
4. Start PRISM (<code>/etc/init.d/voxeo-as start</code>) to allow it to unpack and launch the Rayo application.  After starting PRISM wait around 2 minutes for the application to be detected and unpacked.
5. Shut PRISM down again to begin configuration.
6. Edit the file <code>$PRISM_HOME/config/portappmapping.properties</code> to map port 5060 to Rayo:
<pre>
5060:rayo
</pre>
Important! Ensure that only one line in this file begins with "5060".

7. Edit the file <code>$PRISM_HOME/apps/rayo/WEB-INF/xmpp.xml</code>
Find the section for <code>xmpp:serv-domains</code> and add the fully qualified hostname of your PRISM server to the file.  If you only intend to use PRISM locally (connecting via localhost) then you may skip this step.  In this example we have added "my-prism-server.example.com":
<pre class="brush: xml">
        &lt;xmpp:serv-domains&gt;
                &lt;xmpp:servdomain&gt;127.0.0.1&lt;/xmpp:servdomain&gt;
                &lt;xmpp:servdomain&gt;localhost&lt;/xmpp:servdomain&gt;
                &lt;xmpp:servdomain&gt;my-prism-server.example.com&lt;/xmpp:servdomain&gt;
        &lt;/xmpp:serv-domains&gt;
</pre>

8. Edit the file <code>$PRISM_HOME/apps/rayo/WEB-INF/classes/rayo-routing.properties</code>
In this file you will be mapping SIP addresses to XMPP JIDs.  The match is made using a regular expression on the left side of the equals sign.  To route all SIP calls to the JID "adhearsion@example.com" you would use a line like this:

<pre>
.*=adhearsion@example.com
</pre>

You may add as many mappings as you need to send calls to various different Adhearsion applications or other Rayo clients.  Note that the first matching line in the file will take the call.


### Licensing PRISM

During the PRISM installation process you will be prompted to set up a demo license.  To see the license that is active in PRISM you can visit the administration console at http://my-prism-server.example.com:8080/console.  Refer to the PRISM documentation or Voxeo technical support for more help licensing PRISM.

## Configuring Adhearsion for PRISM

As always the full list of configuration options can be viewed, along with a description and their default values, by typing <code>rake config:show</code> in your application directory.  There are a few configuration options that are particularly important:

* config.punchblock.platform must be set to <code>:xmpp</code>
* config.punchblock.username must be set to your XMPP JID (eg. "adhearsion@example.com")
* config.punchblock.password must be set to the password for your JID
* config.punchblock.root_domain must be set to the fully qualified domain name of your PRISM server

Note that as described in our [Deployment Best Practices](/docs/best-practices/deployment), we recommend NOT storing the XMPP username and password in the <code>config/adhearsion.rb</code> file.  Instead these should be stored in environment variables (notably: <code>AHN_PUNCHBLOCK_USERNAME</code> and <code>AHN_PUNCHBLOCK_PASSWORD</code>) that are loaded by the process prior to launching.

## Getting Help

<a href="#" rel="docs-nav-active" style="display:none;">docs-nav-getting-started</a>
