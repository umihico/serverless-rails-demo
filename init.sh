docker build -t rails-local .
docker run -i --rm --entrypoint '' -v $(PWD):/var/task rails-local bash - << EOF
rails new . --skip-keeps --skip-bundle --skip-active-record
bundle install
bundle exec rails webpacker:install
EOF