###############################################################################
# VMLib range manager
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

;

module VMLib

  class Range

    # Initialize the range
    def initialize
      range_lo = Version.new '', 0, 0, 0
      @range = [:range_op_ge, range_lo]
      @match_pre = false
    end

    # Set the range
    def range= (val)
      unless val.kind_of? String
        raise Errors::ParameterError, "unrecognized input type #{val}"
      end

      # Supported values
      # * 1.2.3 - 1.3.4 inclusive ranges
      # * 1 - 2 imprecise inclusive ranges, basically means any version from
      #   1.0.0 to 1.x.y (less than 2.0.0)
      # * 1.2 - 1.2.3 - means any version from 1.2.0 to 1.2.3
      # * 1.2.3 - 1.4 - means any version from 1.2.3 to 1.4.x (less than 1.5.0)
      # * 1.x - Any 1.x.y release
      # * 1.2.x - Any 1.2.x release
      # * 1 - Any 1.x.y release
      # * 1.2 - Any 1.2.x release
      # * 1.2.3 - Only release 1.2.3
      # * ~> 1 - Ruby version constraint operator - any version >= 1.0.0
      # * ~> 1.2 - any version >= 1.2.0, but < 2.0.0
      # * ~> 1.2.3 - any version >= 1.2.3 but < 1.3.0
      # * > x, > x.y, > x.y.z - Strictly greater than
      # * >=, <, <= as above
      # || - allows specification of multiple ranges using a boolean OR
      # && - allows specification of multiple ranges using a boolean AND
      # ! - allows negation of a particular range
    end

  end


end
