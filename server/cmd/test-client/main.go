package main

import (
	"fmt"
	"log"
	"net/url"
	"github.com/gorilla/websocket"
)

func main() {

	u := url.URL {
		Scheme: "ws",
		Host: "localhost:3333",
		Path: "/echo",
	}

	log.Printf("Conecting to %s", u.String())

	c, _, err := websocket.DefaultDialer.Dial(u.String(), nil)

	if err != nil { log.Fatal("Dialing error", err) }

	defer c.Close()

	for {
		var input string

		fmt.Print("> ")

		_, err := fmt.Scanln(&input)

		if err != nil { log.Fatal(err) }

		log.Printf("Sending %s", input)
		err = c.WriteMessage(websocket.TextMessage, []byte(input))
		if err != nil { log.Fatal(err) }

		_, message, err := c.ReadMessage()
		if err != nil { log.Fatal(err) }
		log.Printf("Received %s", message)
	}
}
