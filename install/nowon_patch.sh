#!/bin/bash

# NO-WON for Linux HLDS 3.0.1.6
# By Tomas Janousek <tomi@nomi.cz>

# check binary
if ! echo '929531ac99001405b81473ca57850c54  hlds_l' | md5sum --check >/dev/null 2>&1 ; then
    echo 'The hlds binary is not the one I expect or it has been already patched'
    exit
fi

# patch CompareClassBAdr
echo '0052b3d: 9090 9090 9090 90' | xxd -r - hlds_l

# patch CheckExeChecksum__Fv
echo '0051e98: 9090 9090' | xxd -r - hlds_l

# patch Master_Init
echo '001a5e2: 9090 9090 9090' | xxd -r - hlds_l
echo '001a5fa: 9090 9090 9090' | xxd -r - hlds_l

# patch Heartbeats with sv_lan 1
echo '0019e66: 9090 9090 9090' | xxd -r - hlds_l
echo '0019f85: 9090 9090 9090' | xxd -r - hlds_l
echo '0019f9d: 9090 9090 9090' | xxd -r - hlds_l

# patch Master_Shutdown
echo '001a088: 9090 9090 9090' | xxd -r - hlds_l
echo '001a0a0: 9090 9090 9090' | xxd -r - hlds_l

echo 'Your hlds was successfully patched (hopefully)'
