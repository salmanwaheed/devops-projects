from setuptools import setup, find_packages
from pathlib import Path

req_path = Path(__file__).parent / "requirements.txt"

with open(req_path) as f:
  install_requires = f.read().splitlines()

setup(
  name="venom",
  version="0.1.0",
  packages=find_packages(),
  description="A CLI Framework",
  author="Salman Waheed",
  author_email="salman@example.com",
  install_requires=install_requires or [],
)
