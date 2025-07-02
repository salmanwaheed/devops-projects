# rome-cli

- Structure: main.py → cli.py → app.py → other modules (e.g. gdrive.py, helpers.py, libs.py).
- Load configs and secrets from a YAML config file (`/etc/rome-cli/config.yml` by default).
- Allow custom config path via `--config /path/to/config.yml`.
- Hides errors unless `--debug` is set.
- Prevents `.pyc` / `__pycache__` creation.
- Works great with Nuitka (onefile or native binary).
- If subcommands are found, register and run them as usual.
- If no subcommands are found (i.e. `rome_cli/commands/` is empty), fallback to a default app, like `app.py`.
- Each subcommand module like `sub_01.py` or `sub_02.py`:
  - must have `add_args(parser)`, `run_app(args, config)` and `register_subparser(subparsers, add_sub)` functions.
  - gets access to `args` and shared `config`.
  - discovers and loads them at runtime automatically.

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
rome-cli [sub-01|sub-02] --config config.yml --debug

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
