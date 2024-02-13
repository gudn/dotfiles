function alpine --description 'alias alpine docker run --rm -it --net=host alpine'
  docker run --rm -it --net=host alpine $argv
        
end
