# Creating a Digital Ocean droplet running Rails + Postgres with persistant storage and https

For your ctrl-D pleasure...

```
SERVER_IP
katescuttings
RAILS_SECRET (generate with `rails secret`)
kim@gfsc.studio
```

## Create and configure droplet

Create an Ubuntu 16.04 droplet using the Digital Ocean dashboard.

### Sign in and update

```
ssh root@SERVER_IP
apt update && apt upgrade --assume-yes
```

### Optionally add your locale

```
locale-gen en_GB en_GB.UTF-8
dpkg-reconfigure locales
```

### Optionally add Imagemagick if we know we are going to be using it

```
apt install imagemagick libmagickwand-dev
```

### Create a swap if you're using a cheapo box ($5 tier)

```
fallocate -l 2048m /mnt/swap_file.swap
chmod 600 /mnt/swap_file.swap
mkswap /mnt/swap_file.swap
swapon /mnt/swap_file.swap
echo "/mnt/swap_file.swap none swap sw 0 0" >> /etc/fstab
```

## Create a Dokku app and addons

### Install Dokku

```
wget https://raw.githubusercontent.com/dokku/dokku/v0.20.4/bootstrap.sh
sudo DOKKU_TAG=v0.20.4 bash bootstrap.sh
```

### Add a domain name (mandatory)

Go to http://SERVER_IP and add a domain name (if you don't it seems to go weird: use a junk one if needed)

### Create the app and database

```
dokku apps:create katescuttings
dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres
dokku postgres:create katescuttings-db
dokku postgres:link katescuttings-db katescuttings
```

### Increase the timeout as initial setup can take a while

```
dokku config:set katescuttings CURL_CONNECT_TIMEOUT=30 CURL_TIMEOUT=300
dokku config katescuttings
```

### Add persistent storage

