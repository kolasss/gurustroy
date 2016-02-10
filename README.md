# Gurustroy API server

## API docs

http://docs.gurustroy.apiary.io/#

## Start guard

- bin/guard

## Starting Gurustroy API server

- bin/rails s


## Настроика сервера для деплоя

- установить rbenv
- postgresql
- nginx + passenger
- capistrano deploy
- настроить database.yml, settings.yml
- настройка ssl
https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-14-04
https://mozilla.github.io/server-side-tls/ssl-config-generator/

Не добавлять add_header Strict-Transport-Security max-age=15768000; Рэилс сам добавляет такой хедер, если стоит force_ssl=true.


## deploy

cap production deploy
