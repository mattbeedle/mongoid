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

    it 'allows a child to be created by passing the parent' do
      rating = Rating.create! :ratable => @paris
      rating.ratable.should == @paris
      @paris.reload.ratings.first.should == rating
    end
  end

  context "when the parent is new" do
    let(:movie) { Movie.new }
    let!(:rating) { movie.ratings.build }

    it "appends the document to the association" do
      movie.ratings.first.should == rating
    end

    it "sets the reverse association's ids" do
      rating.ratable.should == movie
      rating.ratable_id.should == movie.id
      rating.ratable_type.should == movie.class.name
    end
  end

  context "when the parent is not new" do
    let(:avatar) do
      Movie.new.tap do |movie|
        movie.instance_variable_set(:@new_record, false)
      end
    end
    let!(:rating) { avatar.ratings.build }
    let!(:user) { User.create! }

    it "appends the document to the association" do
      avatar.ratings.first.should == rating
    end

    it "sets the reverse association's ids" do
      rating.ratable.should == avatar
      rating.ratable_id.should == avatar.id
      rating.ratable_type.should == avatar.class.name
    end

    it 'should be able to build a polymorphic associated object' do
      r = user.ratings.build :ratable => avatar
      r.ratable.should == avatar
      r.ratable_id.should == avatar.id
      r.ratable_type.should == avatar.class.name
    end
  end
end
