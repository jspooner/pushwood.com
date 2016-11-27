object @user
attributes :email, :authentication_token

code :id do |m|
  "#{m[:id]}"
end
