# rome-cli

- structure: main.py → cli.py → app.py → other modules (e.g. gdrive.py, helpers.py, libs.py).
- Load configs and secrets from a YAML config file (`/etc/rome-cli/config.yml` by default).
- Allow custom config path via `--config /path/to/config.yml`.
- Hides errors unless `--debug` is set.
- Prevents `.pyc` / `__pycache__` creation.
- Works great with Nuitka (onefile or native binary).

```sh
# download repo and go into the directory
cd ./python/rome-cli

######## production
./install.sh
./uninstall.sh

rome-cli --help # get help
rome-cli --config ./path/config.yml # custom path
rome-cli --debug # debug
rome-cli # default /etc/rome-cli/config.yml

######## development
python3 -m venv ./venv
source ./venv/bin/activate
pip3 install -r requirements.txt

python3 -m main --help # get help
python3 -m main --config ./path/to/config.yml # custom path
python3 -m main --debug # debug
python3 -m main # uses default /etc/rome-cli/config.yml

deactivate
```
