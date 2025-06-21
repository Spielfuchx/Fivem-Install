#!/bin/bash

echo '🛠️ FiveM TxAdmin Linux Installer von SpielFuchx (2x Server Edition)'

apt update
apt install wget tar screen -y

# Ordnerstruktur erstellen
mkdir -p /home/FiveM/{server1,server2,artifacts}
cd /home/FiveM/artifacts

# Artifacts herunterladen
echo '🌐 Link zu den FiveM-Artifakten eingeben (fx.tar.xz):'
read link

wget -O fx.tar.xz "$link"
tar xf fx.tar.xz
rm fx.tar.xz

echo '✅ Artifacts entpackt'

# Artifacts kopieren
cp -r . /home/FiveM/server1/alpine
cp -r . /home/FiveM/server2/alpine

# server.cfg für beide Server
cat <<EOF > /home/FiveM/server1/server.cfg
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"
sv_hostname "Mein Server 1"
# sv_licenseKey ""
EOF

cat <<EOF > /home/FiveM/server2/server.cfg
endpoint_add_tcp "0.0.0.0:30130"
endpoint_add_udp "0.0.0.0:30130"
sv_hostname "Mein Server 2"
# sv_licenseKey ""
EOF

# Start/Stop/Status für Server 1
cat <<EOF > /home/FiveM/server1/run.sh
#!/bin/bash
echo "Starte FiveM Server 1..."
screen -dmS fivem1 /home/FiveM/server1/alpine/run.sh +exec ../server.cfg
EOF

cat <<EOF > /home/FiveM/server1/stop.sh
#!/bin/bash
echo "Stoppe FiveM Server 1..."
screen -S fivem1 -X quit
EOF

cat <<EOF > /home/FiveM/server1/status.sh
#!/bin/bash
if screen -list | grep -q "fivem1"; then
    echo "Server 1 läuft ✅"
else
    echo "Server 1 gestoppt ❌"
fi
EOF

# Start/Stop/Status für Server 2
cat <<EOF > /home/FiveM/server2/run.sh
#!/bin/bash
echo "Starte FiveM Server 2..."
screen -dmS fivem2 /home/FiveM/server2/alpine/run.sh +exec ../server.cfg
EOF

cat <<EOF > /home/FiveM/server2/stop.sh
#!/bin/bash
echo "Stoppe FiveM Server 2..."
screen -S fivem2 -X quit
EOF

cat <<EOF > /home/FiveM/server2/status.sh
#!/bin/bash
if screen -list | grep -q "fivem2"; then
    echo "Server 2 läuft ✅"
else
    echo "Server 2 gestoppt ❌"
fi
EOF

# Gemeinsame Start/Stop-Skripte
cat <<EOF > /home/FiveM/start_all.sh
#!/bin/bash
/home/FiveM/server1/run.sh
/home/FiveM/server2/run.sh
EOF

cat <<EOF > /home/FiveM/stop_all.sh
#!/bin/bash
/home/FiveM/server1/stop.sh
/home/FiveM/server2/stop.sh
EOF

chmod +x /home/FiveM/server1/*.sh
chmod +x /home/FiveM/server2/*.sh
chmod +x /home/FiveM/start_all.sh /home/FiveM/stop_all.sh

# Cronjobs für Autostart
echo '🕒 Cronjobs werden eingerichtet...'
(crontab -l 2>/dev/null; echo "@reboot /home/FiveM/server1/run.sh > /home/FiveM/server1/cron.log 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "@reboot /home/FiveM/server2/run.sh > /home/FiveM/server2/cron.log 2>&1") | crontab -

echo '✅ Installation abgeschlossen!'
echo '📂 Serververzeichnisse:'
echo '   - /home/FiveM/server1'
echo '   - /home/FiveM/server2'
echo ''
echo '🧪 Starte beide Server manuell mit:'
echo '   /home/FiveM/start_all.sh'
echo '🛑 Stoppe beide Server mit:'
echo '   /home/FiveM/stop_all.sh'
echo 'ℹ️ Einzelstatus prüfen mit:'
echo '   /home/FiveM/server1/status.sh'
echo '   /home/FiveM/server2/status.sh'
