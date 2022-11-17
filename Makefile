RUN_ARGS := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))

drop!:
	rails db:drop

initially:
	rails db:create
	rails db:migrate:up VERSION=20220725204641
	rake fake:questions
	rails db:migrate:up VERSION=20220727124606
	rails db:migrate:up VERSION=20220729002645
	rake fake:user
	rails db:migrate:up VERSION=20220729210243
	rails db:migrate:up VERSION=20220730130756
	rails db:migrate:up VERSION=20220802145447
	rails db:migrate:up VERSION=20220802145521
	rake fake:questions_user
	rails db:migrate:up VERSION=20220802154605
	rake fake:gravatar_user
	rails db:migrate:up VERSION=20220802194738
	rails db:migrate:up VERSION=20220803141236
	rails db:migrate:up VERSION=20220803141301
	rails db:migrate:up VERSION=20220803231436
	rake fake:random_tags
	rails db:migrate:up VERSION=20220808213018
	rails db:migrate:up VERSION=20220809154614
	yarn install


rspec:
	bundle exec rspec spec/models/answer_spec.rb
	bundle exec rspec spec/models/question_spec.rb
	bundle exec rspec spec/models/user_spec.rb
	bundle exec rspec spec/policies/question_policy_spec.rb
	bundle exec rspec spec/requests/client_spec.rb
	bundle exec rspec spec/requests/github_spec.rb
	bundle exec rspec spec/requests/questions_spec.rb
	bundle exec rspec spec/requests/sessions_spec.rb
	bundle exec rspec spec/requests/tags_json_spec.rb

rubocop:
	rubocop -A

run-console:
	bundle exec rails console

c: run-console

.PHONY:	db
