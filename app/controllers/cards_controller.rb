class CardsController < ApplicationController

  def index
    # session.clear #debug
    if session[:all_card].nil?
      @card = Card.new(all_card: "")
    else
      @card = Card.new(all_card: session[:all_card])
      @result = session[:result]
      @errors = session[:card_errors]
    end
  end

  def create
    @card = Card.new
    @card[:all_card] = card_params[:all_card] if card_params
    service = CardFormService.new(card_params[:all_card])
    card_set = Card.new({all_card: service.card, first_card: service.first_card, second_card: service.second_card, third_card: service.third_card, fourth_card: service.fourth_card, fifth_card: service.fifth_card })
    # if card_set.save #カードの保存に成功したとき
    if service.save
      card_set.save #２重になっているが，一応ロジックは通る
      session[:result]= service.hand
      session[:card_errors] = nil
    else #失敗したとき．エラーを返す
      session[:result] = ""
      session[:card_errors] = service.error_msg
    end
    #indexに渡すためにsessionに保存
    session[:all_card] = service.card

    redirect_to root_path
  end

  private
    def card_params
      params.require(:card).permit(:all_card)
    end
end