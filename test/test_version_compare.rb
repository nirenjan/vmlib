###############################################################################
# VMLib version comparision test cases
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

require 'test/unit'
require 'vmlib'

module VMLib

  module Tests #:nodoc:

    class TestBasicVersion < ::Test::Unit::TestCase   #:nodoc:

      # Test comparing two versions with different major, minor & patch
      def test_compare_regular
        version1 = VMLib::Version.new
        version2 = VMLib::Version.new

        # Test if having identical version strings is working
        assert_equal 0, version1 <=> version2

        # Test if having different major versions shows up correctly
        version1.major = 1
        assert_equal 1, version1 <=> version2

        # Test if having different minor versions shows up correctly
        version2.major = 1
        version2.minor = 1
        assert_equal -1, version1 <=> version2

        # Test if having different patch versions shows up correctly
        version1.minor = 1
        version2.patch = 10
        assert_equal -1, version1 <=> version2

        # Test if setting the versions to identical one shows up as equal
        version1.patch = 10
        assert_equal 0, version1 <=> version2

        # Test using digits of different length in the patch
        version2.patch = 9
        assert_equal 1, version1 <=> version2
      end

      # Test comparing two versions with different prerelease info
      def test_compare_prerelease
        version1 = VMLib::Version.new
        version2 = VMLib::Version.new

        # Test that a prerelease sorts lower than non-prerelease version
        version1.prerelease = ''
        assert_equal 1, version1 <=> version2

        # Test that two dev releases sort in order
        version1.prerelease = '1'
        assert_equal 1, version1 <=> version2

        # Test that a dev and an alpha sort with dev lower
        version1.bump_release_type
        assert_equal 1, version1 <=> version2

        # Test that a dev and a beta sort with dev lower
        version1.bump_release_type
        assert_equal 1, version1 <=> version2

        # Test that a dev and a rc sort with dev lower
        version1.bump_release_type
        assert_equal 1, version1 <=> version2

        # Test that an alpha and alpha are sorted in order
        version1.prerelease = 'alpha.1'
        version2.prerelease = 'alpha.1'
        assert_equal 0, version1 <=> version2

        version1.prerelease = 'alpha.2'
        assert_equal 1, version1 <=> version2

        # Test that an alpha and a beta sort with alpha lower
        version1.bump_release_type
        assert_equal 1, version1 <=> version2

        # Test that an alpha and a rc sort with alpha lower
        version1.bump_release_type
        assert_equal 1, version1 <=> version2

        # Test that a beta and beta are sorted in order
        version1.prerelease = 'beta.1'
        version2.prerelease = 'beta.1'
        assert_equal 0, version1 <=> version2

        version1.prerelease = 'beta.2'
        assert_equal 1, version1 <=> version2

        # Test that a beta and a rc sort with beta lower
        version1.bump_release_type
        assert_equal 1, version1 <=> version2

        # Test that a rc and rc are sorted in order
        version1.prerelease = 'rc.1'
        version2.prerelease = 'rc.1'
        assert_equal 0, version1 <=> version2

        version1.prerelease = 'rc.2'
        assert_equal 1, version1 <=> version2
      end


      # Test that a custom prerelease sorts the same way as a defined one
      def test_compare_custom_prerelease
        version1 = VMLib::Version.new
        version2 = VMLib::Version.new

        version1.prerelease = 'foo.bar.baz'
        version2.prerelease = 'foo.bar.baz'
        assert_equal 0, version1 <=> version2
        
        # Test that two alphanumeric prerelease strings get sorted lexically
        version1.prerelease = 'foo.bas.baz'
        assert_equal 1, version1 <=> version2

        version1.prerelease = 'foo.bars.baz'
        assert_equal 1, version1 <=> version2

        # Test that numeric identifiers get compared numerically
        version1.prerelease = 'foo.123'
        version2.prerelease = 'foo.21'
        assert_equal 1, version1 <=> version2

        # Test sample test cases from mojombo/semver#100
        version1.prerelease = 'a.3.b.54'
        version2.prerelease = 'a.2.b.55'
        assert_equal 1, version1 <=> version2

        version1.prerelease = 'a.b.2'
        version2.prerelease = 'a.1.b'
        assert_equal 1, version1 <=> version2

        version1.prerelease = 'a.99.c.1'
        version2.prerelease = 'a.1.b.2'
        assert_equal 1, version1 <=> version2

        version1.prerelease = 'a.b'
        version2.prerelease = 'a.1.b.2'
        assert_equal 1, version1 <=> version2

        # Test that longer identifiers sort higher than shorter ones
        version1.prerelease = 'a.1.b.2.c'
        assert_equal 1, version1 <=> version2
      end


      # Test that build metadata is ignored in sorts unless explicitly enabled
      def test_compare_build
        version1 = VMLib::Version.new
        version2 = VMLib::Version.new

        version1.build = '5c08ad0'
        version2.build = '44cbb6c'
        assert_equal 0, version1 <=> version2

        version1.compare_build = true
        assert_equal 1, version1 <=> version2

        # Test that having a build metadata sorts higher than none
        version2.build = ''
        assert_equal 1, version1 <=> version2
        
        version2.build = '5c08ad0'
        assert_equal 0, version1 <=> version2
        
        # Test that longer build meta data sorts higher than shorter
        version1.build = '5c08ad0.20130618'
        assert_equal 1, version1 <=> version2

        # Test that numeric identifiers sort numerically
        version2.build = '5c08ad0.301206'
        assert_equal 1, version1 <=> version2
      end


    end


  end


end
