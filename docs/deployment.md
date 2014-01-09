## Deploying on DigitalOcean/Other VPS

Bootstrap new servers with: https://github.com/enroll/enroll-bootstrap

### Prepare SSH

Edit `~/.ssh/config`:

    Host staging.enroll.io
      ForwardAgent yes

    Host enroll.io
      ForwardAgent yes

Run `ssh-add`.

### Deploy

Run:

    be cap staging deploy

For production:

    be cap production deploy

## Running on Heroku

Staging is currently running on Heroku.

* http://enroll-staging.herokuapp.com

Production is currently running on Heroku.

* http://enroll-production.herokuapp.com

## Deployment

To deploy on Heroku, make sure you have the proper git remotes
in place:

    $ git remote add staging git@heroku.com:enroll-staging.git
    $ git remote add production git@heroku.com:enroll-production.git

Then deploy like you would any other Heroku app:

    $ git push staging master
    $ git push production master

Migrations are not automatically run with a deploy. If your feature has
migrations, don't forget to run them after deploying your code:

    $ heroku run rake db:migrate --app enroll-staging
    $ heroku run rake db:migrate --app enroll-production

Due to how ActiveRecord handles the cache of columns, its best to restart the
server after the migrations have finished.

    $ heroku restart --app enroll-staging
    $ heroku restart --app enroll-production

### Sending Emails - Resque Background Workers

By default, the resque worker that handles sending email is disabled on
staging. To enable email on staging, type the following:

    $ heroku scale web=1 resque=1 --app enroll-staging

Make sure to disable the resque worker again when you're done:

    $ heroku scale web=1 resque=0 --app enroll-staging

That saves us $35/month!

## Continuous Integration

### Janky

The Janky CI server is deployed here:
* http://enroll-janky.herokuapp.com

The code we're running on our Janky CI server lives here:
* https://github.com/enroll/janky

### Jenkins

Jenkins is set up at http://162.216.17.171

### Hubot

Branches should build automatically on Janky when they're pushed up to
GitHub, but you can manually run a build in [Campfire](chat) with Hubot like:

    hubot ci build enroll/branch-name

The Hubot server is deployed here:
* http://enroll-hubot.herokuapp.com

The code we're running on our Hubot server lives here:
* https://github.com/enroll/hubot

If you want to enable a specific [hubot-script](hubot-scripts), just add
the script name to the [hubot scripts package](hubot-script-json), and
redeploy the Hubot application on Heroku.

[chat]: https://launchwise.campfirenow.com/room/564908
[hubot-scripts]: http://hubot-script-catalog.herokuapp.com
[hubot-scripts-json]: https://github.com/enroll/hubot/blob/master/hubot-scripts.json
