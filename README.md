# Sample Procore OAuth Client Application

### Preparing to run the app

1. register app with procore to:
    - get a client_id and client_secret
    - register redirect uris where this app will receive OAuth callbacks after successful oauth request
2. Copy `.env.example` to `.env` and update values with your credentials

### To run locally

    bundle install
    foreman start
    open http://localhost:5000

### To run in via docker

    docker build -t proauth .
    docker run -p 5000:5000 proauth
    open http://localhost:5000

### Deploying the app to Heroku

    APP_NAME=chose_an_app_name \
    heroku create ${APP_NAME}\
    && git push heroku \
    && heroku config:set PROCORE_CLIENT_SECRET=xxx \
    && heroku config:set PROCORE_CLIENT_ID=XXX \
    && heroku config:set PROCORE_API_URL=https://app.procore.com \
    && heroku config:set PROCORE_OAUTH2_REDIRECT_URI=https://${APP_NAME}.herokuapp.com/callback \
    && heroku open
    heroku logs --tail

Or, click this button to setup a heroku app:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/procore/proauth)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## About Procore

<img
  src="https://www.procore.com/images/procore_logo.png"
  alt="Procore Logo"
  width="250px"
/>

Manage Version is maintained by Procore Technologies.

Procore - building the software that builds the world.

Learn more about the #1 most widely used construction management software at [procore.com](https://www.procore.com/)
