echo 'FiveM TxAdmin Linux Installer von SpielFuchx'

apt update
apt install -y xf tar screen

mkdir -p /home/FiveM/server
cd /home/FiveM/server

echo 'Geben Sie den Link zu den FiveM-Artifakten ein:'
read link
wget $link -O fx.tar.xz

echo 'Entpacken der FiveM-Dateien...'
tar xf fx.tar.xz
echo 'Artifacts installiert'

rm fx.tar.xz

# Funktion: Server starten
start_server() {
    echo "Starte FiveM Server in einer screen Session namens 'fivem'..."
    screen -dmS fivem ./run.sh
    echo "Server gestartet."
}

# Funktion: Server stoppen
stop_server() {
    echo "Stoppe FiveM Server..."
    screen -S fivem -X quit
    echo "Server gestoppt."
}

echo 'Server Starten: start'
echo 'Server Stoppen: stop'
echo 'Status überprüfen: status'

while true; do
    read -p "Befehl eingeben (start/stop/status/exit): " cmd
    case "$cmd" in
        start)
            start_server
            ;;
        stop)
            stop_server
            ;;
        status)
            if screen -list | grep -q "fivem"; then
                echo "Server läuft."
            else
                echo "Server ist nicht aktiv."
            fi
            ;;
        exit)
            echo "Beende das Skript."
            break
            ;;
        *)
            echo "Unbekannter Befehl."
            ;;
    esac
done
