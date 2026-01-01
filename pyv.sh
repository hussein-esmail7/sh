#!/bin/bash

# pyv.sh
# Hussein Esmail
# Created: 2025 11 07 (Fri)
# Updated: 2025 11 07 (Fri)
# Description: Automate the launching and upgrading of Python virtual environments
#
# https://www.google.com/search?q=python+program+to+automatically+upgrade+pip&oq=python+program+to+automatically+upgrade+pip&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBCDY4NzhqMGoxqAIAsAIA&sourceid=chrome&ie=UTF-8
#
# https://www.reddit.com/r/Python/comments/1b2ldnp/automate_creating_a_virtual_environment_and/
#


# Create venv
python3 -m venv $1

# Activate vemv
source $1/bin/activate

# Upgrade pip
python3 -m pip install --upgrade pip



exit 0
