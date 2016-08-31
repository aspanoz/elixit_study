# AppPhoenix

## Заметки на память

### установить коректное окружение. я использую asdf

### скачать зависимости
  * mix deps.get
  * npm install

### установка phontomjs для функциональных тестов
  * npm install -g phantomjs
  * mix test                             -- запустить все тесты
  * mix test --only controller_user      -- запустить тесты с тегом controller_user

### скомпилировать проект
  * mix compile

### генерация баз и миграция
  * mix ecto.create
  * mix ecto.migrate
  * mix run priv/repo/seeds.exs           -- создание дефолтного пользователя


### Запуск сервера
  * mix phoenix.server
