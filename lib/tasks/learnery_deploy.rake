
  require 'heroku-headless'
  require 'fileutils'
  def deploy(application_name)
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
    versionkeys = %w(TRAVIS_BRANCH TRAVIS_BUILD_ID TRAVIS_BUILD_NUMBER TRAVIS_COMMIT TRAVIS_REPO_SLUG)
    versionkeys.each do | key |
      puts "#{key}: #{ENV[key]}"
    end


    if ENV['TRAVIS_TEST_RESULT'] != "0"
      puts "There were errors in the build - skipping deploy."
    else
      app_name = application_name

      puts "deploying to heroku app \"#{app_name}\""
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
    task :deploy, :application_name do | task, args|
      deploy(args[:application_name])
    end
end

namespace :learnery do
    desc "Write Version Info from Travis Env"
    task :version do
    versionkeys = %w(TRAVIS_BRANCH TRAVIS_BUILD_ID TRAVIS_BUILD_NUMBER TRAVIS_COMMIT TRAVIS_REPO_SLUG)
    version = versionkeys.map do | key |
      "#{key}: #{ENV[key]}"
    end
    #version = version.join(", ")
    github_link = "https://github.com/#{ENV['TRAVIS_REPO_SLUG']}/commit/#{ENV['TRAVIS_COMMIT']}"
    travis_link = "https://travis-ci.org/#{ENV['TRAVIS_REPO_SLUG']}/builds/#{ENV['TRAVIS_BUILD_ID']}"
    version = "This is <a href=\"#{github_link}\">#{ENV['TRAVIS_REPO_SLUG']}@#{ENV['TRAVIS_COMMIT']}</a> Build <a href=\"#{travis_link}\">#{ENV['TRAVIS_BUILD_NUMBER']}</a>"
    dir = 'app/views/learnery/version/'
    FileUtils.mkdir_p(dir)
    File.open(File.join(dir,'_version.html.erb'), 'w') { |file| file.write(version) }
    end
end

