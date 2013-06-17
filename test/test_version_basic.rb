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
        assert_equal '0.0.0+1', version.to_s
      end

    end


  end


end
