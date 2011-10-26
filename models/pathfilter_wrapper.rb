class PathfilterWrapper < Jenkins::Tasks::BuildWrapper
  display_name "Pathfilter"

  attr_accessor :include_paths
  attr_accessor :exclude_paths

  def initialize(attrs)
    p attrs
    @include_paths = attrs['include_paths']
    @exclude_paths = attrs['exclude_paths']
  end

  # Called some time before the build is to start.
  def setup(build, launcher, listener, env)
    listener.info "build will start: #{@include_paths.inspect} #{@exclude_paths.inspect}"
    build.native.setResult(Java.hudson.model.Result::NOT_BUILT)

    changeset = build.native.getChangeSet()
    listener.info "Changeset: #{changeset}"
    begin
      changeset.each {|change|
        listener.info " Change: #{change}"
        files = change.getAffectedFiles()
        listener.info "  Affected: #{files}"
      }
    rescue
    end

    build.halt("Stopping you")
  end

  # Called some time when the build is finished.
  def teardown(build, listener, env)
    listener.info "build finished"

    true
  end
end
