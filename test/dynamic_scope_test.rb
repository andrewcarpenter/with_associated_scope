require File.join(File.dirname(__FILE__), 'test_helper')

class DynamicScopeTest < Test::Unit::TestCase

  context "A class which has included with_associated_scope" do
    should "only add joins when conditions returns a string" do
      proxy_options = {:joins => :books, :conditions => ["books.published_on <= ?", Date.today]}
      assert_equal proxy_options, Author.with_associated_scope(:books, :published).proxy_options
    end
    
    should "only add joins when conditions returns a string and deeply nested" do
      proxy_options = {:joins => {:authorships => :book}, :conditions => ["books.published_on <= ?", Date.today]}
      assert_equal proxy_options, Author.with_associated_scope( {:authorships => :book}, :published).proxy_options
    end
    
    should "nest everything" do
      proxy_options = {:joins => :books, :conditions => {:books => {:published_on => Date.today}}}
      assert_equal proxy_options, Author.with_associated_scope(:books, :published_today).proxy_options
    end
    
    should "work with parameters" do
      date = 1.year.ago
      proxy_options = {:joins => :books, :conditions => ["books.published_on >= ?", date]}
      assert_equal proxy_options, Author.with_associated_scope(:books, :published_after, date).proxy_options
    end
    
  end
end
