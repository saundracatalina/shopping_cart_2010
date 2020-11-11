class Market
  attr_reader :name,
              :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(item)
    @vendors.find_all do |vendor|
      vendor if vendor.inventory.include?(item)
    end
  end

  def total_inventory
    inventory = {}
    @vendors.each do |vendor|
      items_at_market.each do |item|
        inventory[item] = {
          quantity: total_quantity_of_item(item),
          vendors: vendors_that_sell(item)
        }
      end
    end
    inventory
  end

  def items_at_market
    @vendors.flat_map do |vendor|
      vendor.inventory.keys
    end.uniq
  end

  def total_quantity_of_item(item)
    @vendors.sum do |vendor|
      vendor.inventory[item]
    end
  end

  def overstocked_items
    too_much_item =[]
    total_inventory.each do |item, info|
      too_much_item << item if info[:quantity] > 50 && info[:vendors].count > 1
    end
    too_much_item
  end

  def sorted_item_list
    item_names = items_at_market.map do |item|
      item.name
    end
    item_names.sort_by do |name|
      name
    end
  end

  def sell(item, amt)
    @vendors.any? do |vendor|
      vendor.check_stock(item) >= amt
    end
  end

  def remove_stock(item, amt)
    if sell(item, amt)
      @vendors.each do |vendor|
        vendor.inventory[item] -= amt
      end
    end
  end
end
