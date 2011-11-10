Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = 'pathignore'
  plugin.version = '0.2'
  plugin.description = 'Allows SCM-triggered jobs to ignore build requests if only certain paths have changed, or to build if and only if certain paths are changed'

  plugin.url = 'https://wiki.jenkins-ci.org/display/JENKINS/Pathignore+Plugin'
  plugin.developed_by 'jorgenpt', 'Jørgen P. Tjernø <jorgenpt@gmail.com>'

  plugin.depends_on 'ruby-runtime', '0.4'
end
