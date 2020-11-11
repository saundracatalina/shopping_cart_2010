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
end
