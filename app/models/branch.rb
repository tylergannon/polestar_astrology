# encoding: utf-8
class Branch < ActiveRecord::Base
  extend FriendlyId
  friendly_id :animal, use: [:finders, :slugged]

  belongs_to :native_stem, :class_name => 'Stem'
  has_many :pillars
  default_scope -> {order(:id)}

  def hour
    hour = (ordinal-1)*2
    start_time = Time.parse("#{hour}:00")
    unless start_time.dst?
      start_time -= 1.hour
    end
    start_time.hour
  end

  def time_of_day
    hour = (ordinal-1)*2
    start_time = Time.parse("#{hour}:00")
    unless start_time.dst?
      start_time -= 1.hour
    end
    end_time = start_time + 2.hours
    "#{start_time.strftime("%l%P")}-#{end_time.strftime("%l%P")}"
  end

  def diametric
    self.class.find_by_ordinal((ordinal + 6) % 12)
  end

  def self.reseed
    Branch.destroy_all

    BRANCH_DATA.each_with_index do |data, i|
      create! id: data[7].to_i, char: data[0], pinyin: data[1], normalized: data[2], animal: data[3], hour: data[4],
        month: data[5], native_stem: Stem.find(data[6]), ordinal: data[7].to_i
    end
  end

  def self.find_by_english_name(name)
    Rails.cache.fetch("branch-#{name}") do
      friendly.find(name.to_s)
    end
  end

  def self.find_by_ordinal(i)
    Rails.cache.fetch("branch-#{i}") do
      friendly.find ENGLISH_NAMES[i-1].to_s
    end
  end

  def self.find_by_pinyin(pinyin)
    find_by_english_name BRANCHES[pinyin.to_sym].to_s
  end

  BRANCH_DATA = [
    %i(子 zǐ zi rat 1 11 yang-water 1),
    %i(丑 chǒu chou ox 2 12 yin-earth 2),
    %i(寅 yín yin tiger 3 1 yang-wood 3),
    %i(卯 mǎo mao rabbit 4 2 yin-wood 4),
    %i(辰 chén chen dragon 5 3 yang-earth 5),
    %i(巳 sì si snake 6 4 yin-fire 6),
    %i(午 wǔ wu horse 7 5 yang-fire 7),
    %i(未 wèi wei goat 8 6 yin-earth 8),
    %i(申 shēn shen monkey 9 7 yang-metal 9),
    %i(酉 yǒu you rooster 10 8 yin-metal 10),
    %i(戌 xū xu dog 11 9 yang-earth 11),
    %i(亥 hài hai pig 12 10 yin-water 12)].freeze

  BRANCHES = BRANCH_DATA.map{|t| t[2..3]}.to_h.freeze
  ALL_BRANCH_NAMES = BRANCHES.to_a.flatten
  PINYIN_NAMES = BRANCHES.keys
  ENGLISH_NAMES= BRANCHES.values
end
