# encoding: UTF-8
###############################################################################
# VMLib class attributes
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

module VMLib
  # This is the primary version number class for the version manager library
  class Version
    # ==================================================================
    # Compare build operator - this is false by default
    # ==================================================================
    @@compare_build = false

    def self.compare_build=(val) #:nodoc:
      unless val == true || val == false
        fail Errors::ParameterError, "invalid value #{val}"
      end

      @@compare_build = val
    end

    # Specify whether to compare build metadata or not between two versions
    def self.compare_build
      @@compare_build
    end

    # ==================================================================
    # Prerelease parser - this is enabled by default
    # ==================================================================
    @@enable_prerelease_parser = true

    def self.enable_prerelease_parser=(val) #:nodoc:
      unless val == true || val == false
        fail Errors::ParameterError, "invalid value #{val}"
      end

      @@enable_prerelease_parser = val
    end

    # Specify whether to use the prerelease parser or not. Disabling this
    # will cause an error to be thrown in the following cases:
    # * Calling the bump_release_type functionality
    # * Calling bump_prerelease with a non-numeric identifier at the end
    def self.enable_prerelease_parser
      @@enable_prerelease_parser
    end
  end
end
