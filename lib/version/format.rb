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
      fstr = format_name(fstr)

      # Match the major version
      fstr = format_vnumber(fstr, 'M', @major)

      # Match the minor version
      fstr = format_vnumber(fstr, 'm', @minor)

      # Match the patch version
      fstr = format_vnumber(fstr, 'p', @patch)

      # Match the prerelease version
      fstr = format_prerelease(fstr)

      # Match the build version
      fstr = format_build(fstr)
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

    private

    def format_name(fstr)
      if @name.empty?
        fstr.gsub('%n', '')
      else
        fstr.gsub('%n', @name.to_s + ' ')
      end
    end

    def format_vnumber(fstr, cls, val)
      expr = /%(\d*)#{cls}/
      loop do
        match = expr.match(fstr)
        break unless match
        fstr = fstr.sub(expr, Kernel.format("%0#{match[1]}d", val))
      end
      fstr
    end

    def format_prerelease(fstr)
      case @reltype
      when :rel_type_dev    then fstr.gsub('%r', "-#{@devnum}")
      when :rel_type_alpha  then fstr.gsub('%r', "-a.#{@alphanum}")
      when :rel_type_beta   then fstr.gsub('%r', "-b.#{@betanum}")
      when :rel_type_rc     then fstr.gsub('%r', "-rc.#{@rcnum}")
      when :rel_type_custom then fstr.gsub('%r', '-' + @relcustom.join('.'))
      else fstr.gsub('%r', '')
      end
    end

    def format_build(fstr)
      case @buildtype
      when :bld_type_custom then fstr.gsub('%b', '+' + @buildcustom.join('.'))
      else fstr.gsub('%b', '')
      end
    end
  end
end
