class CardsController < ApplicationController

  # Serviceクラス使えるかテスト 消す---------------------------
  CardFormService.hoge("foofoo") #クラスメソッドはできた！
  # CardFormService.valid #privateでも呼び出し可能と見えたが，特異クラスのなかではだめ．
  #-------------------------------------------------------------

  def index
    # session.clear #debug
    if session[:all_card].nil?
      @card = Card.new(all_card: "")
    else
      @card = CardFormService.set_card_from_session(session)
      @card.save #createでsaveしてもerrorが引っかからないので，こっち
      @result = session[:result] if @card.save
    end
  end

  def create
    @card = Card.new
    @card[:all_card] = card_params[:all_card] if card_params

    # カードを1～5枚目に分解する
    CardFormService.get_five_cards(@card)

    # カードをスートと数字に分解する #メソッド化いらない？
    @suits = card_params[:all_card].split(" ").map{ |c| c[0] }
    @nums = card_params[:all_card].split(" ").map{ |c| c[1..-1].to_i }
    # [@suits, @nums] = CardFormService.separate_suit_num(card_params)

    # カードの役を判定する
    @result = CardFormService.judge_hand(@suits, @nums)

    # sessionに保存
    CardFormService.save_session(session, @card, @result)

    # indexにリダイレクト
    redirect_to root_path
  end

  private
    def card_params
      params.require(:card).permit(:all_card)
    end

end