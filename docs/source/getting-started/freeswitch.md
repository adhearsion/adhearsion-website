#### FreeSWITCH

In order for Adhearsion to drive FreeSWITCH, FreeSWITCH must have the inbound event socket configured correctly (in conf/autoload_configs/event_socket.conf.xml), and inbound calls routed to 'park'. This dialplan entry will direct all calls to Adhearsion:

<pre class="brush: xml;">
<extension name='Adhearsion'>
  <condition field="destination_number" expression=".*$">
    <action application='park'/>
  </condition>
</extension>
</pre>


