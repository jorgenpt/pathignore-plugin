class PathignoreWrapper < Jenkins::Tasks::BuildWrapper
  display_name "Do not build if only specified paths have changed"

  attr_accessor :invert_ignore
  attr_accessor :ignored_paths

  def initialize(attrs)
    @invert_ignore = attrs['invert_ignore']
    @ignored_paths = attrs['ignored_paths']
  end

  # Here we test if any of the changes warrant a build
  def setup(build, launcher, listener, env)
    patterns = @ignored_paths.split(',').collect { |p| p.strip }
    verb = if invert_ignore then "Including" else "Ignoring" end
    listener.info "#{verb} paths matching patterns: #{patterns.inspect}"

    paths = []

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
          paths << path

          # For each path we see if at least one ignore matches, and ignore this
          # file if that's the case.
          pattern_matched = false
          patterns.each do |pattern|
            if File.fnmatch(pattern, path)
              pattern_matched = true
              break
            end
          end

          # If file isn't ignored, we keep on truckin', i.e. run the build.
          if not invert_ignore and not pattern_matched
            listener.info "File #{path} passed filter, running build."
            return
          elsif invert_ignore and pattern_matched
            listener.info "File #{path} passed filter, running build."
            return
          end
        end
      end
    rescue
      listener.error "Encountered exception when scanning for filtered paths: #{$!}"
      listener.error "Allowing build by default."
      return
    end

    # We only get here if no unignored or included file was touched, so skip build.
    listener.info "No paths passed filter, skipping build."
    listener.info "Changed paths: #{paths.inspect}"

    build.native.setResult(Java.hudson.model.Result::NOT_BUILT)
    build.halt("Build not needed.")
  end
end
