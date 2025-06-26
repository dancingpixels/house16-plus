# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    def initialize(user)
    return unless user

    if user.admin?
      can :manage, :all
    elsif user.sales?
      can :read,   Product
      can :create, Product
      # can :update, Product, user_id: user.id
      can :read,   Invoice
      can :create, Invoice
      # can :update, Invoice, user_id: user.id
      can :read,   Meal
      can :create, Meal
      can :update, Meal, user_id: user.id

       can :read,  Category
    end
  end
  end
end
