curl -F 'email=jspooner@gmail.com' \
		 -F 'password=111111' \
		 -F 'password_confirmation=111111000' \
			http://spoonbook-2.local:3000/api/v1/authentication/create.json