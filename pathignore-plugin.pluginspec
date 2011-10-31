Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = 'pathignore-plugin'
  plugin.version = '0.2'
  plugin.description = 'Allows jobs to be skipped/run based on which paths changed.'

  plugin.depends_on 'ruby-runtime', '0.4'
end
