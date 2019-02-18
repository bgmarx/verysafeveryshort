# VerySafeVeryShort

A barebones URL shortener for demonstration purposes

## Requirements 
* Redis 
* Elixir 1.7 
* OTP 20 

## Installation
* `mix do deps.get, compile`
* `iex -S mix` 
*  At localhost:4025

## API

### POST /shorten 
* Request 
```json 
%{"url": "http://elixiroutlaws.com/"}
```
* Response 

```json
201 created
{
    "url": "8fcc77a754"
}
```

### GET /:key
* If key is found, 302 redirect to the url associated with the key 
* If not found 404 is returned
