# encoding: UTF-8
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
        assert_equal '0', version.format('%M')
        
        version.major = 42
        assert_equal '42', version.format('%M')
      end


      # Test if printing the minor version comes out correctly
      def test_format_minor
        version = VMLib::Version.new
        assert_equal '0', version.format('%m')
        
        version.minor = 13
        assert_equal '13', version.format('%m')
      end


      # Test if printing the patch version comes out correctly
      def test_format_patch
        version = VMLib::Version.new
        assert_equal '0', version.format('%p')
        
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
        version.prerelease = '0'
        assert_equal '-0', version.format('%r')
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

      end


      # Test if printing the prerelease version comes out correctly
      def test_format_build
        version = VMLib::Version.new

        # Test that an emtpy build corresponds to an empty string
        version.build = ''
        assert_equal '', version.format('%b')

        # Test that a custom build prints exactly as entered
        version.build = '001'
        assert_equal '+001', version.format('%b')

        version.build = '20130313144700'
        assert_equal '+20130313144700', version.format('%b')

        version.build = 'exp.sha.5114f85'
        assert_equal '+exp.sha.5114f85', version.format('%b')
      end


      # Test if the tag format comes out as expected
      def test_format_tag
        version = VMLib::Version.new 'foo', 1, 2, 3, 'rc.1', 'sha.5114f85'

        # Make sure all fields are included in the tag
        assert_equal 'v1.2.3-rc.1+sha.5114f85', version.tag

        # Changing the build should reflect in the tag
        version.build = 'sha.0012312'
        assert_equal 'v1.2.3-rc.1+sha.0012312', version.tag

        # Removing the build should reflect in the tag
        version.build = ''
        assert_equal 'v1.2.3-rc.1', version.tag

        # Changing the prerelease should reflect in the tag
        version.prerelease = 'alpha.2'
        assert_equal 'v1.2.3-a.2', version.tag

        # Removing the prerelease should reflect in the tag
        version.prerelease = ''
        assert_equal 'v1.2.3', version.tag

        # Having a build metadata and no prerelease should reflect in the tag
        version.build = 'sha.12ab32d'
        assert_equal 'v1.2.3+sha.12ab32d', version.tag
      end


      # Test if the to_s function works as expected
      def test_format_to_s
        version = VMLib::Version.new 'foo', 1, 2, 3, 'rc.1', 'sha.5114f85'

        # Make sure all fields are included in the to_s
        assert_equal 'foo 1.2.3-rc.1+sha.5114f85', version.to_s

        # Changing the name should reflect in the to_s
        version.name = 'bar'
        assert_equal 'bar 1.2.3-rc.1+sha.5114f85', version.to_s

        # Changing the major number should reflect in the to_s
        version.major = 4
        assert_equal 'bar 4.2.3-rc.1+sha.5114f85', version.to_s

        # Changing the minor number should reflect in the to_s
        version.minor = 5
        assert_equal 'bar 4.5.3-rc.1+sha.5114f85', version.to_s

        # Changing the patch number should reflect in the to_s
        version.patch = 6
        assert_equal 'bar 4.5.6-rc.1+sha.5114f85', version.to_s

        version.major = 1
        version.minor = 2
        version.patch = 3

        # Changing the build should reflect in the to_s
        version.build = 'sha.0012312'
        assert_equal 'bar 1.2.3-rc.1+sha.0012312', version.to_s

        # Removing the build should reflect in the to_s
        version.build = ''
        assert_equal 'bar 1.2.3-rc.1', version.to_s

        # Changing the prerelease should reflect in the to_s
        version.prerelease = 'alpha.2'
        assert_equal 'bar 1.2.3-a.2', version.to_s

        # Removing the prerelease should reflect in the to_s
        version.prerelease = ''
        assert_equal 'bar 1.2.3', version.to_s

        # Having a build metadata and no prerelease should reflect in the to_s
        version.build = 'sha.12ab32d'
        assert_equal 'bar 1.2.3+sha.12ab32d', version.to_s
      end


    end


  end


end
