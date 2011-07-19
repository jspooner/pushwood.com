object @user
attributes :email, :authentication_token, :errors

code :id do |m|
  "#{m[:id]}"
end
