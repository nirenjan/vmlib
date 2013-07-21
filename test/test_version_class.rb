###############################################################################
# VMLib class attribute test cases
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

require 'test/unit'
require 'vmlib'

module VMLib

  module Tests #:nodoc:

    class TestVersionClass < ::Test::Unit::TestCase   #:nodoc:

      # Test setting and getting the compare_build attribue
      def test_compare_build
        VMLib::Version.compare_build = true
        assert_equal true, VMLib::Version.compare_build

        VMLib::Version.compare_build = false
        assert_equal false, VMLib::Version.compare_build

        # Setting it to something other than true or false raises an error
        assert_raise VMLib::Errors::ParameterError do
          VMLib::Version.compare_build = 0
        end
      end


      # Test setting and getting the prerelease parser attribute
      def test_enable_prerelease_parser
        VMLib::Version.enable_prerelease_parser = false
        assert_equal false, VMLib::Version.enable_prerelease_parser

        VMLib::Version.enable_prerelease_parser = true
        assert_equal true, VMLib::Version.enable_prerelease_parser

        # Setting it to something other than true or false raises an error
        assert_raise VMLib::Errors::ParameterError do
          VMLib::Version.enable_prerelease_parser = 0
        end
      end


    end


  end


end
