
module Qbrick
  class BrickTypeFilter < SimpleDelegator
    def empty?
      !(respond_to?(:user_can_add_childs?) && user_can_add_childs? && !allowed.empty?)
    end

    def allowed
      if Qbrick::BrickType.enabled.count.zero?
        []
      elsif allowed_brick_types.empty?
        Qbrick::BrickType.enabled
      else
        Qbrick::BrickType.enabled.constrained(allowed_brick_types)
      end
    end
  end
end
