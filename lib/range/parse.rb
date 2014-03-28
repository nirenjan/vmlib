###############################################################################
# VMLib range parser
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

require 'strscan'

module VMLib

  class Range
    
    # Numeric range expression accepts any positive number without leading zeroes
    VNUM = /0|[1-9]\d*/

    # Version number can consist of major, major+minor or a full M+m+p
    VERSION = /#{VNUM}(\.#{VNUM}?(\.#{VNUM})?)?/

    # Match operators are tied to the version, and constrain the match against
    # that version
    MATCHOP = /(~\>|[><]|[><!=]=)\s*/

    # A version expression consists of an optional match operator followed by
    # optional whitespace followed by the version (excluding the match operator
    # implies an implicit exact match '=='), or it can be a version range
    # that is expressed as version - version.
    VEREXP = /(#{MATCHOP}?#{VERSION})|(#{VERSION}\s*-\s*#{VERSION})/

    # Initialize the range
    def initialize
      @match_data = StringScanner.new ''
      reset_parser
    end
    attr_reader :match_data, :parse_tokens, :range

    # Set the range
    def range= (val)
      unless val.kind_of? String
        raise Errors::ParameterError, "unrecognized input type #{val}"
      end

      # Supported values
      # * 1.2.3 - 1.3.4 inclusive ranges
      # * 1 - 2 imprecise inclusive ranges, basically means any version from
      #   1.0.0 to 1.x.y (less than 2.0.0)
      # * 1.2 - 1.2.3 - means any version from 1.2.0 to 1.2.3
      # * 1.2.3 - 1.4 - means any version from 1.2.3 to 1.4.x (less than 1.5.0)
      # * 1 - Any 1.x.y release
      # * 1.2 - Any 1.2.x release
      # * 1.2.3 - Only release 1.2.3
      # * ~> 1 - Ruby version constraint operator - any version >= 1.0.0
      # * ~> 1.2 - any version >= 1.2.0, but < 2.0.0
      # * ~> 1.2.3 - any version >= 1.2.3 but < 1.3.0
      # * > x, > x.y, > x.y.z - Strictly greater than
      # * >=, <, <= as above
      # || - allows specification of multiple ranges using a boolean OR
      # && - allows specification of multiple ranges using a boolean AND
      # ! - allows negation of a particular range
      #
      # Priority of operations
      # * ()
      # * ~>
      # * >=, >, <=, <, ==, !=
      # * -
      # * &&, ||
      # * !
      init_parser(val)
      while not @match_data.eos?
        # Skip over any whitespace
        match_exp(/\s+/) and next

        # Match a version number range (VERSION - VERSION)
        match_exp(/#{VERSION}\s*-\s*#{VERSION}/) do |v|
          parse_range(v)
        end and next

        # Match a version number prefixed by an optional match operator
        match_exp(/((~>|[<>]|[<>=!]=)\s*)?#{VERSION}/) do |v|
          parse_match(v)
        end and next

        # Match logical operators
        match_exp(/!|([&|])\1/) do |v|
          [[:logical, v]]
        end and next

        # Match parentheses
        match_exp(/[()]/) do |v|
          [[:parentheses, v]]
        end and next

        # Should never reach this point
        reset_parser
        raise Errors::ParseError,
            "Invalid range expression '#{@match_data.string}' at index #{@match_data.pos}"
      end

      @match_data.string
    end

    private
    def match_exp(exp, &block)
      match = @match_data.scan(exp)
      if match
        if block_given?
          result = yield(match)
          if result
            @parse_tokens.concat result
          end
        end
      end

      return match
    end

    def init_parser(val)
      @range = true
      @match_data.string = val
      @parse_tokens = []
    end

    def reset_parser
      @range = false
    end

    def parse_match(v)
      ver = parse_version(v.match(/#{VERSION}/)[0])
      v = v.gsub(/\s*#{VERSION}/, '')
      op = case v
        when '~>'
          return parse_constrain(ver)
        when '>='
          :ge
        when '<='
          :le
        when '>'
          :gt
        when '<'
          :lt
        when '!='
          :ne
        when '=='
          :eq
        else
          :eq
      end
      [[:version, op, ver]]
    end

    # Parse range basically splits the version range into two match operators,
    # i.e., V1 - V2 => (>= V1 && <= V2)
    def parse_range(v)
      s = StringScanner.new v
      r = []
      t = s.scan(/#{VERSION}/)
      r << [:parentheses, '(']
      r << [:version, :ge, parse_version(t)]
      r << [:logical, '&&']
      s.scan(/\s*-\s*/)
      t = s.scan(/#{VERSION}/)
      t = parse_version(t)
      method = "bump_#{t[:type].to_s}".to_sym
      t[:ver].method(method).call

      r << [:version, :lt, t]
      r << [:parentheses, ')']
      r
    end

    def parse_version(v)
      ver = Version.new

      case v.count(".")
      when 0
        vt = v + '.0.0'
        ver.parse vt
        {:type => :major, :ver => ver}
      when 1
        vt = v + '.0'
        ver.parse vt
        {:type => :minor, :ver => ver}
      when 2
        ver.parse v
        {:type => :patch, :ver => ver}
      end
    end

    def parse_constrain(ver)
      v1 = ver[:ver]
      out = [
        [:parentheses, '('],
        [:version, :ge, {:type => :patch, :ver => v1}],
        [:logical, '&&']
      ]
      out << case ver[:type]
        when :major
          [:absolute, true]
        when :minor
          v = Version.new
          v.parse v1.to_s
          v.bump_major
          [:version, :lt, {:type => :patch, :ver => v}]
        when :patch
          v = Version.new
          v.parse v1.to_s
          v.bump_minor
          [:version, :lt, {:type => :patch, :ver => v}]
      end
      out << [:parentheses, ')']

      out
    end

  end


end
