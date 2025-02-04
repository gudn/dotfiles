function ndx --description "docker wrapper to run npx commands"
    mkdir -p /tmp/ndxcache
    docker run -it --rm -v (pwd):/mnt:Z -v /tmp/ndxcache:/root/.npm --workdir /mnt docker.io/node npx $argv;
end
