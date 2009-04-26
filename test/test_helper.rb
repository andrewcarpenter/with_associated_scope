# shamelessly copied from pacecar

$: << File.join(File.dirname(__FILE__), '..', 'lib')
$: << File.join(File.dirname(__FILE__))

require 'rubygems'
require 'test/unit'
require 'activerecord'
require 'shoulda'
require 'associated_scope'
require 'models'
begin require 'redgreen'; rescue LoadError; end
