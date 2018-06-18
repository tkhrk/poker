class CardsController < ApplicationController

  def index
    # 変数受け取り，設定
    @card = Card.new
    # session.clear #debag
    if session[:all_card].nil?
      @card[:all_card] = "S1 S2 S3 S4 S5"
    else
      @card[:all_card] = session[:all_card]
    end
    @result = session[:result]
  end

  def create
    @card = Card.new
      if card_params
        @card[:all_card] = card_params[:all_card]
      end

    # カードを1～5枚目に分解する
    @card[:all_card].split(" ").each_with_index do |c,ind|
      @card[:first_card]  = c if ind == 0
      @card[:second_card] = c if ind == 1
      @card[:third_card]  = c if ind == 2
      @card[:fourth_card] = c if ind == 3
      @card[:fifth_card]  = c if ind == 4
    end

    # カードをスートと数字に分解する(.valuesがなぜか使えない,リファクタリング検討)
    @suits = [@card[:first_card][0], @card[:second_card][0],@card[:third_card][0],@card[:fourth_card][0],@card[:fifth_card][0]]
    @nums = [@card[:first_card][1].to_i,@card[:second_card][1].to_i,@card[:third_card][1].to_i,@card[:fourth_card][1].to_i,@card[:fifth_card][1].to_i]

    # カードの役を判定する
    if @suits.uniq.length == 1 && @nums.uniq.length == 5 && @nums.max - @nums.min == 4
      @result = 'ストレートフラッシュ'
    elsif @nums.count(@nums.max_by { |v| @nums.count(v) }) == 4
      @result = 'フォー・オブ・ア・カインド'
    elsif @nums.uniq.count == 2
      @result = 'フルハウス'
    elsif @suits.uniq.length == 1
      @result = 'フラッシュ'
    elsif @nums.uniq.length == 5 && @nums.max-@nums.min == 4
      @result = 'ストレート'
    elsif @nums.count(@nums.max_by { |v| @nums.count(v) }) == 3
      @result = 'スリー・オブ・ア・カインド'
    elsif @nums.uniq.length == 3
      @result = 'ツーペア'
    elsif @nums.uniq.length == 4
      @result = 'ワンペア'
    else
      @result = 'ハイカード'
    end

    # sessionに保存
    session[:all_card] = @card[:all_card]
    session[:result] = @result

    # indexにリダイレクト
    redirect_to root_path
  end

  private
    def card_params
      params.require(:card).permit(:all_card)
    end
end