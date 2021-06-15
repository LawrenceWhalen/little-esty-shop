class Merchants::BulkDiscountsController < ApplicationController

  before_action :set_merchant

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
    @holidays = NagerHolidays.three_holidays
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.update(bulk_discount_params.merge(percentage: params[:bulk_discount][:percentage].to_f / 100))
    redirect_to merchant_bulk_discount_path(@merchant.id, bulk_discount.id)
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params.merge(percentage: params[:bulk_discount][:percentage].to_f / 100))
    if bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant.id)
    end
  end

  def destroy
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.delete
    redirect_to merchant_bulk_discounts_path(@merchant.id)
  end

  private
    def bulk_discount_params
      params[:bulk_discount].permit(:quantity_threshold, :percentage)
    end

    def set_merchant
      @merchant = Merchant.find(params[:merchant_id])
    end
end
