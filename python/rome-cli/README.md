# rome-cli

- Load secrets from a YAML config file (`/etc/rome-cli/config.yml` by default).
- Allow custom config path via `--config /path/to/config.yml`.
- Supports environment variables like `SECRET_KEY=<value>`.
- Hides errors unless `DEBUG=true` is set.
- Prevents `.pyc` / `__pycache__` creation.
- Works great with Nuitka (onefile or native binary).

```sh
# download repo and go into the directory
cd ./python/rome-cli

######## production
./install.sh
./uninstall.sh

rome-cli                     # uses default /etc/rome-cli/config.yml
rome-cli --config ./dev.yml  # custom path
rome-cli -c ./dev.yml        # short flag
DEBUG=true rome-cli          # shows traceback on failure
SECRET_KEY=123 rome-cli      # pass environment variables

######## development
python3 -m venv ./venv
source ./venv/bin/activate
pip3 install -r requirements.txt

# test 01
SECRET_KEY=123 python3 -m app
# test 02
DEBUG=true python3 -m app
# test 03
python3 -m app --config ./dev.yml

deactivate
```
