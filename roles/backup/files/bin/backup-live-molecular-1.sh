#!/bin/bash

TODAY=$(date +%y%m%d)

echo "== mol-mod, date: $TODAY"
echo "- rsync backups: $(date)"
rsync -a live-molecular-1:mol-mod/backups /backup/data/mol-mod/
echo "- rsync imports: $(date)"
rsync -a live-molecular-1:mol-mod/imports /backup/data/mol-mod/
echo "- done: $(date)"
echo
