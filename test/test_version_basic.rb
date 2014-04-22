# encoding: UTF-8
###############################################################################
# VMLib basic version test cases
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

require 'test/unit'
require 'vmlib'

module VMLib

  module Tests #:nodoc:

    class TestBasicVersion < ::Test::Unit::TestCase   #:nodoc:

      # Test the default value when a new version is created
      def test_default_value
        version = VMLib::Version.new

        assert_equal '0.0.0-0', version.to_s
      end


      # Test the version with a different version number
      def test_custom_version
        version = VMLib::Version.new('SomeProject', 1, 1, 0, 'a.1', 'b.20')
        assert_equal 'SomeProject 1.1.0-a.1+b.20', version.to_s
      end


      # Test setting the version record fields individually
      def test_version_fields
        version = VMLib::Version.new
        assert_equal '0.0.0-0', version.to_s

        version.major = 1
        assert_equal '1.0.0-0', version.to_s

        version.minor = 2
        assert_equal '1.2.0-0', version.to_s

        version.patch = 3
        assert_equal '1.2.3-0', version.to_s

        version.name = 'FooBar'
        assert_equal 'FooBar 1.2.3-0', version.to_s

        version.prerelease = ''
        assert_equal 'FooBar 1.2.3', version.to_s

        version.build = 'build.20'
        assert_equal 'FooBar 1.2.3+build.20', version.to_s

        version.prerelease = 'alpha.1'
        assert_equal 'FooBar 1.2.3-a.1+build.20', version.to_s

      end


      # Test the prerelease parser and formatter
      def test_prerelease
        version = VMLib::Version.new
        version.prerelease = '1'
        assert_equal '0.0.0-1', version.to_s

        version.prerelease = 'a.2'
        assert_equal '0.0.0-a.2', version.to_s

        # Test that the string alpha gets interpreted as 'a'
        version.prerelease = 'alpha.3'
        assert_equal '0.0.0-a.3', version.to_s

        # Test that a non-standard alpha gets treated as a custom field
        version.prerelease = 'alpha.1.2'
        assert_equal '0.0.0-alpha.1.2', version.to_s

        version.prerelease = 'alpha.a1'
        assert_equal '0.0.0-alpha.a1', version.to_s

        version.prerelease = 'b.4'
        assert_equal '0.0.0-b.4', version.to_s

        # Test that the string beta gets interpreted as 'b'
        version.prerelease = 'beta.3'
        assert_equal '0.0.0-b.3', version.to_s

        # Test that a non-standard beta gets treated as a custom field
        version.prerelease = 'beta.a2'
        assert_equal '0.0.0-beta.a2', version.to_s

        version.prerelease = 'beta.1.2'
        assert_equal '0.0.0-beta.1.2', version.to_s

        version.prerelease = 'rc.1'
        assert_equal '0.0.0-rc.1', version.to_s

        # Test that an unrecognized format still gets stored
        version.prerelease = 'foo.bar.baz'
        assert_equal '0.0.0-foo.bar.baz', version.to_s

        # Verify that an empty pre-release gets treated as a final release
        version.prerelease = ''
        assert_equal '0.0.0', version.to_s
      end


      # Test the build assignment
      def test_build
        version = VMLib::Version.new
        version.build = '1'
        assert_equal '0.0.0-0+1', version.to_s

        version.prerelease = ''
        assert_equal '0.0.0+1', version.to_s

        version.build = 'foo.bar.baz'
        assert_equal '0.0.0+foo.bar.baz', version.to_s

        # Verify that the build identifiers get treated as strings,
        # basically checking that we don't strip leading zeroes in fields
        # with only digits
        version.build = '001'
        assert_equal '0.0.0+001', version.to_s

        version.build = '20130313144700'
        assert_equal '0.0.0+20130313144700', version.to_s

        version.build = 'exp.sha.5114f85'
        assert_equal '0.0.0+exp.sha.5114f85', version.to_s
      end


      # Test the inspect method
      def test_inspect
        v = VMLib::Version.new 'vmlib', 1, 2, 0, '', ''
        assert_match(/^#<VMLib::Version:0x[0-9a-f]{16} @name='vmlib' @major=1 @minor=2 @patch=0>$/, v.inspect)

        v.name = 'foo'
        assert_match(/^#<VMLib::Version:0x[0-9a-f]{16} @name='foo' @major=1 @minor=2 @patch=0>$/, v.inspect)

        v.major = 3
        assert_match(/^#<VMLib::Version:0x[0-9a-f]{16} @name='foo' @major=3 @minor=2 @patch=0>$/, v.inspect)

        v.minor = 1
        assert_match(/^#<VMLib::Version:0x[0-9a-f]{16} @name='foo' @major=3 @minor=1 @patch=0>$/, v.inspect)

        v.patch = 4
        assert_match(/^#<VMLib::Version:0x[0-9a-f]{16} @name='foo' @major=3 @minor=1 @patch=4>$/, v.inspect)

        # Test the dev prerelease
        v.prerelease = '159'
        assert_match(/^#<VMLib::Version:0x[0-9a-f]{16} @name='foo' @major=3 @minor=1 @patch=4 @devnum=159>$/, v.inspect)

        # Test the alpha prerelease
        v.prerelease = 'alpha.59'
        assert_match(/^#<VMLib::Version:0x[0-9a-f]{16} @name='foo' @major=3 @minor=1 @patch=4 @alphanum=59>$/, v.inspect)

        # Test the beta prerelease
        v.prerelease = 'beta.857'
        assert_match(/^#<VMLib::Version:0x[0-9a-f]{16} @name='foo' @major=3 @minor=1 @patch=4 @betanum=857>$/, v.inspect)

        # Test the rc prerelease
        v.prerelease = 'rc.2'
        assert_match(/^#<VMLib::Version:0x[0-9a-f]{16} @name='foo' @major=3 @minor=1 @patch=4 @rcnum=2>$/, v.inspect)

        # Test the custom prerelease
        v.prerelease = '1.2a'
        assert_match(/^#<VMLib::Version:0x[0-9a-f]{16} @name='foo' @major=3 @minor=1 @patch=4 @prerelease=\[1, "2a"\]>$/,  v.inspect)

        # Test adding on a custom build
        v.build = 'g3567acc'
        assert_match(/^#<VMLib::Version:0x[0-9a-f]{16} @name='foo' @major=3 @minor=1 @patch=4 @prerelease=\[1, "2a"\] @build=\["g3567acc"\]>$/,  v.inspect)
        
        # Test adding on a custom build
        v.build = 'g3567acc.20130721'
        assert_match(/^#<VMLib::Version:0x[0-9a-f]{16} @name='foo' @major=3 @minor=1 @patch=4 @prerelease=\[1, "2a"\] @build=\["g3567acc", "20130721"\]>$/,  v.inspect)
        
        # Test clearing the prerelease
        v.prerelease = ''
        assert_match(/^#<VMLib::Version:0x[0-9a-f]{16} @name='foo' @major=3 @minor=1 @patch=4 @build=\["g3567acc", "20130721"\]>$/,  v.inspect)
        
        # Test clearing the build
        v.build = ''
        assert_match(/^#<VMLib::Version:0x[0-9a-f]{16} @name='foo' @major=3 @minor=1 @patch=4>$/,  v.inspect)
      end


    end


  end


end
