class PathfilterWrapper < Jenkins::Tasks::BuildWrapper
  # Called some time before the build is to start.
  def setup(build, launcher, listener, env)
    listener.info "build will start"
    begin
      build.native.setResult(Java.hudson.model.Result::NOT_BUILT)
    rescue
      listener.info "FAIL #{$!}"
    end

    false
  end

  # Called some time when the build is finished.
  def teardown(build, listener, env)
    listener.info "build finished"

    true
  end
end
