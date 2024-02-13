function retoken --wraps='ssh-add -e /usr/lib/opensc-pkcs11.so; ssh-add -s /usr/lib/opensc-pkcs11.so' --description 'alias retoken ssh-add -e /usr/lib/opensc-pkcs11.so; ssh-add -s /usr/lib/opensc-pkcs11.so'
  ssh-add -e /usr/lib/opensc-pkcs11.so; ssh-add -s /usr/lib/opensc-pkcs11.so $argv; 
end
