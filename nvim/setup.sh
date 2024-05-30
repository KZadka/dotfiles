VENV_PATH=~/.config/.nvim-venv/

if test -d $VENV_PATH; then
    exit 0
fi

python3.12 -m venv $VENV_PATH
cd $VENV_PATH
source bin/activate
pip3 install --upgrade pip
pip3 install autopep8 pynvim black-macchiato djlint ruff-lsp pyright

