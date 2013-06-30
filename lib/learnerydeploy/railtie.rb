require 'learnerydeploy'
require 'rails'
module Learnery
  class Railtie < Rails::Railtie
    railtie_name :learnerydeploy

    rake_tasks do
      load "tasks/learnery_deploy.rake"
    end

  end
end
