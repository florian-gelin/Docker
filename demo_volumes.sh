#!/bin/bash
set -u
D="sudo docker"

pause() {
    echo
    while read -r -s -t 0.05 -n 1 _; do :; done
    read -r -p ">>> Capture possible. Entrée pour passer à l'étape suivante... " _
    [ -n "${NOCLEAR:-}" ] || clear
}
$D rm -f ecrivain >/dev/null 2>&1
$D volume rm partage >/dev/null 2>&1
rm -rf ~/hostdata

clear
echo "=== 1. Créer et inspecter un volume nommé ==="
$D volume create partage
$D volume ls
$D volume inspect partage
pause

echo "=== 2. Conteneur 'ecrivain' : écrit la date toutes les 5 s dans le volume ==="
$D run -d --name ecrivain -v partage:/data alpine sh -c "while true; do date >> /data/log.txt; sleep 5; done"
$D ps
echo "(attente de 12 s pour que le conteneur écrive quelques lignes...)"
sleep 12
$D exec ecrivain cat /data/log.txt
sleep 12
pause

echo "=== 3. Second conteneur : lit le MÊME volume (lecture seule) ==="
$D run --rm -v partage:/data:ro alpine tail -n 3 /data/log.txt
sleep 12
pause

echo "=== 3b. Tentative d'écriture en lecture seule (doit échouer) ==="
$D run --rm -v partage:/data:ro alpine sh -c "echo test > /data/x"
sleep 12
pause

echo "=== 4. --volumes-from : reprendre les volumes d'un autre conteneur ==="
$D run --rm --volumes-from ecrivain alpine ls /data
sleep 12
pause

echo "=== 5. Où sont les données sur la VM ? ==="
sudo ls -l /var/lib/docker/volumes/partage/_data
sleep 12
pause

echo "=== 6. Persistance : on supprime le conteneur, pas le volume ==="
$D rm -f ecrivain
$D run --rm -v partage:/data alpine tail -n 2 /data/log.txt
$D volume ls
sleep 12
pause

echo "=== 7. Bind mount (dossier de la VM) pour comparer ==="
mkdir -p ~/hostdata && echo bonjour > ~/hostdata/a.txt
$D run --rm -v /home/monitor/hostdata:/data alpine cat /data/a.txt
sleep 12
pause

echo "=== 8. Suppression du volume ==="
$D volume rm partage
$D volume ls
echo
echo "Démonstration terminée."
