# [Create Pinterest App](https://www.skillshare.com/classes/technology/Ruby-on-Rails-in-3-Weeks-Build-Evernote-Pinterest-and-Wordpress/1493287244)

## [The repository of the code](https://github.com/CrashLearner/PinterestClone)

### Go through all of the videos to create the Pinterest App

*17. Get Started with Pinterest Replica*  
*18. Controller, Routes, Index Page*  
*19. Create, Show and Edit New Pins*  
*20. Delete Pins, Add Users*  
*21. Define User Role, Add Structure/Styling*  
*22. Upload Images with Paperclip gem, Edit & Delete Images*  
*23. Style with Masonry and Bootstrap*  
*24. Up-Voting Pins using Gem*  
*25. Final Polishing of New, Edit, Account Sign In/Out Pages*

-----
## 17. Get Started with Pinterest Replica
=====
##### ` $ rails new yourname_pinterest `
=====
##### Update your `Gemfile`

```ruby
source 'https://rubygems.org'

gem 'rails', '4.0.2'
gem 'sqlite3'
gem 'sass-rails', '~> 5.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'simple_form', '~> 3.0.2'
gem 'haml', '~> 4.0.5'
gem 'bootstrap-sass', '~> 3.2.0.2'

group :development, :test do
  gem 'byebug', '~> 6.0.2'
  gem 'web-console', '~> 2.0'
  gem 'spring'
end
```
=====
##### $ bundle install
=====
##### $ rails g model Pin title:string description:text
=====
##### $ rake db:migrate
=====

### Add Rspec

#### Add the RSpec gem to your `Gemfile`
````ruby
source 'https://rubygems.org'

gem 'rails', '4.0.2'
gem 'sass-rails', '~> 5.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'simple_form', '~> 3.0.2'
gem 'haml', '~> 4.0.5'
gem 'bootstrap-sass', '~> 3.2.0.2'

group :development, :test do
  gem 'sqlite3'
  gem 'byebug', '~> 6.0.2'
  gem 'web-console', '~> 2.0'
  gem 'spring'
+  gem 'rspec-rails', '~> 3.0'
end

group :production do
  gem 'pg'
end
````
=====
#### `$ bundle install`
=====
#### '$ rails generate rspec:install`
=====

### Write a test that fails because you do not have a Pin Controller

#### `spec/controllers/pins_controller_spec.rb`

````ruby
require 'rails_helper'

RSpec.describe PinsController, type: :controller do
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end 

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end 

    it "loads all of the pins into @pins" do
      pin1, pin2 = Pin.create!, Pin.create!
      get :index

      expect(assigns(:pins)).to match_array([pin1, post2])
    end 
  end 
end
````
### Write a test that fails because the Model is not built out yet
````ruby
require 'rails_helper'

RSpec.describe Pin, :type => :model do
  it "has a title and a description" do
    tabbies = Pin.create!(title: 'Kittens', description: 'All tabbies')

    expect(Pin.title).to eq('Kittens')
    expect(Pin.description).to eq('All tabbies')
  end 
end
````
### The Failing Tests
````ruby
7 examples, 7 failures  
Failed examples:  
rspec ./spec/controllers/pin_controller_spec.rb:5 # PinsController GET #index responds successfully with an HTTP 200 status code
rspec ./spec/controllers/pin_controller_spec.rb:11 # PinsController GET #index renders the index template
rspec ./spec/controllers/pin_controller_spec.rb:16 # PinsController GET #index loads all of the pins into @pins
rspec ./spec/controllers/pins_controller_spec.rb:5 # PinsController GET #index responds successfully with an HTTP 200 status code
rspec ./spec/controllers/pins_controller_spec.rb:11 # PinsController GET #index renders the index template
rspec ./spec/controllers/pins_controller_spec.rb:16 # PinsController GET #index loads all of the pins into @pins
rspec ./spec/models/pin_spec.rb:4 # Pin has a title and a description
```
=====
##### $ rails g controller Pins
=====
##### Update your `app/controller/pins_controller.rb`

```ruby
class PinsController < ApplicationController
+  def index
+  end
end
```
=====
##### Update your `config/routes.rb`
```ruby
Rails.application.routes.draw do
  resources :pins

  root "pins/#index"
