set -e

export SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
export DIST_DIR="$HOME/Documents/VirtualBox/Python38"
export PIP_DOWNLOAD_URL="https://files.pythonhosted.org/packages/8e/76/66066b7bc71817238924c7e4b448abdb17eb0c92d645769c223f9ace478f/pip-20.0.2.tar.gz"

if [ "$1" = "windows" ]; then
  echo "Building for Windows..."
  export DIST_DIR="$SCRIPT_DIR"/dist/windows
  export PYTHON_DOWNLOAD_URL="https://www.python.org/ftp/python/3.8.2/python-3.8.2-embed-amd64.zip"
  mkdir -p "$DIST_DIR"
  wget $PYTHON_DOWNLOAD_URL -O "$DIST_DIR"/python.zip
  unzip "$DIST_DIR"/python.zip -d "$DIST_DIR"
  wget $PIP_DOWNLOAD_URL -O "$DIST_DIR"/pip.tar.gz
  tar -zxvf "$DIST_DIR"/pip.tar.gz -C "$DIST_DIR"
  mv "$DIST_DIR"/pip-20.0.2/src/pip "$DIST_DIR"
  cd "$DIST_DIR" && zip -r "$DIST_DIR"/pip.zip pip && cd -
  rm -rf "$DIST_DIR"/python.zip "$DIST_DIR"/pip.tar.gz "$DIST_DIR"/pip "$DIST_DIR"/pip-20.0.2
  printf "python38.zip\npip.zip\n.\n.\Lib\site-packages\n" >"$DIST_DIR"/python38._pth
  cp "$SCRIPT_DIR"/setup.py "$DIST_DIR"
  cp "$SCRIPT_DIR"/input.exe "$DIST_DIR"
  cp "$SCRIPT_DIR"/setup.ico "$DIST_DIR"
  cp "$SCRIPT_DIR"/setup.nsi "$DIST_DIR"
  printf "Download NSIS and compile script setup.nsi"
else
  echo "Building for Mac/Linux..."
  export DIST_DIR="$SCRIPT_DIR"/dist/unix
  mkdir -p "$DIST_DIR"
  cp "$SCRIPT_DIR"/setup.py "$DIST_DIR"
  if ! [ -x "$(command -v makeself)" ]; then
    echo "Installing 'makeself'..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
  # pyinstaller -w -F "$SCRIPT_DIR"/setup.py
  makeself "$DIST_DIR" dist/Installer "Installer 0.0.0.1" python3 setup.py
fi
