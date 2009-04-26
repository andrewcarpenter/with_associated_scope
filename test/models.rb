ActiveRecord::Base.establish_connection :adapter  => 'sqlite3', :database => File.join(File.dirname(__FILE__), 'test.db')

class CreateSchema < ActiveRecord::Migration
  def self.up
    create_table :authors, :force => true do |t|
      t.string :first_name
      t.string :last_name
      t.timestamps
    end
    create_table :authorships, :force => true do |t|
      t.integer :author_id
      t.integer :book_id
    end
    create_table :books, :force => true do |t|
      t.string :title
      t.text :description
      t.date :published_on
      t.string :genre 
      t.timestamps
    end
    create_table :events, :force => true do |t|
      t.integer :book_id
      t.date :date
      t.string :title
      t.boolean :approved
    end
  end
end

CreateSchema.suppress_messages { CreateSchema.migrate(:up) }

class Author < ActiveRecord::Base
  has_many :authorships
  has_many :books, :through => :authorships
end

class Authorships < ActiveRecord::Base
  belongs_to :author
  belongs_to :book
end

class Book < ActiveRecord::Base
  has_many :authorships
  has_many :authors, :through => :authorships
  has_many :events
  
  named_scope :fiction, :conditions => {:genre => 'Fiction'}
  named_scope :published, lambda {
    {:conditions => ["books.published_on <= ?", Date.today]}
  }
  named_scope :published_today, lambda {
    {:conditions => {:published_on => Date.today} }
  }
  named_scope :published_after, lambda { |date|
    {:conditions => ["books.published_on >= ?", date]}
  }
end

class Event < ActiveRecord::Base
  belongs_to :book
  named_scope :approved, :conditions => {:approved => true}
end

Book.published_after