end
```
=====

##### Create `app/views/pins/index.html.haml`

```ruby
%h1 Placeholder
```
=====

#### Once this index is create we can run our tests again
````ruby
7 examples, 3 failures  
Failed examples:  
rspec ./spec/controllers/pin_controller_spec.rb:16 # PinsController GET #index loads all of the pins into @pins
rspec ./spec/controllers/pins_controller_spec.rb:16 # PinsController GET #index loads all of the pins into @pins
rspec ./spec/models/pin_spec.rb:4 # Pin has a title and a description
````
=====

##### Create `app/views/pins/index.html.haml`

```ruby
class PinsController < ApplicationController
  def index
  end

 def new
    @pin = Pin.new
  end

  def create
    @pin = Pin.new(pin_params)
  end

  private

  def pin_params
    params.require(:pin).permit(:title, :description)
  end
end
```
=====

### [Simple Form](https://github.com/plataformatec/simple_form)

Because we will be using Bootstrap in this app run this code in your terminal to complete the installation of the SimpleForm Gem

`#### rails generate simple_form:install --bootstrap`
````
      create  config/initializers/simple_form.rb
      create  config/initializers/simple_form_bootstrap.rb
       exist  config/locales
      create  config/locales/simple_form.en.yml
      create  lib/templates/erb/scaffold/_form.html.erb
````
=====

### Create the Form to Create a New Pin `app/views/pins/_form.html.haml `

````html
= simple_form_for @pin, html: { multipart:true } do |f| 
  -if @pin.errors.any?
    #errors
      %h2 
      = pluralize(@pin.errors.count, "error")
      prevented this Pin from saving
      %ul 
        - @pin.errors.full_messages.each do |msg|
          %li=msg

  .form-group
    = f.input :title, input_html: { class: 'form-control' }

  .form-group
    = f.input :description, input_html: { class: 'form-control' }

  = f.button :submit, class: "btn btn-primaray"
````
-----

## 19. Create, Show and Edit New Pins

### Update the `app/controller/pins_controller.rb` to send a flash message if the Pin is created and saved
````ruby
class PinsController < ApplicationController
  def index
  end 

  def new 
    @pin = Pin.new
  end 

  def create
    @pin = Pin.new(pin_params)
+      if @pin.save
+        redirect_to @pin, notice: "Sucessfully Created New Pin"
+      else 
+      render 'new'
  end 

  private

  def pin_params
    params.require(:pin).permit(:title, :description)
  end 

end

````
=====

#### Rename the `app/views/layouts/application.html.erb` to `app/views/layouts/application.html.haml` 

#### Update it from html to haml and add the flash message
````haml
!!!5
%html
%head
  %title PhoebesPinterest
  = stylesheet_link_tag    "application", media: "all", "data-turbolinks-track" => true
  = javascript_include_tag "application", "data-turbolinks-track" => true
  = csrf_meta_tags
%body
  - flash.each do |name, msg|
    = content_tag :div, msg, class: "alert alert-info"

  = yield           
````
=====

#### Add a new spec for the Show Page
````ruby
require 'rails_helper'

