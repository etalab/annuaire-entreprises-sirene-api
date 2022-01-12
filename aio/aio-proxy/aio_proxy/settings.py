import pathlib
import yaml

from pyaml_env import parse_config

BASE_DIR = pathlib.Path(__file__).parent.parent
config_path = BASE_DIR / 'config' / 'aio_proxy.yaml'

config = parse_config(config_path)
