# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def seed_users
    user_id = 0
    10.times do 
      User.create(
        name: "test#{user_id}",
        email: "test#{user_id}@test.com",
        password: '123456',
        password_confirmation: '123456',
        about: "My name is #{user_id}"
      )
      user_id = user_id + 1
    end
  end
  
  
  def seed_categories
    categories = ['Web Developement', 'Graphics Design', 'Tutoring', 'Other']
  
    categories.each do |name|
      Category.create(name: name)
    end
  end
  
  def seed_posts
    categories = Category.all
    post_id = 0
  
    categories.each do |category|
      1.times do
        Post.create(
          title: post_id, 
          content: "Hello World", 
          user_id: rand(1..9), 
          category_id: category.id
        )
        post_id = post_id + 1
      end
    end
  end

  def seed_sposts
    categories = Category.all
    post_id = 0
  
    categories.each do |category|
      1.times do
        Spost.create(
          title: post_id, 
          content: "Hello World", 
          user_id: rand(1..9), 
          category_id: category.id
        )
        post_id = post_id + 1
      end
    end
  end

  seed_users
  seed_categories
  seed_posts
  seed_sposts

