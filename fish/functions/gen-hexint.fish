function gen-hexint --wraps=hexdump\ -vn4\ -e\'1/4\ \"\%04X\"\ 1\ \"\\n\"\'\ /dev/urandom --wraps=hexdump\ -vn4\ -e\'1/4\ \"\%04x\"\ 1\ \"\\n\"\'\ /dev/urandom --description alias\ gen-hexint=hexdump\ -vn4\ -e\'1/4\ \"\%04x\"\ 1\ \"\\n\"\'\ /dev/urandom
  hexdump -vn4 -e'1/4 "%04x" 1 "\n"' /dev/urandom $argv
        
end
