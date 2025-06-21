#!/bin/bash

echo 'FiveM TxAdmin Linux Installer von SpielFuchx'

# Notwendige Pakete installieren
apt update
apt install -y xf tar wget screen cron

# Verzeichnisstruktur erstellen
mkdir -p /home/FiveM/server
cd /home/FiveM/server

# Benutzer nach dem Artifact-Link fragen
echo 'Geben Sie den Link zu den FiveM-Artifakten ein:'
read link
wget $link -O fx.tar.xz

# Artefakte entpacken
echo 'Entpacken der FiveM-Dateien...'
tar xf fx.tar.xz
rm -r fx.tar.xz
echo 'Artifacts installiert'

# Start- und Stop-Skripte erstellen
cat << 'EOF' > /home/FiveM/server/start.sh
#!/bin/bash
cd /home/FiveM/server
screen -dmS fivem ./run.sh
EOF

cat << 'EOF' > /home/FiveM/server/stop.sh
#!/bin/bash
screen -S fivem -X quit
EOF

chmod +x /home/FiveM/server/start.sh /home/FiveM/server/stop.sh

# Crontab für Autostart einrichten
echo 'Crontab wird installiert und eingerichtet'
(crontab -l 2>/dev/null; echo "@reboot /home/FiveM/server/start.sh > /home/FiveM/server/cron.log 2>&1") | crontab -

# Server direkt starten
/home/FiveM/server/start.sh

echo 'Erfolgreich installiert!'
echo 'Jetzt können Sie den Server starten mit: ./start.sh'
echo 'Oder stoppen mit: ./stop.sh'
echo 'Die Datei run.sh wird beim Systemstart automatisch ausgeführt.'
