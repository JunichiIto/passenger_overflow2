require 'spec_helper'

describe Answer do
  before do
    @user = Factory :user 
    @asker = Factory :user, user_name: "someone"
    @question = Factory :question, user: @asker
  end

  it "should create a new instance given valid attributes" do
    answer = @user.answers.build question: @question, content: "my ans"
    @question.answers << answer
    answer.save!
  end

  describe "user associations" do
    before do
      @answer = Factory :answer, user: @user, question: @question
    end

    it "should have the right associated user" do
      @answer.user_id.should == @user.id
      @answer.user.should == @user
    end

    it "should have the right associated question" do
      @answer.question_id.should == @question.id
      @answer.question.should == @question
    end

    it "should have a user attribute" do
      @answer.should respond_to :user
    end

    it "should have a question attribute" do
      @answer.should respond_to :question
    end
  end

  describe "validations" do
    before do
      @attr = { content: "my ans", user: @user, question: @question }
    end

    it "should require a user id" do
      no_user = Answer.new @attr.merge user: nil
      no_user.should_not be_valid
    end

    it "should require a question id" do
      no_question = Answer.new @attr.merge quetion: nil
      no_question.should_not be_valid
    end

    it "should require nonblank content" do
      no_content = Answer.new @attr.merge content: "  "
      no_content.should_not be_valid
    end
  end

  describe "vote associations" do
    before do
      @answer = Factory :answer, question: @question, user: @user, created_at: 1.day.ago
      @vote1 = @asker.vote! @answer
      other_user = Factory :user, user_name: "other"
      @vote2 = other_user.vote! @answer
    end

    it "should have a votes attribute" do
      @answer.should respond_to :votes
    end

    it "should have the right votes" do
      @answer.votes.should include @vote1
      @answer.votes.should include @vote2
    end
  end

  describe "accepted answer associations" do
    before do
      @question = Factory :question, user: @asker
      @answer = Factory :answer, question: @question, user: @user
      other = Factory :user, user_name: "other"
      @another_answer = Factory :answer, question: @question, user: other
    end

    it "should have an accept attribute" do
      @answer.should respond_to :accepted!
    end

    it "should be accepted" do
      @answer.accepted!
      @question.accepted_answer_id.should == @answer.id
      @question.accepted_answer.should == @answer
    end

    it "should not be accepted twice" do
      @answer.accepted!.should be_true
      @answer.accepted!.should_not be_true
      @answer.errors.should_not be_empty
    end

    describe "when alreadey accepted another answer" do
      before do
        @another_answer.accepted!
      end

      it "should not be accepted" do
        @answer.accepted!.should_not be_true
        @answer.errors.should_not be_empty
      end
    end

    describe "reputation on asker" do
      it "should increase asker's reputation" do
        lambda do
          @answer.accepted!
        end.should change(@asker.reputations, :size).from(0).to(1)
      end

      it "should add the right reputation" do
        @answer.accepted!
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
          @answer.accepted!
        end.should change(@user.reputations, :size).from(0).to(1)
      end

      it "should add the right reputation" do
        @answer.accepted!
        rep = @user.reputations.pop
        rep.activity.should == @answer
        rep.reason.should == "accept"
        rep.point.should == 15
        rep.user.should == @user
      end

      describe "when accept myself" do
        before do
          @self_ans = Factory :answer, question: @question, user: @asker
        end        
        it "should not increase reputation" do
          lambda do
            @self_ans.accepted!
          end.should_not change(@asker.reputations, :size)
        end
      end
    end
  end
end
