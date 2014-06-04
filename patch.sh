#!/bin/bash
#set -xv
export HEADER="==========================================================================="

echo
echo $HEADER
echo "extract seabios source code"
echo $HEADER
echo

rm -rf seabios.submodule
tar -zxf files/seabios-1.7.3.2.tar.gz
mv seabios-1.7.3.2 seabios.submodule

echo
echo $HEADER
echo "dump the slic from motherboard (root password required)"
echo $HEADER
echo

# dump the slic table from the computer (note: requires root)
sudo xxd -i /sys/firmware/acpi/tables/SLIC | grep -v len | sed 's/unsigned char.*/static char SLIC[] = {/' > seabios.submodule/src/acpi-slic.hex

echo
echo $HEADER
echo patching seabios...
echo $HEADER
echo

cd seabios.submodule
patch -p1 < ../seabios.patch

echo
echo $HEADER
echo compiling seabios...
echo $HEADER
echo

make

echo
echo $HEADER
echo your bios awaits....
echo $HEADER
echo

cd ..
ls seabios.submodule/out/bios.bin
