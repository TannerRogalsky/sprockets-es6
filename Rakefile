require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.warning = true
end

task :vendor do
  sh "git submodule init"
  sh "git submodule update"

  cd "vendor/6to5" do
    sh "npm install"
    sh "make build"
  end

  cp "vendor/6to5/dist/6to5.js", "lib/sprockets/es6/6to5.js"
  cp "vendor/6to5/dist/polyfill.js", "lib/sprockets/es6/6to5/polyfill.js"
  cp "vendor/6to5/dist/runtime.js", "lib/sprockets/es6/6to5/runtime.js"
end
