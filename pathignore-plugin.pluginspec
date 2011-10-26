Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = 'pathignore-plugin'
  plugin.version = '0.1.0'
  plugin.description = 'Allows jobs to be skipped based on changed paths.'

  plugin.depends_on 'ruby-runtime', '0.4'
end
