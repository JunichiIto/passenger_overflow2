require 'spec_helper'

describe Reputation do
  before do
    @asker = Factory :user
    @question = Factory :question, user: @asker
    @teacher = Factory :user, user_name: "hacker"
    @answer = Factory :answer, user: @teacher, question: @question
    @vote = Factory :vote, user: @asker, answer: @answer

    @vote_attr = { activity_id: @vote,
                   activity_type: "Vote", 
                   reason: "upvote", 
                   point: 10 }

    @accept_attr = { activity_id: @answer,
                     activity_type: "Answer", 
                     reason: "accept", 
                     point: 15 }

    @accepted_attr = { activity_id: @answer,
                       activity_type: "Answer", 
                       reason: "accepted", 
                       point: 2 }
  end  

  describe "validations" do
    before do
      @valid_attr = @vote_attr.merge user_id: @answer.user
    end

    it "should create a new instance given valid attributes" do
      Reputation.create! @valid_attr
    end

    it "should require an activity_id" do
      rep = Reputation.new @valid_attr.merge activity_id: nil
      rep.should_not be_valid
    end

    it "should require an activity_type" do
      rep = Reputation.new @valid_attr.merge activity_type: nil
      rep.should_not be_valid
    end

    it "should require a reason" do
      rep = Reputation.new @valid_attr.merge user_id: nil
      rep.should_not be_valid
    end

    it "should require a reason" do
      rep = Reputation.new @valid_attr.merge reason: nil
      rep.should_not be_valid
    end

    it "should require a point" do
      rep = Reputation.new @valid_attr.merge point: nil
      rep.should_not be_valid
    end

    it "should reject unknown reason" do
      rep = Reputation.new @valid_attr.merge reason: "foobar"
      rep.should_not be_valid
    end
  end

  describe "user associations" do
    before do
      @reputation = @teacher.reputations.create @vote_attr
    end

    it "should have a user attribute" do
      @reputation.should respond_to :user
    end

    it "should have the right associated user" do
      @reputation.user_id.should == @teacher.id
      @reputation.user.should == @teacher
    end
  end

  describe "vote associations" do
    before do
      @reputation = @teacher.reputations.create @vote_attr
    end

    it "should have the right associated vote" do
      @reputation.activity_id.should == @vote.id
      @reputation.activity.should == @vote
    end
  
    it "should return the right question" do
      @reputation.question.should == @question
    end
  end

  describe "accept associations" do
    before do
      @reputation = @teacher.reputations.create @accept_attr
    end

    it "should have the right associated answer" do
      @reputation.activity_id.should == @answer.id
      @reputation.activity.should == @answer
    end
  
    it "should return the right question" do
      @reputation.question.should == @question
    end
  end

  describe "accepted associations" do
    before do
      @reputation = @teacher.reputations.create @accepted_attr
    end

    it "should have the right associated answer" do
      @reputation.activity_id.should == @answer.id
      @reputation.activity.should == @answer
    end
  
    it "should return the right question" do
      @reputation.question.should == @question
    end
  end

  describe "create_for_accept! method" do
    it "should have a create_for_accept! method" do
      Reputation.should respond_to :create_for_accept!
    end

    describe "reputation on asker" do
      it "should increase asker's reputation" do
        lambda do
          Reputation.create_for_accept! @answer
        end.should change(@asker.reputations, :size).from(0).to(1)
      end

      it "should add the right reputation" do
        Reputation.create_for_accept! @answer
        rep = @asker.reputations.pop
        rep.activity.should == @answer
        rep.reason.should == "accepted"
        rep.point.should == 2
        rep.user.should == @asker
      end
    end

    describe "reputation on teacher" do
      it "should increase teacher's reputation" do
        lambda do
          Reputation.create_for_accept! @answer
        end.should change(@teacher.reputations, :size).from(0).to(1)
      end

      it "should add the right reputation" do
        Reputation.create_for_accept! @answer
        rep = @teacher.reputations.pop
        rep.activity.should == @answer
        rep.reason.should == "accept"
        rep.point.should == 15
        rep.user.should == @teacher
      end

      describe "when accept myself" do
        before do
          @self_answer = Factory :answer, question: @question, user: @asker
        end        

        it "should not increase reputation" do
          lambda do
            Reputation.create_for_accept! @self_answer
          end.should_not change(@asker.reputations, :size)
        end
      end
    end
  end

  describe "create_for_vote! method" do
    it "should have a create_for_vote! method" do
      Reputation.should respond_to :create_for_vote!
    end

    describe "reputation on teacher" do
      it "should increase teacher's reputation" do
        lambda do
          Reputation.create_for_vote! @vote
        end.should change(@teacher.reputations, :size).from(0).to(1)
      end

      it "should add the right reputation" do
        Reputation.create_for_vote! @vote
        rep = @teacher.reputations.pop
        rep.activity.should == @vote
        rep.reason.should == "upvote"
        rep.point.should == 10
        rep.user.should == @teacher
      end
    end
  end
end
