
mutualAuth.sh

Tomcat – Mutual authentication over SSL

Steps to enable HTTPS and mutual authentication



Mutual authentication is a security process in which both client and server authenticate each other's identities before actual communication occurs.

Mutual authentication requires that both the server and the client prove their respective identities to each other before performing any communication-related functions.

In a web-based mutual authentication process, communication can occur only if the client and the server trust each other’s digital certificates. 

mutualAuth.sh script, here, will generate a server and the client self signed certificate. It will then import the client certificate in server store for server to trust this client. 

In the end it will generate a XML snippet which can be copied to the Tomcat server.xml. 

This will then enable Tomcat for SSL and will trust a client which has imported the above client certificate.


This is mainly for development puposes.




