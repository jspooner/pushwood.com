User.create({:email => "jspooner@gmail.com", :password => "111111", :password_confirmation => "111111" })
Role.create!([{:name => "admin"},{:name => "photo"},{:name => "photoadmin"}])

me = User.find_by_email("jspooner@gmail.com")
me.roles << Role.find_by_name("admin")
me.save