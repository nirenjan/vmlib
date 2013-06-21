###############################################################################
# VMLib class attributes
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

;

module VMLib

  # This is the primary version number class for the version manager library
  class Version

    # Specify whether to compare build metadata or not between two versions
    @@compare_build = false

    # Specify whether to use the prerelease parser or not. Disabling this
    # will cause an error to be thrown in the following cases:
    # * Calling the bump_release_type functionality
    # * Calling bump_prerelease with a non-numeric identifier at the end
    @@enable_prerelease_parser = true

  end


end
