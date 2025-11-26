package config

import (
	"fmt"
	"os"

	"gopkg.in/yaml.v3"
)

type config struct {
	DatabaseUri string `yaml:"database_uri"`
	Category string `yaml:"category"`
	Format string `yaml:"format"`

	LocalSheet struct {
		FileName string `yaml:"filename"`
	} `yaml:"localsheet"`

	GoogleSheet struct {
		Id string `yaml:"id"`
		Name string `yaml:"name"`
		ServiceAccountFile string `yaml:"service_account_file"`
	} `yaml:"googlesheet"`
}

func Load(path string) (*config, error) {
	rawConfig, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("cannot read config file: %v", err)
	}

	var cfg config
	if err := yaml.Unmarshal(rawConfig, &cfg); err != nil {
		return nil, fmt.Errorf("cannot load config: %v", err)
	}

	return &cfg, nil
}
