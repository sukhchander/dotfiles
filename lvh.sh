#!/bin/bash
 
main() {
  if [[ $(has_lvh_me) == 1 ]]; then
    echo 'lvh.me is already specified in your hosts file'
  else
    add_lvh_me
    echo 'lvh.me was added to your hosts file!'
  fi
  flush_dns_cache
}
 
has_lvh_me() {
  if [[ $(find_lvh_in_hosts) -eq "1" ]]; then
    echo 1
  else
    echo 0
  fi
 
}
 
find_lvh_in_hosts() {
  local has_lvh=`cat /etc/hosts | grep lvh.me | wc -l`
  if [[ "$has_lvh" -gt "0" ]]; then
    echo "1"
  else
    echo "0"
  fi
}
 
add_lvh_me() {
  sudo echo '127.0.0.1 lvh.me' >> /etc/hosts
}
 
flush_dns_cache() {
  if [ `sysctl -n kern.osrelease | cut -d . -f 1` -lt 9 ]; then
    lookupd -flushcache
  else
    dscacheutil -flushcache
  fi
}
 
main
