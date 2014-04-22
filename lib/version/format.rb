# encoding: UTF-8
###############################################################################
# VMLib formatter
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

module VMLib
  class Version
    # Default tag format for version control systems
    TAG_FORMAT = 'v%M.%m.%p%r%b'

    # Display the version in the specified format
    # Input: Format string
    #        %n - name
    #        %M - major version number
    #        %m - minor version number
    #        %p - patch number
    #        %r - prerelease
    #        %b - build number
    def format(fstr)
      if @name.empty?
        fstr = fstr.gsub('%n', '')
      else
        fstr = fstr.gsub('%n', @name.to_s + ' ')
      end

      # Match the major version
      match = /%(\d*)M/.match(fstr)
      fstr = fstr.gsub(/%(\d*)M/, "%0#{$1}d" % @major)

      # Match the minor version
      match = /%(\d*)m/.match(fstr)
      fstr = fstr.gsub(/%(\d*)m/, "%0#{$1}d" % @minor)

      # Match the patch version
      match = /%(\d*)p/.match(fstr)
      fstr = fstr.gsub(/%(\d*)p/, "%0#{$1}d" % @patch)

      if (@reltype == :rel_type_final) ||
         (@reltype == :rel_type_custom && @relcustom.length == 0)
        fstr = fstr.gsub('%r', '')
      else
        fstr =
          case @reltype
          when :rel_type_dev
            fstr.gsub('%r', "-#{@devnum}")
          when :rel_type_alpha
            fstr.gsub('%r', "-a.#{@alphanum}")
          when :rel_type_beta
            fstr.gsub('%r', "-b.#{@betanum}")
          when :rel_type_rc
            fstr.gsub('%r', "-rc.#{@rcnum}")
          when :rel_type_custom
            fstr.gsub('%r', '-' + @relcustom.join('.'))
          else
            fstr.gsub('%r', '')
          end
      end

      if (@buildtype == :bld_type_final) ||
         (@buildtype == :bld_type_custom && @buildcustom.length == 0)
        fstr = fstr.gsub('%b', '')
      else
        fstr =
          case @buildtype
          when :bld_type_custom
            fstr.gsub('%b', '+' + @buildcustom.join('.'))
          else
            fstr.gsub('%b', '')
          end
      end

      fstr
    end

    # Display a version tag suitable for use in tagging releases
    # in the user's version control system
    def tag
      format TAG_FORMAT
    end

    # Display the version information as a string
    def to_s
      format '%n%M.%m.%p%r%b'
    end
  end
end
