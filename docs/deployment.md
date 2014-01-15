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

Deploying will also restart Resque worker to handle sending emails and other background tasks. **If server crashes it is needed to deploy the app, so that worker would get started!** (There is no automatic startup script.)

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
