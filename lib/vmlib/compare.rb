###############################################################################
# VMLib comparision routines
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

;

module VMLib

  class Version

    # Compare two arrays element by element.
    # If one element is numeric and the other a string, then the string
    # takes precedence over the number.
    def compare_arrays(array1, array2)
      raise Errors::ParameterError unless array1.is_a? Array
      raise Errors::ParameterError unless array2.is_a? Array

      # Run for the shorter of the two arrays
      if array1.length < array2.length
        len = array1.length
        possibly_gt = :array2
      else
        len = array2.length
        possibly_gt = :array1
      end

      cmp = 0

      # Check for an empty array, if so, resort to using the Array <=>
      if len == 0
        return array1 <=> array2
      end

      for i in (0...len)
        elm1 = array1[i]
        elm2 = array2[i]
        
        cls1 = elm1.class
        cls2 = elm2.class

        if cls1 == cls2
          cmp = (elm1 <=> elm2)
        else
          if cls1 == String # cls2 = Fixnum
            # String > Fixnum
            cmp = 1
          else # cls1 = Fixnum, cls2 = String
            # Fixnum < String
            cmp = -1
          end
        end

        break unless cmp == 0
      end

      return cmp unless cmp == 0

      # Resort to comparing the remaining elements using Array <=>
      cmp = (array1[len...array1.length] <=> array2[len...array2.length])
      return cmp
    end
    private :compare_arrays

    # Compare two version structures
    def <=> (other)
      # Check major version
      cmp = (@major <=> other.major)
      return cmp unless cmp == 0

      # Check minor version
      cmp = (@minor <=> other.minor)
      return cmp unless cmp == 0

      # Check patch version
      cmp = (@patch <=> other.patch)
      return cmp unless cmp == 0

      # Check prerelease arrays
      myown_pre = self.prerelease.split('.')
      convert_to_integer(myown_pre)
      other_pre = other.prerelease.split('.')
      convert_to_integer(other_pre)
      cmp = compare_arrays(myown_pre, other_pre)
      
      # Make sure that the prerelease is compared correctly
      cmp = 1 if cmp == -1 and myown_pre.length == 0
      cmp = -1 if cmp == 1 and other_pre.length == 0
      return cmp unless cmp == 0

      # Check build arrays, but only if specified
      if (@compare_build)
        myown_bld = self.build.split('.')
        convert_to_integer(myown_bld)
        other_bld = other.build.split('.')
        convert_to_integer(other_bld)
        cmp = compare_arrays(myown_bld, other_bld)
        return cmp unless cmp == 0
      end

      return 0
    end

  end


end
