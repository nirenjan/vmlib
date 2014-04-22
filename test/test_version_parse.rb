# encoding: UTF-8
###############################################################################
# VMLib version parsing test cases
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

require 'test/unit'
require 'vmlib'

module VMLib

  module Tests #:nodoc:

    class TestVersionParse < ::Test::Unit::TestCase   #:nodoc:


      # Test parsing individual components
      def test_version_parse
        v = VMLib::Version.new

        # Test parsing the version with name and prerelease
        v.parse 'vmlib v1.1.0-2'

        assert_equal 'vmlib', v.name
        assert_equal 1, v.major
        assert_equal 1, v.minor
        assert_equal 0, v.patch
        assert_equal '-2', v.prerelease
        assert_equal '', v.build

        # Test parsing a version without the name
        v.parse 'v1.1.0-2'

        assert_equal '', v.name
        assert_equal 1, v.major
        assert_equal 1, v.minor
        assert_equal 0, v.patch
        assert_equal '-2', v.prerelease
        assert_equal '', v.build

        # Test parsing a version with the format as name version X.Y.Z
        v.parse 'vmlib version 1.1.0-2'

        assert_equal 'vmlib', v.name
        assert_equal 1, v.major
        assert_equal 1, v.minor
        assert_equal 0, v.patch
        assert_equal '-2', v.prerelease
        assert_equal '', v.build

        # Test parsing a version with the format as name X.Y.Z
        v.parse 'vmlib 1.1.0-2'

        assert_equal 'vmlib', v.name
        assert_equal 1, v.major
        assert_equal 1, v.minor
        assert_equal 0, v.patch
        assert_equal '-2', v.prerelease
        assert_equal '', v.build

        # Invalid version format (such as 1.2.a3) throws an error
        assert_raise VMLib::Errors::ParseError do
          v.parse 'vmlib 2.0.a1'
        end

        # Right now, vmlib does not support having the format
        # version X.Y.Z, i.e., no name, but the string 'version'
        # followed by the version number. If you need to use the
        # 'version' string format, then you must have a program
        # name, otherwise, it will treat the program name as 'version'
      end

      # Check parsing of version strings with leading zeros throws errors
      def test_parse_leading_zeros
        v = VMLib::Version.new

        # Test parsing with leading zero in major
        assert_raise VMLib::Errors::ParseError do
          v.parse '01.2.3-pre.4.5.6'
        end

        # Test parsing with leading zero in minor
        assert_raise VMLib::Errors::ParseError do
          v.parse '1.02.3-pre.4.5.6'
        end

        # Test parsing with leading zero in patch
        assert_raise VMLib::Errors::ParseError do
          v.parse '1.2.03-pre.4.5.6'
        end

        # Test parsing with leading zero in prerelease identifier field
        assert_raise VMLib::Errors::ParseError do
          v.parse '1.2.3-pre.04.5.6'
        end

        # Verify that leading zeroes in alphanumeric fields doesn't raise errors
        v.parse '1.2.3-pre.0ac011d.250'

        # Verify that leading zeros in build fields doesn't raise errors
        v.parse '1.2.3-pre.foo+bld.0123456.0001'
      end

      # Check parsing of strings with various prerelease combinations
      def test_parse_pre
        v = VMLib::Version.new

        # Passing anything other than a string causes an error to be raised
        assert_raise VMLib::Errors::ParameterError do
          # Pass a number
          v.parse 1.2
        end

        assert_raise VMLib::Errors::ParameterError do
          # Pass an array
          v.parse [1, 2, 0, '', '']
        end

        # Default case - prerelease parser enabled
        v.parse 'v1.1.0-2'
        assert_equal '', v.name
        assert_equal 1, v.major
        assert_equal 1, v.minor
        assert_equal 0, v.patch
        assert_equal '-2', v.prerelease
        assert_equal '', v.build

        # Check alpha case
        v.parse 'v1.1.0-a.2'
        assert_equal '', v.name
        assert_equal 1, v.major
        assert_equal 1, v.minor
        assert_equal 0, v.patch
        assert_equal '-a.2', v.prerelease
        assert_equal '', v.build

        v.parse 'v1.1.0-alpha.2'
        assert_equal '', v.name
        assert_equal 1, v.major
        assert_equal 1, v.minor
        assert_equal 0, v.patch
        assert_equal '-a.2', v.prerelease
        assert_equal '', v.build

        # Check beta case
        v.parse 'v1.1.0-b.2'
        assert_equal '', v.name
        assert_equal 1, v.major
        assert_equal 1, v.minor
        assert_equal 0, v.patch
        assert_equal '-b.2', v.prerelease
        assert_equal '', v.build

        v.parse 'v1.1.0-beta.2'
        assert_equal '', v.name
        assert_equal 1, v.major
        assert_equal 1, v.minor
        assert_equal 0, v.patch
        assert_equal '-b.2', v.prerelease
        assert_equal '', v.build

        # Check rc case
        v.parse 'v1.1.0-rc.2'
        assert_equal '', v.name
        assert_equal 1, v.major
        assert_equal 1, v.minor
        assert_equal 0, v.patch
        assert_equal '-rc.2', v.prerelease
        assert_equal '', v.build
        # Check rc but with non-standard field
        v.parse 'v1.1.0-rc.1a'
        assert_equal '-rc.1a', v.prerelease
        assert_equal '', v.build

        # Check final case
        v.parse 'v1.1.0'
        assert_equal '', v.name
        assert_equal 1, v.major
        assert_equal 1, v.minor
        assert_equal 0, v.patch
        assert_equal '', v.prerelease
        assert_equal '', v.build

        # Check custom case
        v.parse 'v1.1.0-alpha.1a'
        assert_equal '', v.name
        assert_equal 1, v.major
        assert_equal 1, v.minor
        assert_equal 0, v.patch
        assert_equal '-alpha.1a', v.prerelease
        assert_equal '', v.build

        # Passing an invalid prerelease string (such as ?, #, $, etc)
        # throws an error
        assert_raise VMLib::Errors::ParseError do
          v.parse 'v1.1.0-$gedfabc0'
        end

        # Check with prerelease parser disabled
        # This mainly addresses the alpha and beta cases, since it reduces
        # the output to a.X and b.Y for alpha.X and beta.Y respectively
        VMLib::Version.enable_prerelease_parser = false
        # Check alpha case
        v.parse 'v1.1.0-alpha.2'
        assert_equal '-alpha.2', v.prerelease

        # Check beta case
        v.parse 'v1.1.0-beta.2'
        assert_equal '-beta.2', v.prerelease

        # Re-enable the prerelease parser and check if it works as expected
        VMLib::Version.enable_prerelease_parser = true
        # Check alpha case
        v.parse 'v1.1.0-alpha.2'
        assert_equal '-a.2', v.prerelease

        # Check beta case
        v.parse 'v1.1.0-beta.2'
        assert_equal '-b.2', v.prerelease
      end

      # Test that the build combinations are stored as entered
      def test_parse_build
        v = VMLib::Version.new

        v.parse 'vmlib v1.2.0+20130628.0354.gef3c66c'
        assert_equal 'vmlib', v.name
        assert_equal 1, v.major
        assert_equal 2, v.minor
        assert_equal 0, v.patch
        assert_equal '', v.prerelease
        assert_equal '+20130628.0354.gef3c66c', v.build

        # Passing an invalid build string (such as ?, #, $, etc)
        # throws an error
        assert_raise VMLib::Errors::ParseError do
          v.parse 'v1.1.0+$gedfabc0'
        end

      end

      # Test that you can store any combination of pre and build, and
      # it works as expected
      def test_parse_pre_build_combo
        v = VMLib::Version.new

        v.parse 'vmlib version 1.1.0-3+20130628.0354.gef3c66c'
        assert_equal 'vmlib', v.name
        assert_equal 1, v.major
        assert_equal 1, v.minor
        assert_equal 0, v.patch
        assert_equal '-3', v.prerelease
        assert_equal '+20130628.0354.gef3c66c', v.build

        v.parse 'vmlib version 1.1.0+20130628.0354.gef3c66c-3'
        assert_equal 'vmlib', v.name
        assert_equal 1, v.major
        assert_equal 1, v.minor
        assert_equal 0, v.patch
        assert_equal '', v.prerelease
        assert_equal '+20130628.0354.gef3c66c-3', v.build
      end

    end


  end


end