RSpec.describe "pins/show.html.haml", type: :view do
  it "has Pin title, description and a back button" do
    assign(:pin,
      Pin.create!(title: 'Squirrels', description: 'Fluffly tailed nut
eaters.'))
    render template: "pins/show.html.haml"
    expect(rendered).to match "Squirrels"
  end 
end
````

````ruby
Failures:  
Finished in 0.19544 seconds (files took 3.25 seconds to load)  
2 examples, 1 failure  
  1) pins/show.html.haml has Pin title, description and a back button  
     Failure/Error: render template: "pins/show.html.haml"  
     ActionView::MissingTemplate:  
       Missing template pins/show.html.haml
````
=====

#### Create the `app/views/pins/show.html.haml` page
````haml
%h1= @pin.title
%p= @pin.description

= link_to "Back", root_path
````
=====

#### Run the test again
````ruby
Finished in 0.26838 seconds (files took 3.38 seconds to load)  
2 examples, 0 failures
````
=====

#### Update the `app/views/pins/index.html.haml` page to show the Pins
````haml
- @pins.each do |pin|
  %h2= link_to pin.title, pin 
````
=====

#### Update the `app/controllers/pins_controller.rb` page to create the right index action

````ruby
  def index
    @pins = Pin.all.order("created_at DESC")
  end
````
=====

#### Update the `app/controllers/pins_controller.rb` page to add the edit update and destroy actions

````ruby
  def edit
  end

  def update
  if @pin.update(pin_params)
    redirect_to @pin, notice: "Pin was successfully updated."
  else
    render 'edit'
  end

  def destroy
  end
````
=====

#### Create the `app/views/pins/edit.html.haml` page to edit the Pins
````haml
%h1 Edit Pin
= render 'form'
= link_to "Cancel",  pin_path
````
=====

#### Update the `app/views/pins/show.html.haml` page to create a link to edit the Pins
````haml
%h1= @pin.title
%p= @pin.description

= link_to "Back", root_path
+ = link_to "Edit", edit_pin_path
````
=====

## 20. Delete Pins, Add Users

#### Update the `app/controllers/pins_controller.rb` page to add the edit update and destroy actions

````ruby
  def destroy
    @pin.destroy
    redirect_to root_path
  end
````
=====

#### Update the `app/views/pins/show.html.haml` page to create a link to delete the Pins
````haml
%h1= @pin.title
%p= @pin.description

= link_to "Back", root_path
= link_to "Edit", edit_pin_path
+ = link_to "Delete", pin_path, method: :delete, data: { confirm: "Are you sure you want to delete this Pin?" }
````
=====

#### Update the `app/views/pins/index.html.haml` page to add a link to create a new Pin
````haml
= link_to "New Pin", new_pin_path
- @pins.each do |pin|
  %h2= link_to pin.title, pin 
````
=====

### Add the Devise Gem in your Gemfile `gem 'devise', '~> 3.4.1' 
````ruby
  gem 'uglifier', '>= 1.3.0'
  gem 'coffee-rails', '~> 4.1.0'
  gem 'jquery-rails'
  gem 'turbolinks'
  gem 'jbuilder', '~> 2.0'
  gem 'sdoc', '~> 0.4.0', group: :doc
  gem 'simple_form', '~> 3.0.2'
  gem 'haml', '~> 4.0.5'
  gem 'bootstrap-sass', '~> 3.2.0.2'
+ gem 'devise', '~> 3.4.1'

group :development, :test do
  gem 'sqlite3'
  gem 'byebug', '~> 6.0.2'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'rspec-rails', '~> 3.0'
end

group :production do
  gem 'pg'
end

group :test do
  gem 'launchy'
  gem 'capybara'
end
````
=====
### Run `$ bundle` in your terminal
====
### Run `$ rails generate devise:install` in your terminal
====
#### Add this to the bottom of your `config/environments/development.rb ` (before the `end`)
````ruby
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
````
=====
### Run `$ rails generate devise:views` in your terminal

Note all the views that were just created:
````
      invoke  Devise::Generators::SharedViewsGenerator
      create    app/views/devise/shared
      create    app/views/devise/shared/_links.html.erb
      invoke  simple_form_for
      create    app/views/devise/confirmations
      create    app/views/devise/confirmations/new.html.erb
      create    app/views/devise/passwords
      create    app/views/devise/passwords/edit.html.erb
      create    app/views/devise/passwords/new.html.erb
      create    app/views/devise/registrations
      create    app/views/devise/registrations/edit.html.erb
      create    app/views/devise/registrations/new.html.erb
      create    app/views/devise/sessions
      create    app/views/devise/sessions/new.html.erb
      create    app/views/devise/unlocks
      create    app/views/devise/unlocks/new.html.erb
      invoke  erb
      create    app/views/devise/mailer
      create    app/views/devise/mailer/confirmation_instructions.html.erb
      create    app/views/devise/mailer/reset_password_instructions.html.erb
      create    app/views/devise/mailer/unlock_instructions.html.erb
````
====
### Run `$ rails generate devise User` in your terminal to generate the devise User model

Note what it just created:
````ruby
      invoke  active_record
      create    db/migrate/20150825044908_devise_create_users.rb
      create    app/models/user.rb
      invoke    rspec
      create      spec/models/user_spec.rb
      insert    app/models/user.rb
       route  devise_for :users
````
====
### Run `$ rake db:migrate` in your terminal
====
### Re-Start your Rails server
=====
### Check your localhost:3000/users/sign_up to make sure the Sign Up Page is there and working
=====
### Make the Associations between the User and Pin Models
#### Associate the User class to the Pin class  in `app/models/user.rb `
````ruby
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :pins
end
````
=====
#### Associate the Pin class to the User class  in `app/models/pin.rb  `
````ruby
class Pin < ActiveRecord::Base
  belongs_to :user
end
````
=====
#### Check out your `db/schema.rb` file
````ruby
ActiveRecord::Schema.define(version: 20150825044908) do

  create_table "pins", force: true do |t| 
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end 

  create_table "users", force: true do |t| 
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end 

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
````
=====
### Generate a Migration so the Pins Model has a user_id column

#### In the terminal run `$ rails g migration add_user_id_to_pins user_id:integer:index

````
      invoke  active_record
      create    db/migrate/20150825050724_add_user_id_to_pins.rb
````
=====
#### Check out your migration file
````ruby
class AddUserIdToPins < ActiveRecord::Migration
  def change
    add_column :pins, :user_id, :integer
    add_index :pins, :user_id
  end 
end
````
====
### Run `$ rake db:migrate` in your terminal
====
#### Check out your `db/schema.rb` file now
````ruby
ActiveRecord::Schema.define(version: 20150825050724) do

  create_table "pins", force: true do |t| 
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end 

  add_index "pins", ["user_id"], name: "index_pins_on_user_id"

  create_table "users", force: true do |t| 
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end 

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
````
=====
### Create a User in the Rails Console (`rails c` in your terminal`)

(Psst.- Don't type in: railsconsole >>)

`railsconsole >> @pin = Pin.first`
````
Pin Load (1.6ms)  SELECT "pins".* FROM "pins" ORDER BY "pins"."id" ASC LIMIT 1
 => #<Pin id: 1, title: "Tabbies", description: "Striped Cats", created_at: "2015-08-25 03:04:05", updated_at: "2015-08-25 03:04:05", user_id: nil> 
````
=====
`railsconsole >> @user = User.first`
````
User Load (0.0ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT 1
 => #<User id: 1, email: "someone@email.com", encrypted_password: "$2a$10$ISNEZPwsdEJw7ogLxmKbh.YinbPeVqE0X6KOdHg3F3bO...", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2015-08-25 04:53:37", last_sign_in_at: "2015-08-25 04:53:37", current_sign_in_ip: "33.33.33.1", last_sign_in_ip: "33.33.33.1", created_at: "2015-08-25 04:53:37", updated_at: "2015-08-25 04:53:37">
````
=====
`railsconsole >> @pin.user = @user`
````
<User id: 1, email: "someone@email.com", encrypted_password:  "$2a$10$ISNEZPwsdEJw7ogLxmKbh.YinbPeVqE0X6KOdHg3F3bO...", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2015-08-25 04:53:37", last_sign_in_at: "2015-08-25 04:53:37", current_sign_in_ip: "33.33.33.1", last_sign_in_ip: "33.33.33.1", created_at: "2015-08-25 04:53:37", updated_at: "2015-08-25 04:53:37"> 
````
=====
`railsconsole >> @pin.save`
````
UPDATE "pins" SET "user_id" = ?, "updated_at" = ? WHERE "pins"."id" = 1  [["user_id", 1], ["updated_at", Tue, 25 Aug 2015 05:24:28 UTC +00:00]]
   (23.0ms)  commit transaction
 => true 
````
=====

### To test that this worked
#### Go to the 'app/views/pins/show.html.haml page and add this
````haml
   %h1= @pin.title
   %p= @pin.description
+  %p
+  Submitted by
+  = @pin.user.email
+
+  %br/
+
   = link_to "Back", root_path
   = link_to "Edit", edit_pin_path
   = link_to "Delete", pin_path, method: :delete, data: { confirm: "Are you sure you want to delete this Pin?" }
````
=====

## 21. Define User Role, Add Structure/Styling

### Associate a User with the Action of creating a New Pin

#### Update the new and create methods in the `app/controllers/pins_controller.rb`
````ruby
  def new 
+    @pin = current_user.pins.build
  end 

  def create
+    @pin = current_user.pins.build(pin_params)
    if @pin.save
      redirect_to @pin, notice: "Your Pin was successfully created."
    else
      render 'new'
    end 
  end 
````
-----
### Add Bootstrap

We already have the Bootstrap gem in our Gemfile but there are a few other things to do.

#### Rename `app/assets/stylesheets/application.css` >> `app/assets/stylesheets/application.css`
=====
#### Add this to your `app/assets/stylesheets/application.scss`
````scss
    *= require_self
    *= require_tree .
    */
+ @import "bootstrap-sprockets";
+ @import "bootstrap";

````
=====
#### Add this to your `app/assets/javascripts/application.js
````js
   //= require jquery
   //= require jquery_ujs
+ //= require boostrap-sprockets
   //= require turbolinks
   //= require_tree .

````
=====

### Add Navigation

#### Update `app/views/layouts/application.html.haml`
````haml
!!!5
%html
%head
  %title PhoebesPinterest
  = stylesheet_link_tag    "application", media: "all", "data-turbolinks-track" => true
  = javascript_include_tag "application", "data-turbolinks-track" => true
  = csrf_meta_tags
%body
  %nav.navbar.navbar-default
    .container
      .navbar-brand= link_to "Phoebe's Pinterest", root_path

      - if user_signed_in?
        %ul.nav.navbar-nav.navbar-right
          %li= link_to "New Pin", new_pin_path
          %li= link_to "Account",  edit_user_registration_path
          %li= link_to "Sign Out", destroy_user_session_path, method: :delete
      - else
        %ul.nav.navbar-nav.navbar-right
          %li= link_to "Sign Up", new_user_registration_path
          %li= link_to "Sign In",  new_user_session_path

  .container
    - flash.each do |name, msg|
      = content_tag :div, msg, class: "alert alert-info"

    = yield
````
=====
#### Update `app/views/pins/new.html.haml`
````haml
.col-md-6.col-md-offset-3
  %h1 Edit Pin 
  = render 'form'
````
=====
#### Update `app/views/pins/new.html.haml`
````haml
.col-md-6.col-md-offset-3
  %h1 Edit Pin 
  = render 'form'

  = link_to "Cancel", pin_path
````
-----
## 22. Upload Images with Paperclip gem, Edit & Delete Images

#### Add the [PaperClip Gem](https://github.com/thoughtbot/paperclip) to your Gemfile `gem 'paperclip', '~> 4.2.0'`
=====
#### `$ bundle`
=====
#### Install ImageMagick - `$ sudo apt-get install imagemagick -y`
=====
##### https://github.com/thoughtbot/paperclip#image-processor
#### `$ which convert`  
The return should be a path like this >>>` /usr/bin/convert`
##### Open `config/environments/development.rb` Add the following line: 
`````ruby
Paperclip.options[:command_path] = "/usr/bin/"
=====
#### `$ sudo apt-get install imagemagick -y`
=====
### [Quick Start](https://github.com/thoughtbot/paperclip#quick-start)

#### Models `app/models/pin.rb`
````ruby
class Pin < ActiveRecord::Base
  belongs_to :user

  has_attached_file :image, styles: { medium: "300x300>"},
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
````
=====
#### Generate a migration `$ rails g paperclip pin image`
````
      create  db/migrate/20150825235538_add_attachment_image_to_pins.rb
````
=====
#### `$ rake db:migrate`
````
==  AddAttachmentImageToPins: migrating =======================================
-- change_table(:pins)
   -> 0.0187s
==  AddAttachmentImageToPins: migrated (0.0195s) ==============================
````
=====
#### Update `app/views/pins/_form.html.haml` so we can load images from the form
````haml
  .form-group
    = f.input :image, input_html: { class: 'form-control' }
````
=====
#### Update the pin_params in `app/controllers/pin_controller.rb`
````ruby
  def pin_params
    params.require(:pin).permit(:title, :description, :image)
  end 
````
=====
#### Update `app/views/pins/show.html.haml` so we can view the images

put this on the first line
````haml
    %h1= @pin.title
+  = image_tag @pin.image.url(:medium)
    %p= @pin.description
    %p
    Submitted by
    = @pin.user.email
    ...
      the rest of your code
    ...
````
=====
#### Update `app/views/pins/index.html.haml`
````haml
= link_to "New Pin", new_pin_path
- @pins.each do |pin|
  %h2= link_to pin.title, pin 
  = link_to (image_tag pin.image.url(:medium)), pin 
````
=====
#### Update `app/views/pins/edit.html.haml`
````haml
.col-md-6.col-md-offset-3
  %h1 Edit Pin 
  = image_tag @pin.image.url(:medium)
  = render 'form'

  = link_to "Cancel", pin_path 
````
-----

## 23. Style with [Masonry](https://rubygems.org/gems/masonry-rails/versions/0.2.4) and Bootstrap
=====
#### Add Masonry](https://rubygems.org/gems/masonry-rails/versions/0.2.4) to your Gemfile `gem 'masonry-rails', '~> 0.2.4'`
=====
#### `$ bundle install`
=====
#### Update your `app/assets/javascripts/application.js` file
````js
   //= require jquery
   //= require jquery_ujs
+ //= require masonry/jquery.masonry
   //= require bootstrap-sprockets
   //= require turbolinks
   //= require_tree .
````
=====

### Add Coffeescript and Styling
#### Rename `app/assets/javascripts/pins.coffee` to app/assets/javascripts/pins.js.coffee `
````coffee
$ ->
  $('#pins').imagesLoaded ->
    $('#pins').masonry
      itemSelector: '.box'
      isFitWidth: true
````
=====
#### Update `app/views/pind/index.html.haml` to include the Masonry styling
````haml
= link_to "New Pin", new_pin_path
#pins.transitions-enabled
  - @pins.each do |pin|
    .box.panel-default
      = link_to (image_tag pin.image.url), pin 
      .panel-body
        %h2= link_to pin.title, pin 
        %p.user
        Submitted by
        = pin.user.email
````
=====
#### Update `app/assets/stylesheets/application.scss`
````scss
 *= require 'masonry/transitions'
 *= require_self
 *= require_tree .
 */
@import "bootstrap-sprockets";
@import "bootstrap";

body {
	background: #E9E9E9;
}

h1, h2, h3, h4, h5, h6 {
	font-weight: 100;
}

nav {
	box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.22);
	.navbar-brand {
		a {
			color: #BD1E23;
			font-weight: bold;
			&:hover {
				text-decoration: none;
			}
		}
	}
}

#pins {
  margin: 0 auto;
  width: 100%;
  .box {
	  margin: 10px;
	  width: 350px;
	  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.22);
	  border-radius: 7px;
	  text-align: center;
	  img {
	  	max-width: 100%;
	  	height: auto;
	  }
	  h2 {
	  	font-size: 22px;
	  	margin: 0;
	  	padding: 25px 10px;
	  	a {
				color: #474747;
	  	}
	  }
	  .user {
	  	font-size: 12px;
	  	border-top: 1px solid #EAEAEA;
			padding: 15px;
			margin: 0;
	  }
	}
}

