#!/bin/bash

echo 'FiveM TxAdmin Linux Installer von SpielFuchx'

# Installiere benötigte Pakete
apt update
apt install -y xfce4 tar screen wget

# Serververzeichnis erstellen
mkdir -p /home/FiveM/server
cd /home/FiveM/server

# Benutzer nach dem Artifact-Link fragen
echo 'Geben Sie den Link zu den FiveM-Artifakten ein (.tar.xz Datei):'
read link

# Datei herunterladen
wget -O fx.tar.xz "$link"

# Entpacken
echo 'Entpacken der FiveM-Dateien...'
tar xf fx.tar.xz
rm fx.tar.xz
echo 'Artifacts installiert'

# run.sh erstellen
cat << 'EOF' > /home/FiveM/server/run.sh
#!/bin/bash
echo "Starte FiveM Server..."
cd /home/FiveM/server
./run.sh
EOF
chmod +x /home/FiveM/server/run.sh

# stop.sh erstellen
cat << 'EOF' > /home/FiveM/server/stop.sh
#!/bin/bash
echo "Beende FiveM TxAdmin Server..."

if screen -list | grep -q "fivem"; then
    screen -S fivem -X quit
    echo "FiveM Server wurde gestoppt."
else
    echo "Keine laufende 'fivem'-Screen-Session gefunden."
fi
EOF
chmod +x /home/FiveM/server/stop.sh

# Crontab-Eintrag zum automatischen Start bei Reboot
echo 'Crontab wird installiert und eingerichtet...'
(crontab -l 2>/dev/null; echo "@reboot screen -dmS fivem /home/FiveM/server/run.sh > /home/FiveM/server/cron.log 2>&1") | crontab -

# Starte FiveM in benannter Screen-Session
screen -dmS fivem /home/FiveM/server/run.sh

echo '✅ Erfolgreich installiert!'
echo 'ℹ️  Wechseln Sie in den Ordner mit: cd /home/FiveM/server'
echo '▶️  Starten mit: ./run.sh (oder automatisch durch Crontab)'
echo '⏹️  Stoppen mit: ./stop.sh'
