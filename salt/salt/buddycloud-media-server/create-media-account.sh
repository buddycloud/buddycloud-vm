echo 127.0.0.1:5432:tigase_server:tigase_server:Ied8eichOasheil0 > .pgpass
chmod 600 .pgpass
psql -w -U tigase_server -d tigase_server -h 127.0.0.1 -p 5432 -c "SELECT TigAddUserPlainPw('mediaserver-test@buddycloud.com', 'mediaserver-test');" 
rm .pgpass

