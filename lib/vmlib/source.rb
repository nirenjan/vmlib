###############################################################################
# VMLib source editor
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

;

module VMLib

  # This is the class for updating source files with the new version
  class Source

    # Set up the tree to find the root of the source repository
    def initialize(dir = nil)
      # Find the primary version file and get the root path
      version = File.new.find_file(dir)
      root = ::File.dirname(version)

      # Find all files below the root which have the filename
      # beginning with 'version'
      @files = ::Dir.glob("#{root}/**/version*")
      @files.delete_if {|f| ! ::File.file? f }

      # Read the primary version file and get the version string from it
      verdata = ::File.read(version)
      v = Version.new
      v.parse verdata
      @verstring = v.format '"%M.%m.%p%r%b"'
    end

    # Update the specified file
    def update_file (f)
      fdata = ::File.read(f).split("\n")
      
      for i in (0...fdata.length)
        # Check for a version string
        # VERSION ... "<version string>"
        line = fdata[i]
        
        if (line =~ /VERSION.*"\d+\.\d+\.\d+[^"]*"/)
          puts "updating line #{i} in #{f}..."
          puts "    old: #{line}"
          fdata[i] = line.gsub(/"\d+\.\d+\.\d+[^"]*"/, @verstring)
          puts "    new: #{fdata[i]}"
        end
      end

      # For whatever reason, the split deletes the last entry and leaves
      # us without a newline at the end of the file. Make sure that we 
      # do insert a newline at the end of the file.
      ::File.write(f, fdata.join("\n") + "\n")
    end
    private :update_file

    # Update all the source files containing the version
    def update

      @files.each {|f| update_file(f) }
    end

  end


end
