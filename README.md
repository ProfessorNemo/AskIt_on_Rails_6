BASIC PROJECT ON RUBY ON RAILS 6
# Ask-Ans

###### Ruby: `3.0.3` Rails: `6.1.6` Yarn: `3.2.4` Nodejs: `12.22.9` Node: `17.1.0` Language: `Russian/English`
###### Application screenshots are located in the "screenshots" directory

Ruby on Rails MVC application.
Based on the Ruby on Rails 6 tutorial series:
* https://www.youtube.com/playlist?list=PLWlFXymvoaJ_IY53-NQKwLCkR-KkZ_44-

### About:
An online forum where the user can answer/answer questions or tips from other users that are posted.
You can write questions and comments, edit, delete. Also create, delete, block, change access rights and edit users. Also change the role and status of users.

### For avatars:

The avatar for the user is added using a third-party global avatars service https://en.gravatar.com/site/implement/images/
Register on the site https://en.gravatar.com/. Upload your avatar under the email that you are going to use on other sites.
And then this avatar follows you on all sites where you register with the same email, unless of course these sites support gravatar.

### For tags:

When adding a question, the algorithm looks for tags, changes color and makes them clickable. Clicking on a tag will take you to a page with questions from all users with that tag. The tags of all users are displayed on the main page (Solutions like "tom-select" and "ajax" are used here).

### Аuthentication and registration:

All logic related to authentication, registration, password creation and change
done with a manual approach (without the use of libraries such as "device") !


### Administration:

Created a separate page for the administrator.
An administrator can upload zipped Excel files and create multiple users with a single request.

### Get administrator status:

Run Rails console
```
$ make c
```

Find user `id` by `name`
```ruby
> User.pluck(:id, :name)
# => [[1, "Nemo"]]
```

```ruby
> User.find(1).update(role: 2)
```
Now you will have administrator rights to download, upload, delete, edit
and blocking users, as well as `http://127.0.0.1:3000/sidekiq`.

### API:

```
- tags_api: http://localhost:3000/api/tags
```

### Authorization:

Authorization (separation of access rights) in the application is implemented using the Pundit solution, policies are created, and a "guest user" service object is created. Access to the hashtag controller (as an experiment) is allowed only to the administrator...
A test archive with users for loading into the application is located in the directory `lib/zipusers.zip`.

### Tasks running in the background:

The process of sending emails (in our case to the administrator), as well as importing and exporting users, runs in the background. The archive is saved using ActiveStorage (see config/storage.yml) to itself locally in the “storage” directory and then work is performed with this archive in ActiveJob.

Sidekiq has an interface that allows you to see what broke, how many tasks were completed, when it happened, how many connections, what version of Redis has, how much memory Redis is using, etc. To connect this interface in the address bar, write:
http://127.0.0.1:3000/sidekiq. Only the administrator has access to it.

The application is covered with tests...

### Frontend:
Made a migration from `Webpacker` to `Esbuild`.


### Sending letters:
In development, mail is sent using a solution such as `letter_opener`


### Installation:

1. Clone repo
```
$ git clone git@github.com:ProfessorNemo/AskIt_on_Rails_6.git
$ cd AskAns
```

2. Install gems
```
$ bundle
```

3. Create database and run migrations. Besides install and update all dependencies in "package.json" file
```
$ make initially
```

4. Start server:
```
$ bin/dev
```

### Сommands to run tests:

Before running the tests in the console, type the following commands:
```
$ rails db:environment:set RAILS_ENV=test
$ rake db:schema:load RAILS_ENV=test
```
after
```
$ make rspec
```

For API testing, you can also use a solution such as [`Postman`](https://www.postman.com/)


Open `localhost:3000` in browser.
