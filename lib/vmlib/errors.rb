###############################################################################
# VMLib exceptions
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

;

module VMLib


  # This is a namespace for errors that can be thrown by VMLib
  module Errors

    # Base class for all VMLib exceptions
    class VMLibError < ::RuntimeError
    end

    # Thrown if release type doesn't match with requested parameter
    class NoVersionError < VMLibError
    end

    # Thrown if bump operation cannot be performed
    class BumpError < VMLibError
    end

    # Thrown if initialization fails
    class InitError < VMLibError
    end

    # Thrown if parsing fails
    class ParseError < VMLibError
    end

    # Thrown if assigning an invalid value
    class AssignError < VMLibError
    end

  end


end

