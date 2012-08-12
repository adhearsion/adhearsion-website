# Using Adhearsion with PRISM

## Requirements
* [Voxeo PRISM version 11.0 or later (11.5 recommended)](http://voxeolabs.com/prism)
* [rayo-server application](http://ci.voxeolabs.net/jenkins/job/Rayo/lastSuccessfulBuild/artifact/rayo-war/target/)

After downloading the Rayo WAR file it will have the build number in the file name (eg. rayo.b189.war).  Rename this file to simply "rayo.war".

While PRISM itself is a commercial product, a free license with 2-port concurrency is available to developers.  Also, the "rayo-server" application is open source and can be found on its [Github repository](https://github.com/rayo/rayo-server).

Rayo is officially supported on RedHat Enterprise Linux, CentOS and Mac OSX.  Users have also reported getting it to work successfully on Debian and Ubuntu, though this may not be supported by Voxeo.

## Getting PRISM

PRISM can be downloaded for free from 

## Configuring PRISM


1. Set PRISM_HOME to the base directory where you installed PRISM.  This is optional, but recommended to make the following instructions copy/pasteable.  For example "export PRISM_HOME=/opt/voxeo/prism"
2. If PRISM is running, shut it down. This can be done by using the application launcher in OSX or by running "/etc/init.d/voxeo-as stop" on Linux.
3. Rename your Rayo WAR file to simply "rayo.war" and copy it to the PRISM apps directory. By default this is $PRISM_HOME/apps
4. Start PRISM to allow it to unpack and launch the Rayo application.  After starting PRISM wait around 2 minutes for the application to be detected and unpacked.
5. Shut PRISM down again to begin configuration.
6. Edit the file $PRISM_HOME/config/portappmapping.properties to map port 5060 to Rayo:
<pre>
5060:rayo
</pre>
Important! Ensure that only one line in this file begins with "5060".

7. Edit the file $PRISM_HOME/apps/rayo/WEB-INF/xmpp.xml
Find the section for "xmpp:serv-domains" and add the fully qualified hostname of your PRISM server to the file.  If you only intend to use PRISM locally (connecting via localhost) then you may skip this step.  In this example we have added "my-prism-server.example.com":
<pre>
        &lt;xmpp:serv-domains&gt;
                &lt;xmpp:servdomain&gt;127.0.0.1&lt;/xmpp:servdomain&gt;
                &lt;xmpp:servdomain&gt;localhost&lt;/xmpp:servdomain&gt;
                &lt;xmpp:servdomain&gt;my-prism-server.example.com&lt;/xmpp:servdomain&gt;
        &lt;/xmpp:serv-domains&gt;
</pre>

8. Edit the file $PRISM_HOME/apps/rayo/WEB-INF/classes/rayo-routing.properties
In this file you will be mapping SIP addresses to XMPP JIDs.  The match is made using a regular expression on the left side of the equals sign.  To route all SIP calls to the JID "adhearsion@example.com" you would use a line like this:

<pre>
.*=adhearsion@example.com
</pre>

You may add as many mappings as you need to send calls to various different Adhearsion applications or other Rayo clients.  Note that the first matching line in the file will take the call.


### Licensing PRISM

If you are using a Rayo server, you will need to configure your JID and password and ensure that the DIDs have been mapped to your selected JID. Refer to your Rayo server's documentation for how to do this.  You likely will also want to configure your root_domain to point to your Rayo server's domain name for routing outbound calls.

## Getting Help

