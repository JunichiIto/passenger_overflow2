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
      @answer1 = Factory :answer, question: @question, user: @user, created_at: 1.day.ago
      @answer2 = Factory :answer, question: @question, user: @user, created_at: 1.hour.ago
    end

    it "should have a answers attribute" do
      @question.should respond_to :answers
    end

    it "should have the right answers in the right order" do
      @question.answers.should == [@answer2, @answer1]
    end
  end

  describe "accepted answer associations" do
    before do
      @asker = Factory :user, user_name: "someone"
      @question = Factory :question, user: @asker
      @answer = Factory :answer, question: @question, user: @user
      other = Factory :user, user_name: "other"
      @another_answer = Factory :answer, question: @question, user: other
    end

    it "should have an accept attribute" do
      @question.should respond_to :accept
    end

    it "should accept answer" do
      @question.accept @answer
      @question.accepted_answer_id.should == @answer.id
      @question.accepted_answer.should == @answer
      @question.errors.should be_empty
    end

    it "should accept twice" do
      @question.accept @answer
      @question.accept @answer
      @question.errors.should be_empty
    end

    describe "when alreadey accepted another answer" do
      before do
        @question.accept @another_answer
      end

      it "should not accept" do
        @question.accept @answer
        @question.errors.should_not be_empty
      end
    end

    describe "reputation on asker" do
      it "should increase asker's reputation" do
        lambda do
          @question.accept @answer
        end.should change(@asker.reputations, :size).from(0).to(1)
      end

      it "should increase asker's reputation only once" do
        lambda do
          @question.accept @answer
          @question.accept @answer
        end.should change(@asker.reputations, :size).from(0).to(1)
      end
    end

    describe "reputation on teacher" do
      it "should increase teacher's reputation" do
        lambda do
          @question.accept @answer
        end.should change(@user.reputations, :size).from(0).to(1)
      end

      it "should increase teacher's reputation only once" do
        lambda do
          @question.accept @answer
          @question.accept @answer
        end.should change(@user.reputations, :size).from(0).to(1)
      end

      describe "when accept myself" do
        before do
          @self_ans = Factory :answer, question: @question, user: @asker
        end        

        it "should not increase reputation" do
          lambda do
            @question.accept @self_ans
          end.should_not change(@asker.reputations, :size)
        end
      end
    end

    describe "accepted? attribute" do
      it "should have an accepted? attribute" do
        @question.should respond_to :accepted?
      end

      describe "when accepted" do
        before do
          @question.accept @answer
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
end