[Guide](http://dokku.viewdocs.io/dokku~v0.10.3/advanced-usage/persistent-storage/)

ActiveStorage defaults to: `/storage`

```
mkdir /var/lib/dokku/data/storage/katescuttings
chown dokku.dokku /var/lib/dokku/data/storage/katescuttings
```

`/app` comes from the Dockerfile location for the container (see below)

```
dokku storage:mount katescuttings /var/lib/dokku/data/storage/katescuttings/storage:/app/storage
dokku ps:rebuild katescuttings
```

To have a look at the file structure if you get lost: `dokku enter katescuttings`

You'll also want to increase the maximum file size to something a bit more sensible.

```
mkdir /home/dokku/katescuttings/nginx.conf.d/
touch /home/dokku/katescuttings/nginx.conf.d/upload_limit.conf
echo "client_max_body_size 50m;" >> /home/dokku/katescuttings/nginx.conf.d/upload_limit.conf
```

## Local config

### Create app.json in Rails root

```
{
  "name": "katescuttings",
  "description": "App Description",
  "keywords": [
    "dokku",
    "rails"
  ],
  "scripts": {
    "dokku": {
      "postdeploy": "bundle exec rails db:migrate"
    }
  }
}
```

## No CI

If you don't want CI you can skip to "Set production environment variables" and just do this.

```
git remote add dokku dokku@SERVER_IP:katescuttings
git push dokku master
```

## Fancy pants staging/prod/CI etc

### For non-production environments e.g. staging

Update `config/secrets.yml`

```
staging:
  secret_key_base: <%= ENV['SECRET_KEY_BASE'] %>
```

Add environment file to `config/environments` folder

`cp config/environments/production.rb config/environments/staging.rb`

Be sure to make any relevant changes to the file

### Travis deployment for production and staging environment

```
mkdir .travis/ #if doesn't exist
cd .travis/
ssh-keygen -t rsa -b 4096 -f ENV_KEY_NAME
cat KEY_NAME | ssh root@DOMAIN_NAME dokku ssh-keys:add ENV_KEY_NAME
```

Be sure to add `.travis/*.key` and `.travis/*key.pub` to `.gitignore`

Then:

```
gem install travis
travis login
travis encrypt-file ENV_KEY_NAME --add
```

This encrypts the key, creates an entry in `before_install` in .travis.yml, and adds two variables in the travis environment with the decryption keys. Repeat for each environement. Be sure to make a note of the encrypted key and encrypted key iv variables added to travis environment.

Modify your travis.yml to the template below.

```
env:
  globalss
    - CC_TEST_REPORTER_ID=7e0e573cd74e3418226d922174406b38d5692b01d6464701fa57ce51e75eb72a
language: ruby
dist: trusty
addons:
  postgresql: '9.6'
before_script:
  - curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > ./cc-test-reporter
  - chmod +x ./cc-test-reporter
  - ./cc-test-reporter before-build
  - psql -c 'create database placecal_test;' -U postgres
before_install:
  - |
      if [ "$TRAVIS_BRANCH" = "production" ]; then
        openssl aes-256-cbc -K PROD_ENCRYPTED_KEY -iv PROD_ENCRYPTED_KEY_IV -in $TRAVIS_BUILD_DIR/.travis/PROD_KEY_NAME.enc -out PROD_KEY_NAME -d
      elif [ "$TRAVIS_BRANCH" = STAGING_BRANCH_NAME ]; then
        openssl aes-256-cbc -K STAGING_ENCRYPTED_KEY -iv STAGING_ENCRYPTED_KEY_IV -in $TRAVIS_BUILD_DIR/.travis/STAGING_KEY_NAME.enc -out STAGING_KEY_NAME -d
      fi

deploy:
  - provider: script
    skip_cleanup: true
    script: bash scripts/staging.sh
    on:
      branch: master
  - provider: script
    skip_cleanup: true
    script: bash scripts/production.sh
    on:
      branch: production
after_script:
  - ./cc-test-reporter after-build --exit-code $TRAVIS_TEST_RESULT
```

Then, in the `scripts/`, create the deploy script for each environment. For example:

```
#scripts/ENV_NAME.sh

eval "$(ssh-agent -s)" #start the ssh agent
chmod 600 ./ENV_KEY_NAME # this key should have push access
ssh-add ./ENV_KEY_NAME
ssh-keyscan DOMAIN_NAME >> ~/.ssh/known_hosts
git remote add deploy DOKKU_GIT_URL #i.e. dokku@DOMAIN_NAME:katescuttings
git config --global push.default simple
git push deploy master #or BRANCH_NAME:master if deploying a non-master branch
```

Commit, push to repo, and merge into the branch when ready.

## Set production environment variables

You can generate a key with `rails secret`

`dokku config:set katescuttings RAILS_ENV=production SECRET_KEY_BASE=RAILS_SECRET RAILS_SERVE_STATIC_FILES=true`


## Nice extras

### Let's Encrypt

When site is accessible and DNS set up, we can set up https

```
dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
dokku config:set --no-restart katescuttings DOKKU_LETSENCRYPT_EMAIL=kim@gfsc.studio
dokku letsencrypt katescuttings
dokku letsencrypt:cron-job --add
```

### Log rotate docker logs

This can cause space issues if you don't do it

Create the file `/etc/logrotate.d/docker-container` and add the following lines:

```
/var/lib/docker/containers/*/*.log {
  rotate 7
  daily
  compress
  size=1M
  missingok
  delaycompress
  copytruncate
}
```

You can then test the file with `logrotate -fv
/etc/logrotate.d/docker-container`.

If the command is successful you should see a file with the suffix
`[CONTAINER ID]-json.log.1` in the output.

[Reference](https://sandro-keil.de/blog/2015/03/11/logrotate-for-docker-container/)

## Copy database from production to staging (the long way for now)

### Generate production dump on server

`dokku postgres:export PROD_katescuttings-db > /tmp/PROD_katescuttings_production.dump`

### Download from production server and upload to

In your terminal:

```
scp root@PROD_DOMAIN_NAME:/tmp/PROD_katescuttings_production.dump /path/to/local/dir
scp /path/to/local/dir/PROD_katescuttings_production.dump root@STAGING_DOMAIN_NAME:/tmp/PROD_katescuttings_production.dump
```

### Dump into staging datatbase

```
dokku postgres:import STAGING_katescuttings-db < /tmp/PROD_katescuttings_production.dump
```
