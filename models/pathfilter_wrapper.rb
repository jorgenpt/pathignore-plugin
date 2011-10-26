class PathfilterWrapper < Jenkins::Tasks::BuildWrapper
  display_name "Pathfilter"

  # Called some time before the build is to start.
  def setup(build, launcher, listener, env)
    listener.info "build will start"
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
