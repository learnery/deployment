
# this is called by travis ci

# test locally with: rake learnery:deploy
# you need to set these environment variables first:

#  export HEROKU_API_KEY=<secret>
#  export TRAVIS_TEST_RESULT="0"
#  export TRAVIS_JOB_NUMBER=local-test
#  export TRAVIS_BRANCH=master

# git remote rm headlessheroku

# rake learnery:deploy

  require 'heroku-headless'
  def deploy
    #File.new("travis_job_number","w").write(ENV['TRAVIS_JOB_NUMBER'])

    branch =  ENV['TRAVIS_BRANCH']
    deploy_only_branch = "master"
    if branch != deploy_only_branch
      puts "current branch: (#{branch}) - not on #{deploy_only_branch}, skipping deploy."
      exit 0
    end


    required = %w(HEROKU_API_KEY TRAVIS_TEST_RESULT)
    undefined = required.select{|v| !ENV[v]}
    unless undefined.size == 0
      puts "Please define #{required.join(", ")} as environment variables"
      exit 1
    end

    if ENV['TRAVIS_TEST_RESULT'] != "0"
      puts "There were errors in the build - skipping deploy."
    else
      # TODO engine find another way to determine heroku app name for engine
      app_name = 'learnery-engine'
      # this does not work with rake task - ARGV[0] is the task name!
  #    if ARGV[0]
  #      app_name = ARGV[0]
  #    else
  #      app_name = 'learnery-engine'
  #      app_name = 'learnery-staging'
  #      unless 'default' == ENV['LEARNERY_THEME']
  #        app_name = "#{app_name}-#{ENV['LEARNERY_THEME']}"
  #      end
  #    end

      puts "deploying to heroku app #{app_name}"
      remote_name = "headlessheroku"
      HerokuHeadless.configure do | config |
        config.post_deploy_commands = ['rake db:migrate']
        config.pre_deploy_git_commands = [
          "git remote add #{remote_name} git@heroku.com:#{app_name}.git"
         ]
      end

      result = HerokuHeadless::Deployer.deploy( app_name )
      puts "successfully deployed to #{app_name}" if result
      exit result ? 0 : 1
    end
  end


namespace :learnery do
    desc "Deploy to heroku"
    task :deploy => :environment do
      deploy
    end
end
