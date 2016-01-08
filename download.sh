#!/bin/sh

source key
python lib/download_groups.py
python lib/download_members.py
python lib/download_events.py
python lib/download_rsvps.py
