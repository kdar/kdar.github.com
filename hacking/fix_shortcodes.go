package main

import (
	"bytes"
	"fmt"
	"image"
	_ "image/gif"
	_ "image/jpeg"
	_ "image/png"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"golang.org/x/net/html"
)

var (
	figureRe  = regexp.MustCompile(`\{\{\s*<\s*figure .*?\s*>\s*\}\}`)
	staticDir = "static"
)

func main() {
	files, err := filepath.Glob("content/post/*.*")
	if err != nil {
		log.Fatal(err)
	}

	for _, file := range files {
		data, err := ioutil.ReadFile(file)
		if err != nil {
			log.Fatal(err)
		}

		newdata := figureRe.ReplaceAllFunc(data, fixFigure)
		err = ioutil.WriteFile(file, newdata, os.ModePerm)
		if err != nil {
			log.Fatal(err)
		}
	}
}

func fixFigure(b []byte) []byte {
	doc, err := html.Parse(bytes.NewBuffer(b[2 : len(b)-2]))
	if err != nil {
		log.Fatal(err)
	}

	var f func(*html.Node) bool
	f = func(n *html.Node) bool {
		if n.Type == html.ElementNode && n.Data == "figure" {
			var attrs []html.Attribute
			for _, a := range n.Attr {
				if a.Key == "src" {
					img := getImage(a.Val)
					if img == nil {
						log.Fatalf("%s: img was nil", a.Val)
					}
					attrs = append(attrs, html.Attribute{
						Key: "size",
						Val: fmt.Sprintf("%dx%d", img.Bounds().Max.X, img.Bounds().Max.Y),
					})
					attrs = append(attrs, html.Attribute{
						Key: "link",
						Val: a.Val,
					})
				}
			}

			n.Attr = append(n.Attr, attrs...)

			buf := &bytes.Buffer{}
			html.Render(buf, n)
			b = []byte(fmt.Sprintf("{{%s}}", buf.String()[:buf.Len()-9]))
			return true
		}
		for c := n.FirstChild; c != nil; c = c.NextSibling {
			if f(c) {
				return true
			}
		}

		return false
	}
	f(doc)

	return b
}

func getImage(uri string) image.Image {
	var reader io.Reader

	if strings.HasPrefix(uri, "http") {
		resp, err := http.Get(uri)
		if err != nil {
			log.Fatal(err)
		}

		defer resp.Body.Close()

		reader = resp.Body
	} else {
		fp, err := os.Open(filepath.Join(staticDir, uri))
		if err != nil {
			log.Fatal(err)
		}

		defer fp.Close()

		reader = fp
	}

	m, _, err := image.Decode(reader)
	if err != nil {
		log.Fatal(err)
	}

	return m
}
