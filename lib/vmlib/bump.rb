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

    def bump_major
      @major = @major + 1
      @minor = 0
      @patch = 0

      true
    end

    def bump_minor
      @minor = @minor + 1
      @patch = 0

      true
    end

    def bump_patch
      @patch = @patch + 1

      true
    end

  end


end
