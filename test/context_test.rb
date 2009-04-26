require File.join(File.dirname(__FILE__), 'test_helper')

class ContextTest < Test::Unit::TestCase

  context "A class which has included with_associated_scope" do
    should "have with_associated_scope method" do
      assert Book.respond_to?(:with_associated_scope)
    end
    
    should "nest when passed a simple context" do
      proxy_options = { :conditions => {:events => {:approved => true}}, :joins => :events }
      assert_equal proxy_options, Book.with_associated_scope(:events, :approved).proxy_options
    end
    
    should "nest when passed a hash context" do
      proxy_options = { :conditions => {:books => {:events => {:approved => true}}}, :joins => {:books => :events} }
      assert_equal proxy_options, Author.with_associated_scope({:books => :events}, :approved).proxy_options
    end
    
    should "nest when passed a deeply nested hash context" do
      proxy_options = { :conditions => {:authorships => {:book => {:events => {:approved => true}}}}, :joins => {:authorships => {:book => :events}} }
      assert_equal proxy_options, Author.with_associated_scope({:authorships => {:book => :events}}, :approved).proxy_options
    end
    
  end
end
