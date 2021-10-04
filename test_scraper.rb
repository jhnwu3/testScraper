# frozen_string_literal: true

require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'restclient'

# Big Products Class that is invariabbly filled up.
class Product
  def initialize
    @name = ''
    @price = 0.0
    @brand = ''
    @cpu = ''
    @gpu = ''
    @ssd = ''
    @memory = ''
    @link = ''
  end
  # getter methods
  attr_accessor :name, :price, :brand, :link, :cpu, :gpu, :ssd, :memory
end

# scraper functions within the products class
class Scraper
  def initialize
    # set up arrays for price, product, product_attribute, and product_brand
    @products = []
  end

  # set up the get calls to microcenter
  def collect_data
    doc = Nokogiri::HTML(open('https://www.microcenter.com/search/search_results.aspx?N=4294967288&NTK=all&sortby=match&rpp=96'))
    product_price = []
    product_brand = []

    # collect information for product, price, and brand
    # product= doc.xpath('//div/h2/a/@data-name').collect {|node| node.text.strip}
    product_listing = doc.search('div.normal h2 a').map(&:text) #css('div').css('h2').search('a').map(&:text)
    product_price = doc.xpath('//div/a/@data-price').collect { |node| node.text.strip }
    product_brand = doc.xpath('//div/a/@data-brand').collect { |node| node.text.strip }
    product_link = doc.xpath('//div/h2/a/@href').collect { |node| node.text.strip }

    # setup Array product_attribute with values from product, price, and brand
    i = 0
    product_listing.each do |title|
      item = Product.new
      core_link = 'https://www.microcenter.com'
      item.name = title
      item.price = product_price[i].to_f
      item.brand = product_brand[i]
      item.link = core_link + product_link[i]
      @products.append(item)
    end
  end

  def print_attributes
    i = 0
    @products.each do |item|
      i += 1
      puts "-------------------------------------item #{i}---------------------------------------------------------------------"
      puts "Laptop Specs: #{item.name}"
      puts "Brand: #{item.brand}"
      puts "Price: $#{item.price}"
      puts "Link to item: #{item.link}"
    end
  end
end

# Processing Class
class Process
  def 
    
  end 
end

# calculation class
class Calc
  def initialize
    @aver_price = 0
    @amou_brand = 0
    @brands = []
  end

  def gpu_score(title)
    score = 0
    if title.include? '3080'
      score = 4
    elsif title.include?('3070') || title.include?('2080')
      score = 3
    elsif title.include?('3060') || title.include?('2070')
      score = 2
    elsif title.include?('2060') || title.include('1660')
      score = 1
    end
    score
  end

  def storage_score(title)
    score = 0
    if title.include?('2TB')
      score = 4
    elsif title.include?('1TB')
      score = 3
    elsif title.include?('512GB')
      score = 2
    elsif title.include?('256GB')
      score = 1
    end
    score
  end

  def ram_score(title)
    score = 0
    if title.include?('64GB')
      score = 4
    elsif title.include?('32GB')
      score = 3
    elsif title.include?('16GB')
      score = 2
    elsif title.include?('8GB')
      score = 1
    end
    score
  end  

  def cpu_score(title)
    score = 0
    if title.include?('i9') || title.include?('Ryzen 9') || title.include?('M1')
      score = 4
    elsif title.include?('i7') || title.include?('Ryzen 7')
      score = 3
    elsif title.include?('i5') || title.include?('Ryzen 5')
      score = 2
    elsif title.include?('i3') || title.include?('Ryzen 3')
      score = 1
    end
    score
  end

  def laptop_score(title)
    gpu_score(title) + cpu_score(title) + ram_score(title) + storage_score(title)
  end
  # calculate the average Price for the current page
  def average_price(micro)
    sum = 0
    i = 0
    micro.products.each do |item|
      sum += item.price
      i += 1
    end
    @aver_price = sum / micro.products.length
  end

  # calculate the amount of brands
  def amount_brands(micro)
    sum = 0
    brands_listed = []
    micro.product_attribute.each do |item|
      if brands.include(item.brand)
        sum += 1
      else
        brands_listed.push(item.brand)
      end
    end
    @brands = brandssum
    @amou_brand = sum
  end
end

micro = Scraper.new
micro.collect_data
micro.print_attributes

# page = mechanize.get('https://www.microcenter.com/search/search_results.aspx?Ntk=all&sortby=match&N=4294967288&myStore=true')
# titles = []
# titles.append(page.at('normal').at())
