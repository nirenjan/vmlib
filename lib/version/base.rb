# encoding: UTF-8
###############################################################################
# VMLib base
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

module VMLib
  # This is the primary version number class for the version manager library
  class Version
    # Reset the version number to 0.0.0-0
    def reset
      @name = ''
      @major = 0
      @minor = 0
      @patch = 0
      @reltype = :rel_type_dev
      @devnum = 0
      @alphanum = 0
      @betanum = 0
      @rcnum = 0
      @relcustom = []
      @buildtype = :bld_type_final
      @buildcustom = []

      true
    end

    # Create a new version instance and set it to the specified parameters
    def initialize(name = '',
                   major = 0, minor = 0, patch = 0,
                   prerelease = '0', build = '')
      reset
      self.name = name
      self.major = major
      self.minor = minor
      self.patch = patch
      self.prerelease = prerelease
      self.build = build
    end

    # Inspect the version object
    def inspect
      str = "#<#{self.class}:"
      str += Kernel.format('0x%016x', object_id * 2)
      str += " @name='#{@name}'"
      str += " @major=#{@major}"
      str += " @minor=#{@minor}"
      str += " @patch=#{@patch}"

      str +=
        case @reltype
        when :rel_type_dev    then " @devnum=#{@devnum}"
        when :rel_type_alpha  then " @alphanum=#{@alphanum}"
        when :rel_type_beta   then " @betanum=#{@betanum}"
        when :rel_type_rc     then " @rcnum=#{@rcnum}"
        when :rel_type_custom then " @prerelease=#{@relcustom.inspect}"
        else ''
        end

      str +=
        case @buildtype
        when :bld_type_custom then " @build=#{@buildcustom.inspect}"
        else ''
        end

      str += '>'

      str
    end

    ###########################################################################
    # Accessor functions for name
    ###########################################################################

    # The program or project name
    attr_accessor :name

    # Set the program or project name
    undef name=
    def name=(name) #:nodoc:
      name.kind_of?(String) ||
        fail(Errors::AssignError, "invalid name #{name.inspect}")

      @name = name
    end

    ###########################################################################
    # Accessor functions for major
    ###########################################################################

    # The major version number
    attr_accessor :major

    # Set the major version number
    undef major=
    def major=(major) #:nodoc:
      major.kind_of?(Integer) ||
        fail(Errors::AssignError, "invalid major version #{major.inspect}")

      @major = major
    end

    ###########################################################################
    # Accessor functions for minor
    ###########################################################################

    # The minor version number
    attr_accessor :minor

    # Set the minor version number
    undef minor=
    def minor=(minor) #:nodoc:
      minor.kind_of?(Integer) ||
        fail(Errors::AssignError, "invalid minor version #{minor.inspect}")

      @minor = minor
    end

    ###########################################################################
    # Accessor functions for patch
    ###########################################################################

    # The patch version number
    attr_accessor :patch

    # Set the patch version number
    undef patch=
    def patch=(patch) #:nodoc:
      patch.kind_of?(Integer) ||
        fail(Errors::AssignError, "invalid patch version #{patch.inspect}")

      @patch = patch
    end

    ###########################################################################
    # Accessor functions for prerelease
    ###########################################################################

    # Get the prerelease information
    def prerelease #:attr:
      format '%r'
    end

    # Set the prerelease information
    def prerelease=(pre)
      pre.kind_of?(String) ||
        fail(Errors::ParseError, "invalid prerelease #{pre.inspect}")

      m = parse_release(pre)
      pre = pre.sub(SPECIAL_REGEX, '') if m
      warn "ignoring additional data #{pre.inspect}" unless pre.empty?

      true
    end

    ###########################################################################
    # Accessor functions for build
    ###########################################################################

    # Get the build information
    def build
      format '%b'
    end

    # Set the build information
    def build=(build)
      build.kind_of?(String) ||
        fail(Errors::ParseError, "invalid build #{build.inspect}")

      m = parse_build(build)
      build = build.sub(SPECIAL_REGEX, '') if m
      warn "ignoring additional data #{build.inspect}" unless build.empty?

      true
    end
  end
end
