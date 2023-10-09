#!/bin/bash
source /etc/profile
source $HOME/.bashrc
conda activate gptac_venv_py39

python main.py >/dev/null 2>&1 &
