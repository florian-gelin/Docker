# ===== ALIAS DOCKER =====

# --- Conteneurs ---
alias dps='sudo docker ps'
alias dpsa='sudo docker ps -a'
alias drun='sudo docker run'
alias dstart='sudo docker start'
alias dstop='sudo docker stop'
alias drestart='sudo docker restart'
alias drm='sudo docker rm'
alias drmf='sudo docker rm -f'
alias dlogs='sudo docker logs -f'
alias dex='sudo docker exec -it'
alias dinspect='sudo docker inspect'
alias dstats='sudo docker stats --no-stream'
alias dstopall='sudo docker ps -q | xargs -r sudo docker stop'
alias drmall='sudo docker ps -aq | xargs -r sudo docker rm'

# --- Images ---
alias di='sudo docker images'
alias dpull='sudo docker pull'
alias dbuild='sudo docker build -t'
alias drmi='sudo docker rmi'
alias dhistory='sudo docker history'
alias dimgprune='sudo docker image prune -a'

# --- Système ---
alias dv='sudo docker version'
alias dinfo='sudo docker info'
alias ddf='sudo docker system df'
alias dclean='sudo docker system prune'

# --- Fonctions (quand l'argument n'est pas à la fin de la commande) ---
# dsh <conteneur> [shell]  : ouvre un shell dans un conteneur (sh par défaut)
dsh() { sudo docker exec -it "$1" "${2:-sh}"; }

# dip <conteneur> : affiche l'adresse IP d'un conteneur
dip() { sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$1"; }

# dhelp : liste tous les raccourcis docker
dhelp() {
    alias | grep 'sudo docker'
    echo "dsh <conteneur> [shell]  : ouvrir un shell dans un conteneur"
    echo "dip <conteneur>          : afficher l'adresse IP d'un conteneur"
}
# ===== FIN ALIAS DOCKER =====
