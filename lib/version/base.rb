###############################################################################
# VMLib base
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

;

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
    def initialize(name = '', major = 0, minor = 0, patch = 0, prerelease = '0', build = '')
      reset
      set_name name
      set_major major
      set_minor minor
      set_patch patch
      set_prerelease prerelease
      set_build build
    end
    
    # Inspect the version object
    def inspect
      str = "#<#{self.class}:"
      str += "0x%016x" % (self.object_id * 2)
      str += " @name='#{@name}'"
      str += " @major=#{@major}"
      str += " @minor=#{@minor}"
      str += " @patch=#{@patch}"

      case @reltype
      when :rel_type_dev
        str += " @devnum=#{@devnum}"
      when :rel_type_alpha
        str += " @alphanum=#{@alphanum}"
      when :rel_type_beta
        str += " @betanum=#{@betanum}"
      when :rel_type_rc
        str += " @rcnum=#{@rcnum}"
      when :rel_type_custom
        str += " @prerelease=#{@relcustom.inspect}"
      end

      case @buildtype
      when :bld_type_custom
        str += " @build=#{@buildcustom.inspect}"
      end

      str += ">"

      str
    end

    ###########################################################################
    # Accessor functions for name
    ###########################################################################

    # The program or project name
    attr_accessor :name

    # Set the program or project name
    undef name=
    def name= (name) #:nodoc:
      set_name name
    end

    def set_name (name) #:nodoc:
      name.kind_of? String or
        raise Errors::AssignError, "invalid name #{name.inspect}"

      @name = name
    end
    private :set_name

    ###########################################################################
    # Accessor functions for major
    ###########################################################################

    # The major version number
    attr_accessor :major

    # Set the major version number
    undef major=
    def major=(major) #:nodoc:
      set_major major
    end

    def set_major (major) #:nodoc:
      major.kind_of? Integer or
        raise Errors::AssignError, "invalid major version #{major.inspect}"

      @major = major
    end
    private :set_major

    ###########################################################################
    # Accessor functions for minor
    ###########################################################################

    # The minor version number
    attr_accessor :minor

    # Set the minor version number
    undef minor=
    def minor=(minor) #:nodoc:
      set_minor minor
    end

    def set_minor (minor) #:nodoc:
      minor.kind_of? Integer or
        raise Errors::AssignError, "invalid minor version #{minor.inspect}"

      @minor = minor
    end
    private :set_minor

    ###########################################################################
    # Accessor functions for patch
    ###########################################################################

    # The patch version number
    attr_accessor :patch

    # Set the patch version number
    undef patch=
    def patch=(patch) #:nodoc:
      set_patch patch
    end

    def set_patch (patch) #:nodoc:
      patch.kind_of? Integer or
        raise Errors::AssignError, "invalid patch version #{patch.inspect}"

      @patch = patch
    end
    private :set_patch

    ###########################################################################
    # Accessor functions for prerelease
    ###########################################################################

    # Get the prerelease information
    def prerelease #:attr:
      format '%r'
    end

    # Set the prerelease information
    def prerelease=(prerelease)
      set_prerelease prerelease
    end

    def set_prerelease (prerelease) #:nodoc:
      prerelease.kind_of? String or
        raise Errors::ParseError, "invalid prerelease #{prerelease.inspect}"

      m = parse_release(prerelease)
      prerelease = prerelease.sub(SPECIAL_REGEX, '') if m
      warn "ignoring additional data #{prerelease.inspect}" unless prerelease.empty?

      true
    end
    private :set_prerelease

    ###########################################################################
    # Accessor functions for build
    ###########################################################################

    # Get the build information
    def build
      format '%b'
    end

    # Set the build information
    def build=(build)
      set_build build
    end

    def set_build (build) #:nodoc:
      build.kind_of? String or
        raise Errors::ParseError, "invalid build #{build.inspect}"

      m = parse_build(build)
      build = build.sub(SPECIAL_REGEX, '') if m
      warn "ignoring additional data #{build.inspect}" unless build.empty?

      true
    end


  end


end
