# flashcoffee

v2

## Firebase Storage CORS settings
https://cloud.google.com/storage/docs/cors-configurations?hl=pt-br
gcloud storage buckets update gs://flashcoffee-32259.appspot.com --cors-file=storage_cors_config.json

## Add products
Set Index
Content OBJECT:
{"key":"","name":"","image":"types/","priceMap":[16,18,20]}

## Firebase deploy WEB

First of all - Install firebase-tools if you don't have it:
$ npm install -g firebase-tools

1. Open a terminal and navigate to the root directory for your Flutter app and run this command to login:
   $ firebase login:ci
2. Next, run this command from the root directory of your Flutter app to initialize your Firebase project:
   $ firebase init --token token (login:ci)
3. Use the arrow keys to navigate the cursor to Hosting and hit the spacebar to select it, then press enter.
   Select Use an existing project by pressing Enter (navigate with arrow keys).
4. Build web app:
   $ flutter build web
5. Enter build/web as the public directory and press enter.
   Press Y or N for single-page app. srep-staging is NOT on single-page mode.  
   Overwrite index.html. NOT.
6. Run Deploy:
   $ firebase deploy
   $ firebase hosting:channel:deploy CHANNEL_ID --token token (login:ci) --expires 7d
   Replace CHANNEL_ID with a string with no spaces (for example, feature_mission-2-mars).
   This ID will be used to construct the preview URL associated with the preview channel.
   $ firebase hosting:channel:delete CHANNEL_ID --token token (login:ci)
7. Open the URL shown in the terminal. Done!

## Firebase command UTILS
$ firebase projects:list CHANNEL_ID --token (login:ci)
$ firebase use PROJECT_ID --token (login:ci)


firebase use flashcoffee-32259
firebase deploy --token
firebase hosting:channel:deploy BETA --token (login:ci)
firebase projects:list BETA --token (login:ci)