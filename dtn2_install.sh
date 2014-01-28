#!/bin/bash
# This script download and install dtn2 + all the requirements.

msg(){
  echo -e "\033[1;36m   [inf] $1\033[0m"
}
err(){
  echo -e "\033[1;31m   [err] $1\033[0m"
}
#TODO make a function for all these test, using kill $$ might work

msg "Update && upgrade"
apt-get update -y && apt-get upgrade -y

msg "Install required packages"
apt-get install -y linux-headers-3.2.0.4-686-pae mercurial tcl8.5-dev libevent-pthreads-2.0-5 make libxmlsec1-dev gcc g++
test "$?" -eq 0 && (msg "OK" || err "Something went wrong" && exit)
msg "If you run this script on mini-10 dell install the package *broadcom-sta-dkms* to get Wi-Fi card working"

msg "cd-ing to /root"
cd /root

msg "dl-ing oasys and dtn sources"
hg clone http://hg.code.sf.net/p/dtn/oasys oasys
test "$?" -eq 0 && (msg "OK" || err "Something went wrong" && exit)
hg clone http://hg.code.sf.net/p/dtn/DTN2 dtn
test "$?" -eq 0 && (msg "OK" || err "Something went wrong" && exit)

cd oasys
msg "Configuring oasys"
./configure --without-db
test "$?" -eq 0 && (msg "OK" || err "Something went wrong" && exit)
msg "Making oasys"
make
test "$?" -eq 0 && (msg "OK" || err "Something went wrong" && exit)

cd ../
mv oasys/ -t dtn
cd dtn
msg "Configuring dtn"
#edp: external decision plane; ecl: external convergence layer
./configure -C --disable-ecl --disable-edp --without-db
test "$?" -eq 0 && (msg "OK" || err "Something went wrong" && exit)
msg "Making dtn"
make
test "$?" -eq 0 && (msg "OK" || err "Something went wrong" && exit)
msg "Make installing oasys"
make install
test "$?" -eq 0 && (msg "OK" || err "Something went wrong" && exit)

