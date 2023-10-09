function docker-upgrade --description 'upgrade all local docker images'
  for image in (docker images | awk '{ print $1 }' | tail -n +2);
    docker pull $image;
  end;
end
