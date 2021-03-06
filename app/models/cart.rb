class Cart < ActiveRecord::Base
  has_many :line_items
  has_many :items, through: :line_items
  belongs_to :user

  validates_uniqueness_of :id

  def total
    self.line_items.map do |line_item|
      item = Item.find(line_item.item_id)
      item.price * line_item.quantity
    end.sum
  end

  def add_item(item_id)
    line_item = self.line_items.find_by(item_id: item_id)
    if line_item
      line_item.quantity += 1
    else
      line_item = self.line_items.build(item_id: item_id, cart_id: self.id)
    end
    line_item
  end

  def inventory_after_checkout
    self.line_items.each do |li|
      item = Item.find_by(id: li.item_id)
      if item
        item.amount_sold(li.quantity)
      end
    end
  end

  def checkout
    if self.status != true
      self.status = true
    else
      return "Order has already been placed. Can't place again."
    end
  end

  def cart_status
    self.status ? "submitted" : "unsubmitted"
  end

  def self.find_current_cart(cc)
    user = User.find_by(id: cc)
    oc = user.carts.find{|c| c.status == false} if !user.carts.empty?
    oc ? oc : nil
  end

end
