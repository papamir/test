#!/bin/bash
set -e

mkdir -p offline_resemblyzer
cd offline_resemblyzer
python3 -m venv offline
source offline/bin/activate
pip install --upgrade pip
mkdir -p wheels

pip download resemblyzer==0.1.4 \
  --dest wheels \
  --platform win_amd64 \
  --python-version 3.10 \
  --abi cp310 \
  --implementation cp \
  --only-binary=:all: \
  --no-deps

pip download torch==2.0.1 \
  webrtcvad==2.0.10 \
  sympy>=1.13.3 \
  networkx \
  typing==3.7.4.3 \
  --dest wheels \
  --platform win_amd64 \
  --python-version 3.10 \
  --abi cp310 \
  --implementation cp \
  --only-binary=:all: \
  --no-deps || echo "Some packages may not have binaries. Will need to install source or build manually."

echo "resemblyzer==0.1.4" > wheels/requirements.txt
echo "torch==2.0.1" >> wheels/requirements.txt
echo "webrtcvad==2.0.10" >> wheels/requirements.txt
echo "sympy>=1.13.3" >> wheels/requirements.txt
echo "networkx" >> wheels/requirements.txt
echo "typing==3.7.4.3" >> wheels/requirements.txt

cd wheels
zip -r ../offline-resemblyzer.zip .
cd ..

IP=$(hostname -I | awk '{print $1}')
echo "Download offline http://$IP:8000/offline-resemblyzer.zip"
python3 -m http.server 8000
