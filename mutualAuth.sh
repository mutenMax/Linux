#!/bin/bash

echo "Please enter your server key and store password : "
read serverPasswd

while [[ $serverPasswd = "" ]]; do
   read serverPasswd
done
echo -e "Generating Server Key..."

keytool -genkey -v -alias serverKey \
-keyalg RSA \
-validity 3650 \
-keystore server.keystore \
-dname "CN=localhost, OU=Dev Team, O=ORG, L=London, ST=UK, C=IT" \
-storepass $serverPasswd \
-keypass $serverPasswd
if [ $? -ne 0 ]; then
  exit 1
fi

echo "Please enter your client key and store password : "
read clientPasswd
while [[ $clientPasswd = "" ]]; do
   read serverPasswd
done

echo -e "\nGenerating Client Key..."

keytool -genkey -v -alias clientKey \
-keyalg RSA \
-validity 3650 \
-storetype PKCS12 \
-keystore clientStore.p12 \
-dname "CN=TEST_CERT, EMAILADDRESS=test@test.com, OU=Proteus Team, O=ORG, L=London, ST=UK, C=IT" \
-storepass $clientPasswd \
-keypass $clientPasswd

if [ $? -ne 0 ]; then
  exit 1
fi
echo "Generating Client certicate..."
keytool -export -alias clientKey -keystore clientStore.p12 -storetype PKCS12 -storepass $clientPasswd -rfc -file clientKey.cer
echo "Importing Client certicate onto Server store..."
keytool -import -v -file clientKey.cer -keystore server.keystore -storepass $serverPasswd

#This will import the generated client certificate to keychain (for Mac)
#echo -e "Please enter your network/root password.."
#sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain clientKey.cer

echo -e "\n****** Steps to enable HTTPS and mutual authentication ******"
echo -e "\n1. Add/ replace below connection config in your tomcat server.xml.\n"
cat << httpsConnector
  <Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true"
       maxThreads="150" scheme="https" secure="true"
       keystoreFile="`pwd`/server.keystore" keystorePass="$serverPasswd"
       truststoreFile="`pwd`/server.keystore" truststorePass="$serverPasswd"
       clientAuth="true" sslProtocol="TLS" />
httpsConnector

echo -e "\n2. Import \"`pwd`/clientKey.cer\" in your browser or keychain.\n"
exit
