class PathignoreWrapper < Jenkins::Tasks::BuildWrapper
  display_name "Do not build if only specified paths have changed"

  attr_accessor :ignored_paths

  def initialize(attrs)
    @ignored_paths = attrs['ignored_paths']
  end

  # Here we test if any of the changes affect non-ignored files
  def setup(build, launcher, listener, env)
    ignored_paths = @ignored_paths.split(',').collect { |p| p.strip }
    listener.info "Ignoring paths: #{ignored_paths.inspect}"

    begin
      changeset = build.native.getChangeSet()
      # XXX: Can there be files in the changeset if it's manually triggered?
      # If so, how do we check for manual trigger?
      if changeset.isEmptySet()
        listener.info "Empty changeset, running build."
        return
      end

      changeset.each do |change|
        change.getAffectedPaths().each do |path|

          # For each path we see if at least one ignore matches, and ignore this
          # file if that's the case.
          should_ignore = false
          ignored_paths.each do |ignore|
            if File.fnmatch(ignore, path)
              should_ignore = true
              break
            end
          end

          # If file isn't ignored, we keep on truckin', i.e. run the build.
          if not should_ignore
            listener.info "Found non-ignored file change, running build."
            return
          end
        end
      end
    rescue
      listener.error "Encountered exception when scanning for ignored paths: #{$!}"
    end

    # We only get here if no unignored file was touched, so skip build.
    listener.info "All files ignored, skipping build."
    build.native.setResult(Java.hudson.model.Result::NOT_BUILT)
    build.halt("Build not needed.")
  end
end