#edit_page {
	.current_image {
		img {
			display: block;
			margin: 20px 0;
		}
	}
}

#pin_show {
	.panel-heading {
		padding: 0;
	}
	.pin_image {
		img {
			max-width: 100%;
			width: 100%;
			display: block;
			margin: 0 auto;
		}
	}
	.panel-body {
		padding: 35px;
		h1 {
			margin: 0 0 10px 0;
		}
		.description {
			color: #868686;
			line-height: 1.75;
			margin: 0;
		}
	}
	.panel-footer {
		padding: 20px 35px;
		p {
			margin: 0;
		}
		.user {
			padding-top: 8px;
		}
	}
}

textarea {
	min-height: 250px;
}
````
=====
#### Update `app/views/pins/show.html.haml` with Bootstrap styling
````haml
#pin_show.row
  .col-md-8.col-offset-2
    .panel.panel-default
      .panel-heading.pin_image
        = image_tag @pin.image.url
      .panel-body
        %h1= @pin.title
        %p= @pin.description
        %p  
        Submitted by
        = @pin.user.email
      .panel-footer
        .row
          .col-md-6
            Submitted by
            = @pin.user.email
          .col-md-6
            .btn-group.pull-right
              = link_to "Home", root_path, class: "btn btn-default"
              = link_to "Edit", edit_pin_path, class: "btn btn-default"
              = link_to "Delete", pin_path, method: :delete, data: { confirm: "Are you sure you want to delete this Pin?" }, class: "btn btn-default"
