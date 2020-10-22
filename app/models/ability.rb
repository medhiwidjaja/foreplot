class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :new_request, :send_request, to: :request

    @user = user || User.new
    @user.role = 'guest' if @user.role.blank?

    send(@user.role.downcase)
  end

  # Admin user can do anything
  def admin
    can :manage, :all
  end

  # Guest, a non-signed in user, can only view public articles
  def guest
    can :read, Article do |article|
      article.private == false || article.private == nil
    end
    can :read, User
  end

  # Member is a registered user
  def member
    guest
    # Member's account type determines his/her abilities
    send @user.account.downcase
  end

  # Types of user account: free, basic, academic, pro and enterprise

  def free
    # Article
    cannot :manage, Article, private: true
    can :manage, Article do |article|
      (article.private == false && article.user_id == @user.id)
    end
    # Appraisal
    can :manage, Appraisal do |appraisal|
      appraisal.member.user_id == @user.id
    end
    # Participation
    can :manage, Member, user_id: @user.id
    # User
    can [:read, :update], User, id: @user.id
  end

  def basic
    free
    can :participate_in, Article do |article|
      article.members.include? @user
    end
    can :manage, Article do |article|
      (article.user_id == @user.id)
    end
  end

  def academic
    basic

    can :create_report, Article do |article|
      article.user_id == @user.id
    end
    can :import_export_excel, Article do |article|
      article.user_id == @user.id
    end
  end

  def pro
    academic
    can :create_report, Article 
    can :create_pdf_report, Article
    can :import_export_excel, Article
  end

end
