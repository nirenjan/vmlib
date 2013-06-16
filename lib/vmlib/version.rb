###############################################################################
# VMLib version information
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

module VMLib

  VERSION = "1.1.0-1" #:nodoc:

  def VMLib.gem_version
    /\d+\.\d+\.\d+/.match(VERSION).to_s
  end
end
