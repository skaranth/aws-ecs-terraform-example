package main

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

type TodoController struct {
	repo *TodoRepository
}

func (ctrl *TodoController) Init(engine *gin.Engine)  {
	engine.GET("/todo", ctrl.GetTodos)
	engine.POST("/todo", ctrl.Create)
}
func (ctrl *TodoController) GetTodos(c *gin.Context) {
	var todos []Todo
	todos, err := ctrl.repo.GetAll()
	if err != nil {
		c.AbortWithStatus(http.StatusNotFound)
	} else {
		c.JSON(http.StatusOK, todos)
	}
}

func (ctrl *TodoController) Create(c *gin.Context) {
	var todo Todo
	c.BindJSON(&todo)
	err := ctrl.repo.Create(&todo)
	if err != nil {
		c.AbortWithStatus(http.StatusNotFound)
	} else {
		c.JSON(http.StatusOK, todo)
	}
}

