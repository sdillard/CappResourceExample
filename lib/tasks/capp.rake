namespace :capp do
  desc 'compile latest changes for release'
  task :compile_release do
    cmd = ["cd capp", "rm -rf Build/Release", "jake release"].join(" && ")
    system(cmd)
  end
  
  desc 'compile latest changes for debug'
  task :compile_debug do
    cmd = ["cd capp", "rm -rf Build/Debug", "jake debug"].join(" && ")
    system(cmd)
  end
  
  desc 'clean all builds'
  task :clean do
    cmd = ["cd capp", "rm -rf Build/*"].join(" && ")
    system(cmd)
  end

  namespace :link do

    desc 'symlink the development env'
    task :dev do
      cmd = ["rm -rf public", "ln -s capp public"].join(" && ")
      system(cmd)
    end
    
    desc 'symlink the compiled debug env'
    task :debug do
      cmd = ["rm -rf public", "ln -s capp/Build/Debug/ceroi public"].join(" && ")
      system(cmd)
    end

    desc 'symlink the release env'
    task :release do
      cmd = ["rm -rf public", "ln -s capp/Build/Release/ceroi public"].join(" && ")
      system(cmd)
    end

  end
  
  desc 'compile release version and symlink public'
  task :promote do
    cmd = ["cd capp", "rm -rf Build/Release", "jake release"].join(" && ")
    system(cmd)
    cmd = ["rm -rf public", "ln -s capp/Build/Release/ceroi public"].join(" && ")
    system(cmd)
  end
  
  desc 'compile debug version and symlink public'
  task :promote_debug do
    cmd = ["cd capp", "rm -rf Build/Debug", "jake debug"].join(" && ")
    system(cmd)
    cmd = ["rm -rf public", "ln -s capp/Build/Debug/ceroi public"].join(" && ")
    system(cmd)
  end
end
