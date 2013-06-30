source 'https://rubygems.org'

# Specify your gem's dependencies in learnerydeploy.gemspec
gemspec

# for travis deploy to learnery-staging
# added here because .gemspec does not support depending on git versions
#http://stackoverflow.com/questions/6499410/ruby-gemspec-dependency-is-possible-have-a-git-branch-dependency
group :test do
  # forked for now because we need this:
  # https://github.com/learnery/heroku-headless/commit/b5179227c710ac84e871b91699fd0fc355d43b28
  gem 'heroku-headless', :git => 'https://github.com/drblinken/heroku-headless.git'
end
