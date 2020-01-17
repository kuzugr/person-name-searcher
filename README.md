## テキストから形態素解析を用いて人名のみ抽出するAPI

### set up
* docker build -t person-name-searcher:latest .
* docker run -d -p 8080:8080 person-name-searcher

### usage
* curl -XPOST localhost:8080/persons --data-urlencode text='僕は田中太郎で、弟の名前は田中二郎だ。'
* ["田中太郎"]