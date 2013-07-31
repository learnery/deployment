
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
    if ENV['TRAVIS_TEST_RESULT'] != "0"
      puts "There were errors in the build - skipping deploy."
    else
      app_name = application_name

      puts "deploying to heroku app \"#{app_name}\""
      remote_name = "headlessheroku"
      HerokuHeadless.configure do | config |
        config.post_deploy_commands = ['rake db:migrate']
        config.pre_deploy_git_commands = [
          "git config --global user.email \"drblinken@gmail.com\"",
          "git config --global user.name \"Travis CI\"",
          "git checkout master",
          "git remote add #{remote_name} git@heroku.com:#{app_name}.git",
          "git add . ",
          "git commit -m \"version info from ci\" "
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

VERSION_INFO_DIR='app/views/learnery/version/'
VERSION_INFO_FILE='_version.html.erb'

def write_version_info_file(version)
    FileUtils.mkdir_p(VERSION_INFO_DIR)
    File.open(File.join(VERSION_INFO_DIR,VERSION_INFO_FILE), 'w') { |file| file.write(version) }

end

namespace :learnery do
  desc "Write Version Info from Travis Env"
  task :version do
    github_link = "https://github.com/#{ENV['TRAVIS_REPO_SLUG']}/commit/#{ENV['TRAVIS_COMMIT']}"
    travis_link = "https://travis-ci.org/#{ENV['TRAVIS_REPO_SLUG']}/builds/#{ENV['TRAVIS_BUILD_ID']}"
    version = "This is <a href=\"#{github_link}\">#{ENV['TRAVIS_REPO_SLUG']}@#{ENV['TRAVIS_COMMIT'][0..6]}</a> Build <a href=\"#{travis_link}\">#{ENV['TRAVIS_BUILD_NUMBER']}</a>"
    write_version_info_file(version)
  end
end

namespace :learnery do
  desc "Overwrites Version Info"
  task :versiondelete do
  version = "(Deploy Script Generated Version Info Should Go Here"
  write_version_info_file(version)
  end
end

