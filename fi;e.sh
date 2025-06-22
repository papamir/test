#!/bin/bash
set -e
mkdir -p offline_librosa
cd offline_librosa
python3 -m venv offline
source offline/bin/activate

mkdir -p wheels
pip install --upgrade pip
pip download librosa==0.11.0 \
  --dest wheels \
  --platform win_amd64 \
  --python-version 3.10 \
  --abi cp310 \
  --implementation cp \
  --only-binary=:all:

echo "librosa==0.11.0" > wheels/requirements.txt
cd wheels
zip -r ../offline-librosa.zip .
cd ..

IP=$(hostname -I | awk '{print $1}')
echo "http://$IP:8000/offline-librosa.zip"
python3 -m http.server 8000
