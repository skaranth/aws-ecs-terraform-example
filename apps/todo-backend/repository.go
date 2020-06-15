package main

import (
	"fmt"
	"sync"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"
)

var (
	repoSingleton  *TodoRepository
	syncRepository sync.Once
)

type TodoRepository struct {
	db *gorm.DB
}

func GetTodoRepository(config *DBConfig) *TodoRepository {
	syncRepository.Do(func() {
		repoSingleton = &TodoRepository{}
		db, err := gorm.Open("postgres", DbURL(config))

		if err !=nil{
			panic(err)
		}
		repoSingleton.db = db
		repoSingleton.db.AutoMigrate(&Todo{})

	})

	return repoSingleton
}

func DbURL(dbConfig *DBConfig) string {
	return fmt.Sprintf("host=%s port=%d user=%s dbname=%s sslmode=disable password=%s",
		dbConfig.Host, dbConfig.Port, dbConfig.User, dbConfig.DBName, dbConfig.Password)
}

func (repo *TodoRepository) Close() error {
	return repo.db.Close()
}

func (repo *TodoRepository) GetAll() ([]Todo, error) {
	var todo []Todo
	if err := repo.db.Find(&todo).Error; err != nil {
		return nil, err
	}
	return todo, nil
}

func (repo *TodoRepository) Create(todo *Todo) (err error) {
	if err = repo.db.Create(todo).Error; err != nil {
		return err
	}
	return nil
}
//
//func (repo *TodoRepository) Get(todo *Todo, id string) (err error) {
//	if err := repo.db.Where("id = ?", id).First(todo).Error; err != nil {
//		return err
//	}
//	return nil
//}
//
//func (repo *TodoRepository) Update(todo *Todo, id string) (err error) {
//	repo.db.Save(todo)
//	return nil
//}
//
//func (repo *TodoRepository) Delete(todo *Todo, id string) (err error) {
//	Config.DB.Where("id = ?", id).Delete(todo)
//	return nil
//}
