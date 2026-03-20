class MealIdeasController < ApplicationController
  def show
    goal = current_user.profile.goal
    @ideas =
      case goal
      when "fat_loss"
        ["鶏むね＋野菜スープ", "サラダチキン＋ゆで卵", "刺身定食（ご飯少なめ）"]
      when "strength"
        ["白米＋牛肉＋味噌汁", "卵かけご飯＋納豆", "鮭＋ご飯＋ヨーグルト"]
      else
        ["プロテイン＋バナナ", "鶏むね＋米＋野菜", "ツナ＋パスタ＋サラダ"]
      end
  end
end