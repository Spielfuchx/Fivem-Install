echo 'FiveM TxAdmin Linux Installer von SpielFuchx'

apt install xf tar

mkdir -p /home/FiveM/Artefakts/server
cd /home/FiveM/Artefakts/server

echo 'Geben Sie den Link zu den FiveM-Artifakten ein:'
read link
wget $link

echo 'Entpacken der FiveM-Dateien...'
tar xf fx.tar.xz
echo 'Artifacts installiert'

rm -r fx.tar.xz

echo 'Installieren von Screen...'
apt install screen

echo ' crontab wird installiert und eingerichtet'

(crontab -l 2>/dev/null; echo "@reboot /bin/bash /home/FiveM/Artefakts/server/run.sh > /home/FiveM/server/cron.log 2>&1") | crontab -

cd /home/FiveM/Artefakts/server && screen ./run.sh

echo 'Erfolgreich installiert! Jetzt müssen Sie in den Ordner cd /home/FiveM/Artefakts/server wechseln und die Datei run.sh ausführen --> ./run.sh'

echo 'Außerdem wurde ein Crontab erfolgreich installiert. Bei einen Server neustart wird FIveM / TxAdmin automatisch Gestartet.'

# START.SH HINZUFÜGEN
cat << 'EOF' > /home/FiveM/Artefakts/server/start.sh
#!/bin/bash
cd /home/FiveM/Artefakts/server
screen -dmS fivem ./run.sh
EOF

# STOP.SH HINZUFÜGEN
cat << 'EOF' > /home/FiveM/Artefakts/server/stop.sh
#!/bin/bash
screen -S fivem -X quit
EOF

chmod +x /home/FiveM/Artefakts/server/start.sh /home/FiveM/Artefakts/server/stop.sh