````
-----
## 24. Up-Voting Pins using Gem

### Add the [acts_as_votable gem so users can vote on pins](https://rubygems.org/gems/acts_as_votable/versions/0.10.0) 

#### Add `gem 'acts_as_votable', '~> 0.10.0'` to your Gemfile
=====
#### `$ bundle`
=====
### Acts As Votable uses a votes table to store all voting information. 
=====
#### To generate the migration run ` $ rails generate acts_as_votable:migration` in your terminal
````
create  db/migrate/20150826050747_acts_as_votable_migration.rb
````
=====
##### Then run ` $ rake db:migrate` in your terminal
````
==  ActsAsVotableMigration: migrating =========================================
-- create_table(:votes)
   -> 0.0066s
-- add_index(:votes, [:voter_id, :voter_type, :vote_scope])
   -> 0.0021s
-- add_index(:votes, [:votable_id, :votable_type, :vote_scope])
   -> 0.0037s
==  ActsAsVotableMigration: migrated (0.0158s) ================================
````
=====
#### Update `app/models/pin.rb` to ad the `acts_as_votable` method
````ruby
class Pin < ActiveRecord::Base
+  acts_as_votable
  belongs_to :user

  has_attached_file :image, styles: { medium: "300x300>"}
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
````
=====
#### Update the `config/routes.rb`
````ruby
Rails.application.routes.draw do
  devise_for :users
  resources :pins do
    member do
      puts "like", to: "pins#upvote"
    end
  end
  root "pins#index"
end
````
=====
#### Update the `app/controllers/pins_controller.rb` 

##### Add `:upvote` to the `before_action` and only allow authenticated users on all the pages except the index and show page in the `app/controllers/pins_controller.rb` 
````ruby
  before_action :find_pin, only: [:show, :edit, :update, :destroy, :upvote]
  before_action :authenticate_user!, except: [:index, :show]

````
##### Define the upvote method in the `app/controllers/pins_controller.rb` 
````ruby
  def upvote
    @pin.upvote_by current_user
    redirect_to :back
  end 
````
#### Update the `app/views/pins/show.html.haml` page to add link for Up-Voting
````haml
   = link_to "Home", root_path, class: "btn btn-default"
   = link_to "Edit", edit_pin_path, class: "btn btn-default"
   = link_to "Delete", pin_path, method: :delete, data: { confirm: "Are you sure you want to delete this Pin?" }, class: "btn btn-default"
   = link_to "Home", root_path, class: "btn btn-default"
````

