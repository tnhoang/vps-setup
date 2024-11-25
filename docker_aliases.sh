#!/bin/sh

alias d='docker'
alias dcu='docker-compose up -d'
alias dcub="docker-compose up -d --build"
alias dcd='docker-compose down'
alias dcs='docker-compose stop'
alias di='docker images'
alias ds='docker service'
alias dl='docker logs'
alias dlf='docker logs -f'
alias dps="docker ps --format 'table {{.ID}}\\t{{.Names}}\\t{{.Ports}}\\t{{.Status}}\\t{{.Image}}'"

dln() {
  docker logs -f `docker ps | grep $1 | awk '{print $1}'`
}

de() {
  docker exec -it $1 /bin/sh
}

dexe() {
  docker exec -it $1 $2
}
