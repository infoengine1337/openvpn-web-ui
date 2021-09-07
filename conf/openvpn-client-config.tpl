dev tun
persist-tun
persist-key
client
resolv-retry infinite
remote {{ .ServerAddress }} {{ .Port }} {{ .Proto }}
lport 0

cipher {{ .Cipher }}
keysize {{ .Keysize }}
auth {{ .Auth }}
tls-client

redirect-gateway def1

ca {{ .Ca }}
cert {{ .Cert }}
key {{ .Key }}

comp-lzo
