package main

import (
	"log"
	"net/http"
	"github.com/gorilla/websocket"
)

const addr = "0.0.0.0:3333"

var upgrader = websocket.Upgrader {}

func main() {
	log.Printf("Starting server ws://%s", addr)
	http.HandleFunc("/echo", echo)
	log.Fatal(http.ListenAndServe(addr, nil))
}

func echo(w http.ResponseWriter, r *http.Request) {
	log.Print("Connection")
	upgrader.CheckOrigin = func(r *http.Request) bool { return true }

	c, err := upgrader.Upgrade(w, r, nil)

	if err != nil { log.Fatal(err) }

	defer c.Close()

	log.Print("Waiting for message...")

	for {
		mt, message, err := c.ReadMessage()
		if err != nil { log.Fatal(err) }

		log.Printf("Message: %s", message)

		err = c.WriteMessage(mt, message)
		if err != nil { log.Fatal(err) }
	}
}
