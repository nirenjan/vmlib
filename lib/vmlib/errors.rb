# encoding: UTF-8
###############################################################################
# VMLib exceptions
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

module VMLib
  # This is a namespace for errors that can be thrown by VMLib
  module Errors
    # Base class for all VMLib exceptions
    VMLibError = Class.new(::RuntimeError)

    # Thrown if release type doesn't match with requested parameter
    NoVersionError = Class.new(VMLibError)

    # Thrown if bump operation cannot be performed
    BumpError = Class.new(VMLibError)

    # Thrown if initialization fails
    InitError = Class.new(VMLibError)

    # Thrown if parsing fails
    ParseError = Class.new(VMLibError)

    # Thrown if assigning an invalid value
    AssignError = Class.new(VMLibError)

    # Thrown if the API receives invalid parameters
    ParameterError = Class.new(VMLibError)

    # Thrown if there's an issue with the path for the version file
    PathError = Class.new(VMLibError)

    # Thrown if there's an issue with the version file itself
    VersionFileError = Class.new(VMLibError)
  end
end
