# Dots

This is a RoR reproduction of the game [Dots](https://en.wikipedia.org/wiki/Dots_(game)), created with Web Sockets using Rails' Action Cable

Game
-------------------------

This game based on rooms system, one player should create room, another should join it, after that it will available for them, but not for other users. The game will be over, if one of the players wins the game, or both of them will surrender.

Start server
-------------------------

1. `bundle install` to install all necessary games
2. Set your pg congig in `database.yml` file.
3. `rake db:create` & `rake db:migrate` to create and migrate database.

    > If u want to fill your db with some test data, u can call `rake db:seed`
4. `rails s` to start server. It will be avaliable on 3000 port

