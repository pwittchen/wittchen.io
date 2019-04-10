#!/usr/bin/env bash
source .ftpconfig
lftp ftp://$USER:$PASS@$HOST -e "set ftp:ssl-allow no; mirror -R -v --only-newer public domains/wittchen.io/public_html; quit"
