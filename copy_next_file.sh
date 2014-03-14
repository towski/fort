#!/bin/bash
OLD_FILE=$(ls -lt public/journals/ | head -2 | tail -1 | rev | cut -f1 -d' ' | rev)
NEW_FILE=public/journals/$(date +%Y%m%d).html
cp public/journals/$OLD_FILE $NEW_FILE
vim $NEW_FILE
