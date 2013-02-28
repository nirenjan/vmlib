#!/usr/bin/env ruby
# -*- ruby -*-

require 'yaml'

class VMLibError < RuntimeError; end
class VMLibMissingError < RuntimeError; end

class VMLib
  include Comparable

  FILE_NAME = '.version'
  TAG_FORMAT = 'v%M.%m.%p%s%b'

  SPECL_REGEX = /^[A-Za-z0-9][A-Za-z0-9-]*(\.[A-Za-z0-9][A-Za-z0-9-]*)*$/

  attr_reader :name, :major, :minor, :patch, :specl, :build

  # Initialize the version class
  def initialize(name = '', major = 0, minor = 1, patch = 0, specl = '', build = '')
    set_version(name, major, minor, patch, specl, build)
  end

  def set_version(name, major = 0, minor = 1, patch = 0, specl = '', build = '')
    name.kind_of? String or raise VMLibError, "invalid name: #{name}"
    major.kind_of? Integer or raise VMLibError, "invalid major: #{major}"
    minor.kind_of? Integer or raise VMLibError, "invalid minor: #{minor}"
    patch.kind_of? Integer or raise VMLibError, "invalid patch: #{patch}"

    unless specl.empty?
      specl =~ SPECL_REGEX or raise VMLibError, "invalid special: #{specl}"
    end

    unless build.empty?
      build =~ SPECL_REGEX or raise VMLibError, "invalid build: #{build}"
    end

    @name = name
    @major = major
    @minor = minor
    @patch = patch
    @specl = specl.split '.'
    @build = build.split '.'
    convert_to_integer(@specl)
    convert_to_integer(@build)
  end

  # Display the version in the specified format
  # Input: Format string
  #        %n - name
  #        %M - major version number
  #        %m - minor version number
  #        %p - patch number
  #        %s - special information
  #        %b - build number
  def format(fstr)
    fstr = fstr.gsub('%n', @name.to_s)
    fstr = fstr.gsub('%M', @major.to_s)
    fstr = fstr.gsub('%m', @minor.to_s)
    fstr = fstr.gsub('%p', @patch.to_s)

    if (@specl.length == 0)
      fstr = fstr.gsub('%s', '')
    else
      fstr = fstr.gsub('%s', '-' + @specl.join('.'))
    end

    if (@build.length == 0)
      fstr = fstr.gsub('%b', '')
    else
      fstr = fstr.gsub('%b', '+' + @build.join('.'))
    end

    fstr
  end

  # Display a version tag suitable for use in tagging releases
  # in the user's version control system
  def tag
    format TAG_FORMAT
  end

  # Display the version information as a string
  def to_s
    format "%M.%m.%p %s %b"
  end

  # Scan the elements of the array and if the element is a number
  # being represented as a string, convert it back to Integer
  def convert_to_integer(array)
    array.kind_of? Array or raise VMLibError, "invalid array: #{array}"

    for i in (0...array.length)
      array[i].to_s.match(/^\d+$/) and array[i] = array[i].to_i
    end
  end

  # Increment the major version number, clear the remaining fields
  def update_major(major)
    major.kind_of? Integer or raise VMLibError, "invalid major: #{major}"

    if major > @major
      @major = major
      @minor = 0
      @patch = 0
      @specl = []
      @build = []
    elsif major < @major
      raise VMLibError, "cannot decrement major version number from #{@major} to #{major}"
    # else
    # Don't bother changing the version if the major numbers match
    end
  end

  # Increment the minor version number, leave major untouched
  # clear the remaining fields
  def update_minor(minor)
    minor.kind_of? Integer or raise VMLibError, "invalid minor: #{minor}"

    if minor > @minor
      @minor = minor
      @patch = 0
      @specl = []
      @build = []
    elsif minor < @minor
      raise VMLibError, "cannot decrement minor version number from #{@minor} to #{minor}"
    # else
    # Don't bother changing the version if the minor numbers match
    end
  end

  # Increment the patch version number, leave major & minor untouched
  # clear the remaining fields
  def update_patch(patch)
    patch.kind_of? Integer or raise VMLibError, "invalid patch: #{patch}"

    if patch > @patch
      @patch = patch
      @specl = []
      @build = []
    elsif patch < @patch
      raise VMLibError, "cannot decrement patch version number from #{@patch} to #{patch}"
    # else
    # Don't bother changing the version if the patch numbers match
    end
  end

  # Update the special portion and clear the build number
  def update_special(specl)
    specl.kind_of? String or raise VMLibError, "invalid special: #{specl}"
    specl =~ SPECL_REGEX or raise VMLibError, "invalid special format: #{specl}"

    @specl = specl.split '.'
    @build = []
    convert_to_integer(@specl)
  end

  # Update the build number
  def update_build(build)
    build.kind_of? String or raise VMLibError, "invalid build: #{build}"
    build =~ SPECL_REGEX or raise VMLibError, "invalid build format: #{build}"

    @build = build.split '.'
    convert_to_integer(@build)
  end

  # Increment the major version number by 1
  # 1.x.y[-rel.a][+build.b] => 2.0.0
  def bump_major
    update_major(@major + 1)
  end

  # Increment the minor version number by 1
  # 1.2.y[-rel.a][+build.b] => 1.3.0
  def bump_minor
    update_minor(@minor + 1)
  end

  # Increment the patch number by 1
  # 1.2.3[-rel.a][+build.b] => 1.2.4
  def bump_patch
    update_patch(@patch + 1)
  end

  # Increment the last field of the special (if it exists and is numeric) by 1
  # 1.2.3-alpha.1[+build.b] => 1.2.3-alpha.2
  def bump_special
    if @specl.empty?
      raise VMLibError, "cannot bump an empty special"
    else
      @specl.push increment_special(@specl.pop)
      @build = []
    end
  end

  # Increment the last field of the build (if it exists and is numeric) by 1
  # 1.2.3+build.2 => 1.2.3+build.3
  def bump_build
    if @build.empty?
      raise VMLibError, "cannot bump an empty build"
    else
      @build.push increment_special(@build.pop)
    end
  end

  # Wrapper function to call each of the individual bump functions
  def bump(type)
    case type.downcase
    when 'major'; bump_major
    when 'minor'; bump_minor
    when 'patch'; bump_patch
    when 'special'; bump_special
    when 'build'; bump_build
    else; raise "unknown bump type: #{type}"
    end
  end

  # Checks if the value is an integer and increments it by 1
  def increment_special(value)
    unless (value.kind_of? Integer)
      raise VMLibError, "cannot increment a non-integer value: #{value}"
    end

    value + 1
  end

  # Load the specified version file
  def load_version_file(file)
    @file = file
    hash = YAML.load_file(file) || {}
    @major = hash['major'] or raise VMLibError, "invalid version file: #{file}"
    @minor = hash['minor'] or raise VMLibError, "invalid version file: #{file}"
    @patch = hash['patch'] or raise VMLibError, "invalid version file: #{file}"
    @specl = hash['special'] or raise VMLibError, "invalid version file: #{file}"
    @build = hash['build'] or raise VMLibError, "invalid version file: #{file}"
    @name = hash['name'] or raise VMLibError, "invalid version file: #{file}"
  end

  # Save the version info to the specified file
  def save_version_file(file = nil)
    file ||= @file

    raise VMLibError, "unspecified version file" unless file

    hash = {
      'major' => @major,
      'minor' => @minor,
      'patch' => @patch,
      'special' => @specl,
      'build' => @build,
      'name' => @name,
    }

    yaml = YAML.dump(hash)
    open(file, 'w') { |f| f.write yaml }
  end

  # Wrapper function to find the version file, load it and return
  # the version object
  def find(dir = nil)
    load_version_file(find_file(dir))

    return self
  end

  # Search the current and all parent folders for a version file
  # Raises an error if it cannot find any up to the root.
  def find_file(dir = nil)
    dir ||= Dir.pwd
    raise VMLibError, "#{dir} is not a directory" unless File.directory?(dir)
    path = File.join(dir, FILE_NAME)

    Dir.chdir(dir) do
      while !File.exists?(path) do
        if (File.dirname(path).match(/^(\w:\/|\/)$/i))
          raise VMLibMissingError, "#{dir} is not versioned", caller
        end

        path = File.join(File.dirname(path), '..')
        path = File.expand_path(path)
        puts "versioner: looking at path #{path}"
        path = File.join(path, FILE_NAME)
      end
      return path
    end
  end

  # Comparision function to compare two versions
  def <=> other
    maj = major.to_i <=> other.major.to_i
    return maj unless maj == 0

    min = minor.to_i <=> other.minor.to_i
    return min unless min == 0

    pat = patch.to_i <=> other.patch.to_i
    return pat unless pat == 0

    # Special has slightly different handling. If present, it should have
    # lower precedence than the one with special absent. However, if both
    # sides have special present, then behave normally.
    spe = specl <=> other.specl
    return 1 if (spe == -1 and specl.length == 0)
    return -1 if (spe == 1 and other.specl.length == 0)
    return spe unless spe == 0

    # Build naturally has higher precendence than an absent build number
    bld = build <=> other.build
    return bld
  end
end

