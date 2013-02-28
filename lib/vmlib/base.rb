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

  end


end
