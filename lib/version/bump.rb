###############################################################################
# VMLib bump routines
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

;

module VMLib

  class Version

    # Bump the major release by 1 and reset the minor and patch
    # releases to 0.
    def bump_major
      @major = @major + 1
      @minor = 0
      @patch = 0

      true
    end

    # Bump the minor release by 1 and reset the patch release to 0
    def bump_minor
      @minor = @minor + 1
      @patch = 0

      true
    end

    # Bump the patch release by 1
    def bump_patch
      @patch = @patch + 1

      true
    end

  end


end
