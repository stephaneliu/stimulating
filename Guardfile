# frozen_string_literal: true

guard 'process', name: 'Webpacker', command: 'bin/webpack' do
  watch(%r{^app/javascript/w+/*})
end


brakeman_options = {
  run_on_start: true,
  quiet: true
}

guard 'brakeman', brakeman_options do
  watch(%r{^app/.+.(erb|haml|rhtml|rb)$})
  watch(%r{^config/.+.rb$})
  watch(%r{^lib/.+.rb$})
  watch('Gemfile')
end

# Guard-HamlLint supports a lot options with default values:
# all_on_start: true        # Check all files at Guard startup. default: true
# haml_dires: ['app/views'] # Check Directories. default: 'app/views' or '.'
# cli: '--fail-fast --no-color' # Additional command line options to haml-lint.
guard :haml_lint, all_on_start: false do
  watch(%r{.+.html.*.haml$})
  watch(%r{(?:.+/)?.haml-lint.yml$}) { |m| File.dirname(m[0]) }
end

group :red_green_refactor, halt_on_fail: true do
  rspec_options = {
    cmd: 'bin/rspec -f doc',
    run_all: {
      cmd: 'COVERAGE=true DISABLE_SPRING=true bin/rspec -f doc'
    },
    all_after_pass: true
  }

  guard :rspec, rspec_options do
    require "guard/rspec/dsl"
    dsl = Guard::RSpec::Dsl.new(self)

    # RSpec files
    rspec = dsl.rspec

    watch(rspec.spec_helper)  { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    # Ruby files
    ruby = dsl.ruby

    dsl.watch_spec_files_for(ruby.lib_files)

    # Rails files
    rails = dsl.rails(view_extensions: %w(erb haml slim))
    dsl.watch_spec_files_for(rails.app_files)
    dsl.watch_spec_files_for(rails.views)

    watch(rails.controllers) do |m|
      [
        rspec.spec.call("routing/#{m[1]}_routing"),
        rspec.spec.call("controllers/#{m[1]}_controller"),
        rspec.spec.call("acceptance/#{m[1]}")
      ]
    end

    # Rails config changes
    watch(rails.spec_helper)    { rspec.spec_dir }
    watch(rails.routes)         { "#{rspec.spec_dir}/routing" }
    watch(rails.app_controller) { "#{rspec.spec_dir}/controllers" }

    # Capybara features specs
    watch(rails.view_dirs) { |m| rspec.spec.call("features/#{m[1]}") }
    watch(rails.layouts)   { |m| rspec.spec.call("features/#{m[1]}") }

    # Turnip features and steps
    watch(%r{^spec/acceptance/(.+).feature$})
    watch(%r{^spec/acceptance/steps/(.+)_steps.rb$}) do |m|
      Dir[File.join("**/#{m[1]}.feature")][0] || "spec/acceptance"
    end
  end

  rubocop_options = {
    all_on_start: false,
    cli: '--rails --parallel',
    # keep_failed: true,
  }

  guard :rubocop, rubocop_options do
    watch(%r{.+.rb$})
    watch(%r{(?:.+/)?.rubocop(?:_todo)?.yml$}) { |m| File.dirname(m[0]) }
  end
end
