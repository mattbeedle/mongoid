require 'spec_helper'

describe Mongoid::Associations::Options do
  describe 'polymorphic association' do
    before do
      @avatar      = Movie.create! :name => 'Avatar'
      @paris       = Movie.create! :name => 'One Night in Paris'
      @booky_wook  = Book.create! :name => 'My Booky Wook'
    end

    it 'should have no polymorphic children by default' do
      @avatar.ratings.count.should == 0
      @paris.ratings.count.should == 0
      @booky_wook.ratings.count.should == 0
    end

    it 'allows polymorphic children to be created' do
      @avatar.ratings.create! :score => 10
      @avatar.ratings.count.should == 1
      @avatar.ratings.first.score.should == 10
    end

    it 'allows polymorphic children to be appended (with <<)' do
      @paris.ratings << Rating.new(:score => 3)
      @paris.save!
      @paris.ratings.count.should == 1
      @paris.ratings.first.score.should == 3
    end

    it 'correctly infers the parent from the child' do
      @booky_wook.ratings.create! :score => 1
      @booky_wook.ratings.first.ratable.should == @booky_wook
    end

    it 'sets the polymorphic type field in the child' do
      @booky_wook.ratings.create! :score => 10
      @booky_wook.ratings.first.ratable_type.should == @booky_wook.class.to_s
    end
  end
end
