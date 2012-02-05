require 'spec_helper'

describe Question do
  before do
    @user = Factory :user
    @attr = {
      title: "value for title",
      content: "value for content"
    }
  end

  describe "user associations" do
    before do
      @question = @user.questions.create @attr
    end

    it "should have a user attribute" do
      @question.should respond_to :user
    end

    it "should have the right associated user" do
      @question.user_id.should == @user.id
      @question.user.should == @user
    end
  end

  describe "validations" do
    it "should require a user id" do
      Question.new(@attr).should_not be_valid
    end

    it "should require nonblank title" do
      @user.questions.build(title: "  ").should_not be_valid
    end

    it "should reject long title" do
      @user.questions.build(title: "a" * 256).should_not be_valid
    end

    it "should require nonblank content" do
      @user.questions.build(content: "  ").should_not be_valid
    end
  end

  describe "answer associations" do
    before do
      asker = Factory :user, user_name: "someone"
      @question = Factory :question, user: asker
      @a1 = Factory :answer, question: @question, user: @user, created_at: 1.day.ago
      @a2 = Factory :answer, question: @question, user: @user, created_at: 1.hour.ago
    end

    it "should have a answers attribute" do
      @question.should respond_to :answers
    end

    it "should have the right answers in the right order" do
      @question.answers.should == [@a2, @a1]
    end
  end

  describe "accepted answer associations" do
    before do
      @asker = Factory :user, user_name: "someone"
      @question = Factory :question, user: @asker
      @a1 = Factory :answer, question: @question, user: @user, created_at: 1.day.ago
      @a2 = Factory :answer, question: @question, user: @user, created_at: 1.hour.ago
    end

    it "should have an accept attribute" do
      @question.should respond_to :accept!
    end

    it "should accept an answer" do
      @question.accept! @a2
      @question.accepted_answer_id.should == @a2.id
      @question.accepted_answer.should == @a2
    end
    
    it "should have an accepted? attribute" do
      @question.should respond_to :accepted?
    end

    describe "reputation on asker" do
      it "should increase asker's reputation" do
        lambda do
          @question.accept! @a2
        end.should change(@asker.reputations, :size).from(0).to(1)
      end

      it "should add the right reputation" do
        @question.accept! @a2
        rep = @asker.reputations.pop
        rep.activity.should == @a2
        rep.reason.should == "accepted"
        rep.point.should == 2
        rep.user.should == @asker
      end
    end

    describe "reputation on teacher" do
      it "should increase teacher's reputation" do
        lambda do
          @question.accept! @a2
        end.should change(@user.reputations, :size).from(0).to(1)
      end

      it "should add the right reputation" do
        @question.accept! @a2
        rep = @user.reputations.pop
        rep.activity.should == @a2
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
            @question.accept! @self_ans
          end.should_not change(@asker.reputations, :size)
        end
      end
    end

    describe "when accepted" do
      before do
        @question.accept! @a2
      end

      it "should be accepted" do
        @question.should be_accepted
      end
    end

    describe "when not accepted" do
      it "should not be accepted" do
        @question.should_not be_accepted
      end
    end
  end
end
