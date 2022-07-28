const { google } = require('googleapis');
const path = require('path');
const fs = require('fs');
const credentials = require('../app/config/credentials.json');

// Replace with the code you received from Google
const code = '4/0AdQt8qimu6MjRHOuHztCIWnUd2avcNGfsxqNzrpWvvqSJH57rXTxrVz-gU3lt9MA35Gs8g';
const { client_secret, client_id, redirect_uris } = credentials.installed;
const oAuth2Client = new google.auth.OAuth2(client_id, client_secret, redirect_uris[0]);

oAuth2Client.getToken(code).then(({ tokens }) => {
  const tokenPath = path.join(__dirname, '../app/config/token.json');
  fs.writeFileSync(tokenPath, JSON.stringify(tokens));
  console.log('Access token and refresh token stored to token.json');
});