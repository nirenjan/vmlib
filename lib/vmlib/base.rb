###############################################################################
# VMLib base
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

;

module VMLib

  # This is the primary version number class
  class Version

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

    def initialize
      reset
    end
    
    # Accessor functions for name
    attr_reader :name

    def name=(nm)
      nm.kind_of? String or
        raise Errors::AssignError, "invalid name #{nm.inspect}"

      @name = nm
    end

    # Accessor functions for major
    attr_reader :major

    def major=(m)
      m.kind_of? Integer or
        raise Errors::AssignError, "invalid major version #{m.inspect}"

      @major = m
    end

    # Accessor functions for minor
    attr_reader :minor

    def minor=(m)
      m.kind_of? Integer or
        raise Errors::AssignError, "invalid minor version #{m.inspect}"

      @minor = m
    end

    # Accessor functions for patch
    attr_reader :patch

    def patch=(p)
      p.kind_of? Integer or
        raise Errors::AssignError, "invalid patch version #{p.inspect}"

      @patch = p
    end

    # Accessor functions for prerelease
    def prerelease
      format '%r'
    end

    def prerelease=(r)
      r.kind_of? String or
        raise Errors::ParseError, "invalid prerelease #{r.inspect}"

      m = parse_release(r)
      r = r.sub(SPECIAL_REGEX, '') if m
      warn "ignoring additional data #{r.inspect}" unless r.empty?

      true
    end

    # Accessor functions for build
    def build
      format '%b'
    end

    def build=(b)
      b.kind_of? String or
        raise Errors::ParseError, "invalid build #{b.inspect}"

      m = parse_build(b)
      b = b.sub(SPECIAL_REGEX, '') if m
      warn "ignoring additional data #{b.inspect}" unless b.empty?

      true
    end

  end


end
