function df --description 'alias df=df -h -x squashfs -x tmpfs -x devtmpfs'
 command df -h -x squashfs -x tmpfs -x devtmpfs $argv; 
end
