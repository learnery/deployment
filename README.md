# Learnerydeploy

a gem containing a rake task for deployment wrapping the
heroku-headless gem.

## Installation

Add this line to your application's Gemfile:

    gem 'learnerydeploy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install learnerydeploy

## Usage

To add automatic deployment from Travis to your build,
you need add the HEROKU_API_KEY and a call to your .travis.yml:

   travis encrypt HEROKU_API_KEY=<your-heroku-api-key>

(you can find your HEROKU_API_KEY under your account settings on heroku)

and add this line to your .travis.yml:

    rake learnery:deploy["<heroku-app-name"]

e.g.

    script:
     - rake
     - rake learnery:deploy["learnery-staging"]



### local testing
You can test the automatic deployment locally with:

    rake learnery:deploy["<heroku-app-name"]

for this to work, you need to set these environment variables first:

    export HEROKU_API_KEY=<secret>
    export TRAVIS_TEST_RESULT="0"
    export TRAVIS_JOB_NUMBER=local-test
    export TRAVIS_BRANCH=master

Note: the git remote "headlessheroku" will not be removed -
if you want to deploy to a different app, you need to remove it first:

    git remote rm headlessheroku

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
