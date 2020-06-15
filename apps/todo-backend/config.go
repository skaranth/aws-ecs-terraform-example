package main


import (
	"fmt"
	awsssm "github.com/PaddleHQ/go-aws-ssm"
	"github.com/spf13/viper"
	"os"
	"strings"
	"sync"
)


var (
	configSingleton *Config
	syncConfig      sync.Once
)
const AWSParameterStoreBasePath = "todo-backend"


type Config struct{
	v *viper.Viper
}

type DBConfig struct {
	Host     string
	Port     int
	User     string
	DBName   string
	Password string
}

func buildDBConfig(v *viper.Viper) *DBConfig {
	dbConfig := DBConfig{
		Host:     v.GetString("DB_HOST"),
		Port:     v.GetInt("DB_PORT"),
		User:     v.GetString("DB_USER"),
		DBName:   v.GetString("DB_NAME"),
		Password: v.GetString("DB_PASSWORD"),
	}
	return &dbConfig
}

func GetConfig() *Config{
	syncConfig.Do(func(){
		configSingleton = &Config{v: viper.New()}

		env := getEnv()
		loadYamlConfig(env, configSingleton.v)
		if !isLocal(env){
			loadConfigFromAWSParameterStore(env, configSingleton.v)
		}
	})
	return configSingleton
}

func (c *Config) GetDBConfig() *DBConfig{
	return buildDBConfig(c.v)
}
func loadConfigFromAWSParameterStore(env string, v *viper.Viper) error {
	paramsPath := fmt.Sprintf("%s/%s/", AWSParameterStoreBasePath, env)
	pmstore, err := awsssm.NewParameterStore()
	if err != nil {
		return err
	}
	params, err := pmstore.GetAllParametersByPath(paramsPath, true)
	if err!=nil{
		return err
	}
	v.SetConfigType("json")
	err = v.ReadConfig(params)
	if err!=nil{
		return err
	}
	return nil
}

func loadYamlConfig(env string, v *viper.Viper) {
	v.SetConfigType("yaml")
	v.AddConfigPath("./env")
	v.SetConfigName(strings.ToLower(env))
	if err := v.ReadInConfig(); err != nil {
		panic(err)
	}
}

func isLocal(env string) bool {
	return env =="LOCAL"
}

func getEnv() string {
	env := os.Getenv("ENV")
	if env == "" {
		env = "LOCAL"
	}
	return env
}

