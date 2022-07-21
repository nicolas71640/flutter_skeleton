Some features can't be fully tested automatically in the CI. 

Here's the list of all the tests that have been to be executed manually before any release. 

# Google Signin
On the test phone, add the google account "nicolas.lemble@gmail.com"
1. Clean the mongodb
2. Launch the app, click on the google signin => It should signin without any error and go the next page
3. Disconnect from this account
4. Click again on the google signin button => It should signin without any error and go the next page
5. Disconnect from this account
6. Go to signup page, in the "email" field type the address "nicolas.lemble@gmail.com" and whatever you want in the password fields
7. Click on signup, it should fail, indicating that this e-mail is already used.