package main

import (
	"github.com/gin-gonic/gin"
)

func main() {
	todoRepo := GetTodoRepository(GetConfig().GetDBConfig())
	defer todoRepo.Close()

	engine := InitializeEngine(todoRepo)
	engine.Run()
}

func InitializeEngine(todoRepo *TodoRepository) *gin.Engine {
	engine := gin.Default()
	controller := TodoController{repo: todoRepo}
	controller.Init(engine)
	return engine
}