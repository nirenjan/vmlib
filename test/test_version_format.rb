###############################################################################
# VMLib version formatting test cases
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

require 'test/unit'
require 'vmlib'

module VMLib

  module Tests #:nodoc:

    class TestFormat < ::Test::Unit::TestCase   #:nodoc:

      
      # Test if printing the name comes out correctly
      def test_format_name
        version = VMLib::Version.new
        # Test if an empty name corresponds to an empty string
        assert_equal '', version.format('%n')

        # Test if a valid name corresponds to the name plus a space
        version.name = 'foo'
        assert_equal 'foo ', version.format('%n')
        assert_equal 'foo bar', version.format('%nbar')
        assert_equal 'foo  bar', version.format('%n bar')
      end


      # Test if printing the major version comes out correctly
      def test_format_major
        version = VMLib::Version.new
        version.major = 42
        
        assert_equal '42', version.format('%M')
      end


      # Test if printing the minor version comes out correctly
      def test_format_minor
        version = VMLib::Version.new
        version.minor = 13
        
        assert_equal '13', version.format('%m')
      end


      # Test if printing the patch version comes out correctly
      def test_format_patch
        version = VMLib::Version.new
        version.patch = 16
        
        assert_equal '16', version.format('%p')
      end


      # Test if printing the prerelease version comes out correctly
      def test_format_prerelease
        version = VMLib::Version.new
        
        # Test that an empty prerelease corresponds to an empty string
        version.prerelease = ''
        assert_equal '', version.format('%r')

        # Test that a dev release corresponds to a -# string
        version.prerelease = '1'
        assert_equal '-1', version.format('%r')

        # Test that an alpha prerelease corresponds to a -a.# string
        version.prerelease = 'alpha.1'
        assert_equal '-a.1', version.format('%r')
        version.prerelease = 'a.2'
        assert_equal '-a.2', version.format('%r')

        # Test that a beta prerelease corresponds to a -b.# string
        version.prerelease = 'beta.3'
        assert_equal '-b.3', version.format('%r')
        version.prerelease = 'b.4'
        assert_equal '-b.4', version.format('%r')

        # Test that a rc prerelease corresponds to a -rc.# string
        version.prerelease = 'rc.5'
        assert_equal '-rc.5', version.format('%r')

        # Test that a custom prerelease prints as entered
        version.prerelease = 'foo.bar.baz'
        assert_equal '-foo.bar.baz', version.format('%r')
        version.prerelease = '1.2.3.4.5.6.7.8.9.0'
        assert_equal '-1.2.3.4.5.6.7.8.9.0', version.format('%r')
        version.prerelease = '1.2.3.4.5.6.7.8.9.09'
        assert_equal '-1.2.3.4.5.6.7.8.9.9', version.format('%r')

      end


    end


  end


end
