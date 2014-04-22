# encoding: UTF-8
###############################################################################
# VMLib file manager
###############################################################################
# Copyright (C) 2013 Nirenjan Krishnan
# All rights reserved.
###############################################################################

module VMLib
  # This is the file class for handling VMLib version files
  class File
    # Default file name of 'Version'
    FILE_NAME = 'Version'

    # Create a new file object with the specified filename. If the filename
    # is not specified, it reverts to the default
    def initialize(filename = nil)
      @filename ||= FILE_NAME
      @dir = nil
    end

    # Search the current and all parent folders for a version file
    # Raises an error if it cannot find any up to the root.
    def find_file(dir = nil)
      dir ||= ::Dir.pwd
      fail Errors::PathError unless ::File.directory?(dir)
      path = ::File.join(dir, @filename)

      ::Dir.chdir(dir) do
        until ::File.exist?(path)
          if ::File.dirname(path).match(%r{^(\w:/|/)$}i)
            fail Errors::NoVersionError, "#{dir} is not versioned"
          end

          path = ::File.join(::File.dirname(path), '..')
          path = ::File.expand_path(path)
          path = ::File.join(path, @filename)
        end
        @dir = path
        return path
      end
    end

    # Read the version file and return the parsed version data
    def read(dir = nil)
      path = find_file(dir)

      if ::File.readable?(path)
        # Read
        verdata = Version.new
        verdata.parse ::File.read(path)
      else
        fail Errors::VersionFileError, "unable to read #{path}"
      end

      verdata
    end

    # Write the specfied version into the version file
    def write(version, dir = nil)
      path = find_file(dir)

      unless version.is_a? Version
        fail Errors::ParameterError, "invalid version #{version}"
      end

      if ::File.writable?(path)
        # Write
        ::File.write(path, version.to_s + "\n")
      else
        fail Errors::VersionFileError, "unable to write #{path}"
      end
    end

    # Create a new version file for the current (or specified) folder.
    # If it already exists, then throw an error
    def create(name = '', dir = nil)
      # Make sure that the directory isn't versioned already
      begin
        path = find_file(dir)
      rescue Errors::NoVersionError
        # We are good to go
        dir ||= ::Dir.pwd
        raise Errors::PathError unless ::File.directory?(dir)
        path = ::File.join(dir, @filename)

        ::File.open(path, 'w') do |file|
          version = Version.new(name)
          file.write version.to_s + "\n"
        end
      else
        # Raise error that it's already versioned
        fail Errors::VersionFileError, "version already exists at #{path}"
      end
    end
  end
end
