###############################################################################
# VMLib version information
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

module VMLib

  VERSION = "1.1.0" #:nodoc:

  # This function is used by the gemspec file to generate a
  # gem version number that corresponds to %M.%m.%p format
  def VMLib.gem_version #:nodoc:
    /\d+\.\d+\.\d+/.match(VERSION).to_s
  end
end
