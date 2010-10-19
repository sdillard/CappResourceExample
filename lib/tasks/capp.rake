namespace :capp do

  namespace :compile do

    desc 'compile latest changes for release'
    task :release do
      cmd = ["cd capp", "rm -rf Build/Release", "jake release"].join(" && ")
      system(cmd)
    end
    
    desc 'compile latest changes for debug'
    task :debug do
      cmd = ["cd capp", "rm -rf Build/Debug", "jake debug"].join(" && ")
      system(cmd)
    end
    
    desc 'clean all builds'
    task :clean do
      cmd = ["cd capp", "rm -rf Build/*"].join(" && ")
      system(cmd)
    end

  end

  namespace :util do
    
    desc 'sets the environment variable based on YAML config file'
    task :set_project do
      if defined?(Rails) && defined?(Rails.root)
        #use this if on Rails 3+
        capp_config_file = Rails.root.join('/config/capp_project.yml')
      else
        #use this if on Rails < 3
        capp_config_file = "#{RAILS_ROOT}/config/capp_project.yml"
      end
      capp_config = YAML::load(File.open(capp_config_file)) if File.exists? capp_config_file
      ENV['CAPP_PROJECT_NAME'] = capp_config["project"] if capp_config
    end
    
  end
  
  namespace :link do

    desc 'symlink the development env'
    task :dev do
      cmd = ["rm -rf public", "ln -s capp public"].join(" && ")
      system(cmd)
    end
    
    desc 'symlink the compiled debug env'
    task :debug => ['capp:util:set_project'] do
      project_name = ENV['CAPP_PROJECT_NAME']
      if project_name
        cmd = ["rm -rf public", "ln -s capp/Build/Debug/#{project_name} public"].join(" && ")
        system(cmd)
      end
    end

    desc 'symlink the release env'
    task :release => ['capp:util:set_project'] do
      project_name = ENV['CAPP_PROJECT_NAME']
      if project_name
        cmd = ["rm -rf public", "ln -s capp/Build/Release/#{project_name} public"].join(" && ")
        system(cmd)
      end
    end

  end
  
  namespace :promote do

    desc 'compile release version and symlink public'
    task :release => ['capp:compile:release', 'capp:link:release'] do      
    end
    
    desc 'compile debug version and symlink public'
    task :debug => ['capp:compile:debug', 'capp:link:debug'] do      
    end

  end
end
