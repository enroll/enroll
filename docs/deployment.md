## Running on Heroku

Staging is currently running on Heroku.

* http://something.herokuapp.com

### Deployment

To deploy to Heroku, run these commands in [Enroll.io][chat]:

    /deploy enroll/branch-name to staging
    /deploy enroll/branch-name to production
    /deploy?  # lists help

### Migrations

Migrations are not automatically run with a deploy. If your feature has
migrations, don't forget to run them after deploying your code:

    $ heroku run rake db:migrate --app enroll
    $ heroku run rake db:migrate --app enroll-staging

Due to how ActiveRecord handles the cache of columns, its best to restart the
server after the migrations have finished.

    $ heroku restart --app enroll

[chat]: https://launchwise.campfirenow.com/room/564908
