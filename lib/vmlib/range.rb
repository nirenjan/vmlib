###############################################################################
# VMLib range manager
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

require 'strscan'

module VMLib

  class Range

    # Initialize the range
    def initialize
      @match_data = StringScanner.new ''
      reset_parser
    end

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
      num = /0|[1-9]\d*/
      init_parser(val)
      while not @match_data.eos?
        # Skip over any whitespace
        match_exp(/\s+/) and next

        # Match a patch level version number
        match_exp(/#{num}\.#{num}\.#{num}/) do |v|
          [[:version, :patch, v]]
        end and next

        # Match a minor level version number
        match_exp(/#{num}\.#{num}/) do |v|
          [[:version, :minor, v + '.0']]
        end and next

        # Match a major level version number
        match_exp(/#{num}/) do |v|
          [[:version, :major, v + '.0.0']]
        end and next

        # Match the constrain operator (~>)
        match_exp(/~>/) do |v|
          [[:operator, :constrain]]
        end and next

        # Match the range operators (>=, <=, ==, !=, >, <)
        match_exp(/[<=>!]=/) do |v|
          case v[0]
          when '>='
            op = :ge
          when '<='
            op = :le
          when '=='
            op = :eq
          when '!='
            op = :ne
          end

          [[:operator, op]]
        end and next

        # Match strictly greater/lesser
        match_exp(/[<>]/) do |v|
          if v[0] == '>'
            op = :gt
          else
            op = :lt
          end

          [[:operator, op]]
        end and next

        # Match to operator
        match_exp(/-/) do |v|
          [[:range]]
        end and next

        # Match not operator
        match_exp(/!/) do |v|
          [[:logical, :not]]
        end and next

        # Match parentheses
        match_exp(/[()]/) do |v|
          if v[0] == '('
            open = true
          else
            open = false
          end

          [[:parentheses, open]]
        end and next

        # Match && and || operators
        match_exp(/&&/) do |v|
          [[:logical, :and]]
        end and next

        match_exp(/\|\|/) do |v|
          [[:logical, :or]]
        end and next

        # Should never reach this point
        reset_parser
        raise Errors::ParseError,
            "Invalid range expression '#{@match_data.string}'"
      end

      convert_to_rpn

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
      @range = []
      @match_data.string = val
      @parse_tokens = []
    end

    def reset_parser
      @range = [false]
      @match_data.string = ''
      @parse_tokens = []
    end

    def convert_to_rpn
      @tokens = ''
      @parse_tokens.each do |tok|
        @tokens += case tok[0]
          when :version
            'v'
          when :operator
            'r'
          when :range
            't'
          when :parentheses
            if (tok[1]) then '(' else ')' end
          when :logical
            tok[1].to_s[0]
        end
      end
    end

  end


end
