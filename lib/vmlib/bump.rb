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

    # Bump the prerelease version by 1
    def bump_prerelease
      case @reltype
      when :rel_type_dev
        @devnum += 1
      when :rel_type_alpha
        @alphanum += 1
      when :rel_type_beta
        @betanum += 1
      when :rel_type_rc
        @rcnum += 1
      when :rel_type_final
        raise Errors::BumpError, "cannot bump prerelease for a final version"
      when :rel_type_custom
        lastfield = @relcustom.pop
        if lastfield.kind_of? Integer
          @relcustom.push (lastfield + 1)
        else
          @relcustom.push lastfield
          raise Errors::BumpError, "cannot bump a non-numeric prerelease field"
        end
      end
    end

    # Bump the prerelease type
    def bump_release_type
      case @reltype
      when :rel_type_dev # development -> alpha
        @reltype = :rel_type_alpha
        @alphanum = 1

      when :rel_type_alpha # alpha -> beta
        @reltype = :rel_type_beta
        @betanum = 1

      when :rel_type_beta # beta -> rc
        @reltype = :rel_type_rc
        @rcnum = 1

      when :rel_type_rc # rc -> final
        @reltype = :rel_type_final

      when :rel_type_final # ERROR!
        raise Errors::BumpError, "cannot bump from final version"

      when :rel_type_custom # ERROR!
        raise Errors::BumpError, "cannot bump from custom prerelease"

      end
    end

  end


end
