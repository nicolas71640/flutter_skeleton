In order to configure the google api to make nodemailer able to send an email, here's some tutorial that I've used : 
 - https://nodemailer.com/smtp/oauth2/
 - https://docs.emailengine.app/setting-up-gmail-oauth2-for-imap-api/?utm_source=nodemailer&utm_campaign=nodemailer&utm_medium=oauth-link
 - https://javascript.plainenglish.io/sending-emails-with-nodemailer-with-gmail-and-oauth2-e0b609587b7a
 - https://www.labnol.org/google-api-service-account-220405
- https://github.com/nodemailer/nodemailer/issues/1445


Here's the steps : 
1. Configuration of google api
    a) https://console.cloud.google.com/apis/credentials?project=avecpaulette-50195
    In this link, CREATE CREDENTIALS/OAuth client ID,  
    b) Application type : Desktop App
    c) Download the .json and put it in backend/app/config/credentials.json

2. Authorize the app to use the scope
    a) Run the script backend/scripts/auth.js (node auth.js)
    b) Copy the given URL and paste in browser
    c) Follow the google steps to authorize the app
    d) Copy the token in the last URL and paste in the file token.json (code)

3. Generate tokens
    a) Run the script backend/scripts/token.js (node token.js)

4. Run the test
    In backend/test/utils/mailer.js, uncomment the test 'should send an email', run it, and check you email