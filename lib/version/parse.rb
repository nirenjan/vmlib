# encoding: UTF-8
###############################################################################
# VMLib parser
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

module VMLib
  class Version
    # The parse functions are all marked as private

    private

    # Regular expression format to understand the release and build formats.
    #
    # Acceptable formats:
    #     alpha.1.4
    #     beta.1.4
    #     6.2.8
    #     1
    #     build-256.2013-01-04T16-40Z
    #
    # These fields consist of dot-separated identifiers, and these identifiers
    # may contain only alphanumeric characters and hyphens.
    #
    # Fields consisting of only digits will be interpreted as numeric and
    # leading zeroes will be stripped.
    SPECIAL_REGEX = /^[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*/

    # Regular expression to understand the version format.
    #
    # Acceptable formats:
    #     1.78.2
    #     v1.30.4908
    #     version 2.4.875
    #
    # Leading zeroes are not accepted in any numeric field
    VER_REGEX = /^(?:v|version )?(?<major>0|[1-9]\d*)\.(?<minor>0|[1-9]\d*)\.(?<patch>0|[1-9]\d*)/

    # Regular expression to understand the version format with optional leading
    # zeroes
    VER_REGEX_ZERO = /^(?:v|version )?\d+\.\d+\.\d+/

    # Regular expression format to retrieve the name. Names may consist of
    # any combination of any alphanumeric character, underscores and hyphens.
    NAME_REGEX = /^(?<name>[0-9A-Za-z_-]+)\s+/

    def convert_to_integer(array)
      array.kind_of?(Array) ||
        fail(Errors::VMLibError, "not an array: #{array}")

      array.each_index do |i|
        array[i].to_s.match(/^\d+$/) && array[i] = array[i].to_i
      end
    end

    def parse_release(str)
      match = SPECIAL_REGEX.match(str)
      if match
        # OK, we have a prerelease match, now parse it to determine
        # the release type
        @relcustom = match[0].split '.'

        # Cross check to make sure that we don't have leading zeroes
        # in any numeric field
        @relcustom.each do |r|
          if r.to_s.match(/^0\d+$/)
            fail Errors::ParseError,
                 'leading zeroes not allowed in numeric identifiers'
          end
        end

        rel = @relcustom[0]
        case rel

        # Development version 1.0.0-0, 1.0.0-1, 1.0.0-2, etc.
        when /^\d+$/
          if @relcustom.length == 1
            @reltype = :rel_type_dev
            @devnum = rel.to_i
          else
            @reltype = :rel_type_custom
          end

        # Alpha version 1.0.0-a.1, 1.0.0-alpha.2, etc.
        when /^(a|alpha)$/
          if @relcustom.length == 2 && @relcustom[1].match(/^\d+$/)
            @reltype = :rel_type_alpha
            @alphanum = @relcustom[1].to_i
          else
            @reltype = :rel_type_custom
          end

        # Beta version 1.0.0-b.1, 1.0.0-beta.2, etc.
        when /^(b|beta)$/
          if @relcustom.length == 2 && @relcustom[1].match(/^\d+$/)
            @reltype = :rel_type_beta
            @betanum = @relcustom[1].to_i
          else
            @reltype = :rel_type_custom
          end

        # Release Candidate version 1.0.0-rc.1, 1.0.0-rc.2, etc.
        when /^rc$/
          if @relcustom.length == 2 && @relcustom[1].match(/^\d+$/)
            @reltype = :rel_type_rc
            @rcnum = @relcustom[1].to_i
          else
            @reltype = :rel_type_custom
          end

        else
          @reltype = :rel_type_custom
        end

        # The user may have disabled the prerelease parser
        @reltype = :rel_type_custom unless @@enable_prerelease_parser

        # Done parsing, clear the relcustom array if it's not a custom type
        @relcustom = [] unless @reltype == :rel_type_custom
        convert_to_integer(@relcustom)
      else # if !match
        # It may be an empty string, so set the reltype to final in that case
        if str.empty?
          match = nil
          @reltype = :rel_type_final
        else
          fail Errors::ParseError, "unrecognized prerelease '#{str}'"
        end
      end

      match
    end

    def parse_build(str)
      match = SPECIAL_REGEX.match(str)
      if match
        # OK, we have a build match, now parse it to determine
        # the release type
        # Currently, only supports :bld_type_custom
        @buildcustom = match[0].split '.'
        @buildtype = :bld_type_custom

        # Done parsing, clear the array if it's not a custom type
        @buildcustom = [] unless @buildtype == :bld_type_custom
        # Converting to integer breaks some of the sample test cases on
        # semver.org. Therefore, we will leave the strings as is.
      else # if !match
        # It may be an empty string, so set the buildtype to final in that case
        if str.empty?
          match = nil
          @buildtype = :bld_type_final
        else
          fail Errors::ParseError, "unrecognized build '#{str}'"
        end
      end

      match
    end

    public

    # Parse a string containing the project name and version number into
    # its individual components
    def parse(ver)
      unless ver.kind_of? String
        fail Errors::ParameterError, 'expected a string to be parsed'
      end

      # Chop off any trailing newlines
      ver.chomp!

      # Match the name
      match = NAME_REGEX.match(ver)
      if match
        @name = match[:name]
        ver = ver.sub(NAME_REGEX, '')
      else
        # Sometimes we may not get a name to be parsed. If that's the case
        # then ensure we clear the name field.
        @name = ''
      end

      # Match the major, minor and patch versions
      match = VER_REGEX.match(ver)
      if match
        @major = match[:major].to_i
        @minor = match[:minor].to_i
        @patch = match[:patch].to_i
        ver = ver.sub(VER_REGEX, '')
      else
        if VER_REGEX_ZERO.match(ver)
          fail Errors::ParseError, 'leading zeroes not acceptable in version'
        else
          fail Errors::ParseError, "unrecognized version format '#{ver}'"
        end
      end

      # See if we have a prerelease version (begins with a -)
      if ver =~ /^-/
        ver = ver.sub(/^-/, '')

        match = parse_release(ver)
        if match
          # Delete the matched data
          ver = ver.sub(SPECIAL_REGEX, '')
        end
      else # if ver !~ /^-/
        @reltype = :rel_type_final
      end

      # See if we have a build version (begins with a +)
      if ver =~ /^\+/
        ver = ver.sub(/^\+/, '')

        match = parse_build(ver)
        if match
          # Delete the matched data
          ver = ver.sub(SPECIAL_REGEX, '')
        end
      else # if ver !~ /^\+/
        @buildtype = :bld_type_final
      end

      # By now, ver should be empty. Raise an error if this is not the case
      unless ver.empty?
        fail Errors::ParseError, "unrecognized version format '#{ver}'"
      end

      true
    end
  end
end
