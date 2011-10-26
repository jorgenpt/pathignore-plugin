Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = 'pathfilter-plugin'
  plugin.version = '0.0.1'
  plugin.description = 'Allows jobs to be skipped based on changed paths.'

  plugin.depends_on 'ruby-runtime', '0.4'
end
