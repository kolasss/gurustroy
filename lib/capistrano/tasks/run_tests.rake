before :deploy, "deploy:run_tests"

namespace :deploy do
  desc "Runs test before deploying, can't deploy unless they pass"
  task :run_tests do
    test_log = "log/capistrano.test.log"
    puts "--> Running tests ... Please wait ..."
    unless system "SKIP_COVERAGE=true bundle exec rake test > #{test_log} 2>&1"
      puts "--> Tests failed. Results in: #{test_log} and below:"
      system "cat #{test_log}"
      exit;
    end
    puts "--> All tests passed"
    system "rm #{test_log}"
  end
end
