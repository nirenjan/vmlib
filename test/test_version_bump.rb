# encoding: UTF-8
###############################################################################
# VMLib bump test cases
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

require 'test/unit'
require 'vmlib'

module VMLib

  module Tests #:nodoc:

    class TestBump < ::Test::Unit::TestCase   #:nodoc:

      # Test bumping the patch version
      def test_bump_patch
        version = VMLib::Version.new
        assert_equal '0.0.0-0', version.to_s

        version.bump_patch
        assert_equal '0.0.1-0', version.to_s

        version.prerelease = ''
        version.bump_patch
        assert_equal '0.0.2', version.to_s
      end

    
      # Test bumping the minor version
      # Once with a zero patch, and again with a non-zero patch
      def test_bump_minor
        version = VMLib::Version.new
        assert_equal '0.0.0-0', version.to_s

        version.bump_minor
        assert_equal '0.1.0-0', version.to_s

        version.patch = 4
        assert_equal '0.1.4-0', version.to_s

        # Does bumping the minor version reset the patch to zero?
        version.bump_minor
        assert_equal '0.2.0-0', version.to_s

        # Does bumping the minor version leave the prerelease unaffected?
        version.prerelease = 'rc.0'
        version.bump_minor
        assert_equal '0.3.0-rc.0', version.to_s
      end


      # Test bumping the major version
      # Test with zero, and non-zero patch & minor versions
      def test_bump_major
        version = VMLib::Version.new
        version.prerelease = ''
        version.bump_major
        assert_equal '1.0.0', version.to_s

        version.patch = 1
        assert_equal '1.0.1', version.to_s

        # Does bumping the major version reset the patch to zero?
        version.bump_major
        assert_equal '2.0.0', version.to_s

        version.minor = 2
        assert_equal '2.2.0', version.to_s

        # Does bumping the major version reset the minor version to zero?
        version.bump_major
        assert_equal '3.0.0', version.to_s

        version.minor = 1
        version.patch = 4
        assert_equal '3.1.4', version.to_s

        # Does bumping the major version reset minor & patch to zero?
        version.bump_major
        assert_equal '4.0.0', version.to_s
      end


      # Test bumping a dev version
      def test_bump_pre_dev
        version = VMLib::Version.new
        version.bump_prerelease
        assert_equal '0.0.0-1', version.to_s

        version.bump_prerelease
        assert_equal '0.0.0-2', version.to_s
      end

      
      # Test bumping dev to alpha and bumping alpha versions
      def test_bump_pre_alpha
        version = VMLib::Version.new
        # Does type bumping a development version go to alpha?
        version.bump_release_type
        assert_equal '0.0.0-a.1', version.to_s

        version.bump_prerelease
        assert_equal '0.0.0-a.2', version.to_s
      end


      # Test bumping dev to alpha to beta & bumping beta versions
      def test_bump_pre_beta
        version = VMLib::Version.new
        version.bump_release_type
        assert_equal '0.0.0-a.1', version.to_s

        # Does type bumping an alpha version go to beta?
        version.bump_release_type
        assert_equal '0.0.0-b.1', version.to_s

        version.bump_prerelease
        assert_equal '0.0.0-b.2', version.to_s
      end


      # Test bumping dev to alpha to beta to rc & bumping rc versions
      def test_bump_pre_rc
        version = VMLib::Version.new
        version.bump_release_type
        assert_equal '0.0.0-a.1', version.to_s

        version.bump_release_type
        assert_equal '0.0.0-b.1', version.to_s

        # Does type bumping a beta version go to release candidate?
        version.bump_release_type
        assert_equal '0.0.0-rc.1', version.to_s

        version.bump_prerelease
        assert_equal '0.0.0-rc.2', version.to_s
      end


      # Test bumping dev to alpha to beta to rc to final & bumping final
      def test_bump_pre_final
        version = VMLib::Version.new
        version.bump_release_type
        assert_equal '0.0.0-a.1', version.to_s

        version.bump_release_type
        assert_equal '0.0.0-b.1', version.to_s

        version.bump_release_type
        assert_equal '0.0.0-rc.1', version.to_s

        # Does type bumping a release candidate go to final?
        version.bump_release_type
        assert_equal '0.0.0', version.to_s

        # Bumping type from final raises BumpError
        assert_raise(VMLib::Errors::BumpError) do
          version.bump_release_type
        end

        # Bumping from final raises BumpError
        assert_raise(VMLib::Errors::BumpError) do
          version.bump_prerelease
        end
      end


      # Test bumping a custom type
      def test_bump_pre_custom
        version = VMLib::Version.new
        
        # Does bumping a custom prerelease string increment the last field
        # (if numeric)?
        version.prerelease = 'foo.9'
        assert_equal '0.0.0-foo.9', version.to_s

        version.bump_prerelease
        assert_equal '0.0.0-foo.10', version.to_s

        version.prerelease = '1.2.3.4.5.6.7.8.9'
        assert_equal '0.0.0-1.2.3.4.5.6.7.8.9', version.to_s

        version.bump_prerelease
        assert_equal '0.0.0-1.2.3.4.5.6.7.8.10', version.to_s

        # Error raised when bumping a non-numeric final field
        version.prerelease = 'foo'
        assert_raise(VMLib::Errors::BumpError) do
          version.bump_prerelease
        end

        version.prerelease = '1.2.3.4.5.foo'
        assert_raise(VMLib::Errors::BumpError) do
          version.bump_prerelease
        end

        # Error raised when trying to bump the type
        assert_raise(VMLib::Errors::BumpError) do
          version.bump_release_type
        end
      end


    end


  end


end
